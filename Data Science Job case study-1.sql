USE campusx;

SELECT * FROM salaries;
SET SESSION sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

/*1. As a market researcher, your job is to Investigate the job market for a company that analyzes workforce data. Your Task is to know how many people were employed IN 
different types of companies AS per their size IN 2021.*/
SELECT company_size, COUNT(company_size) AS 'Employees'
FROM salaries
WHERE work_year = 2021
GROUP BY company_size;

/*2. Imagine you are a talent Acquisition specialist Working for an International recruitment agency. Your Task is to identify the top 3 job titles that command the highest 
average salary Among part-time Positions IN the year 2023. However, you are Only Interested IN Countries WHERE there are more than 50 employees, Ensuring a robust sample size 
for your analysis.*/
SELECT job_title, AVG(salary_in_usd)
FROM salaries
WHERE employment_type = 'PT' AND work_year = 2023
GROUP BY job_title;

/*3. As a database analyst you have been assigned the task to Select Countries where average mid-level salary is higher than overall mid-level salary for the year 2023.*/

SELECT company_location, AVG(salary_in_usd) AS country_salary
FROM salaries
WHERE experience_level = 'MI'
GROUP BY company_location
HAVING AVG(salary_in_usd) > (SELECT AVG(salary_in_usd)AS overall_avg_salary
FROM salaries
WHERE experience_level = 'MI');

/*4. As a database analyst you have been assigned the task to Identify the company locations with the highest and lowest average salary for senior-level (SE) employees 
in 2023.*/
SELECT a.company_location, a.Avg_salary AS highest_avg_salary, b.company_location, b.Avg_salary AS lowest_avg_salary
FROM
(
SELECT company_location, AVG(salary_in_usd) AS Avg_salary
FROM salaries
WHERE experience_level = 'SE'
GROUP BY company_location
ORDER BY Avg_salary DESC
LIMIT 1
) AS a
INNER JOIN
(
SELECT company_location, AVG(salary_in_usd) AS Avg_salary
FROM salaries
WHERE experience_level = 'SE'
GROUP BY company_location
ORDER BY Avg_salary ASC
LIMIT 1
) b ON a.company_location != b.company_location;

/*5. You're a Financial analyst Working for a leading HR Consultancy, and your Task is to Assess the annual salary growth rate for various job titles. By Calculating 
the percentage Increase IN salary FROM previous year to this year, you aim to provide valuable Insights Into salary trends WITHIN different job roles.*/
WITH salaries_avg AS
(
	SELECT a.job_title, a.Avg_sal_2023, b.Avg_sal_2024
	FROM
	(
		SELECT job_title, AVG(salary_in_usd) AS 'Avg_sal_2023'
		FROM salaries
		WHERE work_year = 2023
		GROUP BY job_title
	) a INNER JOIN 
	(
		SELECT job_title, AVG(salary_in_usd) AS 'Avg_sal_2024'
		FROM salaries
		WHERE work_year = 2024
		GROUP BY job_title
	) b ON a.job_title = b.job_title
)
SELECT job_title, Avg_sal_2023, Avg_sal_2024, ROUND(((Avg_sal_2024 - Avg_sal_2023)/ Avg_sal_2023) * 100,2) AS Percent_Change
FROM salaries_avg;

/*6. You've been hired by a global HR Consultancy to identify Countries experiencing significant salary growth for entry-level roles. Your task is to list the top three
 Countries with the highest salary growth rate FROM 2020 to 2023, Considering Only companies with more than 50 employees, helping multinational Corporations identify Emerging 
 talent markets.*/
