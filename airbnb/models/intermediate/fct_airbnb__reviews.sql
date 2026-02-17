{{
  config(
    materialized = 'incremental',
    on_schema_change = 'fail'

    )
}}
with reviews as (
    select *
    from {{ref('stg_airbnb__reviews')}}
)

select 
{{ dbt_utils.generate_surrogate_key(['LISTING_ID', 'REVIEWER_NAME', 'REVIEW_DATE', 'REVIEW_TEXT']) }} as review_id,
*
from reviews
where review_text is not null
{% if is_incremental() %}
    AND review_date > (select max(review_date) from {{this}})
{% endif %}