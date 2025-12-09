with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    count(*) as total_hits
from hits
