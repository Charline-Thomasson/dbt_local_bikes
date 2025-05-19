select
    product.product_name,
    product.model_year,
    product.product_id,
    brand.brand_name,
    product.brand_id,
    category.category_name,
    product.category_id
from {{ ref('stg_local_bike_product')}} product
left join
    {{ ref('stg_local_bike_product_category')}} category
    on product.category_id = category.category_id
left join 
    {{ ref('stg_local_bike_brand')}} brand 
    on product.brand_id = brand.brand_id
group by all
