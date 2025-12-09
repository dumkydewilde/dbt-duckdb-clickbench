with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    search_phrase
from hits
where search_phrase <> ''
order by search_phrase
limit 10
