with final as (
    select
        d.date_id as day,
        w.weight_lb,
        w.weight_lb - lag(w.weight_lb, 1) over (order by d.date_id asc) as day1_change,
        lag(w.weight_lb, 1) over (order by d.date_id asc) as day1_weight
    from {{ ref ('date_spine') }} d
    join {{ ref ('stg__weight_daily') }} w on d.date_id = date_trunc('day', w.record__ts)
)

select * from final