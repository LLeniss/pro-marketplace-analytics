select *
from {{ ref('mart_pro_weekly_retention') }}
where retention_pct < 0
   or retention_pct > 100
   or active_pros > cohort_size