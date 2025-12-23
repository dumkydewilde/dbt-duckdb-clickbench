{{
    config(
        materialized='incremental',
        incremental_strategy='microbatch',
        concurrent_batches=false,
        event_time='event_date',
        batch_size='day',
        lookback=0,
        begin='2013-07-01',
        full_refresh=false
    )
}}

select * from {{ ref('stg_clickbench__hits') }}