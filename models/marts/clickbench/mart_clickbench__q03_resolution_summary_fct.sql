with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    sum(coalesce(adv_engine_id, 0)) as sum_adv_engine_id,
    count(*) as total_hits,
    avg(resolution_width) as avg_resolution_width
from hits
