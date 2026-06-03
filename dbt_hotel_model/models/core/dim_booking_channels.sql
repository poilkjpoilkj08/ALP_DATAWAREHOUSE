select
    channel_id,
    market_segment,
    distribution_channel
from {{ ref('stg_booking_channels') }}