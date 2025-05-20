{% docs int_local_bike_order %}

# Order Details Model Documentation

This document provides detailed information about the `order_details` dbt model, which serves as a comprehensive dataset for analyzing all aspects of our bike sales orders, from placement to shipment, including product and store specifics.

## Overview

The `order_details` model is a denormalized view that integrates data from our raw order, order item, and store sources. It enriches the core order information with calculated date parts (`year`, `month`, `year_month`) and crucial details about the specific items within each order, as well as the store where the order was placed. This model is designed to facilitate in-depth analysis of sales trends, product performance, and store-level insights without requiring complex joins in downstream queries.

## Data Sources

This model joins three staging models:
* `stg_local_bike_order_item`: This is the primary source, providing details for each individual item within an order.
* `stg_local_bike_order`: Joined on `order_id`, this brings in order-level attributes like `order_date`, `customer_id`, and `order_status`.
* `stg_local_bike_store`: Joined on `store_id` (from the `orders` table), this adds geographical and naming information about the store.

Maintaining the data quality within these staging layers is critical to the integrity and accuracy of the `order_details` model.

## Model Logic

The `order_details` model performs the following key transformations and joins:

* **Core Item Selection**: It starts with the granular `order_item` data, ensuring each row represents a unique product within a specific order.
* **Order-Level Enrichment**: It enriches each order item with corresponding order details by `LEFT JOIN`ing on `order_id`. This brings in fields like `order_date`, `customer_id`, and order statuses.
* **Store Information Integration**: It further enriches the data by `LEFT JOIN`ing with the `store` model on `store_id`, pulling in `store_name`, `store_state`, and `store_city`.
* **Date Part Extraction**: It extracts `year` and `month` from the `order_date` for easier time-based analysis.
* **Year-Month Concatenation**: It creates a `year_month` field (e.g., "2023-01") for simplified chronological grouping and filtering.

{% enddocs %}