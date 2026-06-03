with source_data as (
    select * from {{ source('hotel_raw_source', 'booking_channels') }}
)

select
    cast(channel_id as STRING) as channel_id,
    cast(market_segment as STRING) as market_segment,
    cast(distribution_channel as STRING) as distribution_channel
from source_data