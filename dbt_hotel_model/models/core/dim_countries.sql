with staging_data as (
    select * from {{ ref('stg_countries') }}
)

select
    country_code,
    coalesce(country_name, 'Unknown') as country_name
from staging_data

union all

-- Menambahkan baris default 'Unknown' secara manual ke dalam tabel dimensi
select
    'Unknown' as country_code,
    'Unknown' as country_name