WITH salary_change AS
(
	SELECT company_location, work_year, AVG(salary_in_usd) AS avg
	FROM salaries
	WHERE experience_level = 'EN' AND (work_year = 2021 OR work_year = 2023)
	GROUP BY company_location, work_year
) 
SELECT *,
(((Avg_sal_2023 - Avg_sal_2021)/Avg_sal_2021) * 100) AS changes
FROM 
(
	SELECT company_location,
	MAX(CASE WHEN work_year = 2021 THEN avg END) AS 'Avg_sal_2021',
	MAX(CASE WHEN work_year = 2023 THEN avg END) AS 'Avg_sal_2023'
	FROM salary_change
	GROUP BY company_location
)a
WHERE (((Avg_sal_2023 - Avg_sal_2021)/Avg_sal_2021) * 100) IS NOT NULL
ORDER BY (((Avg_sal_2023 - Avg_sal_2021)/Avg_sal_2021) * 100) DESC;

/*7. Picture yourself as a data architect responsible for database management. Companies in US and AU(Australia) decided to create a hybrid model for employees they decided 
that employees earning salaries exceeding $90000 USD, will be given work from home. You now need to update the remote work ratio for eligible employees, ensuring efficient 
remote work management while implementing appropriate error handling mechanisms for invalid input parameters.*/
CREATE TABLE temp AS SELECT * FROM salaries; -- temp_table

 -- by default mysql runs on safe update mode , this mode  is a safeguard against updating
 -- or deleting large portion of  a table.
 -- We will turn off safe update mode using set_sql_safe_updates
 
SET SQL_SAFE_UPDATES = 0;

UPDATE temp
SET remote_ratio = 100
WHERE (company_location = 'US' OR company_location = 'AU') AND salary_in_usd > 90000;

SELECT * 
FROM temp 
WHERE (company_location = 'US' OR company_location = 'AU') AND salary_in_usd > 90000;

/*8. In the year 2024, due to increased demand in the data industry, there was an increase in salaries of data field employees.
Entry Level-35% of the salary.
Mid junior – 30% of the salary.
Immediate senior level- 22% of the salary.
Expert level- 20% of the salary.
Director – 15% of the salary.
You must update the salaries accordingly and update them back in the original database.
*/

UPDATE temp
SET salary_in_usd = 
		CASE 
			WHEN experience_level = 'EN' THEN salary_in_usd * 1.35   -- 35% increase
			WHEN experience_level = 'MI' THEN salary_in_usd * 1.30   -- 30% increase
            WHEN experience_level = 'SE' THEN salary_in_usd * 1.22   -- 22% increase
			WHEN experience_level = 'EX' THEN salary_in_usd * 1.20   -- 20% increase
		    WHEN experience_level = 'DX' THEN salary_in_usd * 1.15   -- 15% increase
	        ELSE salary_in_usd
		END
WHERE work_year = 2024;

 SELECT * FROM salaries WHERE work_year = 2024;
 SELECT * FROM temp WHERE work_year = 2024;
 
/*9. You are a researcher and you have been assigned the task to Find the year with the highest average salary for each job title.*/
WITH highest_salary AS
(
	SELECT work_year, job_title, AVG(salary_in_usd) AS Avg_salary
	FROM salaries
	GROUP BY work_year, job_title
)
SELECT work_year, job_title,Avg_salary
FROM
(
	SELECT work_year, job_title,Avg_salary, DENSE_RANK() OVER(PARTITION BY job_title ORDER BY Avg_salary) AS rn
	FROM highest_salary
) t
WHERE rn =1;

/*10. You have been hired by a market research agency where you been assigned the task to show the percentage of different employment type (full time, part time) in 
Different job roles, in the format where each row will be job title, each column will be type of employment type and cell value for that row and column will show the % value*/
SELECT job_title,
ROUND((SUM(CASE WHEN employment_type = 'FT' THEN 1 ELSE 0 END) / COUNT(*))*100,2) AS 'FT_percentage',
ROUND((SUM(CASE WHEN employment_type = 'PT' THEN 1 ELSE 0 END) / COUNT(*))*100,2) AS 'PT_percentage',
ROUND((SUM(CASE WHEN employment_type = 'CT' THEN 1 ELSE 0 END) / COUNT(*)*100),2) AS 'CT_percentage',
ROUND((SUM(CASE WHEN employment_type = 'FL' THEN 1 ELSE 0 END) / COUNT(*)*100),2) AS 'FL_percentage'
FROM salaries
GROUP BY job_title