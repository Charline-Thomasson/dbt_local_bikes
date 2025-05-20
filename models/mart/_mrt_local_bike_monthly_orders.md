{% docs mrt_local_bike_monthly_orders %}

# Monthly Sales Performance Model Documentation

This document provides detailed information about the `mrt_local_bike_monthly_orders` dbt model, which offers aggregated sales metrics with month-over-month comparisons at a granular level.

## Overview

The `mrt_local_bike_monthly_orders` model is designed to track and analyze sales trends and performance over time. It aggregates key sales metrics (orders, items sold, total amount, average order value, average items per order) on a monthly basis, broken down by store, product, brand, and category. A crucial feature of this model is the inclusion of previous month's values for direct month-over-month comparison, facilitating easy identification of growth or decline.

## Data Sources

This model directly queries the `mrt_local_bike_detailed_order` model. This upstream model is expected to provide all the necessary detailed order line item information, including derived product and store attributes.

## Model Logic

The `mrt_local_bike_monthly_orders` model performs the following key transformations and aggregations:

* **Aggregation**: It groups the data by `year`, `month`, `year_month`, `store_name`, `product_name`, `product_brand`, and `product_category`.
* **Current Month Metrics**: It calculates the following metrics for the current month:
    * `total_orders`: Count of distinct `order_id`s.
    * `total_items_sold`: Sum of `quantity`.
    * `total_order_amount`: Sum of `total_line_amount`, rounded to two decimal places.
    * `average_order_value`: `total_order_amount` divided by `total_orders`, rounded to two decimal places.
    * `average_order_item`: `total_items_sold` divided by `total_orders`, rounded to the nearest whole number.
* **Previous Month Metrics**: For each of the above metrics, it uses the `LAG()` window function to retrieve the corresponding value from the previous month. The `PARTITION BY store_name, product_name, product_brand, product_category ORDER BY year, month` clause ensures that the `LAG` function operates correctly within each unique combination of store, product, brand, and category, ordered chronologically. A default value of `0` is used for the first month in a partition where no previous month exists.
* **Ordering**: The final output is ordered by `year` and `month` to present the data chronologically.


{% enddocs %}