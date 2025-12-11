.PHONY: setup clickbench microbatch

DBT_PROJECT := duckdb_clickbench
CLICKBENCH_PREFIX := clickbench_
# Command that lists every duckdb_clickbench output beginning with clickbench_
CLICKBENCH_TARGETS_CMD := uv run python -c "import pathlib, yaml; path = pathlib.Path('profiles.yml'); data = yaml.safe_load(path.read_text()) if path.exists() else {}; data = data or {}; profile = data.get('$(DBT_PROJECT)', {}); outputs = profile.get('outputs', {}); matches = [name for name in outputs if name.startswith('$(CLICKBENCH_PREFIX)')]; print(' '.join(matches))"

setup:
	mkdir -p data
	uv sync
	uv run dbt debug
	uv run dbt deps
	uv run dbt run -s dbt_artifacts
	uv run dbt run -s staging

clickbench:
	@targets="$$($(CLICKBENCH_TARGETS_CMD))"; \
	if [ -z "$$targets" ]; then \
		echo "No $(CLICKBENCH_PREFIX)* profiles defined under $(DBT_PROJECT) in profiles.yml"; \
		exit 1; \
	fi; \
	for target in $$targets; do \
		echo "Running clickbench profile $$target"; \
		uv run dbt run -s marts.clickbench --full-refresh --target $$target || exit $$?; \
	done
	echo "\n\nRESULTS:"
	uv run dbt show -q -s benchmarks.clickbench

results:
	uv run dbt show -q -s benchmarks.clickbench

microbatch:
	uv run dbt run -s normal_incremental --full-refresh
	uv run dbt run -s normal_incremental microbatch microbatch_ukey --event-time-start "2013-07-01" --event-time-end "2013-07-31"
