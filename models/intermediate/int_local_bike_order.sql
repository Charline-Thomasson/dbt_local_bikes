select
orders.order_date,
extract(year from order_date) as year,
extract(month from order_date) as month,
concat(extract(year from order_date), "-", extract(month from order_date)) as year_month, 
orders.original_order_status,
orders.customer_id,
orders.new_order_status,
orders.required_date,
orders.shipped_date,
order_item.*,
store.store_name,
store.state as store_state,
store.city as store_city

from {{ ref('stg_local_bike_order_item')}} order_item
left join {{ ref('stg_local_bike_order')}} orders on order_item.order_id = orders.order_id
left join {{ ref('stg_local_bike_store')}}store on orders.store_id = store.store_id