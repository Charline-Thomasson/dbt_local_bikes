# Welcome to my project for Local Bike!

##  - DataBird AE training: Final case study: Local Bike -

## Context: 
Final case study as part of the analytics engineering training with DataBird  
(6 weeks part-time & remote course)  
I have created models beginning with 9 csv files.  

### Models follow 3 steps of transformation:

### Staging : 

9 models (1 for each original csv file) going through very light transformations such as:  
casting columns into correct data type or aliasing for clarity

### Intermediate: 

4 models to join data from the original 9 models in order to get detailed data on specific topics identified for mart analysis  
3 topics identified are:  
    -  sales/order analysis: `int_local_bike_order` + `int_local_bike_detailed_product` (+ `int_local_bike_customer` only for the customer_id)  
    -  stock management: `int_local_stock_level`  + `int_local_bike_detailed_product`   
    -  customer knowledge: `int_local_bike_customer`   

### Mart: 

4 models :

- `mrt_local_bike_detailed_order` : is a dataset with the finest granularity, destined to teams wanting to experiment with self-service BI.  
The dataset does not contain any customer details for security/privacy reasons

- `mrt_local_bike_monthly_orders`: is derived directly from `mrt_local_bike_detailed_order` and aggregated to a monthly granularity for a ready-to-use or implement in dashboards audience

- `mrt_local_bike_stock`: aims to be used in a dashboard along with sales/order data to make sure that:  

   1: best selling products are still well stocked, especially as the average number of item per order is about 4.  
   2: appropriate action is taken to reduce long-life stocks (promotional campaigns to encourage sales)

- `mrt_local_bike_customer_stats`: intends to be used for various purposes
   
   1st purpose: use of KPIs metrics in dashboard which should be anonymised first or restricted to few users 
   
   2nd purpose: the dataset contains additional categorizations/ segmentation of clients which can be fed back to a CRM platform (reverse ETL).  
   --> this allows valuable insights to optimize communication campaigns. 
   Since "Local Bike" aims to provide personalized service, and stay active with local communities it should keep a regular line of communication with customers.  
   For example: send invites for events to the right public, i.e. if kids friendly event: send communication to customers identified with kids.  
   If event is centered around sports biking: invite customers who have purchased this type of bike...  
   With the "last buy date" information, it's also possible to send a friendly reminder to visit the shop in order to have a check on your bike or ask customers if they need any accessories, or even help with their tyres.  
   Another strategy with children's bikes could be offering a "bike swap discount" : as kids grow up they might need to upgrade bike size.  
   Therefore checking when the last purchase of a child bike was, and offering a generous discount for the next size bike in exchange of the currently owned bike could encourage customer loyalty.  
   And it would promote the circular / eco-friendly economy that local businesses aspire to.  


## Personal comments:

### On models:  

In this case study all models are materialized as views or tables because their size is rather small.
In the real world some of the tables would be of larger size and require partitionning and clustering strategies.
Local Bike is presented as small enterprise, but should the company's size grow in future and add more shops and more products to the catalogue:

Here are the models I would identify as large and my recommendations:  

`stg_local_bike_order` : partition by order_date  
`stg_local_bike_order_item` : cluster by order_id, item_id  
`stg_local_bike_stock` :  partition by store_id, cluster by category_id, product_id 

`mrt_local_bike_detailed_order` : would be materialized as incremental, partition by order_date, cluster by order_id    
In the sql file of the model I would try to add this config:  
{{  
    config(  
        materialized='incremental',  
        unique_key='order_id',  
        incremental_strategy='merge',  
        on_schema_change='sync_all_columns'   
    )  
}}  

## A final dashboard is available in PowerBI  
https://app.powerbi.com/links/fJ-tTX2u4_?ctid=30131f05-99e7-440a-a5e9-d3e8201e730c&pbi_source=linkShare  

/!\ There are flaws in the data which need to be corrected
For example average item per order should be around 4/5 overall.
The monthly dataset derived from the detailed_order dataset (order_item level) shouldn't have been pre-aggregated for measures of type average.  
For now notable insights to be derived from avaialble data are:    
A confirmation that that Baldwin is the historical shop with the largest customer base abd the highest number of orders/ revenue  
However Santa Cruz Bikes has the highest share of returning customers  
Amongst order insights we can see that the "Trek" brand generates most revenue due to hight prices.  
But Electra is the most ordered brand (most units sold).  
This brand trend is true for all 3 shops.  
The newest store: Rowlett Bikes has the highest average customer lifetime value (but this could be biased by the lower customer base)  

There is no explanation from looking at stocks regarding the non finalised orders from April 2018 onwards.
As there is no date attached to the stock photo it is difficult to know if it is compared to the relevant period.  


### On data quality: improvements/ steps required  

-  `order_status`:  needs to be explicit, there is no indication whatsoever as to what those integers mean.  
The only fact is that all orders with order_status = 4 have a "shipped_date".   
Therefore we can assume the order is complete.  
This needs to be improved, in order to know if there is a status "pending" for example, so that these orders can be treated quickly.  

-  The product catalogue is not maintained correctly.  
There are `product_names` which are exactly the same but with different `Product_id` and `Product_category`
So there are two possible issues:  
1.  it could be the same product with a different colour : then add the colour to the product name to differentiate them
2.  it is exactly the same product entered twice: in this case one of the product_ids needs to be discontinued   
  It cannot be deleted because there could be orders and stocks associated to it.  
  However, we can add a 'do not use' at the beginning of the name in order to slowly stop populating data through this product id.









### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
