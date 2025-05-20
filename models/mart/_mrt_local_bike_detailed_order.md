{% docs mrt_local_bike_detailed_order %}

#  Detailed order Model Documentation

This document provides detailed information about the `detailed_order` dbt model, which serves as a central analytic table for all sales transactions, enriched with product, customer, and store details.

## Overview

The `detailed_order` model is a comprehensive fact table designed for in-depth sales analysis. It brings together granular order item data with relevant dimensions from product, customer, and store entities. This model calculates the `total_line_amount` and provides various attributes crucial for understanding sales performance, product trends, customer behavior, and geographical sales distribution. It acts as the primary source for reporting and dashboards related to sales.

## Data Sources

This model utilizes two intermediate models:
* `int_local_bike_detailed_product`: This CTE, named `product_data`, provides comprehensive product attributes, including product name, model year, brand name, and category name.
* `int_local_bike_order`: This CTE, named `sales_data`, provides detailed order item information, which is further enriched by a `LEFT JOIN` to `int_local_bike_customer` on `customer_id` to include customer details.

The final model is constructed by `LEFT JOIN`ing the `sales_data` CTE with the `product_data` CTE on `product_id`. The accuracy and completeness of the upstream intermediate models are critical for the reliability of this fact table.

## Model Logic

The `detailed_order` model performs the following key transformations and joins:

* **`product_data` CTE**: Selects all necessary product attributes from `int_local_bike_detailed_product`.
* **`sales_data` CTE**:
    * Selects order-item level details, including derived date parts, order statuses, quantities, prices, and discounts from `int_local_bike_order`.
    * Enriches these details by `LEFT JOIN`ing with `int_local_bike_customer` on `customer_id` to bring in customer attributes.
* **Final Selection and Join**:
    * The main `SELECT` statement joins the `sales_data` CTE with the `product_data` CTE on `product_id`.
    * It renames `brand_name` to `product_brand` and `category_name` to `product_category` for clarity.
    * It calculates `total_line_amount` by applying the `calculate_price` macro (which typically accounts for `unit_price`, `quantity`, and `discount`), rounded to two decimal places.

## Columns

{% enddocs %}