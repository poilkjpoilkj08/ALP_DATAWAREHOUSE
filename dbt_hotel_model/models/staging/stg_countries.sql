with source_data as (
    select * from {{ source('hotel_raw_source', 'countries') }}
)

select
    cast(country_code as STRING) as country_code,
    cast(country_name as STRING) as country_name
from source_data