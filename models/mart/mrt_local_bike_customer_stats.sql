WITH customer_category_preferences AS (
    SELECT
        full_name,
        customer.customer_id,
        state,
        city,
        zip_code,
        full_address,
        -- Calculate total purchases for each category per customer
        SUM(CASE WHEN product_category = 'Electric Bikes' OR product_category = 'Comfort Bicycles' OR product_category = 'Cruisers Bicycles' THEN 1 ELSE 0 END) AS city_bike_purchases,
        SUM(CASE WHEN product_category = 'Mountain Bikes' OR product_category = 'Cyclocross Bicycles' OR product_category = "Road Bikes" THEN 1 ELSE 0 END) AS sports_bike_purchases,
        SUM(CASE WHEN product_category = 'Children Bicycles' THEN 1 ELSE 0 END) AS kids_bike_purchases
    FROM
        {{ref('mrt_local_bike_detailed_order')}} orders
        LEFT JOIN {{ref('int_local_bike_customer')}} customer
        ON orders.customer_id = customer.customer_id
    GROUP BY
        ALL
),
customer_segments AS (
    SELECT
        full_name,
        customer_id,
        state,
        city,
        zip_code,
        full_address,
        -- Assign customer segment based on category preferences
        CASE
            WHEN city_bike_purchases > sports_bike_purchases AND city_bike_purchases > kids_bike_purchases THEN 'City Bikers'
            WHEN sports_bike_purchases > city_bike_purchases AND sports_bike_purchases > kids_bike_purchases THEN 'Sports Bikers'
            WHEN kids_bike_purchases > city_bike_purchases AND kids_bike_purchases > sports_bike_purchases THEN 'Kids'
            WHEN city_bike_purchases = sports_bike_purchases AND city_bike_purchases > kids_bike_purchases THEN 'City/Sports Bikers'  --tiebreaker
            WHEN city_bike_purchases = kids_bike_purchases AND city_bike_purchases > sports_bike_purchases THEN 'City/Kids Bikers'    --tiebreaker
            WHEN sports_bike_purchases = kids_bike_purchases AND sports_bike_purchases > city_bike_purchases THEN 'Sports/Kids Bikers'  --tiebreaker
            ELSE 'Mixed' 
        END AS customer_segment
    FROM customer_category_preferences
),
combined_segments AS ( -- CTE to combine the 2 segmentations
  SELECT
    s.full_name,
    s.customer_id,
    s.state,
    s.city,
    s.zip_code,
    s.full_address,
    s.customer_segment,
    CASE WHEN (product_category) = "children bicycles" THEN 1
    ELSE 0 
    END AS has_kids
  FROM customer_segments s
  JOIN {{ref('mrt_local_bike_detailed_order')}} sd ON s.customer_id = sd.customer_id
  GROUP BY ALL
),
customer_favorites AS (
    SELECT
        customer_id,
        -- most frequently purchased brand for each customer
        MAX(product_brand) AS favorite_brand,
        -- most frequently purchased product for each customer
        MAX(product_name) AS favorite_product
    FROM (
        SELECT
            customer_id,
            product_brand,
            product_name,
            COUNT(*) AS purchase_count,
            ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS rn
        FROM
            {{ref('mrt_local_bike_detailed_order')}}
        GROUP BY
            customer_id,
            product_brand,
            product_name
    )
    WHERE rn = 1
    GROUP BY customer_id
),
final_result AS (
    SELECT
        cs.full_name AS customer_name,
        cs.customer_id,
        cs.state AS customer_state,
        cs.city AS customer_city,
        cs.full_address AS customer_full_address,
        cs.has_kids,
        sd.store_name,
        MIN(sd.order_date) AS first_buy,
        MAX(sd.order_date) AS last_buy,
        -- assuming "today" or "current_date()" is 29th December 2018 since it is the most recent order_date available
        DATE_DIFF("2018-12-29", MAX(sd.order_date), MONTH) AS months_since_last_buy, 
        CASE WHEN DATE_DIFF(MAX(sd.order_date), MIN(sd.order_date), DAY) = 0 THEN "new customer"
        ELSE "repeated customer" 
        END AS new_known_customer,
        COUNT(DISTINCT sd.order_id) AS total_orders,
        SUM(sd.quantity) AS total_items,
        ROUND(SUM(sd.quantity) / COUNT(DISTINCT sd.order_id), 2) AS average_order_item,
        ROUND(SUM(sd.total_line_amount), 2) AS customer_lifetime_value,
        ROUND(SUM(sd.total_line_amount) / COUNT(DISTINCT sd.order_id), 2) AS average_order_amount,
        cs.customer_segment,
        cf.favorite_brand,
        cf.favorite_product
    FROM
        {{ref('mrt_local_bike_detailed_order')}} sd
    JOIN
        combined_segments cs ON sd.customer_id = cs.customer_id
    LEFT JOIN 
        customer_favorites cf ON sd.customer_id= cf.customer_id
    GROUP BY
        cs.full_name,
        cs.customer_id,
        cs.state,
        cs.city,
        cs.full_address,
        cs.has_kids,
        sd.store_name,
        cs.customer_segment,
        cf.favorite_brand,
        cf.favorite_product
    ORDER BY
        cs.full_name
)

SELECT * from final_result
