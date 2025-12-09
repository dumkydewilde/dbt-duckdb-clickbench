with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    search_phrase,
    min(url) as first_url,
    min(title) as first_title,
    count(*) as hit_count,
    count(distinct user_id) as unique_users
from hits
where title ilike '%google%'
  and url not ilike '%.google.%'
  and search_phrase <> ''
group by search_phrase
order by hit_count desc
limit 10
