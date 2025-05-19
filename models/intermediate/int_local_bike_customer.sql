select

    customer_id,
    first_name,
    last_name,
    concat(first_name, " ", last_name) as full_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code,
    concat(street, ", ", city, ", ", state, ", ", zip_code) as full_address

from {{ ref('stg_local_bike_customer')}}