with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    adv_engine_id,
    count(*) as hit_count
from hits
where coalesce(adv_engine_id, 0) <> 0
group by adv_engine_id
order by hit_count desc
