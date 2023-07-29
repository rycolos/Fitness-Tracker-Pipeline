with final as (
    select
        d.year_month,
        avg(w.weight_lb) as avg_weight_lb,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 1) over (order by d.year_month asc) as mo1_change,
        lag(avg(w.weight_lb), 1) over (order by d.year_month asc) as mo1_weight,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 3) over (order by d.year_month asc) as mo3_change,
        lag(avg(w.weight_lb), 3) over (order by d.year_month asc) as mo3_weight,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 6) over (order by d.year_month asc) as mo6_change,
        lag(avg(w.weight_lb), 6) over (order by d.year_month asc) as mo6_weight,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 9) over (order by d.year_month asc) as mo9_change,
        lag(avg(w.weight_lb), 9) over (order by d.year_month asc) as mo9_weight,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 12) over (order by d.year_month asc) as mo12_change,
        lag(avg(w.weight_lb), 12) over (order by d.year_month asc) as mo12_weight
    from {{ ref ('date_spine') }} d
    join {{ ref ('stg__weight_daily') }} w on d.date_id = date_trunc('day', w.record__ts)
    group by d.year_month
)


select * from final