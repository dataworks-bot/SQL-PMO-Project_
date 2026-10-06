USE pmo_project;

-- Query 1: total FTE per person per month, flagged if above 1.0
SELECT
    resource_id,
    month,
    SUM(fte_allocated) AS total_fte,
    CASE
        WHEN SUM(fte_allocated) > 1.0 THEN 'OVER-ALLOCATED'
        ELSE 'OK'
    END AS status
FROM project_resource_allocation
GROUP BY resource_id, month
ORDER BY total_fte DESC;

-- Query 2: only the over-allocated people, with names
SELECT
    r.resource_id,
    r.resource_name,
    r.resource_role,
    r.resource_department,
    a.month,
    SUM(a.fte_allocated) AS total_fte
FROM project_resource_allocation a
JOIN resources r ON r.resource_id = a.resource_id
GROUP BY r.resource_id, r.resource_name, r.resource_role, r.resource_department, a.month
HAVING SUM(a.fte_allocated) > 1.0
ORDER BY total_fte DESC;