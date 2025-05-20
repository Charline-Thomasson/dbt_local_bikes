{% macro calculate_price(price,quantity,discount) %}
({{price}} * {{quantity}}) * (1 - {{discount}})
{% endmacro %}
