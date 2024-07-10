# Data Science Job Case Study

### Overview
This case study demonstrates various SQL queries performed on a salaries dataset, aiming to analyze workforce data for different roles and companies. The tasks simulate real-world scenarios that a data analyst might encounter in various professional roles, such as market research, talent acquisition, database management, financial analysis, and data architecture.

### Insights
1. Discovered that large-sized companies employ the highest number of individuals, suggesting robust job opportunities compared to medium and small-sized firms.
2. Identified significant disparities in average salaries between Data Scientists and Data Analysts, highlighting the market's valuation of specialized skills.
3. Evaluated countries where mid-level salaries exceeded the overall average, emphasizing competitive markets like Qatar, Australia, and the United States.

### Learnings
- Aggregate Functions: Utilized AVG(), COUNT(), and SUM() to compute average salaries, count employees, and sum values.
- Group By: Applied GROUP BY to categorize data based on specific columns like company_size, job_title, company_location.
- Conditional Logic: Employed CASE statements to implement conditional logic for updating salary values.
- Common Table Expressions (CTEs): Used WITH clauses to create temporary result sets that can be referenced within a SELECT, INSERT, UPDATE, or DELETE statement.
- Subqueries: Implemented subqueries to compute intermediate results, such as overall average salary.
- Window Functions: Applied DENSE_RANK() for ranking rows within a partition, helping to identify the highest average salaries.
- Data Manipulation: Conducted UPDATE operations to modify existing
