------------------------------------------------------------
-- FINANCIAL VARIANCE ANALYTICS QUERIES
-- This file provides reusable SQL for analyzing
-- planned vs. actual financial performance across projects.
------------------------------------------------------------

------------------------------------------------------------
-- 1. Monthly Cost Variance by Project
-- (Actual Cost – Planned Cost)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    pf.month,
    pf.planned_cost,
    pf.actual_cost,
    (pf.actual_cost - pf.planned_cost) AS cost_variance
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
ORDER BY pf.project_id, pf.month;


------------------------------------------------------------
-- 2. Monthly Benefit Variance by Project
-- (Actual Benefit – Planned Benefit)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    pf.month,
    pf.planned_benefit,
    pf.actual_benefit,
    (pf.actual_benefit - pf.planned_benefit) AS benefit_variance
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
ORDER BY pf.project_id, pf.month;


------------------------------------------------------------
-- 3. Total Cost Variance per Project (Summed Across Months)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    SUM(pf.planned_cost) AS total_planned_cost,
    SUM(pf.actual_cost) AS total_actual_cost,
    SUM(pf.actual_cost - pf.planned_cost) AS total_cost_variance
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
GROUP BY pf.project_id, p.project_name
ORDER BY total_cost_variance DESC;


------------------------------------------------------------
-- 4. Total Benefit Variance per Project (Summed Across Months)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    SUM(pf.planned_benefit) AS total_planned_benefit,
    SUM(pf.actual_benefit) AS total_actual_benefit,
    SUM(pf.actual_benefit - pf.planned_benefit) AS total_benefit_variance
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
GROUP BY pf.project_id, p.project_name
ORDER BY total_benefit_variance DESC;


------------------------------------------------------------
-- 5. Cumulative Cost Variance Over Time (per Project)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    pf.month,
    SUM(pf.actual_cost - pf.planned_cost)
        OVER (PARTITION BY pf.project_id ORDER BY pf.month) AS cumulative_cost_variance
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
ORDER BY pf.project_id, pf.month;


------------------------------------------------------------
-- 6. Projects with Cost Overruns (Actual > Planned)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    pf.month,
    pf.planned_cost,
    pf.actual_cost,
    (pf.actual_cost - pf.planned_cost) AS cost_overrun
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
WHERE pf.actual_cost > pf.planned_cost
ORDER BY cost_overrun DESC;


------------------------------------------------------------
-- 7. Projects with Benefit Shortfalls (Actual < Planned)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    pf.month,
    pf.planned_benefit,
    pf.actual_benefit,
    (pf.actual_benefit - pf.planned_benefit) AS benefit_shortfall
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
WHERE pf.actual_benefit < pf.planned_benefit
ORDER BY benefit_shortfall ASC;


------------------------------------------------------------
-- 8. Cost Variance % (Actual – Planned) / Planned
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    pf.month,
    pf.planned_cost,
    pf.actual_cost,
    ROUND(
        (pf.actual_cost - pf.planned_cost) / NULLIF(pf.planned_cost, 0) * 100,
        2
    ) AS cost_variance_pct
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
ORDER BY pf.project_id, pf.month;


------------------------------------------------------------
-- 9. Benefit Realization % (Actual / Planned)
------------------------------------------------------------
SELECT
    pf.project_id,
    p.project_name,
    pf.month,
    pf.planned_benefit,
    pf.actual_benefit,
    ROUND(
        pf.actual_benefit / NULLIF(pf.planned_benefit, 0) * 100,
        2
    ) AS benefit_realization_pct
FROM project_financials pf
JOIN projects p ON p.project_id = pf.project_id
ORDER BY pf.project_id, pf.month;


------------------------------------------------------------
-- 10. Portfolio-Level Cost Variance Summary
------------------------------------------------------------
SELECT
    SUM(planned_cost) AS portfolio_planned_cost,
    SUM(actual_cost) AS portfolio_actual_cost,
    SUM(actual_cost - planned_cost) AS portfolio_cost_variance
FROM project_financials;

