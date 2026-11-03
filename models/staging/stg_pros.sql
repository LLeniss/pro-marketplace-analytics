select
    pro_id,
    signup_date,
    market,
    acquisition_channel,
    onboarding_completed,
    first_completed_job_date
from {{ ref('pros') }}