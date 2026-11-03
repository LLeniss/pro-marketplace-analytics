select
    cohort_week,
    count(distinct cohort_size) as distinct_sizes
from {{ ref('mart_pro_weekly_retention') }}
group by cohort_week
having count(distinct cohort_size) > 1