with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    regexp_replace(referer, '^https?://(?:www\\.)?([^/]+)/.*$', '\\1') as referer_domain,
    avg(length(referer)) as avg_referer_length,
    count(*) as hit_count,
    min(referer) as sample_referer
from hits
where referer <> ''
group by referer_domain
having count(*) > 100000
order by avg_referer_length desc
limit 25
