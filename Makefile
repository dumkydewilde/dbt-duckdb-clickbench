.PHONY: setup clickbench microbatch

DBT_PROJECT := duckdb_clickbench
CLICKBENCH_PREFIX := clickbench_
# Command that lists every duckdb_clickbench output beginning with clickbench_
CLICKBENCH_TARGETS_CMD := uv run python -c "import pathlib, yaml; path = pathlib.Path('profiles.yml'); data = yaml.safe_load(path.read_text()) if path.exists() else {}; data = data or {}; profile = data.get('$(DBT_PROJECT)', {}); outputs = profile.get('outputs', {}); matches = [name for name in outputs if name.startswith('$(CLICKBENCH_PREFIX)')]; print(' '.join(matches))"

INCREMENTAL_TARGETS := \
	incremental_single_thread_8GB \
	incremental_multi_thread_3_8GB \
	incremental_multi_thread_8_8GB \
	incremental_single_thread_16GB
	

setup:
	mkdir -p data
	uv sync
	uv run dbt debug
	uv run dbt deps
	uv run dbt run -s dbt_artifacts
	uv run dbt run -s staging
	uv run dbt run -s results --empty

clickbench:
	@targets="$$($(CLICKBENCH_TARGETS_CMD))"; \
	if [ -z "$$targets" ]; then \
		echo "No $(CLICKBENCH_PREFIX)* profiles defined under $(DBT_PROJECT) in profiles.yml"; \
		exit 1; \
	fi; \
	for target in $$targets; do \
		echo "Running clickbench profile $$target"; \
		uv run dbt run -s benchmarks.clickbench --full-refresh --target $$target || exit $$?; \
	done
	echo "\n\nRESULTS:"
	uv run dbt show -q -s results.results__clickbench

incremental:
	### Initial full-refresh to create the base tables for testing incremental models
	@for target in $(INCREMENTAL_TARGETS); do \
		echo "Running incremental benchmarks for profile $$target"; \
		uv run dbt run -s tag:microbatch_incremental --full-refresh --target $$target --threads 8; \
		\
		echo "  Benchmarking regular (full-refresh) table"; \
		uv run dbt run -s table --target $$target; \
		\
		echo "  Benchmarking incremental models with different strategies"; \
		uv run dbt run -s incremental__del_ins_date_partition --target $$target; \
		uv run dbt run -s incremental__del_ins_ukey_date --target $$target; \
		uv run dbt run -s incremental__del_ins_ukey --target $$target; \
		uv run dbt run -s incremental__merge_ukey_date --target $$target; \
		uv run dbt run -s incremental__merge_update_columns --target $$target; \
		uv run dbt run -s incremental__merge --target $$target; \
		\
		echo "  Simulating microbatch re-processing for event dates July 1-31, 2013"; \
		uv run dbt run -s microbatch_default_concurrent --event-time-start "2013-07-01" --event-time-end "2013-07-31" --target $$target; \
	done
	
	### Results:
	duckdb data/clickbench.duckdb -c "select * from main.results__incremental limit 20"

microbatch: incremental

results:
	uv run dbt run -q -s results
	uv run dbt show -q -s results.results__clickbench  --limit 20

	duckdb data/clickbench.duckdb -c "select * from main.results__incremental limit 30"