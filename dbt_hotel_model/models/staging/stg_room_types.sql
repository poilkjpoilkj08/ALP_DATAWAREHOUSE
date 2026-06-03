with source_data as (
    select * from {{ source('hotel_raw_source', 'room_types') }}
)

select
    cast(room_type_code as STRING) as room_type_code,
    cast(room_type_label as STRING) as room_type_label
from source_data