{% docs mrt_local_bike_customer_stats %}

# mrt_local_bike_customer_stats Model Documentation

This document provides detailed information about the `mrt_local_bike_customer_stats` dbt model, designed to offer a deep, analytical understanding of our customer base, including their purchasing habits, preferences, and overall value.

## Overview

The `mrt_local_bike_customer_stats` model is a robust dimension table that combines detailed customer information with their complete purchasing history to derive key metrics and segments. It calculates essential customer lifetime value (CLV) indicators, identifies purchasing patterns, and assigns customers to specific segments based on their preferred bicycle categories. This model is critical for targeted marketing campaigns, customer relationship management, and strategic business decision-making.

## Data Sources

This model extensively uses two intermediate models:
* `mrt_local_bike_detailed_order`: This provides granular order and product details, including product categories, brands, and line item amounts. It is the primary source for calculating purchase preferences and history.
* `int_local_bike_customer`: This provides core customer demographic and address information.

The model builds upon these sources through a series of CTEs and joins to enrich the customer data.

## Model Logic

The `mrt_local_bike_customer_stats` model is constructed through several sequential Common Table Expressions (CTEs) and a final aggregation:

* **`customer_category_preferences` CTE**: This CTE calculates the total number of purchases for specific bicycle categories (City Bikes, Sports Bikes, Kids Bikes) for each customer. It joins `mrt_local_bike_detailed_order` with `int_local_bike_customer` and groups by all customer attributes to sum up category-specific purchases.
* **`customer_segments` CTE**: This CTE uses the purchase counts from `customer_category_preferences` to assign a `customer_segment`. It employs `CASE` statements to identify predominant purchase types, handling tie-breaker scenarios to assign segments like 'City Bikers', 'Sports Bikers', 'Kids', or 'Mixed'.
* **`combined_segments` CTE**: This CTE joins the `customer_segments` with `mrt_local_bike_detailed_order` again to identify if a customer `has_kids` (i.e., has purchased children's bicycles). It groups by all relevant customer and segment attributes.
* **`customer_favorites` CTE**: This CTE determines each customer's most frequently purchased `favorite_brand` and `favorite_product`. It achieves this by counting purchases for each brand-product combination per customer and then using a `ROW_NUMBER()` window function to rank them, selecting only the top item (`rn = 1`).
* **`final_result` CTE**: This is the core aggregation step.
    * It joins `mrt_local_bike_detailed_order` (aliased as `sd`) with `combined_segments` (`cs`) and `customer_favorites` (`cf`) on `customer_id`.
    * It calculates various customer-level metrics:
        * `first_buy` (minimum order date).
        * `last_buy` (maximum order date).
        * `months_since_last_buy` (recency metric, calculated against a fixed date of '2018-12-29').
        * `new_known_customer` (classifying customers based on first vs. repeated purchases).
        * `total_orders` (count of distinct orders).
        * `total_items` (sum of quantity).
        * `average_order_item`.
        * `customer_lifetime_value` (sum of `total_line_amount`).
        * `average_order_amount`.
    * All these metrics are grouped by customer and their derived segment/preference attributes.
* **Final Selection**: The model then selects all columns from the `final_result` CTE.



{% enddocs %}