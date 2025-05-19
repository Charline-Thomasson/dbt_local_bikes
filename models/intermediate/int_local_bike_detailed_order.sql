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
extract(year from order_date) as year,
extract(month from order_date) as month,
concat(extract(year from order_date), "-", extract(month from order_date)) as year_month, 
orders.original_order_status,
orders.new_order_status,
orders.required_date,
orders.shipped_date,
order_item.*,
store.store_name,
store.state as store_state,
store.city as store_city,
CONCAT(customer.first_name, " ", customer.last_name) as customer_name,
customer.state as customer_state,
customer.city as customer_city,
customer.zip_code as customer_zip_code

from {{ ref('stg_local_bike_order_item')}} order_item
left join {{ ref('stg_local_bike_order')}} orders on order_item.order_id = orders.order_id
left join {{ ref('stg_local_bike_store')}}store on orders.store_id = store.store_id
left join {{ ref('stg_local_bike_customer')}} customer on orders.customer_id = customer.customer_id

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
ROUND((quantity * unit_price) * (1 - discount),2) as total_line_amount,
sales.required_date,
sales.shipped_date,
sales.store_name,
sales.store_state,
sales.customer_name,
sales.customer_state,
sales.customer_city,
case when lower(product.category_name) = "children bicycles" then 1
else 0 end as has_kids_yes_no

from sales_data sales
left join product_data product on sales.product_id = product.product_id
