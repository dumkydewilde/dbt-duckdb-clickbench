with hits as (
    select
        date_trunc('minute', event_time) as minute_bucket
    from {{ ref('stg_clickbench__hits') }}
    where counter_id = 62
      and event_date between date '2013-07-14' and date '2013-07-15'
      and coalesce(is_refresh, 0) = 0
      and coalesce(dont_count_hits, 0) = 0
)

select
    minute_bucket,
    count(*) as pageviews
from hits
group by minute_bucket
order by minute_bucket
limit 10 offset 1000
