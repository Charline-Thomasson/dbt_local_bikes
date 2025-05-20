{% docs mrt_local_bike_stock %}

# `mrt_local_bike_stock` Model Documentation

This document provides detailed information about the `mrt_local_bike_stock` dbt model, designed to offer a consolidated and pivoted view of product inventory levels across specific stores, along with an aggregated stock status.

## Overview

The `mrt_local_bike_stock` model transforms granular stock data into a more digestible format, presenting the stock quantity of each product for specific key stores in separate columns. Additionally, it calculates an overall stock status for each product, providing a quick indicator of its availability. This model is highly valuable for inventory planning, sales teams needing quick stock checks, and identifying products that are sold out or in low supply.

## Data Sources

This model primarily utilizes two intermediate models:
* `int_local_bike_detailed_product`: This model provides comprehensive details about each product, including its name, model year, brand, and category.
* `int_local_bike_stock_level`: This model provides the current stock quantity of each product at each store.

The data flow involves enriching product information with stock levels and then pivoting the stock quantities by specific store IDs.

## Model Logic

The `mrt_local_bike_stock` model employs Common Table Expressions (CTEs) to achieve its final structure:

* **`product_data` CTE**: Retrieves detailed product information from `int_local_bike_detailed_product`, grouping by all columns to ensure uniqueness.
* **`stock_data` CTE**:
    * `LEFT JOIN`s the `product_data` CTE with `int_local_bike_stock_level` on `product_id`.
    * Calculates `SUM(stock.quantity)` as `stock_left` for each product at each store, effectively rolling up stock quantities for each product-store combination.
    * Groups by all columns to ensure correct aggregation.
* **`result` CTE**: Selects specific fields (`store_name`, `store_id`, `product_name`, `model_year`, `brand_name`, `category_name`, `stock_left`) from `stock_data` for a cleaner intermediate step.
* **Final Select Statement**:
    * Aggregates the `stock_left` using `SUM(CASE WHEN ...)` statements to create pivoted columns for `store_id_1_stock`, `store_id_2_stock`, and `store_id_3_stock`. This effectively transforms rows into columns for specific stores.
    * Calculates `total_stock_status` based on the sum of `stock_left` across all stores, categorizing it as "sold out", "low stock", or "sufficient stock".
    * Groups the final result by `product_name` to ensure that stock levels and status are summarized per product.

{% enddocs %}