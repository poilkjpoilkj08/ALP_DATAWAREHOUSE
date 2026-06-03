with bookings as (
    select * from {{ ref('stg_bookings') }}
),
hotels as (
    select * from {{ ref('dim_hotels') }}
),
countries as (
    select * from {{ ref('dim_countries') }}
),
room_types as (
    select * from {{ ref('dim_room_types') }}
),
channels as (
    select * from {{ ref('dim_booking_channels') }}
)

select
    -- 1. primary key fact table 
    b.booking_id,

    -- 2. foreign key 
    b.hotel_id,
    b.country_code,
    b.channel_id,
    b.reserved_room_type_code,
    b.assigned_room_type_code,

    -- 3. dim time
    b.arrival_date_year,
    b.arrival_date_month,
    b.arrival_date_week_number,
    b.arrival_date_day_of_month,
    -- Kalkulasi format tanggal utuh (YYYY-MM-DD) untuk filter time-series di BI
    PARSE_DATE('%Y %B %e', CONCAT(CAST(b.arrival_date_year AS STRING), ' ', b.arrival_date_month, ' ', CAST(b.arrival_date_day_of_month AS STRING))) as arrival_date_full,

    -- 4. metrics
    b.stays_in_weekend_nights,
    b.stays_in_week_nights,
    b.stays_in_weekend_nights + b.stays_in_week_nights as total_stays_nights, -- kalkulasi total malam menginap 
    b.adults,
    b.children,
    b.babies,
    b.adults + b.children + b.babies as total_guests, -- kalkulasi total tamu 
    b.adr as average_daily_rate,
    (b.stays_in_weekend_nights + b.stays_in_week_nights) * b.adr as estimated_revenue, -- Kalkulasi Estimasi Pendapatan
    
    -- 5. business logic dan segmentassi
    -- Segmentasi jenis tamu berdasarkan jumlah
    CASE 
        WHEN b.adults = 1 AND b.children = 0 AND b.babies = 0 THEN 'Solo'
        WHEN b.adults = 2 AND b.children = 0 AND b.babies = 0 THEN 'Couple'
        WHEN (b.children > 0 OR b.babies > 0) THEN 'Family'
        ELSE 'Group/Other'
    END as guest_segment,

    -- Segmentasi waktu booking
    CASE 
        WHEN b.lead_time < 7 THEN 'Last Minute (0-6 days)'
        WHEN b.lead_time BETWEEN 7 AND 30 THEN 'Normal (7-30 days)'
        ELSE 'Early Bird (> 30 days)'
    END as lead_time_category,

    -- 6. status and info tambahan 
    b.is_canceled,
    b.lead_time,
    b.is_repeated_guest,
    b.previous_cancellations,
    b.previous_bookings_not_canceled,
    b.booking_changes,
    b.deposit_type,
    b.customer_type,
    b.required_car_parking_spaces,
    b.total_of_special_requests,
    b.reservation_status,
    b.reservation_status_date

from bookings b
-- menggunakan left join untuk memastikan semua data tabel utama terangkut
left join hotels h on b.hotel_id = h.hotel_id
left join countries c on b.country_code = c.country_code
left join room_types rt on b.reserved_room_type_code = rt.room_type_code
left join channels ch on b.channel_id = ch.channel_id