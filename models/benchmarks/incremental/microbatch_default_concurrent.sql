{{
    config(
        materialized='incremental',
        incremental_strategy='microbatch',
        event_time='event_time',
        batch_size='day',
        lookback=0,
        begin='2013-07-01',
        full_refresh=false,
        concurrent_batches=true
    )
}}

select * from {{ ref('stg_clickbench__hits') }}