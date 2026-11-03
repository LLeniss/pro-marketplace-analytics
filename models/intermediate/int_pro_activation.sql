select
    pro_id,
    signup_date,
    market,
    acquisition_channel,
    onboarding_completed,
    first_completed_job_date,
    date_diff('day', signup_date, first_completed_job_date) as days_to_first_job,
    coalesce(
        date_diff('day', signup_date, first_completed_job_date) between 0 and 14,
        false
    ) as is_activated_14d
from {{ ref('stg_pros') }}