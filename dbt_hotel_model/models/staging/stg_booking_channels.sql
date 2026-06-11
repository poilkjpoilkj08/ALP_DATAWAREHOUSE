with source_data as (
    select * from {{ source('hotel_raw_source', 'booking_channels') }}
)

select
    cast(channel_id as STRING) as channel_id,
    
    CASE 
        WHEN market_segment IS NULL 
             OR TRIM(market_segment) = '' 
             OR LOWER(TRIM(market_segment)) = 'null'
             OR LOWER(TRIM(market_segment)) = 'undefined' 
        THEN NULL -- Ubah ke NULL asli dulu
        ELSE cast(market_segment as STRING)
    END as market_segment,

    CASE 
        WHEN distribution_channel IS NULL 
             OR TRIM(distribution_channel) = '' 
             OR LOWER(TRIM(distribution_channel)) = 'null'
             OR LOWER(TRIM(distribution_channel)) = 'undefined' 
        THEN NULL -- Ubah ke NULL asli dulu
        ELSE cast(distribution_channel as STRING)
    END as distribution_channel

from source_data