select
    concat(order_id,"-",item_id) as order_item_id,
    order_id,
    item_id,
    product_id,
    quantity,
    list_price as unit_price,
    discount
from {{ source("local_bike", "order_item") }}