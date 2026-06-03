select
    country_code,
    country_name
from {{ ref('stg_countries') }}