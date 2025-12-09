with hits as (
    select *
    from {{ ref('stg_clickbench__hits') }}
)

select
    adv_engine_id,
    resolution_width,
    user_id,
    search_phrase,
    event_date,
    event_time,
    region_id,
    mobile_phone_model,
    mobile_phone,
    search_engine_id,
    url,
    title,
    referer,
    counter_id,
    dont_count_hits,
    is_refresh,
    is_link,
    is_download,
    trafic_source_id,
    url_hash,
    referer_hash,
    window_client_width,
    window_client_height,
    client_ip,
    watch_id
from hits
where url ilike '%google%'
order by event_time
limit 10
