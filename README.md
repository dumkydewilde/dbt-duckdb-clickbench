# dbt-duckdb ClickBench Benchmarks

Minimal dbt project to benchmark the DuckDB adapter / dbt models against the ClickBench dataset. The sections below explain where the raw data comes from, how to drive the benchmark runs via `make`, and how to pin specific `dbt-duckdb` builds.

## TLDR;

1. Run `make setup` (downloads 14GB dataset)
2. `make clickbench` or `make incremental` to run different benchmarks
3. View the results in your terminal, e.g.

| target_name     | total_runtime_s | models_executed |
| --------------- | --------------- | --------------- |
| clickbench_8GB  |         35.905… |              43 |
| clickbench_24GB |         38.348… |              43 |
| clickbench_2GB  |         55.512… |              43 |

| model_name           | model_status    | model_runtime_s |
| -------------------- | --------------- | --------------- |
| microbatch_date_p... | error           |          4.917… |
| table                | success         |         50.121… |
| microbatch_ukey_d... | partial success |         58.288… |
| microbatch_ukey      | partial success |         66.825… |
| incremental__del_... | success         |        101.014… |
| incremental__del_... | success         |        104.659… |
| microbatch_default   | success         |        106.800… |
| incremental__del_... | success         |        108.483… |
| incremental__del_... | success         |        115.144… |
| incremental__merg... | error           |        117.395… |
| incremental__merge   | error           |        117.522… |
| incremental__merg... | error           |        119.890… |

## ClickBench dataset

The staging source defined in `models/staging/source.yml` points DuckDB at the public ClickBench export:

```text
read_parquet('https://datasets.clickhouse.com/hits_compatible/hits.parquet', binary_as_string=True) -- 14GB!
```

By default the `stg_clickbench__hits` model streams directly from this remote Parquet file and materializes as a table, so you can run the benchmarks immediately without re-downloading. If you prefer to store the file locally (for repeatable offline runs from Parquet or to avoid re-downloading ~14 GB), you can download it once and adjust the source to point at your local copy. Update `models/staging/source.yml` so the `external_location` points to `read_parquet('data/clickbench/hits.parquet')` instead of the remote URL.

## Running the benchmarks via Make

All benchmark entry points live in the root `Makefile` so you do not have to remember the full `dbt` invocations. Run these from the project root after syncing dependencies with `uv sync`.

- `make setup` — executes `uv run dbt debug` to validate the database setup and then `uv run dbt run -s staging` to download and materialize the staging layer.
- `make clickbench` — runs `uv run dbt run -s marts.clickbench --full-refresh`, rebuilding every mart model under the `clickbench` subdirectory.
- `make microbatch` — first performs a full refresh of the shared `normal_incremental` models, then reruns `normal_incremental`, `microbatch`, and `microbatch_ukey` with the event-time window `2013-07-01` through `2013-07-31`.

## Pinning `dbt-duckdb` versions

`pyproject.toml` currently pulls a specific dbt-duckdb adapter with microbatch implementation (see: [PR #644](https://github.com/duckdb/dbt-duckdb/pull/644))

```toml
[project]
dependencies = [
    "dbt-duckdb>=1.8.2",
]

[tool.uv.sources]
dbt-duckdb = { git = "https://github.com/gfrmin/dbt-duckdb", branch = "microbatch" }
```

You have two knobs for testing other adapter builds:

1. **Pin a released version** by setting an exact requirement and removing the git override:

    ```toml
    dependencies = [
         "dbt-duckdb==1.8.3",
    ]
    ```

2. **Follow a specific git ref** by editing `[tool.uv.sources]`, for example:

    ```toml
    [tool.uv.sources]
    # either
    dbt-duckdb = { git = "https://github.com/duckdb/dbt-duckdb", rev = "1c0ffee" }
    # or
    dbt-duckdb = { path = "/Users/username/code/dbt-duckdb-from-me/", package = true }
    ```

After changing either value, run `uv sync` so the lockfile and virtual environment pick up the new adapter. Subsequent `make` targets will automatically use whatever version `uv` just installed.
