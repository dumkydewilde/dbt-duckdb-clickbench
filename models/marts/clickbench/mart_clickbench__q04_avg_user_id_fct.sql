with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    avg(user_id) as avg_user_id
from hits
