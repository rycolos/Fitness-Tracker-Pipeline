select 
    record__ts::timestamptz as record__ts,
    weight::real as weight_lb
from {{ ref ('stg_snapshot__weight_daily') }}