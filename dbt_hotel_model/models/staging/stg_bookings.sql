with source_data as (
    select * from {{ source('hotel_raw_source', 'bookings') }}
)

select
    -- 1. Keys / Identitas
    cast(booking_id as STRING) as booking_id,
    cast(hotel_id as STRING) as hotel_id,
    cast(channel_id as STRING) as channel_id,
    cast(country_code as STRING) as country_code,
    
    -- 2. Detail Kamar
    cast(reserved_room_type_code as STRING) as reserved_room_type_code,
    cast(assigned_room_type_code as STRING) as assigned_room_type_code,
    
    -- 3. Informasi Tanggal 
    cast(arrival_date_year as INT64) as arrival_date_year,
    cast(arrival_date_month as STRING) as arrival_date_month,
    cast(arrival_date_week_number as INT64) as arrival_date_week_number,
    cast(arrival_date_day_of_month as INT64) as arrival_date_day_of_month,
    
    -- 4. Durasi Menginap & Tamu
    cast(stays_in_weekend_nights as INT64) as stays_in_weekend_nights,
    cast(stays_in_week_nights as INT64) as stays_in_week_nights,
    cast(adults as INT64) as adults,
    cast(children as INT64) as children,
    cast(babies as INT64) as babies,
    cast(meal as STRING) as meal,
    
    -- 5. Riwayat Pemesanan & Status
    cast(is_canceled as INT64) as is_canceled,
    cast(lead_time as INT64) as lead_time,
    cast(is_repeated_guest as INT64) as is_repeated_guest,
    cast(previous_cancellations as INT64) as previous_cancellations,
    cast(previous_bookings_not_canceled as INT64) as previous_bookings_not_canceled,
    cast(booking_changes as INT64) as booking_changes,
    cast(days_in_waiting_list as INT64) as days_in_waiting_list,
    
    -- 6. Tipe Booking & Finansial
    cast(deposit_type as STRING) as deposit_type,
    cast(customer_type as STRING) as customer_type,
    cast(adr as FLOAT64) as adr, -- ADR (Average Daily Rate) bisa berbentuk desimal
    cast(required_car_parking_spaces as INT64) as required_car_parking_spaces,
    cast(total_of_special_requests as INT64) as total_of_special_requests,
    
    -- 7. Agent / Company ,pake string karean bisa mengandung text atau null
    cast(agent as STRING) as agent,
    cast(company as STRING) as company,
    
    -- 8. Status Akhir
    cast(reservation_status as STRING) as reservation_status,
    cast(reservation_status_date as DATE) as reservation_status_date

from source_data