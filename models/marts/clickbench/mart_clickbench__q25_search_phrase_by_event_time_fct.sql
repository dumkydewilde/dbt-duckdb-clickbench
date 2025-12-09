with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    search_phrase
from hits
where search_phrase <> ''
order by event_time
limit 10
