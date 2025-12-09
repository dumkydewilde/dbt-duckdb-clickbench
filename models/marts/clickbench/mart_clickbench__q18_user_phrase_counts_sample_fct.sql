with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    user_id,
    search_phrase,
    count(*) as hit_count
from hits
group by user_id, search_phrase
order by user_id, search_phrase
limit 10
