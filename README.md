# Pro Marketplace Analytics (dbt + DuckDB)

> **Portfolio project using synthetic data.** It is inspired by common two-sided marketplace problems and does not use or describe any real company's data or metrics.

## Business question

In a services marketplace, supply (Pros) must be activated and matched with demand (jobs). This project asks:

1. What share of new Pros complete a first job within 14 days (activation)?
2. How well does the marketplace assign, complete and cancel jobs by market?

## Stack

- **dbt Core** (1.12) with the **DuckDB** adapter: local, reproducible, no server needed
- SQL for transformations; dbt tests for data quality

## Project structure

```text
seeds/         Synthetic source data (pros.csv, jobs.csv)
models/
  staging/       Light cleaning, 1:1 with sources, plus tests and docs
  intermediate/  Business logic (14-day Pro activation flag)
  marts/         Consumption-ready tables
docs/metrics.md  Single definition for each metric
```

## Metrics

Every metric has one written definition (numerator, denominator, grain, caveats) in [`docs/metrics.md`](docs/metrics.md). The goal is one number the business can trust.

## How to run

```bash
py -3.12 -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install dbt-duckdb
dbt seed --profiles-dir .
dbt run --profiles-dir .
dbt test --profiles-dir .
```

## Data quality

dbt tests check that:

- `pro_id` and `job_id` are unique and not null
- `market` and `status` only contain expected values
- Weekly retention: cohort size is constant within each cohort, rates stay between 0 and 100, and cohort sizes add up to the Pros registered before the cutoff date

## Findings (illustrative only)

- Dallas shows the highest cancellation rate (2 of 7 jobs). Both cancelled jobs were assigned to Pros who had not completed onboarding.
- This is a **hypothesis** to test, not a conclusion: n = 2.
- `avg_days_to_assignment` is 0 everywhere because the synthetic data assigns jobs on the creation day.
- Dallas also has the lowest share of Pros with a first completed job (2 of 5). Averages exclude Pros with no job, so read them next to the share.
- Dallas assigned jobs to all 5 Pros although only 3 had completed onboarding, and only 2 of the 5 completed a job. Hypothesis to test with an experiment, not a conclusion.

## Limitations

- Tiny synthetic sample (16 Pros, 20 jobs): rates are not statistically meaningful.
- Dates only, no timestamps, so time metrics have day-level precision.
- Segment cuts are exploratory.

## Next steps

- Add an onboarding A/B test analysis (power, SRM, significance)
- Add a BI layer (e.g., Lightdash) on top of the marts