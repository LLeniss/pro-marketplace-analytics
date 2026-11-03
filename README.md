# Growth Funnel Optimization & A/B Testing Framework

A portfolio project using synthetic e-commerce data to analyze a conversion funnel and evaluate a simulated checkout experiment with SQL and Python.

The analysis covers funnel segmentation, sample-size planning, sample ratio mismatch (SRM), two-proportion hypothesis testing, and revenue analysis using non-parametric methods.

> This is a simulation, not a real business deployment. All findings describe the synthetic dataset and should not be interpreted as demonstrated commercial impact.

## Business Question

Could a simplified checkout experience improve visitor-to-purchase conversion without negatively affecting revenue per visitor?

The simulated experiment compares:

- **Control:** A legacy multi-step checkout.
- **Variant B:** A simplified checkout experience.

The objective is to connect statistical results to a business recommendation while making uncertainty and limitations explicit.

## Metrics and Units of Analysis
Essayer :
|
Overall conversion rate
Visitors who purchased / all visitors in each variant
Primary
Checkout-to-purchase conversion
Visitors who purchased / visitors who reached checkout
Secondary funnel diagnostic
Revenue per visitor (RPV)
Total revenue / all visitors in each variant
Secondary business outcome
Average order value (AOV)
Revenue / orders
Secondary metric; no separate result reported here
The primary conversion analysis uses visitors as the unit of analysis.

Revenue per visitor includes visitors who did not purchase, rather than only paying customers.

Checkout-to-purchase conversion is a funnel diagnostic. Because checkout participation may itself be affected by treatment, this conditional metric should not replace the overall visitor-level comparison.

Dataset and Experiment Setup
Data: Synthetic e-commerce data.
Total visitors: 50,000.
Intended allocation: 50% Control / 50% Variant B.
Observed allocation: 25,053 Control / 24,947 Variant B.
Device segments: Mobile, Desktop, and Tablet.
Device-level comparisons are exploratory and are not treated as independently confirmed treatment effects.

Tools and Repository Structure
SQL and DuckDB: Funnel aggregation and segmentation.
Python: Data generation, statistical analysis, and visualization.
data/
Synthetic input data
sql/
Funnel and analytical queries
src/generate_data.py
Synthetic data generation
src/run_sql.py
SQL execution
src/hypothesis_testing.py
Experiment analysis
src/visualize.py
Visualizations
reports/
Analysis outputs
requirements.txt
Python dependencies
Analytical Workflow
Generate synthetic visitor and revenue data.
Aggregate the funnel by variant and device.
Estimate the sample size required for the target effect.
Check the observed allocation for sample ratio mismatch.
Compare overall conversion rates.
Analyze revenue per visitor.
Interpret the results alongside uncertainty and design limitations.
1. Funnel Analysis
The SQL analysis aggregates visitor counts across funnel stages and compares performance by variant and device.

Exploratory Findings
Mobile
2.89%
3.31%
Desktop
3.06%
3.14%
For Mobile, checkout-to-purchase conversion increased from 22.92% to 26.08%.

Mobile showed a larger observed conversion increase than Desktop in these summaries. However, these descriptive results do not establish that the treatment effect differs by device.

A formal comparison of treatment effects across devices, with appropriate attention to multiple comparisons, would be needed before recommending a device-specific rollout.

2. Sample-Size Planning
The power-analysis output reported:

Baseline conversion rate used
2.9537%
Target relative minimum detectable effect
10%
Required visitors per variant
54,042
Observed Control visitors
25,053
Observed Variant B visitors
24,947
The available sample did not reach the planned sample size.

An experiment can produce a statistically significant result before reaching its planned sample size. However, that does not mean the original power requirement was met or justify stopping whenever significance first appears.

For a real experiment, the baseline should come from historical data and the sample size and stopping rule should be specified before launch. This project demonstrates the planning calculation, not a verified preregistered experiment.

3. Sample Ratio Mismatch
Expected allocation
50/50
SRM p-value
0.6355
The SRM check did not detect a statistically significant allocation imbalance.

Passing this check does not prove that tracking, randomization, or every other aspect of the experiment is valid. It addresses the observed variant counts.

4. Overall Conversion Results
Control conversion
2.9537%
Variant B conversion
3.2830%
Absolute lift
+0.3292 percentage points
Relative lift
+11.15%
95% confidence interval for absolute lift
+0.0245 to +0.6339 percentage points
Z statistic
2.118
Two-sided p-value
0.0342
Variant B had a higher observed overall conversion rate.

At the nominal 5% significance threshold, the two-proportion test rejects the null hypothesis of equal conversion rates.

The confidence interval excludes zero but includes small improvements. Statistical significance therefore does not, by itself, establish that the effect is large enough to justify implementation costs.

Reported figures are rounded separately.

5. Revenue Per Visitor
Control RPV
$1.631
Variant B RPV
$1.810
Mann–Whitney p-value
0.0356
Bootstrap 95% confidence interval for mean RPV difference
−$0.024 to +$0.390
Variant B had higher observed revenue per visitor, but the bootstrap confidence interval for the mean difference includes zero.

Therefore, this interval does not establish a positive mean RPV effect at the corresponding confidence level.

Why the Tests Can Give Different Signals
The Mann–Whitney test and the bootstrap interval do not answer the same question.

Mann–Whitney: Tests rank-based distributional differences; it is not a direct test of equality of mean revenue.
Bootstrap interval: Quantifies uncertainty around the estimated difference in mean revenue per visitor.
The Mann–Whitney p-value should not be presented as proof that average revenue increased.

6. Business Recommendation
Recommendation: treat Variant B as promising, but do not claim a proven revenue improvement or an unconditional rollout decision.

The simulated data provides nominal statistical evidence of improved conversion. However:

The planned sample size was not reached.
The mean revenue difference remains uncertain.
Device-level findings are exploratory.
No actual deployment, implementation cost, or production guardrail results are available.
For a real follow-up experiment, I would:

Define the minimum business-relevant improvement.
Plan sample size using historical baseline data.
Specify the stopping rule and analysis approach before launch.
Track conversion alongside revenue and operational guardrails.
Evaluate whether the uncertainty interval supports the business decision.
7. Limitations
Synthetic data: Results demonstrate analytical methods, not actual customer behavior.
Sample size: Observations are below the reported planning requirement.
Revenue uncertainty: The bootstrap interval includes no improvement and a small negative effect.
Exploratory segmentation: Device comparisons do not establish heterogeneous treatment effects.
Experiment timing: These results do not establish that a real experiment ran long enough to capture weekly cycles or longer-term effects.
Reproducibility documentation: Exact execution commands and environment requirements still need to be checked against the scripts before a verified quick-start guide is published.
8. Skills Demonstrated
Translating a product question into measurable outcomes.
SQL-based funnel analysis and segmentation.
Sample-size and power considerations.
Sample ratio mismatch checks.
Two-proportion hypothesis testing.
Bootstrap-based revenue uncertainty estimation.
Distinguishing statistical significance from business significance.
Communicating limitations and avoiding unsupported causal claims.
9. Next Improvements
Verify and document exact execution commands.
Document the power-analysis assumptions and bootstrap configuration.
Add automated data-quality checks.
Define a fixed observation window and stopping policy.
Assess device-level treatment differences formally.
Link verified charts and analysis outputs from reports/.