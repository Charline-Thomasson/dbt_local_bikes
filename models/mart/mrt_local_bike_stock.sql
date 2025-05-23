WITH product_data AS (

  SELECT
    product_name,
    model_year,
    product_id,
    brand_name,
    brand_id,
    category_name,
    category_id
  FROM
    {{ref('int_local_bike_detailed_product')}} 
  GROUP BY ALL 
  
)

,stock_data AS(

  SELECT
    product.*,
    stock.store_id,
    stock.store_name,
    SUM(stock.quantity) AS stock_left,
  FROM
    product_data product
  LEFT JOIN
    {{ref('int_local_bike_stock_level')}} stock
  ON
    product.product_id = stock.product_id
  GROUP BY
    ALL ),
  result AS(
  SELECT
    store_name,
    store_id,
    product_name,
    model_year,
    brand_name,
    category_name,
    stock_left
  FROM
    stock_data )
SELECT
  product_name,
  -- array_agg(product_id) as product_id_list, -- check if necessary to add
  SUM(CASE
      WHEN store_id = 1 THEN stock_left
      ELSE 0
  END
    ) AS Santa_Cruz_Bikes,
  SUM(CASE
      WHEN store_id = 2 THEN stock_left
      ELSE 0
  END
    ) AS Baldwin_Bikes,
  SUM(CASE
      WHEN store_id = 3 THEN stock_left
      ELSE 0
  END
    ) AS Rowlett_Bikes,
  SUM(stock_left) as total_stock,

  CASE 
  WHEN SUM(stock_left) = 0 THEN "sold out"
  WHEN (SUM(stock_left) >= 1 AND SUM(stock_left) <= 4) THEN "low stock (1-4 left)"
  WHEN SUM(stock_left) >= 5 THEN "sufficient stock"
  END AS total_stock_status

FROM
  result
GROUP BY
  product_name