with final as (
    select
        d.year_week,
        avg(w.weight_lb) as avg_weight_lb,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 1) over (order by d.year_week asc) as wk1_change,
        lag(avg(w.weight_lb), 1) over (order by d.year_week asc) as wk1_weight,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 2) over (order by d.year_week asc) as wk2_change,
        lag(avg(w.weight_lb), 2) over (order by d.year_week asc) as wk2_weight,
        avg(w.weight_lb) - lag(avg(w.weight_lb), 3) over (order by d.year_week asc) as wk3_change,
        lag(avg(w.weight_lb), 3) over (order by d.year_week asc) as wk3_weight
    from {{ ref ('date_spine') }} d
    join {{ ref ('stg__weight_daily') }} w on d.date_id = date_trunc('day', w.record__ts)
    group by d.year_week
)

select * from final
