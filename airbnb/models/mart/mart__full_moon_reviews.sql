with reviews as (
    select *
    from {{ref('fct_airbnb__reviews')}}
),
full_moon_dates as (
    select * 
    from {{ref('seed_full_moon_dates')}}
)

select 
    r.*,
    case
        when fmd.full_moon_date is null then 'not full moon'
        else ' day after full moon'
    end as is_full_moon
from reviews r
left join full_moon_dates fmd on to_date(r.review_date) = dateadd(day, 1,fmd.full_moon_date)
order by full_moon_date