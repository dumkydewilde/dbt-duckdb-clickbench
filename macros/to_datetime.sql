{% macro to_datetime(col) %}
    epoch_ms({{ col }} * 1000)
{% endmacro %}
