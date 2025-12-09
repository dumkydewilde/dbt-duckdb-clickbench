select
    1 as literal_group,
    url,
    count(*) as hit_count
from {{ ref('stg_clickbench__hits') }}
group by literal_group, url
order by hit_count desc
limit 10
