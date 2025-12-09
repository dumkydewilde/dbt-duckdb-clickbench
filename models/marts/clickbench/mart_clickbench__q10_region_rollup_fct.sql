with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    region_id,
    sum(coalesce(adv_engine_id, 0)) as sum_adv_engine_id,
    count(*) as hit_count,
    avg(resolution_width) as avg_resolution_width,
    count(distinct user_id) as unique_users
from hits
group by region_id
order by hit_count desc
limit 10
