{% docs dim_airbnb__hosts %}
Cleansed dimension table containing Airbnb host information sourced from `raw_hosts`.

Null host names are replaced with the value `'Anonymous'` to ensure downstream reporting always has a displayable name. A dbt contract is enforced on this model, locking column names and data types.
{% enddocs %}

{% docs dim_airbnb__hosts__host_name %}
Display name of the host. When the source value is `NULL`, this column is set to `'Anonymous'` so that all rows have a non-null, human-readable name.
{% enddocs %}

{% docs dim_airbnb__hosts__is_superhost %}
Indicates whether the host holds Airbnb Superhost status (`t` = superhost, `f` = standard host). Superhosts meet Airbnb's criteria for high ratings, response rate, and completed stays.
{% enddocs %}

{% docs dim_airbnb__listings__minimum_nights%}
Minimum number of nights require to rent this property

Keep in mind that old listings might have `minimum_nights` set to 0 in the source tables. Our cleansing algorithm updates this to `1`. 

{% enddocs %}