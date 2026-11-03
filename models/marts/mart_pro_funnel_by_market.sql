with first_completed as (
    select
        assigned_pro_id as pro_id,
        min(completed_date) as first_completed_date
    from {{ ref('stg_jobs') }}
    where status = 'completed'
    group by assigned_pro_id
),

first_assigned as (
    select
        assigned_pro_id as pro_id,
        min(created_date) as first_assigned_date
    from {{ ref('stg_jobs') }}
    where assigned_pro_id is not null
    group by assigned_pro_id
),

pro_flags as (
    select
        p.pro_id,
        p.market,
        p.onboarding_completed,
        a.pro_id is not null as was_assigned,
        f.pro_id is not null as completed_job
    from {{ ref('stg_pros') }} p
    left join first_assigned a on p.pro_id = a.pro_id
    left join first_completed f on p.pro_id = f.pro_id
)

select
    market,
    count(*) as signed_up,
    sum(case when onboarding_completed then 1 else 0 end) as onboarded,
    sum(case when was_assigned then 1 else 0 end) as assigned_a_job,
    sum(case when completed_job then 1 else 0 end) as completed_a_job,
    round(100.0 * sum(case when onboarding_completed then 1 else 0 end) / count(*), 1) as pct_onboarded,
    round(100.0 * sum(case when completed_job then 1 else 0 end) / count(*), 1) as pct_completed_job
from pro_flags
group by market
order by market