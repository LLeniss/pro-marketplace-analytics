with settings as (
    select date '2025-01-29' as observation_date
),

pros as (
    select
        pro_id,
        signup_date,
        cast(date_trunc('week', signup_date) as date) as cohort_week
    from {{ ref('stg_pros') }}
    where signup_date <= (select observation_date from settings)
),

cohorts as (
    select
        cohort_week,
        count(*) as cohort_size
    from pros
    group by cohort_week
),

cohort_weeks as (
    select
        c.cohort_week,
        c.cohort_size,
        w.weeks_since_cohort
    from cohorts c
    cross join settings s
    cross join lateral range(
        0,
        date_diff(
            'week',
            c.cohort_week,
            date_trunc('week', s.observation_date)
        )
    ) as w(weeks_since_cohort)
),

activity as (
    select
        p.cohort_week,
        date_diff(
            'week',
            p.cohort_week,
            date_trunc('week', j.completed_date)
        ) as weeks_since_cohort,
        count(distinct p.pro_id) as active_pros
    from pros p
    join {{ ref('stg_jobs') }} j
        on p.pro_id = j.assigned_pro_id
    cross join settings s
    where j.status = 'completed'
      and j.completed_date >= p.signup_date
      and j.completed_date <= s.observation_date
    group by 1, 2
)

select
    c.cohort_week,
    c.cohort_size,
    c.weeks_since_cohort,
    coalesce(a.active_pros, 0) as active_pros,
    round(
        100.0 * coalesce(a.active_pros, 0) / c.cohort_size,
        1
    ) as retention_pct
from cohort_weeks c
left join activity a
    on c.cohort_week = a.cohort_week
   and c.weeks_since_cohort = a.weeks_since_cohort
order by c.cohort_week, c.weeks_since_cohort