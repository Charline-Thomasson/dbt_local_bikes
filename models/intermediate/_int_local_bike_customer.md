{% docs int_local_bike_customer %}

# Customers Model Documentation

This document provides detailed information about the `customers` dbt model, which serves as a foundational dataset for analyzing customer information within our data warehouse.

## Overview

The `customers` model is built upon raw customer data from our source systems (specifically `stg_local_bike_customer`) and enriches it by creating derived attributes like `full_name` and `full_address`. It aims to provide a clean, standardized, and readily usable dataset of customer demographics and contact information.

## Data Source

This model directly references the `stg_local_bike_customer` staging model. It is crucial that the data quality within the staging layer is maintained to ensure the integrity of this model.

## Model Logic

The `customers` model performs the following transformations:

* **Selection of Core Attributes**: It selects essential customer attributes such as `customer_id`, `first_name`, `last_name`, `phone`, `email`, `street`, `city`, `state`, and `zip_code`.
* **Concatenation of Full Name**: It combines `first_name` and `last_name` to create a user-friendly `full_name` field.
* **Concatenation of Full Address**: It consolidates `street`, `city`, `state`, and `zip_code` into a single `full_address` field for convenience.

{% enddocs %}