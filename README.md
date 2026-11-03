# Pro Marketplace Analytics

A local-first analytics engineering portfolio project using SQL, dbt, and DuckDB to explore professional onboarding, job outcomes, activation, and weekly retention in a synthetic services marketplace.

> **Project scope:** This project uses synthetic data. Findings demonstrate analytical methods and do not represent verified production issues or real business impact.

### Business Context

A services marketplace needs more than professional signups: it needs professionals who complete onboarding, receive suitable job opportunities, and successfully deliver services.

I built this project to explore the relationship between professional supply and job outcomes across Austin, Dallas, and Houston.

Throughout this project, “Pro” refers to a service professional.

### Business Questions

- How does onboarding completion differ by market?
- How many registered Pros receive and complete jobs?
- Where do job outcomes suggest marketplace friction?
- How long does it take Pros to complete their first job?
- How does weekly activity vary across signup cohorts?
- Which data-quality checks help prevent misleading conclusions?

### Technology Stack

- **SQL:** Data transformation and analytical logic.
- **dbt:** Model dependencies, tests, and documentation.
- **DuckDB:** Local analytical database.
- **Python environment:** Project tooling.
- **Git and GitHub:** Version control.

The project follows a local-first approach and does not require a hosted warehouse.

### Repository Structure

- `seeds/` — synthetic source datasets.
- `models/` — staging, intermediate, and analytical models.
- `tests/` — custom SQL data tests.
- `docs/metrics.md` — metric definitions, grain, and analytical caveats.
- `dbt_project.yml` — dbt project configuration.
- `profiles.yml` — local connection configuration.
- `.gitignore` — exclusions for local and generated files.
- `README.md` — project overview and usage.

### Data Model

I organized the transformations into layers:

1. **Seeds:** Load synthetic Pro and job data.
2. **Staging:** Prepare source fields for downstream analysis.
3. **Intermediate models:** Organize reusable transformation logic.
4. **Marts:** Present business-facing analytical outputs.

The staging models include:

- `stg_pros`
- `stg_jobs`

### Main Analytical Marts

#### Job Funnel by Market

**Model:** `mart_job_funnel_by_market`

Analyzes job outcomes by market to support investigation of completion, cancellation, and assignment patterns.

This view complements the Pro-level funnel: job counts and professional counts describe different units of analysis.

#### Pro Funnel by Market

**Model:** `mart_pro_funnel_by_market`

Summarizes registered Pros, onboarding completion, job assignment, and job completion by market.

These counts describe milestones, not necessarily a strictly ordered funnel. A Pro can appear among assigned professionals without having completed onboarding in the available data.

#### Time to First Job by Market

**Model:** `mart_time_to_first_job_by_market`

Summarizes first-job completion coverage and time to first completed job by market.

Coverage must be interpreted alongside average and median time: a market can have a short average among successful Pros while many other Pros have not completed a job.

#### Weekly Pro Retention

**Model:** `mart_pro_weekly_retention`

Tracks weekly Pro activity relative to cohort membership.

The model includes cohort size, weeks since cohort, active Pros, and retention percentage.

A cohort's size must remain constant across its weekly observations. The activity definition and other metric caveats are documented in `docs/metrics.md`.

### Selected Results

#### Pro Milestones by Market

- **Austin:** 6 signed up, 5 onboarded, 5 assigned a job, and 5 completed a job.
- **Dallas:** 5 signed up, 3 onboarded, 5 assigned a job, and 2 completed a job.
- **Houston:** 5 signed up, 5 onboarded, 5 assigned a job, and 4 completed a job.

Dallas stands out because all five Pros have an assignment, but only three have completed onboarding and two have completed a job.

This motivates an investigation into onboarding and assignment rules. It does not establish that incomplete onboarding caused unsuccessful job outcomes.

#### First Completed Job

- **Austin:** 5 of 6 Pros completed a first job; coverage is 83.3%, average time is 9.8 days, and median time is 7 days.
- **Dallas:** 2 of 5 Pros completed a first job; coverage is 40.0%, average time is 5.0 days, and median time is 5 days.
- **Houston:** 4 of 5 Pros completed a first job; coverage is 80.0%, average time is 5.0 days, and median time is 5 days.

Dallas illustrates why speed alone is insufficient: its average time is shorter than Austin's, but its first-job coverage is substantially lower.

### Analytical Decisions

#### Report Coverage Alongside Speed

Time-to-first-job statistics describe Pros who reached that milestone.

Pros who have not completed a job are not represented in those averages. I therefore report coverage alongside speed to avoid treating a selective subset as representative of all signups.

#### Keep Cohort Denominators Stable

