select
    staff_id,
    first_name,
    last_name,
    email,
    phone,
    active,
    store_id,
    safe_cast(manager_id as int) as manager_id
from {{ source("local_bike", "employee") }}
