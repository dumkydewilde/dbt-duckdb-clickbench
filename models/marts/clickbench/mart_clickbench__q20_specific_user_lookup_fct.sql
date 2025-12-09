with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    user_id
from hits
where user_id = 435090932899640449
