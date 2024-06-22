
Dataset Overview
The database consisted of multiple tables, including:
•	Employees: Information about each employee, including their personal details and hiring dates.
•	Salaries: Salary history for each employee, including the period for which the salary was valid.
•	Departments: Details of various departments within the organization.
•	Dept emp: Mapping of employees to their respective departments.
•	Titles: Job titles held by employees.
•	Dept manager: Information about department managers.

Steps Undertaken
1.	Data Cleaning and Preprocessing:
o	Created staging tables to avoid altering the master data.
o	Checked and removed any duplicate records.
o	Standardized data by trimming unnecessary spaces.
o	Verified the absence of null values in critical columns.
o	Extracted and formatted dates for further analysis.

2.	Data Exploration:
o	Calculated basic statistics such as gender distribution, average age, and hiring trends.
o	Investigated salary distributions and identified the highest and lowest earners.
o	Analyzed the total salary transactions over the period.

3.	Multidimensional Analysis:
o	Combined employees' and salaries' data to perform gender-based salary comparisons.
o	Analyzed average salaries by year of hiring and age of employees.
o	Examined department-wise salary distributions and employee demographics.

4.	Outlier Detection:
o	Used z-scores to standardize salary data and identify outliers.
o	Focused on departments with a high number of salary outliers, particularly the sales department.

5.	Managerial Insights:
o	Compared average salaries of male and female managers.
o	Identified which department's managers are the highest paid.

6.	Title-Based Analysis:
o	Evaluated average salaries based on job titles to understand the hierarchy and pay scales.
Conclusion


This SQL data analysis project provides a detailed view of the company's employee and salary data, highlighting key trends and insights. The analysis can be used by the HR and management teams to make informed decisions regarding salary adjustments, hiring practices, and workforce management. By identifying outliers and understanding department-wise and title-based salary distributions, the company can ensure equitable and competitive compensation for its employees.
Functions and Clauses Used
1.	CREATE TABLE: To create staging tables.
2.	INSERT INTO ... SELECT: To copy data into staging tables.
3.	SELECT: To retrieve data from tables.
4.	COUNT(): To count rows and specific conditions.
5.	ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...): To identify duplicate rows.
6.	WITH (Common Table Expressions - CTEs): For organizing complex queries and making them more readable.
7.	DISTINCT: To fetch unique records.
8.	TRIM(): To remove whitespace from strings.
9.	IS NULL: To check for NULL values.
10.	EXTRACT (YEAR FROM date column): To extract the year from date fields.
11.	AVG(): To calculate the average value.
12.	SUM(): To calculate the sum of values.
13.	GROUP BY: To aggregate data based on one or more columns.
14.	ORDER BY: To sort results.
15.	JOIN (INNER JOIN, LEFT JOIN): To combine rows from two or more tables based on related columns.
16.	CASE: To conditionally manipulate and transform data.
17.	HAVING: To filter groups based on aggregate functions.
18.	STD(): To calculate the standard deviation.
19.	ALTER TABLE: To modify the structure of existing tables.
20.	UPDATE: To modify existing data in a table.
21.	ROUND(): To round numeric values to a specified precision.

Through these SQL queries and functions, I achieved a thorough understanding of the dataset, enabling me to derive meaningful insights into employee demographics, salary distributions, and organizational trends. This analysis not only highlights the power of SQL in data cleaning and exploration but also provides a solid foundation for making informed business decisions.
Lastly using all Basic, Intermediate and Advanced gave me comprehensive knowledge of SQL tool and helping me gain practical knowledge of the tool.
-	Siddhant kohli
