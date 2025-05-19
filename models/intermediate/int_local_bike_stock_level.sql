select
    stock.store_id,
    store.store_name,
    stock.product_id,
    stock.quantity
from {{ ref('stg_local_bike_stock')}}  stock
left join {{ ref('stg_local_bike_store')}} store on stock.store_id = store.store_id