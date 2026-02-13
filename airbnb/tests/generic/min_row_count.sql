{% test min_row_count(model, min_rows) %}

select 
    count(*) as cnt
from {{ model }}
having cnt < {{ min_rows }}

{% endtest %}