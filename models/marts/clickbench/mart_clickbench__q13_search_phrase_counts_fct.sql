with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    search_phrase,
    count(*) as hit_count
from hits
where search_phrase <> ''
group by search_phrase
order by hit_count desc
limit 10
