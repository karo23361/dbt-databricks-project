{{ config(materialized='incremental', file_format='delta') }}

with source as (

    select * 
    from {{ source('raw', 'sales_customers') }}

),

silver_stg as (

    select 
        customerID as customer_id,
        concat(first_name, ' ', last_name) as full_name,
        {{ clean_string('email_address') }} as email,
        trim(regexp_replace(phone_number, '[^0-9+]','')) as phone,
        address as address,
        ltrim(city) as city,
        ltrim(state) as state,
        ltrim(country) as country,
        ltrim(continent) as continent,
        {{ clean_string('postal_zip_code') }} as postal_code,
        {{ clean_string('gender') }} as gender,
        current_timestamp() as ingested_at,
        current_timestamp() as updated_at
    from source

)

select * from silver_stg

{% if is_incremental() %}
where updated_at > (select max(updated_at) from {{ this }})
{% endif %}
