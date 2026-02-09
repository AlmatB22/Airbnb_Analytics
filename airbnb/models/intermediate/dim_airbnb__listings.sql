{{
    config(
        materialized='view'
    )
}}

with listings as (
    select *
    from {{ref('stg_airbnb__listings')}}
)

select 
    listing_id,
    listing_name,
    listing_url,
    room_type,
    case 
        when minimum_nights = 0 then 1
        else minimum_nights
    end as minimum_nights,
    host_id,
    cast(replace(price_str, '$', '') as numeric(10,2)) as price,
    created_at,
    updated_at
from listings