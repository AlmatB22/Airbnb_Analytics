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

select *
from reviews
where review_text is not null
{% if is_incremental() %}
    AND review_date > (select max(review_date) from {{this}})
{% endif %}