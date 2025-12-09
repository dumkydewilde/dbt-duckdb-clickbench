.PHONY: setup clickbench microbatch

setup:
	uv run dbt debug
	uv run dbt run -s staging

clickbench:
	uv run dbt run -s marts.clickbench --full-refresh

microbatch:
	uv run dbt run -s normal_incremental --full-refresh
	uv run dbt run -s normal_incremental microbatch microbatch_ukey --event-time-start "2013-07-01" --event-time-end "2013-07-31"
