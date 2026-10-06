------------------------------------------------------------
-- PORTFOLIO SUMMARY ANALYTICS QUERIES
-- High‑level portfolio performance indicators across all projects.
------------------------------------------------------------

------------------------------------------------------------
-- 1. Portfolio Financial Summary
-- Total planned vs. actual cost and benefit
------------------------------------------------------------
SELECT
    SUM(planned_budget) AS portfolio_planned_budget,
    SUM(total_actuals) AS portfolio_actuals,
    SUM(total_actuals - planned_budget) AS portfolio_cost_variance
FROM projects;


------------------------------------------------------------
-- 2. Portfolio Cost Variance by Line of Business
------------------------------------------------------------
SELECT
    line_of_business,
    SUM(planned_budget) AS planned_budget,
    SUM(total_actuals) AS actuals,
    SUM(total_actuals - planned_budget) AS cost_variance
FROM projects
GROUP BY line_of_business
ORDER BY cost_variance DESC;


------------------------------------------------------------
-- 3. Portfolio Project Status Breakdown
------------------------------------------------------------
SELECT
    project_status,
    COUNT(*) AS project_count
FROM projects
GROUP BY project_status
ORDER BY project_count DESC;


------------------------------------------------------------
-- 4. Portfolio Risk Rating Distribution
------------------------------------------------------------
SELECT
    risk_rating,
    COUNT(*) AS project_count
FROM projects
GROUP BY risk_rating
ORDER BY project_count DESC;


------------------------------------------------------------
-- 5. Average RAG Health Scores (from project_health_snapshot)
-- Converts RAG to numeric for scoring:
-- Green = 1, Amber = 2, Red = 3
------------------------------------------------------------
SELECT
    AVG(CASE overall_rag
            WHEN 'Green' THEN 1
            WHEN 'Amber' THEN 2
            WHEN 'Red' THEN 3
        END) AS avg_overall_health_score,
    AVG(CASE schedule_rag
            WHEN 'Green' THEN 1
            WHEN 'Amber' THEN 2
            WHEN 'Red' THEN 3
        END) AS avg_schedule_health_score,
    AVG(CASE scope_rag
            WHEN 'Green' THEN 1
            WHEN 'Amber' THEN 2
            WHEN 'Red' THEN 3
        END) AS avg_scope_health_score,
    AVG(CASE cost_rag
            WHEN 'Green' THEN 1
            WHEN 'Amber' THEN 2
            WHEN 'Red' THEN 3
        END) AS avg_cost_health_score
FROM project_health_snapshot;


------------------------------------------------------------
-- 6. Portfolio Schedule Summary
-- % of projects completed, in progress, on hold, not started
------------------------------------------------------------
SELECT
    project_status,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM projects), 2) AS pct_of_portfolio
FROM projects
GROUP BY project_status
ORDER BY pct_of_portfolio DESC;


------------------------------------------------------------
-- 7. Portfolio Timeline Overview
-- Earliest start, latest end, total duration
------------------------------------------------------------
SELECT
    MIN(start_date) AS portfolio_start,
    MAX(end_date) AS portfolio_end,
    DATEDIFF(day, MIN(start_date), MAX(end_date)) AS total_portfolio_duration_days
FROM projects;


------------------------------------------------------------
-- 8. Portfolio Budget Utilization %
-- (Total Actuals / Total Planned Budget)
------------------------------------------------------------
SELECT
    ROUND(
        SUM(total_actuals) / NULLIF(SUM(planned_budget), 0) * 100,
        2
    ) AS portfolio_budget_utilization_pct
FROM projects;


------------------------------------------------------------
-- 9. Top 10 Projects by Cost Variance
------------------------------------------------------------
SELECT
    project_id,
    project_name,
    planned_budget,
    total_actuals,
    (total_actuals - planned_budget) AS cost_variance
FROM projects
ORDER BY cost_variance DESC
LIMIT 10;


------------------------------------------------------------
-- 10. Portfolio Heatmap: RAG Counts
------------------------------------------------------------
SELECT
    overall_rag,
    COUNT(*) AS project_count
FROM project_health_snapshot
GROUP BY overall_rag
ORDER BY project_count DESC;

