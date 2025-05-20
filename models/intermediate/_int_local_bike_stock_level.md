{% docs int_local_bike_stock_level %}

# Store Stock Model Documentation

This document provides detailed information about the `store_stock` dbt model, which aggregates current inventory levels for each product across all our stores.

## Overview

The `store_stock` model combines raw stock data with store-specific information to offer a clear and immediate picture of what products are available at which locations. This model is essential for inventory management, supply chain optimization, and informing customers about product availability. It helps in quickly identifying stock levels and understanding product distribution across our retail network.

## Data Sources

This model joins two staging models:
* `stg_local_bike_stock`: This is the primary source, providing the `product_id`, `store_id`, and `quantity` for each stock entry.
* `stg_local_bike_store`: Joined on `store_id`, this brings in the `store_name` for better readability and contextual analysis.

Maintaining accurate and up-to-date data in these staging layers is critical for the operational efficiency and reliability of the `store_stock` model.

## Model Logic

The `store_stock` model performs the following key transformations and joins:

* **Core Stock Selection**: It selects the fundamental stock attributes, including `store_id`, `product_id`, and `quantity`.
* **Store Name Enrichment**: It enriches the stock records with the corresponding `store_name` by `LEFT JOIN`ing on `store_id` to the `stg_local_bike_store` model. This eliminates the need for downstream joins to get store names.


{% enddocs %}