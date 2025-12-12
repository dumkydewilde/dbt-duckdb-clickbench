{{
    config(
        description="Microbatch incremental model for clickbench hits data. Simulates re-processing data for specific event dates compared to microbatch strategy.",
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='hash_key',
        tags=['microbatch_incremental']
    )
}}

select * from {{ ref('stg_clickbench__hits') }}

{% if is_incremental() %}
    where event_date >= make_date({{ var('data_start_date') }})
{% endif %}