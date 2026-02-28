with hosts as (
    select *
    from {{ ref('dim_airbnb__hosts')}}
)
select distinct(is_superhost) from hosts