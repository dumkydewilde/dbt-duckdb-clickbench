with base as (
    select
        client_ip,
        client_ip - 1 as client_ip_minus_1,
        client_ip - 2 as client_ip_minus_2,
        client_ip - 3 as client_ip_minus_3
    from {{ ref('stg_clickbench__hits') }}
)

select
    client_ip,
    client_ip_minus_1,
    client_ip_minus_2,
    client_ip_minus_3,
    count(*) as hit_count
from base
group by client_ip, client_ip_minus_1, client_ip_minus_2, client_ip_minus_3
order by hit_count desc
limit 10
