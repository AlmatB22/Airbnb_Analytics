-- SINGULAR TEST
select * 
from {{ ref('dim_airbnb__listings') }}
where minimum_nights < 1
limit 10