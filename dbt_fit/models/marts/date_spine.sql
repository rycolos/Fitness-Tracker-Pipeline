with date_series as (
	select 
		generate_series(
			   (date '2023-01-01'), (date '2025-12-31'), interval '1 day'
			 )::date as date_id
	)
select
	date_id,
    to_char(date_id, 'YYYY') as year,
	to_char(date_id, 'MM') as month,
    to_char(date_id, 'YYYY-MM') as year_month,
	to_char(date_id, 'YYYY-WW') as year_week,
	date_part('isodow', date_id) as day_of_week
from date_series