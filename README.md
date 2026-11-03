# Growth Funnel Optimization & A/B Testing Framework

A portfolio project using synthetic e-commerce data to analyze a conversion funnel and demonstrate an A/B testing workflow with SQL, DuckDB, and Python.

The project covers funnel analysis, sample-size planning, sample ratio mismatch (SRM), conversion hypothesis testing, and revenue analysis.

> **Project scope:** This is a simulation using synthetic data. It does not represent a real checkout deployment or proven business impact.

## Business Problem

The project explores whether a simplified checkout experience could improve visitor-to-purchase conversion compared with a legacy multi-step checkout.

- **Control:** Legacy multi-step checkout.
- **Variant B:** Simplified checkout experience.
- **Primary metric:** Overall conversion rate, measured as purchasing visitors divided by all visitors.
- **Secondary metrics:** Checkout-to-purchase conversion, revenue per visitor (RPV), and average order value (AOV).

## Dataset and Experiment Setup

The synthetic dataset represents 50,000 visitors, with an intended 50/50 allocation between Control and Variant B. The analysis includes Mobile, Desktop, and Tablet segments.

Because the data is synthetic, the results demonstrate analytical methods rather than actual customer behavior.

## Metrics

- **Overall conversion rate:** Purchasing visitors divided by all visitors in a variant.
- **Checkout-to-purchase conversion:** Purchasing visitors divided by visitors who reached checkout.
- **Revenue per visitor (RPV):** Total revenue divided by all visitors, including visitors who did not purchase.
- **Average order value (AOV):** Total revenue divided by the number of orders.

Overall conversion is the primary visitor-level outcome. Checkout-to-purchase conversion is a funnel diagnostic and should not replace the overall comparison, because the treatment may affect which visitors reach checkout.

## Tools

- **SQL** for funnel aggregation and segmentation.
- **DuckDB** for local analytical queries.
- **Python** for synthetic data generation, statistical analysis, and visualizations.
- **Git and GitHub** for version control and project documentation.

## Repository Structure

- `data/` — synthetic input data.
- `sql/` — analytical SQL queries.
- `src/generate_data.py` — synthetic data generator.
- `src/run_sql.py` — DuckDB query executor.
- `src/hypothesis_testing.py` — statistical analysis.
- `src/visualize.py` — visualization generation.
- `reports/` — charts and analysis outputs.
- `requirements.txt` — Python dependencies.

## Analytical Workflow

1. Generate synthetic visitor and revenue data.
2. Aggregate funnel stages by variant and device.
3. Estimate the sample size required for a target effect.
4. Check whether the observed allocation matches the intended split.
5. Compare conversion rates between variants.
6. Estimate uncertainty in revenue per visitor.
7. Interpret the results and document limitations.

## Funnel Analysis

The SQL analysis compares visitor counts across funnel stages by variant and device.

### Reported Descriptive Findings

- **Mobile:** Overall conversion increased from 2.89% in Control to 3.31% in Variant B.
- **Mobile:** Checkout-to-purchase conversion increased from 22.92% to 26.08%.
- **Desktop:** Overall conversion was 3.06% in Control and 3.14% in Variant B.

These are descriptive comparisons. They do not establish that the treatment effect is statistically different across devices. Device-level findings should be treated as exploratory unless formally tested.

### Visualization

![Funnel and experiment results](reports/funnel_and_experiment_results.png)

## Statistical Experimentation

The project includes a workflow for evaluating the experiment:

- **Sample-size planning** estimates the observations needed for a target effect under specified assumptions.
- **Sample ratio mismatch (SRM)** checks whether observed variant counts differ unexpectedly from the intended allocation.
- **Two-proportion hypothesis testing** compares visitor-level conversion between Control and Variant B.
- **Revenue bootstrapping** estimates uncertainty around the difference in mean revenue per visitor.

Statistical significance alone is not a rollout recommendation. Results should be considered alongside confidence intervals, sample size, experiment design, and business relevance.

## Business Interpretation

Variant B is a candidate for further evaluation, not automatically a confirmed winner.

Before recommending a real rollout, I would:

1. Validate visitor assignment and tracking.
2. Review the allocation check.
3. Confirm the sample-size assumptions and stopping rule.
4. Review the conversion difference and its confidence interval.
5. Assess uncertainty in revenue per visitor.
6. Check operational guardrails and implementation costs.
7. Treat device comparisons as exploratory unless formally validated.

## Limitations

- The data is synthetic and does not establish real customer behavior.
- Descriptive conversion differences do not, by themselves, prove statistical significance.
- Device-level summaries do not establish that treatment effects differ by device.
- Checkout-to-purchase conversion is conditional on reaching checkout.
- Conversion and revenue may support different conclusions.
- The visitor count alone does not show whether the experiment covered weekly patterns or longer-term effects.
- Execution instructions and environment requirements should be verified against the project scripts before claiming the analysis is fully reproducible.

## Skills Demonstrated

- Translating a product question into measurable outcomes.
- Analyzing conversion funnels with SQL.
- Comparing variants and device segments.
- Considering sample size and statistical power.
- Checking experiment allocation.
- Interpreting conversion and revenue metrics.
- Communicating uncertainty and analytical limitations.

## Next Improvements

- Verify and publish the statistical result tables.
- Document setup and execution commands.
- Document the statistical assumptions and configuration.
- Add automated data-quality checks.
- Validate funnel-stage consistency.
- Document the observation window and stopping policy.
- Test device-level treatment differences formally.
- Confirm that report outputs can be regenerated from the repository.

## Conclusion

This project demonstrates how funnel analysis and experiment evaluation can inform a growth decision.

The key lesson is to distinguish an observed improvement from a statistically supported effect and a business-ready recommendation.