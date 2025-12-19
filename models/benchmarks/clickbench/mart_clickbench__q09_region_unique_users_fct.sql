with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    region_id,
    count(distinct user_id) as unique_users
from hits
group by region_id
order by unique_users desc
limit 10
