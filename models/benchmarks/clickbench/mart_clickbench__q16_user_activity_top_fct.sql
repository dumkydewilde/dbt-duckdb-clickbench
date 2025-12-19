with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    user_id,
    count(*) as hit_count
from hits
group by user_id
order by hit_count desc
limit 10