Weekly activity changes, but membership in a signup cohort should not change from week to week.

I added custom checks to catch inconsistent cohort sizes and mismatches with the Pro data.

#### Separate Milestones from Event Order

An onboarding flag and an assignment record do not establish which happened first.

Determining whether a job was assigned before onboarding completion requires the relevant timestamps or event history.

#### Separate Association from Causation

Market differences generate hypotheses; they do not identify causes.

Further investigation would need to consider factors such as signup timing, job availability, assignment practices, and observation windows.

### Data Quality and Testing

The recorded test run passed nine data tests.

#### Identifier Checks

- `stg_pros.pro_id` is not null.
- `stg_pros.pro_id` is unique.
- `stg_jobs.job_id` is not null.
- `stg_jobs.job_id` is unique.

#### Accepted Values

- Pro markets: Austin, Dallas, and Houston.
- Job statuses: completed, cancelled, assigned, and unassigned.

#### Custom Integrity Tests

- `assert_cohort_size_constant`
- `assert_cohort_sizes_match_pros`
- `assert_retention_between_0_and_100`

These checks address specific failure modes. Passing them does not guarantee that every business rule or data issue has been covered.

### Running the Project Locally

#### Recorded Environment

- Python: 3.12.10
- dbt: 1.12.6
- DuckDB adapter: 1.11.1

The adapter version is not necessarily the same as the installed DuckDB engine version.

#### Setup

1. Clone this repository and open its root folder.
2. Create a virtual environment using `python -m venv .venv`.
3. On Windows PowerShell, activate it using `.\.venv\Scripts\Activate.ps1`.
4. Install the DuckDB adapter using `python -m pip install dbt-duckdb`.
5. Review `profiles.yml` and adjust local paths if necessary.
6. Check the connection using `dbt debug --profiles-dir .`.

Installing without pinned dependencies may produce versions different from the recorded environment.

#### Build and Test

From the project root:

1. Load the synthetic data using `dbt seed --profiles-dir .`.
2. Build the models using `dbt run --profiles-dir .`.
3. Run the tests using `dbt test --profiles-dir .`.

#### Preview a Mart

Run `dbt show --select mart_pro_funnel_by_market --profiles-dir .`.

Replace the selected model name to preview another mart.

#### Generate Documentation

1. Run `dbt docs generate --profiles-dir .`.
2. Run `dbt docs serve --profiles-dir .`.
3. Open the local address printed in the terminal.
4. Press Ctrl+C in that terminal to stop the documentation server.

The terminal remains occupied while the server is running.

### Metric Documentation

See `docs/metrics.md` for metric definitions, model grain, and interpretation caveats.

In particular, distinguish:

- Job-level outcomes from Pro-level milestones.
- All registered Pros from Pros who completed a first job.
- Cohort membership from weekly activity.
- Current onboarding status from onboarding status at assignment time.

### Business Recommendation

I would prioritize investigating the Dallas market before recommending an intervention.

The first questions would be:

1. Are the onboarding fields and assignment records accurate?
2. What was each Pro's onboarding status when the job was assigned?
3. Are the first-job observation windows comparable across markets?
4. Does job availability differ by market?
5. What reasons are recorded for cancellations or incomplete jobs?

If the investigation confirms an operational issue, a targeted intervention could be evaluated with explicit success metrics and guardrails.

This project identifies questions to investigate; it does not demonstrate that a particular intervention would work.

### Limitations

- The dataset is synthetic and small.
- Market percentages are sensitive to individual observations.
- First-job timing excludes Pros who have not reached that milestone.
- Current status fields do not establish historical event order.
- Cohorts may have different observation lengths.
- Passing tests does not establish causal validity.
- No production deployment or business impact is claimed.

### Next Improvements

- Pin dependencies for more consistent environment setup.
- Expand tests for relationships and temporal consistency.
- Add explicit observation-window checks.
- Build a dashboard using the analytical marts.
- Investigate onboarding and assignment timing with event-level data.
- Evaluate cancellation patterns using comparable groups.

### Skills Demonstrated

- SQL transformation and dimensional thinking.
- Layered dbt modeling.
- Local analytics with DuckDB.
- Data-quality testing.
- Cohort and retention analysis.
- Funnel and activation analysis.
- Metric documentation.
- Recognition of selection bias and causal limitations.
- Translating analytical results into investigation priorities.

### Conclusion

I built this project to demonstrate an analytics workflow that combines business questions, reusable models, tests, and documented metrics.

The central lesson is that a metric needs context: faster first-job completion among successful Pros does not necessarily mean a healthier marketplace, and a difference between markets is a starting point for investigation rather than proof of a cause.