with product_data as (
  
select 
product_name,
model_year,
product_id,
brand_name,
brand_id,
category_name,
category_id
from {{ ref('int_local_bike_detailed_product')}}
 
)

,sales_data as (

select
orders.order_date,
orders.year,
orders.month,
orders.year_month, 
orders.original_order_status,
orders.new_order_status,
orders.required_date,
orders.shipped_date,
orders.order_id,
orders.item_id,
orders.product_id,
orders.quantity,
orders.unit_price,
orders.discount,
orders.store_name,
orders.store_state,
orders.store_city,
customer.customer_id

from {{ ref('int_local_bike_order')}} orders
left join {{ ref('int_local_bike_customer')}} customer on orders.customer_id = customer.customer_id

)

select
order_date,
year,
month,
year_month,
order_id,
original_order_status,
new_order_status,
product.product_name,
sales.product_id,
product.brand_name as product_brand,
product.category_name as product_category,
sales.quantity,
sales.unit_price,
sales.discount,
ROUND({{ calculate_price('unit_price','quantity','discount') }},2) as total_line_amount,
sales.required_date,
sales.shipped_date,
sales.store_name,
sales.store_state,
sales.customer_id
-- sales.customer_name,
-- sales.customer_state,
-- sales.customer_city,
-- case when lower(product.category_name) = "children bicycles" then 1
-- else 0 end as has_kids_yes_no

from sales_data sales
left join product_data product on sales.product_id = product.product_id
