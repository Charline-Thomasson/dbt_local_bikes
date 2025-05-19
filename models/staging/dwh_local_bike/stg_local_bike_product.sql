select
    product_id,
    product_name,
    brand_id,
    category_id,
    model_year,
    list_price as unit_price
from {{ source("local_bike", "product") }}