with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    search_phrase,
    count(distinct user_id) as unique_users
from hits
where search_phrase <> ''
group by search_phrase
order by unique_users desc
limit 10
