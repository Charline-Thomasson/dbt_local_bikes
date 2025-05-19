select
    store_id,
    store_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code,
    concat(street, ", ", city, ", ", state, ", ", zip_code) as full_address
from {{ source("local_bike", "store") }}
