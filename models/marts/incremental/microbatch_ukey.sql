{{
    config(
        materialized='incremental',
        incremental_strategy='microbatch',
        unique_key='hash_key',
        event_time='event_time',
        concurrent_batches=false,
        batch_size='day',
        lookback=0,
        begin='2013-07-01',
        full_refresh=false
    )
}}

select * from {{ ref('stg_clickbench__hits') }}