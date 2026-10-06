# SQL PMO Project

Based on the open-source project SammanthaRamirez/SQL-PMO-Project.

## My changes
- Fixed the capacity queries to use the real fte_allocated column
- Added an over-allocation check that flags anyone above 1.0 FTE in a month
- Added a translators table (language pair, skills, rate, availability, rating)
- Added a search query for available translators by language pair

## Note
The translator data is fictional sample data, made only to demonstrate the query.

## Files I added
- analytics/capacity_overallocation_fixed.sql
- analytics/search_available_translators.sql
- ddl/translators.sql
- dml/insert_translators_sample.sql
