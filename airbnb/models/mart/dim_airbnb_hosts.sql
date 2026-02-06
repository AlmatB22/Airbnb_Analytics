with hosts as (
    select *
    from {{ref('stg_airbnb__hosts')}}
)

select 
    host_id,
    NVL(host_name, 'Anonymous') as host_name,
    is_superhost,
    created_at,
    updated_at
from hosts