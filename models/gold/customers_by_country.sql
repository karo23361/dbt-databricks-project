{{ config(materialized='table') }}

select
    country,
    count(*) as customers_count,
    count(distinct customer_id) as unique_customers,
    max(updated_at) as last_updated_at
from {{ ref('stg_sales_customers') }}
group by country
