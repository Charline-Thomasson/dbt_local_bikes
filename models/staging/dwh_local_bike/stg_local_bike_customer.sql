select
    customer_id,
    first_name,
    last_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code,
from {{ source("local_bike", "customer") }}
