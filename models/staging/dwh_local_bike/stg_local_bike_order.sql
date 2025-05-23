select
    order_id,
    customer_id,
    order_status as original_order_status,
    case
        when order_status = 4 then "finalised order" else "non finalised order"
    end as new_order_status,
    order_date,
    required_date,
    safe_cast(shipped_date as date) as shipped_date,
    store_id,
    staff_id as employee_id
from {{ source("local_bike", "order") }}
