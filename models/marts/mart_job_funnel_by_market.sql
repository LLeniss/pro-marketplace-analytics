select
    market,
    count(*) as total_jobs,
    sum(case when assigned_pro_id is not null then 1 else 0 end) as assigned_jobs,
    sum(case when status = 'completed' then 1 else 0 end) as completed_jobs,
    sum(case when status = 'cancelled' then 1 else 0 end) as cancelled_jobs,
    sum(case when status = 'unassigned' then 1 else 0 end) as unassigned_jobs,
    round(100.0 * sum(case when assigned_pro_id is not null then 1 else 0 end) / count(*), 1) as assignment_rate_pct,
    round(100.0 * sum(case when status = 'completed' then 1 else 0 end) / count(*), 1) as completion_rate_pct,
    round(100.0 * sum(case when status = 'cancelled' then 1 else 0 end) / count(*), 1) as cancellation_rate_pct,
    round(avg(date_diff('day', created_date, assigned_date)), 2) as avg_days_to_assignment
from {{ ref('stg_jobs') }}
group by market
order by market