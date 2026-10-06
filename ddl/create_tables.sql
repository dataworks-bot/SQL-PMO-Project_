------------------------------------------------------------
-- PROJECTS
------------------------------------------------------------
CREATE TABLE projects (
    project_id          INT PRIMARY KEY,
    project_name        VARCHAR(200) NOT NULL,
    project_manager     VARCHAR(150),
    project_status      VARCHAR(50),
    line_of_business    VARCHAR(150),
    start_date          DATE NOT NULL,
    end_date            DATE,
    planned_budget      DECIMAL(12,2),
    total_actuals       DECIMAL(12,2),
    risk_rating         VARCHAR(50)
);

------------------------------------------------------------
-- RESOURCES
------------------------------------------------------------
CREATE TABLE resources (
    resource_id         INT PRIMARY KEY,
    resource_name       VARCHAR(150) NOT NULL,
    resource_role       VARCHAR(100),
    resource_department VARCHAR(100)
);

------------------------------------------------------------
-- PROJECT RESOURCE ALLOCATION
------------------------------------------------------------
CREATE TABLE project_resource_allocation (
    project_id          INT NOT NULL,
    resource_id         INT NOT NULL,
    month               DATE NOT NULL,
    fte_allocated       DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (project_id, resource_id, month)
);

------------------------------------------------------------
-- PROJECT FINANCIALS
------------------------------------------------------------
CREATE TABLE project_financials (
    project_id          INT NOT NULL,
    month               DATE NOT NULL,
    planned_cost        DECIMAL(12,2),
    actual_cost         DECIMAL(12,2),
    planned_benefit     DECIMAL(12,2),
    actual_benefit      DECIMAL(12,2),
    PRIMARY KEY (project_id, month)
);

------------------------------------------------------------
-- PROJECT HEALTH SNAPSHOT
------------------------------------------------------------
CREATE TABLE project_health_snapshot (
    project_id          INT NOT NULL,
    snapshot_date       DATE NOT NULL,
    schedule_rag        VARCHAR(10),
    scope_rag           VARCHAR(10),
    cost_rag            VARCHAR(10),
    overall_rag         VARCHAR(10),
    PRIMARY KEY (project_id, snapshot_date)
);

