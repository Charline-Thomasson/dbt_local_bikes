{% docs int_local_bike_detailed_product %}

# Products Model Documentation

This document provides detailed information about the `product` dbt model, which serves as a central dataset for understanding our product catalog, including their associated brands and categories.

## Overview

The `product` model integrates raw product data with information from the brand and category lookup tables. It aims to provide a clean, enriched, and easily consumable dataset for analyzing product performance, categorizing inventory, and understanding brand contributions. This model is crucial for various analytical tasks related to sales, inventory management, and marketing.

## Data Sources

This model joins three staging models:
* `stg_local_bike_product`: This is the primary source, containing core product attributes.
* `stg_local_bike_product_category`: Joined on `category_id`, this brings in the human-readable `category_name`.
* `stg_local_bike_brand`: Joined on `brand_id`, this adds the `brand_name` to each product.

Ensuring the accuracy and consistency of data within these staging layers is paramount for the reliability of the `products` model.

## Model Logic

The `product` model performs the following key transformations and joins:

* **Core Product Selection**: It selects essential product attributes directly from the `stg_local_bike_product` source.
* **Category Enrichment**: It enriches each product with its corresponding category name by `LEFT JOIN`ing on `category_id` to `stg_local_bike_product_category`.
* **Brand Information Integration**: It further enriches the data by `LEFT JOIN`ing with the `stg_local_bike_brand` model on `brand_id`, bringing in the `brand_name`.
* **Aggregation**: The `GROUP BY all` clause ensures that if there were any duplicate combinations of product, brand, and category, they would be consolidated. However, given the nature of these joins, it primarily serves to explicitly define the grouping keys in a declarative way for most SQL dialects when no aggregate functions are present.



{% enddocs %}