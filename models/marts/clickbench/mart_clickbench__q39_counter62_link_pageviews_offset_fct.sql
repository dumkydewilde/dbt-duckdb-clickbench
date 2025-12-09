select
    url,
    count(*) as pageviews
from {{ ref('stg_clickbench__hits') }}
where counter_id = 62
  and event_date between date '2013-07-01' and date '2013-07-31'
  and coalesce(is_refresh, 0) = 0
  and coalesce(is_link, 0) <> 0
  and coalesce(is_download, 0) = 0
  and url <> ''
group by url
order by pageviews desc
limit 10 offset 1000
