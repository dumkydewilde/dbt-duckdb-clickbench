select
    url,
    count(*) as hit_count
from {{ ref('stg_clickbench__hits') }}
group by url
order by hit_count desc
limit 10
