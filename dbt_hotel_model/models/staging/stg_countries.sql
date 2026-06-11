 with source_data as (
    select * from {{ source('hotel_raw_source', 'countries') }}
)

select
    cast(country_code as STRING) as country_code,
    
    CASE 
        WHEN country_name IS NULL 
             OR TRIM(cast(country_name as STRING)) = '' 
             OR LOWER(TRIM(cast(country_name as STRING))) = 'null' 
             OR LOWER(TRIM(cast(country_name as STRING))) = 'undefined'
        THEN NULL 
        
        ELSE cast(country_name as STRING)
    END as country_name

from source_data