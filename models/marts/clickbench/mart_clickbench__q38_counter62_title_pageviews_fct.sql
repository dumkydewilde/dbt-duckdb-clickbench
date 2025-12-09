select
    title,
    count(*) as pageviews
from {{ ref('stg_clickbench__hits') }}
where counter_id = 62
  and event_date between date '2013-07-01' and date '2013-07-31'
  and coalesce(dont_count_hits, 0) = 0
  and coalesce(is_refresh, 0) = 0
  and title <> ''
group by title
order by pageviews desc
limit 10
