with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
    where search_phrase <> ''
)

select
    watch_id,
    client_ip,
    count(*) as hit_count,
    sum(coalesce(is_refresh, 0)) as refresh_sum,
    avg(resolution_width) as avg_resolution_width
from hits
group by watch_id, client_ip
order by hit_count desc
limit 10
