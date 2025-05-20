SELECT
  year,
  month,
  year_month,
  store_name,
  product_name,
  product_brand,
  product_category,
  COUNT(DISTINCT order_id) total_orders,
  ROUND(LAG(COUNT(DISTINCT order_id), 1, 0) OVER (PARTITION BY store_name, product_name, product_brand, product_category ORDER BY year, month)) AS previous_month_total_orders,
  SUM(quantity) AS total_items_sold,
  ROUND(LAG(SUM(quantity), 1, 0) OVER (PARTITION BY store_name, product_name, product_brand, product_category ORDER BY year, month)) AS previous_month_total_items_sold,
  ROUND(SUM(total_line_amount),2) AS total_order_amount,
  ROUND(LAG(SUM(total_line_amount), 1, 0) OVER (PARTITION BY store_name, product_name, product_brand, product_category ORDER BY year, month),2) AS previous_month_total_order_amount,
  ROUND(SUM(total_line_amount) / COUNT(DISTINCT order_id),2) AS average_order_value,
  ROUND(LAG(SUM(total_line_amount) / COUNT(DISTINCT order_id), 1, 0) OVER (PARTITION BY store_name, product_name, product_brand, product_category ORDER BY year, month),2) AS previous_month_average_order_value,
  ROUND(SUM(quantity) / COUNT(DISTINCT order_id)) AS average_order_item,
  ROUND(LAG(SUM(quantity) / COUNT(DISTINCT order_id), 1, 0) OVER (PARTITION BY store_name, product_name, product_brand, product_category ORDER BY year, month)) AS previous_month_average_order_item,
FROM
  {{ref('mrt_local_bike_detailed_order')}}

GROUP BY
  ALL
ORDER BY
  year,
  month