with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    count(distinct search_phrase) as distinct_search_phrases
from hits
