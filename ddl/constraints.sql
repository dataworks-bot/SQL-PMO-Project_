------------------------------------------------------------
-- FOREIGN KEY CONSTRAINTS FOR PMO DATABASE
------------------------------------------------------------

------------------------------------------------------------
-- PROJECT RESOURCE ALLOCATION → PROJECTS & RESOURCES
------------------------------------------------------------
ALTER TABLE project_resource_allocation
ADD CONSTRAINT fk_pra_project
    FOREIGN KEY (project_id)
    REFERENCES projects(project_id);

ALTER TABLE project_resource_allocation
ADD CONSTRAINT fk_pra_resource
    FOREIGN KEY (resource_id)
    REFERENCES resources(resource_id);

------------------------------------------------------------
-- PROJECT FINANCIALS → PROJECTS
------------------------------------------------------------
ALTER TABLE project_financials
ADD CONSTRAINT fk_fin_project
    FOREIGN KEY (project_id)
    REFERENCES projects(project_id);

------------------------------------------------------------
-- PROJECT HEALTH SNAPSHOT → PROJECTS
------------------------------------------------------------
ALTER TABLE project_health_snapshot
ADD CONSTRAINT fk_health_project
    FOREIGN KEY (project_id)
    REFERENCES projects(project_id);

