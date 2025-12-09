{{ config(materialized='view') }}

select
    advengineid as adv_engine_id,
    resolutionwidth as resolution_width,
    userid as user_id,
    searchphrase as search_phrase,
    make_date(EventDate) as event_date,
    eventtime as event_time,
    regionid as region_id,
    mobilephonemodel as mobile_phone_model,
    mobilephone as mobile_phone,
    searchengineid as search_engine_id,
    url,
    title,
    referer,
    counterid as counter_id,
    dontcounthits as dont_count_hits,
    isrefresh as is_refresh,
    islink as is_link,
    isdownload as is_download,
    traficsourceid as trafic_source_id,
    urlhash as url_hash,
    refererhash as referer_hash,
    windowclientwidth as window_client_width,
    windowclientheight as window_client_height,
    clientip as client_ip,
    watchid as watch_id

from {{ source('clickbench', 'hits') }}
