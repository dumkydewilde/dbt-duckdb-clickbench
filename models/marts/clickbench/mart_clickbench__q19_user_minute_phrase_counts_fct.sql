with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    user_id,
    date_part('minute', event_time) as minute_bucket,
    search_phrase,
    count(*) as hit_count
from hits
group by user_id, minute_bucket, search_phrase
order by hit_count desc
limit 10
