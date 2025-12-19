with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    count(*) as adv_engine_hits
from hits
where coalesce(adv_engine_id, 0) <> 0
