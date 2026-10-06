------------------------------------------------------------
-- RESOURCE CAPACITY ANALYTICS QUERIES
-- Workload, utilization, availability, and over‑allocation detection.
------------------------------------------------------------


------------------------------------------------------------
-- NOTE
-- Schema includes Resource_Allocation table that contains:
-- resource_allocations (
--     allocation_id,
--     project_id,
--     resource_id,
--     month,
--     allocated_hours,
--     capacity_hours
-- )
--
-- capacity_hours = total available hours for that resource in that month
-- allocated_hours = hours assigned to projects
------------------------------------------------------------


------------------------------------------------------------
-- 1. Monthly Capacity vs. Allocation per Resource
------------------------------------------------------------
SELECT
    ra.resource_id,
    r.resource_name,
    ra.month,
    ra.capacity_hours,
    ra.allocated_hours,
    (ra.capacity_hours - ra.allocated_hours) AS remaining_capacity
FROM resource_allocations ra
JOIN resources r ON r.resource_id = ra.resource_id
ORDER BY ra.resource_id, ra.month;



------------------------------------------------------------
-- 2. Resource Utilization % (Allocated / Capacity)
------------------------------------------------------------
SELECT
    ra.resource_id,
    r.resource_name,
    ra.month,
    ra.allocated_hours,
    ra.capacity_hours,
    ROUND(
        ra.allocated_hours / NULLIF(ra.capacity_hours, 0) * 100,
        2
    ) AS utilization_pct
FROM resource_allocations ra
JOIN resources r ON r.resource_id = ra.resource_id
ORDER BY ra.resource_id, ra.month;



------------------------------------------------------------
-- 3. Over‑Allocated Resources (Allocated > Capacity)
------------------------------------------------------------
SELECT
    ra.resource_id,
    r.resource_name,
    ra.month,
    ra.capacity_hours,
    ra.allocated_hours,
    (ra.allocated_hours - ra.capacity_hours) AS overage_hours
FROM resource_allocations ra
JOIN resources r ON r.resource_id = ra.resource_id
WHERE ra.allocated_hours > ra.capacity_hours
ORDER BY overage_hours DESC;



------------------------------------------------------------
-- 4. Total Allocation Load per Resource (Across All Months)
------------------------------------------------------------
SELECT
    ra.resource_id,
    r.resource_name,
    SUM(ra.capacity_hours) AS total_capacity,
    SUM(ra.allocated_hours) AS total_allocated,
    SUM(ra.capacity_hours - ra.allocated_hours) AS total_remaining_capacity
FROM resource_allocations ra
JOIN resources r ON r.resource_id = ra.resource_id
GROUP BY ra.resource_id, r.resource_name
ORDER BY total_allocated DESC;



------------------------------------------------------------
-- 5. Portfolio‑Level Resource Utilization Summary
------------------------------------------------------------
SELECT
    SUM(allocated_hours) AS portfolio_allocated_hours,
    SUM(capacity_hours) AS portfolio_capacity_hours,
    ROUND(
        SUM(allocated_hours) / NULLIF(SUM(capacity_hours), 0) * 100,
        2
    ) AS portfolio_utilization_pct
FROM resource_allocations;



------------------------------------------------------------
-- 6. Resource Allocation by Project
------------------------------------------------------------
SELECT
    ra.resource_id,
    r.resource_name,
    ra.project_id,
    p.project_name,
    ra.month,
    ra.allocated_hours
FROM resource_allocations ra
JOIN resources r ON r.resource_id = ra.resource_id
JOIN projects p ON p.project_id = ra.project_id
ORDER BY ra.resource_id, ra.month;



------------------------------------------------------------
-- 7. Resources Supporting the Most Projects
------------------------------------------------------------
SELECT
    ra.resource_id,
    r.resource_name,
    COUNT(DISTINCT ra.project_id) AS project_count
FROM resource_allocations ra
JOIN resources r ON r.resource_id = ra.resource_id
GROUP BY ra.resource_id, r.resource_name
ORDER BY project_count DESC;



------------------------------------------------------------
-- 8. Monthly Portfolio Capacity vs. Allocation
------------------------------------------------------------
SELECT
    month,
    SUM(capacity_hours) AS total_capacity,
    SUM(allocated_hours) AS total_allocated,
    SUM(capacity_hours - allocated_hours) AS remaining_capacity
FROM resource_allocations
GROUP BY month
ORDER BY month;



------------------------------------------------------------
-- 9. Resources With Consistent Over‑Allocation (3+ Months)
------------------------------------------------------------
WITH overages AS (
    SELECT
        resource_id,
        month,
        allocated_hours,
        capacity_hours,
        (allocated_hours - capacity_hours) AS overage
    FROM resource_allocations
    WHERE allocated_hours > capacity_hours
)
SELECT
    o.resource_id,
    r.resource_name,
    COUNT(*) AS months_overallocated
FROM overages o
JOIN resources r ON r.resource_id = o.resource_id
GROUP BY o.resource_id, r.resource_name
HAVING COUNT(*) >= 3
ORDER BY months_overallocated DESC;



------------------------------------------------------------
-- 10. Resources With High Availability (Under‑Utilized)
-- Utilization < 50%
------------------------------------------------------------
SELECT
    ra.resource_id,
    r.resource_name,
    ra.month,
    ra.allocated_hours,
    ra.capacity_hours,
    ROUND(
        ra.allocated_hours / NULLIF(ra.capacity_hours, 0) * 100,
        2
    ) AS utilization_pct
FROM resource_allocations ra
JOIN resources r ON r.resource_id = ra.resource_id
WHERE ra.allocated_hours < (ra.capacity_hours * 0.5)
ORDER BY utilization_pct ASC;

