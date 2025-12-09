select
    url_hash,
    event_date,
    count(*) as pageviews
from {{ ref('stg_clickbench__hits') }}
where counter_id = 62
  and event_date between date '2013-07-01' and date '2013-07-31'
  and coalesce(is_refresh, 0) = 0
  and trafic_source_id in (-1, 6)
  and referer_hash = 3594120000172545465
group by url_hash, event_date
order by pageviews desc
limit 10 offset 100
