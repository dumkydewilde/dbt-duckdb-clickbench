with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    min(cast(event_date as date)) as min_event_date,
    max(cast(event_date as date)) as max_event_date
from hits
