with first_completed as (
    select
        assigned_pro_id as pro_id,
        min(completed_date) as first_completed_date
    from {{ ref('stg_jobs') }}
    where status = 'completed'
    group by assigned_pro_id
),

pro_times as (
    select
        p.pro_id,
        p.market,
        p.signup_date,
        f.first_completed_date,
        date_diff('day', p.signup_date, f.first_completed_date) as days_to_first_job
    from {{ ref('stg_pros') }} p
    left join first_completed f on p.pro_id = f.pro_id
)

select
    market,
    count(*) as total_pros,
    count(first_completed_date) as pros_with_first_job,
    round(100.0 * count(first_completed_date) / count(*), 1) as pct_with_first_job,
    round(avg(days_to_first_job), 1) as avg_days_to_first_job,
    median(days_to_first_job) as median_days_to_first_job
from pro_times
group by market
order by market