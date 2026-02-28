{% macro where_not_null(column_names)%}
    {%- for col in column_names-%}
        {{ col }} is not null
        {% if not loop.last%} and {% endif %}
    {% endfor -%}
{% endmacro %}