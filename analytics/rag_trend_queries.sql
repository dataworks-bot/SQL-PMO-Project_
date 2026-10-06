------------------------------------------------------------
-- RAG TREND ANALYTICS QUERIES
-- Focused on movement, direction, and trend analysis
-- across project health snapshots.
------------------------------------------------------------

------------------------------------------------------------
-- 1. RAG Trend History for All Projects
-- Shows every snapshot in chronological order.
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
ORDER BY ph.project_id, ph.snapshot_date;


------------------------------------------------------------
-- 2. RAG Movement Between Consecutive Snapshots
-- Shows whether each project improved, declined, or stayed flat.
------------------------------------------------------------
WITH ordered AS (
    SELECT
        project_id,
        snapshot_date,
        overall_rag,
        LAG(overall_rag) OVER (PARTITION BY project_id ORDER BY snapshot_date) AS prev_rag
    FROM project_health_snapshot
)
SELECT
    o.project_id,
    p.project_name,
    o.snapshot_date,
    o.prev_rag,
    o.overall_rag AS current_rag,
    CASE
        WHEN o.prev_rag IS NULL THEN 'No Prior Data'
        WHEN o.prev_rag = o.overall_rag THEN 'No Change'
        WHEN o.prev_rag = 'Red'   AND o.overall_rag IN ('Amber','Green') THEN 'Improving'
        WHEN o.prev_rag = 'Amber' AND o.overall_rag = 'Green' THEN 'Improving'
        WHEN o.prev_rag = 'Green' AND o.overall_rag IN ('Amber','Red') THEN 'Declining'
        WHEN o.prev_rag = 'Amber' AND o.overall_rag = 'Red' THEN 'Declining'
        ELSE 'Mixed'
    END AS rag_trend
FROM ordered o
JOIN projects p ON p.project_id = o.project_id
ORDER BY o.project_id, o.snapshot_date;


------------------------------------------------------------
-- 3. Latest RAG Trend (Last Two Snapshots Only)
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
    END AS rag_trend
FROM last_two curr
JOIN last_two prev
    ON curr.project_id = prev.project_id
   AND curr.rn = 1
   AND prev.rn = 2
JOIN projects p ON p.project_id = curr.project_id
ORDER BY rag_trend, p.project_name;


------------------------------------------------------------
-- 4. Portfolio-Level RAG Trend (Count of Projects Moving Up/Down)
------------------------------------------------------------
WITH last_two AS (
    SELECT
        project_id,
        snapshot_date,
        overall_rag,
        ROW_NUMBER() OVER (PARTITION BY project_id ORDER BY snapshot_date DESC) AS rn
    FROM project_health_snapshot
),
trend AS (
    SELECT
        curr.project_id,
        prev.overall_rag AS previous_rag,
        curr.overall_rag AS current_rag,
        CASE
            WHEN prev.overall_rag = curr.overall_rag THEN 'No Change'
            WHEN prev.overall_rag = 'Red'   AND curr.overall_rag IN ('Amber','Green') THEN 'Improving'
            WHEN prev.overall_rag = 'Amber' AND curr.overall_rag = 'Green' THEN 'Improving'
            WHEN prev.overall_rag = 'Green' AND curr.overall_rag IN ('Amber','Red') THEN 'Declining'
            WHEN prev.overall_rag = 'Amber' AND curr.overall_rag = 'Red' THEN 'Declining'
            ELSE 'Mixed'
        END AS rag_trend
    FROM last_two curr
    JOIN last_two prev
        ON curr.project_id = prev.project_id
       AND curr.rn = 1
       AND prev.rn = 2
)
SELECT
    rag_trend,
    COUNT(*) AS project_count
FROM trend
GROUP BY rag_trend
ORDER BY project_count DESC;


------------------------------------------------------------
-- 5. Projects With Consecutive Declines (2+ Drops in a Row)
------------------------------------------------------------
WITH ordered AS (
    SELECT
        project_id,
        snapshot_date,
        overall_rag,
        LAG(overall_rag) OVER (PARTITION BY project_id ORDER BY snapshot_date) AS prev_rag
    FROM project_health_snapshot
),
movement AS (
    SELECT
        project_id,
        snapshot_date,
        CASE
            WHEN prev_rag IS NULL THEN NULL
            WHEN prev_rag = overall_rag THEN 'Flat'
            WHEN prev_rag = 'Green' AND overall_rag IN ('Amber','Red') THEN 'Down'
            WHEN prev_rag = 'Amber' AND overall_rag = 'Red' THEN 'Down'
            ELSE 'Up'
        END AS movement
    FROM ordered
)
SELECT
    m.project_id,
    p.project_name,
    COUNT(*) AS consecutive_declines
FROM movement m
JOIN projects p ON p.project_id = m.project_id
WHERE movement = 'Down'
GROUP BY m.project_id, p.project_name
HAVING COUNT(*) >= 2
ORDER BY consecutive_declines DESC;


------------------------------------------------------------
-- 6. Projects With No RAG Improvement in Last 90 Days
------------------------------------------------------------
SELECT
    p.project_id,
    p.project_name,
    MAX(ph.snapshot_date) AS last_snapshot,
    MIN(ph.overall_rag) AS best_rag_in_period
FROM projects p
JOIN project_health_snapshot ph ON ph.project_id = p.project_id
WHERE ph.snapshot_date >= DATEADD(day, -90, GETDATE())
GROUP BY p.project_id, p.project_name
HAVING MIN(ph.overall_rag) IN ('Amber','Red')
ORDER BY last_snapshot;

