with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    mobile_phone_model,
    count(distinct user_id) as unique_users
from hits
where mobile_phone_model <> ''
group by mobile_phone_model
order by unique_users desc
limit 10
