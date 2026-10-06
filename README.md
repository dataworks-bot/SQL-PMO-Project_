**SQL PMO Project – Portfolio Management Database**

This project demonstrates end‑to‑end SQL capabilities using a realistic Project Management Office (PMO) dataset.  
It includes full database design, Data Definition Language (DDL), Data Manipulation Language (DML), indexing, and advanced analytical SQL used for enterprise‑grade portfolio reporting.

The goal of this project is to simulate how a real PMO manages projects, resources, financials, and health metrics — and how SQL powers the insights behind executive dashboards.

**Purpose of This Project**

This repository serves as a **complete SQL portfolio project** demonstrating:

- Real‑world PMO data modeling  
- Enterprise‑style SQL analytics  
- Clean, maintainable SQL architecture  
- A realistic dataset large enough to show complexity  
- Skills directly applicable to data engineering, BI, and analytics roles  

It is designed to be both a **learning tool** and a **portfolio showcase**.

This project is fully functional and ready for use, extension, or integration into BI dashboards.

**Project Structure**
```
sql-pmo-project/
│
├── data/                # Raw CSV files exported from Excel
│
├── ddl/                 # Database schema (DDL)
│   ├── create_tables.sql
│   ├── constraints.sql
│   └── indexes.sql
│
├── dml/                 # Insert scripts (DML)
│   ├── insert_projects.sql
│   ├── insert_resources.sql
│   ├── insert_allocations.sql
│   ├── insert_financials.sql
│   └── insert_health_snapshot.sql
│
└── analytics/           # Analytical SQL queries
    ├── project_health_queries.sql
    ├── financial_variance_queries.sql
    ├── resource_capacity_queries.sql
    ├── portfolio_summary_queries.sql
    └── rag_trend_queries.sql
```

**Database Schema Overview**

The database contains five core tables:

    Projects – project metadata, budgets, dates, status

    Resources – employees and contractors

    Project_Resource_Allocation – monthly FTE allocation

    Project_Financials – planned vs actual cost & benefit

    Project_Health_Snapshot – RAG status over time

These tables form a realistic PMO relational model suitable for analytics.

**SQL Skills Demonstrated**

Database Design

    - Normalized schema  
    - Primary/foreign keys  
    - Referential integrity  

DDL
  
    - Table creation  
    - Constraints  
    - Indexing strategy  

DML

    - Bulk insert scripts  
    - 250+ project records  
    - 100 resources  
    - Full financial, allocation, and health datasets  

Analytical SQL:

    - Joins  
    - CTEs  
    - Window functions  
    - Variance analysis  
    - Trend analysis  
    - RAG scoring  
    - Portfolio rollups  
    - Resource utilization modeling  
    
This project mirrors the analytics used in real PMO dashboards (Power BI, Tableau, etc.).

**How to Run This Project**

1. Run all scripts in ddl folder in this order:


    -create_tables.sql

    -constraints.sql

    -indexes.sql

   
3. Load data and run all scripts in dml folder

   -insert_projects.sql
   
   -insert_resources.sql
   
   -insert_allocations.sql
   
   -insert_financials.sql
   
   -insert_health_snapshot.sql
   

4. Execute queries in analytics folder to generate insights such as:

    -Project RAG trends

    -Budget vs actual variance

    -Resource over‑allocation

    -Portfolio level summaries

    -Health scoring and early‑warning indicators
