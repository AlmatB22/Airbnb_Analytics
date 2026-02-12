with hosts as (
    select *
    from {{ref('dim_airbnb__hosts')}}
),
listings as (
    select *
    from {{ref('dim_airbnb__listings')}}
)

select 
    l.listing_id,
    l.listing_name,
    l.listing_url,
    l.room_type,
    l.minimum_nights,
    l.price,
    l.host_id,
    h.host_name,
    h.is_superhost as host_is_superhost,
    l.created_at,
    greatest(l.updated_at, h.updated_at) as updated_at
from listings l
left join hosts h on l.host_id = h.host_id