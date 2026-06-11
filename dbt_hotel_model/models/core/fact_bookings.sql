with bookings as (
    select * from {{ ref('stg_bookings') }}
),
countries as (
    select * from {{ ref('dim_countries') }}
)

select
    -- 1. Primary Key Fact Table 
    b.booking_id,

    -- 2. Foreign Key (Aman & Sinkron 100% dengan Tabel Dimensi)
    coalesce(b.hotel_id, 'Unknown') as hotel_id,
    
    -- Menangani 488 data anomali negara: Jika kodenya tidak terdaftar di DIM, paksa jadi 'Unknown'
    CASE 
        WHEN c.country_code IS NOT NULL THEN b.country_code
        ELSE 'Unknown'
    END as country_code,
    
    coalesce(b.channel_id, 'Unknown') as channel_id,
    coalesce(b.reserved_room_type_code, 'Unknown') as reserved_room_type_code,
    coalesce(b.assigned_room_type_code, 'Unknown') as assigned_room_type_code,

    -- 3. Dim Time
    b.arrival_date_year,
    b.arrival_date_month,
    b.arrival_date_week_number,
    b.arrival_date_day_of_month,
    -- Kalkulasi format tanggal utuh (YYYY-MM-DD) untuk filter time-series di BI
    PARSE_DATE('%Y %B %e', CONCAT(CAST(b.arrival_date_year AS STRING), ' ', b.arrival_date_month, ' ', CAST(b.arrival_date_day_of_month AS STRING))) as arrival_date_full,

    -- 4. Metrics
    b.stays_in_weekend_nights,
    b.stays_in_week_nights,
    b.stays_in_weekend_nights + b.stays_in_week_nights as total_stays_nights, -- kalkulasi total malam menginap 
    b.adults,
    b.children,
    b.babies,
    b.adults + b.children + b.babies as total_guests, -- kalkulasi total tamu 
    b.adr as average_daily_rate,
    (b.stays_in_weekend_nights + b.stays_in_week_nights) * b.adr as estimated_revenue, -- Kalkulasi Estimasi Pendapatan
    
    -- 5. Business Logic dan Segmentasi
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

    -- 6. Status and Info Tambahan 
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
-- Melakukan LEFT JOIN ke master negara demi validasi uji relasi dbt test
left join countries c on b.country_code = c.country_code