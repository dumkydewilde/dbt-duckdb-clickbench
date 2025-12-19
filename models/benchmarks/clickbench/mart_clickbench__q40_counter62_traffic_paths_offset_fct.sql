with hits as (
    select
        trafic_source_id,
        search_engine_id,
        adv_engine_id,
        case
            when coalesce(search_engine_id, 0) = 0 and coalesce(adv_engine_id, 0) = 0 then referer
            else ''
        end as src,
        url as dst
    from {{ ref('stg_clickbench__hits') }}
    where counter_id = 62
      and event_date between date '2013-07-01' and date '2013-07-31'
      and coalesce(is_refresh, 0) = 0
)

select
    trafic_source_id,
    search_engine_id,
    adv_engine_id,
    src,
    dst,
    count(*) as pageviews
from hits
group by trafic_source_id, search_engine_id, adv_engine_id, src, dst
order by pageviews desc
limit 10 offset 1000
