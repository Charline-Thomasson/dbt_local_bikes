select
    category_id,
    category_name,
from {{ source ('local_bike', 'product_category')}}