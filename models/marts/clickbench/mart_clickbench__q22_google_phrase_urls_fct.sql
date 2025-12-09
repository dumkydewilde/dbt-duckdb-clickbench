with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    search_phrase,
    min(url) as first_url,
    count(*) as hit_count
from hits
where url ilike '%google%'
  and search_phrase <> ''
group by search_phrase
order by hit_count desc
limit 10
