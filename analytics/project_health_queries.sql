------------------------------------------------------------
-- PROJECT HEALTH ANALYTICS QUERIES
-- RAG scoring, trend analysis, exceptions, and portfolio health.
------------------------------------------------------------

------------------------------------------------------------
-- 1. Latest Health Snapshot for Each Project
------------------------------------------------------------
SELECT
    ph.project_id,
    p.project_name,
    ph.snapshot_date,
    ph.overall_rag,
    ph.schedule_rag,
    ph.scope_rag,
    ph.cost_rag
FROM project_health_snapshot ph
JOIN projects p ON p.project_id = ph.project_id
WHERE ph.snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM project_health_snapshot ph2
    WHERE ph2.project_id = ph.project_id
)
ORDER BY ph.project_id;


------------------------------------------------------------
-- 2. RAG Trend Over Time for a Single Project
-- Replace :project_id with a specific ID when running
------------------------------------------------------------
SELECT
    snapshot_date,
    overall_rag,
    schedule_rag,
    scope_rag,
    cost_rag
FROM project_health_snapshot
WHERE project_id = :project_id
ORDER BY snapshot_date;


------------------------------------------------------------
-- 3. Count of Projects by Overall RAG Status
------------------------------------------------------------
SELECT
    overall_rag,
    COUNT(*) AS project_count
FROM project_health_snapshot ph
WHERE snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM project_health_snapshot ph2
    WHERE ph2.project_id = ph.project_id
)
GROUP BY overall_rag
ORDER BY project_count DESC;


------------------------------------------------------------
-- 4. Projects Currently in Red (Any Dimension)
------------------------------------------------------------
SELECT
    ph.project_id,
    p.project_name,
    ph.snapshot_date,
    ph.overall_rag,
    ph.schedule_rag,
    ph.scope_rag,
    ph.cost_rag
FROM project_health_snapshot ph
JOIN projects p ON p.project_id = ph.project_id
WHERE ph.snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM project_health_snapshot ph2
    WHERE ph2.project_id = ph.project_id
)
AND (
    ph.overall_rag = 'Red'
    OR ph.schedule_rag = 'Red'
    OR ph.scope_rag = 'Red'
    OR ph.cost_rag = 'Red'
)
ORDER BY p.project_name;


------------------------------------------------------------
-- 5. RAG Score Conversion (Green=1, Amber=2, Red=3)
-- Useful for dashboards and weighted scoring models
------------------------------------------------------------
SELECT
    ph.project_id,
    p.project_name,
    ph.snapshot_date,
    CASE overall_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END AS overall_score,
    CASE schedule_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END AS schedule_score,
    CASE scope_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END AS scope_score,
    CASE cost_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END AS cost_score
FROM project_health_snapshot ph
JOIN projects p ON p.project_id = ph.project_id
ORDER BY ph.project_id, ph.snapshot_date;


------------------------------------------------------------
-- 6. Portfolio Average Health Score (Lower = Healthier)
------------------------------------------------------------
SELECT
    AVG(CASE overall_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END) AS avg_overall_score,
    AVG(CASE schedule_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END) AS avg_schedule_score,
    AVG(CASE scope_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END) AS avg_scope_score,
    AVG(CASE cost_rag WHEN 'Green' THEN 1 WHEN 'Amber' THEN 2 WHEN 'Red' THEN 3 END) AS avg_cost_score
FROM project_health_snapshot ph
WHERE snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM project_health_snapshot
);


------------------------------------------------------------
-- 7. Projects Improving or Declining (Last 2 Snapshots)
------------------------------------------------------------
WITH last_two AS (
    SELECT
        project_id,
        snapshot_date,
        overall_rag,
        ROW_NUMBER() OVER (PARTITION BY project_id ORDER BY snapshot_date DESC) AS rn
    FROM project_health_snapshot
)
SELECT
    p.project_id,
    p.project_name,
    prev.overall_rag AS previous_rag,
    curr.overall_rag AS current_rag,
    CASE
        WHEN prev.overall_rag = curr.overall_rag THEN 'No Change'
        WHEN prev.overall_rag = 'Red'   AND curr.overall_rag IN ('Amber','Green') THEN 'Improving'
        WHEN prev.overall_rag = 'Amber' AND curr.overall_rag = 'Green' THEN 'Improving'
        WHEN prev.overall_rag = 'Green' AND curr.overall_rag IN ('Amber','Red') THEN 'Declining'
        WHEN prev.overall_rag = 'Amber' AND curr.overall_rag = 'Red' THEN 'Declining'
        ELSE 'Mixed'
    END AS trend
FROM last_two curr
JOIN last_two prev
    ON curr.project_id = prev.project_id
   AND curr.rn = 1
   AND prev.rn = 2
JOIN projects p ON p.project_id = curr.project_id
ORDER BY trend, p.project_name;


------------------------------------------------------------
-- 8. Projects Missing Health Updates (No Snapshot in 30+ Days)
------------------------------------------------------------
SELECT
    p.project_id,
    p.project_name,
    MAX(ph.snapshot_date) AS last_snapshot
FROM projects p
LEFT JOIN project_health_snapshot ph ON ph.project_id = p.project_id
GROUP BY p.project_id, p.project_name
HAVING MAX(ph.snapshot_date) < DATEADD(day, -30, GETDATE())
ORDER BY last_snapshot;

