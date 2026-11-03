select
    market,
    acquisition_channel,
    count(*) as total_pros,
    sum(case when is_activated_14d then 1 else 0 end) as activated_pros,
    round(
        100.0 * sum(case when is_activated_14d then 1 else 0 end) / count(*),
        1
    ) as activation_rate_14d_pct
from {{ ref('int_pro_activation') }}
group by market, acquisition_channel
order by market, acquisition_channel