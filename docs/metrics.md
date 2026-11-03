# Marketplace Metrics Dictionary

> Portfolio project using synthetic data. These definitions are for this practice case and do not describe LawnStarter's internal metrics.

## Pro activation within 14 days

- **Question:** What share of newly registered Pros complete their first job within 14 days?
- **Numerator:** Pros whose first completed job is from 0 to 14 days after signup, inclusive.
- **Denominator:** Pros with a signup date in the analysis cohort.
- **Formula:** Numerator / denominator.
- **Unit:** Percentage of Pros.
- **Important caveat:** This practice dataset is small and synthetic. Results are for demonstrating the method, not for business claims.

## Job assignment rate

- **Question:** What share of created jobs receive a Pro assignment?
- **Numerator:** Jobs with a non-empty `assigned_pro_id`.
- **Denominator:** All jobs created in the selected period.
- **Formula:** Numerator / denominator.
- **Unit:** Percentage of jobs.

## Job completion rate

- **Question:** What share of created jobs are marked completed?
- **Numerator:** Jobs where `status` is `completed`.
- **Denominator:** All jobs created in the selected period.
- **Formula:** Numerator / denominator.
- **Unit:** Percentage of jobs.
- **Important caveat:** This is measured per job, not per customer or Pro.

## Job cancellation rate

- **Question:** What share of created jobs are marked cancelled?
- **Numerator:** Jobs where `status` is `cancelled`.
- **Denominator:** All jobs created in the selected period.
- **Formula:** Numerator / denominator.
- **Unit:** Percentage of jobs.

## Average time to assignment

- **Question:** How long does it take an assigned job to receive a Pro?
- **Numerator:** Elapsed time from `created_date` to `assigned_date` for assigned jobs.
- **Denominator:** Assigned jobs with both dates available.
- **Unit:** Days.
- **Important caveat:** This dataset contains dates, not timestamps, so the measure has day-level precision.

## Grain and source

- `pros.csv`: one row per Pro (`pro_id`).
- `jobs.csv`: one row per job (`job_id`).
- Source files: synthetic CSVs in the `seeds/` folder.