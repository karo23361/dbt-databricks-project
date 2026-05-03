with source as (

    select * 
    from {{ source('raw', 'sales_customers') }}

),

silver_stg as (

    select
        customerID          as customer_id,
        first_name          as first_name,
        last_name           as last_name,
        concat(first_name, ' ', last_name) as full_name,
        email_address       as email,
        phone_number        as phone,
        address             as address,
        city                as city,
        state               as state,
        country             as country,
        continent           as continent,
        postal_zip_code     as postal_code,
        gender              as gender,
        current_timestamp() as ingested_at
    from source

)

select * from silver_stg;
