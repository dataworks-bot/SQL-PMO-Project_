------------------------------------------------------------
-- INDEXES FOR PMO DATABASE
------------------------------------------------------------

------------------------------------------------------------
-- PROJECTS TABLE INDEXES
------------------------------------------------------------
-- Common filters: status, line of business, risk rating
CREATE INDEX idx_projects_status
    ON projects (project_status);

CREATE INDEX idx_projects_lob
    ON projects (line_of_business);

CREATE INDEX idx_projects_risk
    ON projects (risk_rating);

------------------------------------------------------------
-- RESOURCES TABLE INDEXES
------------------------------------------------------------
-- Common filters: role, department
CREATE INDEX idx_resources_role
    ON resources (resource_role);

CREATE INDEX idx_resources_department
    ON resources (resource_department);

------------------------------------------------------------
-- PROJECT RESOURCE ALLOCATION INDEXES
------------------------------------------------------------
-- Speed up joins and month-based reporting
CREATE INDEX idx_pra_project
    ON project_resource_allocation (project_id);

CREATE INDEX idx_pra_resource
    ON project_resource_allocation (resource_id);

CREATE INDEX idx_pra_month
    ON project_resource_allocation (month);

------------------------------------------------------------
-- PROJECT FINANCIALS INDEXES
------------------------------------------------------------
-- Speed up month-based financial reporting
CREATE INDEX idx_fin_project
    ON project_financials (project_id);

CREATE INDEX idx_fin_month
    ON project_financials (month);

------------------------------------------------------------
-- PROJECT HEALTH SNAPSHOT INDEXES
------------------------------------------------------------
-- Speed up RAG trend analysis
CREATE INDEX idx_health_project
    ON project_health_snapshot (project_id);

CREATE INDEX idx_health_snapshot_date
    ON project_health_snapshot (snapshot_date);

-- Useful for dashboards filtering by RAG
CREATE INDEX idx_health_overall_rag
    ON project_health_snapshot (overall_rag);

