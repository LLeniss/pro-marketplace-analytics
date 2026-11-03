select
    job_id,
    market,
    created_date,
    assigned_pro_id,
    assigned_date,
    completed_date,
    status,
    quoted_price
from {{ ref('jobs') }}
