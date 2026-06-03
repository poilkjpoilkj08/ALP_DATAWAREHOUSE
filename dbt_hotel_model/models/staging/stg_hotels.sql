with source_data as (
    select * from {{ source('hotel_raw_source', 'hotels') }}
)

select
    cast(hotel_id as STRING) as hotel_id,
    cast(hotel_name as STRING) as hotel_name
from source_data