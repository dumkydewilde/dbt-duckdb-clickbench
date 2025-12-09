with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    count(*) as google_url_hits
from hits
where url ilike '%google%'
