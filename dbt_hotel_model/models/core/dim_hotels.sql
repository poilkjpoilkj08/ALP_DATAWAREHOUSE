select
    hotel_id,
    hotel_name
from {{ ref('stg_hotels') }}