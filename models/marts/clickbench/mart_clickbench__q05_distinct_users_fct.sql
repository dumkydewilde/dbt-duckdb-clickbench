with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    count(distinct user_id) as distinct_users
from hits
