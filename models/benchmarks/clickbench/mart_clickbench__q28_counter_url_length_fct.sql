with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    counter_id,
    avg(length(url)) as avg_url_length,
    count(*) as hit_count
from hits
where url <> ''
group by counter_id
having count(*) > 100000
order by avg_url_length desc
limit 25
