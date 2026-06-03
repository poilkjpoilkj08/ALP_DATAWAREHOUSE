select
    room_type_code,
    room_type_label
from {{ ref('stg_room_types') }}