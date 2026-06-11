select
    channel_id,
    coalesce(market_segment, 'Unknown') as market_segment,
    coalesce(distribution_channel, 'Unknown') as distribution_channel
from {{ ref('stg_booking_channels') }}