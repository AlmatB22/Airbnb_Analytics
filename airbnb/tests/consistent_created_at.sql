select 
    r.*,
    l.created_at
from {{ ref('fct_airbnb__reviews') }} r
left join {{ ref('dim_airbnb__listings') }} l
    on r.listing_id = l.listing_id
where l.created_at > r.review_date
limit 10