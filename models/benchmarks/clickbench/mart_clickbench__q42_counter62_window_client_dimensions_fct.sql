select
    window_client_width,
    window_client_height,
    count(*) as pageviews
from {{ ref('stg_clickbench__hits') }}
where counter_id = 62
  and event_date between date '2013-07-01' and date '2013-07-31'
  and coalesce(is_refresh, 0) = 0
  and coalesce(dont_count_hits, 0) = 0
  and url_hash = 2868770270353813622
group by window_client_width, window_client_height
order by pageviews desc
limit 10 offset 10000
