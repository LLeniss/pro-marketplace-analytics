with cohort_totals as (
    select sum(cohort_size) as total
    from (
        select distinct cohort_week, cohort_size
        from {{ ref('mart_pro_weekly_retention') }}
    )
),

pros_total as (
    select count(*) as total
    from {{ ref('stg_pros') }}
    where signup_date <= date '2025-01-29'
)

select *
from cohort_totals, pros_total
where cohort_totals.total != pros_total.total