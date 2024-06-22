-- Data Cleaning and Exploration (Employees table)
-- Creating a staging area to avoid alteration in Masterdata (Employee)


CREATE TABLE employees_staging_data LIKE employees;
INSERT INTO employees_staging_data 
SELECT * 
FROM employees;

SELECT 
    *
FROM
    employees_staging_data;

SELECT 
    COUNT(*)
FROM
    employees_staging_data;
-- 300024 rows in employees table

-- Removing Duplicates (If any)

select *, 
Row_number() over(partition by emp_no , birth_date, first_name, hire_date) as row_num
from employees_staging_data;

-- Similar to python we can put it in a variable for easier exploration of data 

WITH duplicated_data AS (
  SELECT *, 
         ROW_NUMBER() OVER (PARTITION BY emp_no, birth_date, first_name, hire_date) AS row_num
  FROM employees_staging_data
)
SELECT * 
FROM duplicated_data 
WHERE row_num > 1;

-- So we have no duplicate rows 


-- Checking it without PRIMARY KEY

WITH duplicated_data_2 AS (
  SELECT *, 
         ROW_NUMBER() OVER (PARTITION BY birth_date, first_name, hire_date) AS row_num
  FROM employees_staging_data
)
SELECT * 
FROM duplicated_data_2 
WHERE row_num > 1;


-- We have same name but different Employee IDs (PK)
SELECT 
    *
FROM
    employees_staging_data
WHERE
    first_name = 'Sampalli'; 

SELECT 
    *
FROM
    employees_staging_data;

-- Verification

SELECT DISTINCT
    first_name, last_name
FROM
    employees_staging_data;

-- Now 279408 rows have been returned but we had 300024 rows in the data

SELECT 
    COUNT(*) - COUNT(DISTINCT first_name, last_name) AS duplicate_count
FROM
    employees_staging_data;

-- Meaning 20616 are duplicated names, Let's verify with primary key

SELECT DISTINCT
    emp_no
FROM
    employees_staging_data;

-- Proven we have no duplicates

-- Standardizing the data

SELECT 
    first_name, TRIM(first_name)
FROM
    employees_staging_data;

SELECT 
    first_name, TRIM(last_name)
FROM
    employees_staging_data;

select * from employees_staging_data;

-- Checking for Null values

SELECT 
    emp_no, birth_date, first_name, last_name, hire_date, gender
FROM
    employees_staging_data
WHERE
    emp_no IS NULL OR birth_date IS NULL
        OR first_name IS NULL
        OR last_name IS NULL
        OR hire_date IS NULL
        OR gender IS NULL; -- We have no null values

-- Formatting date into only Year for analysis


select * from employees_staging_data;

SELECT 
    birth_date, EXTRACT(YEAR FROM birth_date) AS birth_year
FROM
    employees_staging_data;

alter table employees_staging_data
add column birth_year INT; -- Adding birth year in the staging data

update employees_staging_data
set birth_year = extract(year from birth_date);

SELECT 
    *
FROM
    employees_staging_data;

-- Dropping the birth_month column
alter table employees_staging_data
drop column birth_month;

select * from employees_staging_data;

-- We will do same with hire date 


alter table employees_staging_data
add column hiring_year INT; -- Adding hiring year in the staging data

update employees_staging_data
set hiring_year = extract(year from hire_date);

select * from employees_staging_data;


-- Basic data analysis 

SELECT 
    COUNT(CASE
        WHEN gender = 'M' THEN 1
    END) AS Male_count,
    COUNT(CASE
        WHEN gender = 'F' THEN 1
    END) AS Female_count
FROM
    employees_staging_data; 
-- The case statement is used to conditionally count occurrences based on the gender.
-- count function will count the occurrences of non-null values.
-- Count(case when gender = 'F' then 1 end) will count the rows where the condition is true.


-- Proportion of respective genders
SELECT 
    SUM(CASE
        WHEN gender = 'M' THEN 1
        ELSE 0
    END) / COUNT(*) * 100 AS Male_proportion,
    SUM(CASE
        WHEN gender = 'F' THEN 1
        ELSE 0
    END) / COUNT(*) * 100 AS Female_proportion
FROM
    employees_staging_data;
-- Male proportion = 59.98 %
-- Female proportion = 40.02% 


-- Finding age of the current age of the employees and average age of employees in the firm (2000 data)
SELECT 
    birth_year, 2000 - birth_year AS current_age
FROM
    employees_staging_data;

-- Average age of the employees i.e 42 years 
SELECT 
    AVG(2000 - birth_year) AS average_age_of_employees
FROM
    employees_staging_data;


-- How many years have been hiring going for
-- Finding year which hired the most people (Mode of hiring year)  

SELECT DISTINCT
    (hiring_year)
FROM
    employees_staging_data
ORDER BY hiring_year DESC; -- For 15 years from 1985 to 2000

-- Year with most hiring -- 1986
SELECT 
    hiring_year
FROM
    employees_staging_data
GROUP BY hiring_year
ORDER BY COUNT(*) DESC
LIMIT 1; 

-- How many hires in particular year -- 36150 hires
SELECT 
    COUNT(hiring_year)
FROM
    employees_staging_data
WHERE
    hiring_year = '1986';

-- Average hiring every year -- 1990 hires
SELECT 
    AVG(hiring_year)
FROM
    employees_staging_data;

-- Number of hires in each year from 1985 to 2000
SELECT 
    hiring_year, COUNT(*) AS count
FROM
    employees_staging_data
GROUP BY hiring_year
ORDER BY hiring_year; -- There is a negative decline in the hires 

-- Show the trend and decline in hires each year
select
    a.hiring_year, 
    a.count as hires,
    (a.count - b.count) as change_from_previous_year 
from (
    select hiring_year, COUNT(*) as count
    from employees_staging_data
    group by hiring_year
) a
left join (
    SELECT hiring_year, COUNT(*) AS count
    FROM employees_staging_data
    GROUP BY hiring_year
) b
on a.hiring_year = b.hiring_year + 1
order by a.hiring_year;
-- The inner queries (a and b) each group by hiring_year and count the number of hires where a is current year and b is number of hires previous year .
-- The LEFT JOIN matches each year's hire count with the previous year's hire count (b.hiring_year + 1).
-- The SELECT clause calculates the difference in hires between consecutive years (a.count - b.count)[current year - previous year].
-- The ORDER BY a.hiring_year orders the results by year.


-- Cleaning and analysing salary table

select * from salaries;

-- Data Cleaning and Exploration (Salaries table)

-- Creating a staging area to avoid alteration in Masterdata (Salaries)

CREATE TABLE salaries_staging_data LIKE salaries;
INSERT INTO salaries_staging_data
select * from salaries;

-- Count of records
SELECT 
    salary
FROM
    salaries_staging_data;

SELECT 
    COUNT(*)
FROM
    salaries_staging_data; -- 967,330 records


SELECT DISTINCT
    (emp_no)
FROM
    salaries_staging_data; -- 101,796 records

SELECT DISTINCT
    (emp_no)
FROM
    employees_staging_data; -- 300,034 records


-- Checking for duplicates in salaries_staging_data

select
    *,
    row_number() over (partition by emp_no, salary, from_date, to_date) as row_num
from
    salaries_staging_data;
 
 with duplicated_salaries_data as (
 select
    *,
    row_number() over (partition by emp_no, salary, from_date, to_date) as row_num
from
    salaries_staging_data
)

select * from duplicated_salaries_data where row_num > 1;

-- We do not have duplicate records in the table 

-- Checking for null records
SELECT 
    emp_no, salary, from_date, to_date
FROM
    salaries_staging_data
WHERE
    emp_no IS NULL OR salary IS NULL
        OR from_date IS NULL
        OR to_date IS NULL; -- No null values


SELECT 
    *
FROM
    salaries_staging_data
WHERE
    to_date LIKE '9999%';
--  To avoid confusion the database has 9999 telling the ending ending of consecutive transaction as mentioned in metadata

select * from salaries_staging_data;

SELECT 
    SUM(salary)
FROM
    salaries_staging_data; -- Total salaries transacted from 1985 - 2000 = $61,678,125,784

SELECT 
    emp_no, SUM(salary) AS total_salary
FROM
    salaries_staging_data
GROUP BY emp_no
ORDER BY total_salary DESC; -- Employee with ID 109334 has been payed most of about $2,553,036

SELECT 
    *
FROM
    salaries_staging_data
WHERE
    emp_no = '109334'; -- He/She has been payed for 14 years where his average salary was = $141,835

SELECT 
    AVG(salary)
FROM
    salaries_staging_data
WHERE
    emp_no = '109334';

-- Finding employees who have churned
select COUNT(*) as employees_joined,
       SUM(case when to_date = '9999-01-01' then 1 else 0 end) as employees_left
from salaries_staging_data;

select emp_no, salary -- Highest earner
from salaries_staging_data
order by salary desc
limit 1; -- Person who had Highest earning in a year

select emp_no, salary -- Lowest earner
from salaries_staging_data
order by salary asc
limit 1; -- Person who had lowest earning in a year

-- Doing multidimensional analysis with diffrent tables (Departments , Employees)

create table employee_salary_data as
SELECT a.emp_no, a.salary, a.from_date, a.to_date, 
       b.birth_year, b.first_name, b.last_name, b.gender, b.hiring_year
FROM salaries_staging_data AS a
INNER JOIN employees_staging_data AS b ON a.emp_no = b.emp_no;

-- Now we havce joined the two tables salaries and employees in one table so we can perform the analysis.

Select * from employee_salary_data;	

-- Comparing salaries of male and female 

select
    gender,
    avg(salary) as average_salary
from 
    employee_salary_data
where 
    gender in ('M', 'F')
group by
    gender; -- There not much of a diffrence as we can see 

-- Which year had the most salary transacted -- 1985
SELECT 
    hiring_year, AVG(salary) AS average_salary
FROM
    employee_salary_data
GROUP BY hiring_year
ORDER BY average_salary DESC;

-- Birth column 

alter table employee_salary_data
add column current_age int;

UPDATE employee_salary_data 
SET 
    current_age = 2000 - birth_year;

-- Average salary by age

SELECT 
    current_age, AVG(salary) AS average_salary
FROM
    employee_salary_data
GROUP BY current_age
ORDER BY average_salary DESC;

-- Average salary by experience 

alter table employee_salary_data
add column current_experience int;
UPDATE employee_salary_data 
SET 
    current_experience = 2000 - hiring_year;

SELECT 
    *
FROM
    employee_salary_data;

SELECT 
    current_experience, AVG(salary) AS average_salary
FROM
    employee_salary_data
GROUP BY current_experience
ORDER BY average_salary DESC;
-- The trend is certain , As experience increases the average salary increases as well.

-- Incorporating department table

-- Department with highest average salary 

create table department_salary_data as
SELECT 
    a.dept_no, b.*, c.dept_name
FROM
    dept_emp AS a
        INNER JOIN
    employee_salary_data AS b ON a.emp_no = b.emp_no
        JOIN
    departments AS c ON a.dept_no = c.dept_no;

  SELECT 
    dept_no, dept_name, AVG(salary) as average_salary
FROM
    department_salary_data
GROUP BY dept_no , dept_name order by average_salary desc;


-- Sales department has the highest average salary of $80,776 followed by Marketing , Finance... and department with lowest average salary is Human resources

SELECT 
    *
FROM
    department_salary_data;

-- Average age of employees in different department

SELECT 
    dept_name, dept_no, AVG(current_age) AS average_age
FROM
    department_salary_data
GROUP BY dept_name , dept_no;

-- Surprisingly all departments have around average age of 40-41 years 

-- Average experience 

SELECT 
    dept_name, dept_no, AVG(current_experience) AS average_experience
FROM
    department_salary_data
GROUP BY dept_name , dept_no;

-- Most employees have average experience of 11 years

-- Departments with number of Male and Females in them

SELECT 
    dept_name,
    SUM(CASE
        WHEN gender = 'M' THEN 1
        ELSE 0
    END) AS male_count,
    SUM(CASE
        WHEN gender = 'F' THEN 1
        ELSE 0
    END) AS female_count,
    COUNT(*) AS total_count,
    ROUND(SUM(CASE
                WHEN gender = 'M' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,
            2) AS male_proportion,
    ROUND(SUM(CASE
                WHEN gender = 'F' THEN 1
                ELSE 0
            END) / COUNT(*) * 100,
            2) AS female_proportion
FROM
    department_salary_data
GROUP BY dept_name;

-- Incorporating manager data
-- Highest paid manager by gender

select gender, avg(salary) from manager_data group by gender;

-- In managers Male are paid $10,000 more on average compared to Female managers

-- Which department's managers are paid most 

SELECT 
    d.dept_name, AVG(md.salary) AS average_manager_salary
FROM
    departments d
        INNER JOIN
    manager_data md ON md.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY average_manager_salary DESC;
-- Managers in marketing department are paid the most ($88,371) on average and customer service managers are paid the least on average ($54,959)

CREATE TABLE titles_data AS SELECT es.emp_no,
    es.first_name,
    es.last_name,
    es.gender,
    es.hiring_year,
    es.birth_year,
    sd.salary,
    t.title FROM
    employees_staging_data es
        INNER JOIN
    salaries_staging_data sd ON es.emp_no = sd.emp_no
        INNER JOIN
    titles t ON t.emp_no = es.emp_no;
    
WITH avg_salaries AS (
    SELECT 
        title, 
        AVG(salary) AS average_salary
    FROM 
        titles_data
    GROUP BY 
        title
)
SELECT 
    title, 
    average_salary
FROM avg_salaries
group by title order by average_salary desc; 
-- Senior staff on average makes $70,398 whereas Technique leader makes the least at $59,138


-- Standardizing and Checking for outliers in salaries using z-score

SELECT 
    *
FROM
    department_salary_data;

SELECT 
    AVG(salary) AS average_salary, STD(salary) AS stdev_salary
FROM
    department_salary_data;

WITH stats AS (
    SELECT 
        AVG(salary) AS average_salary,
        STD(salary) AS stdev_salary
    FROM 
        department_salary_data
),
salary_data_with_stats AS (
    SELECT 
        dsd.*,
        s.average_salary,
        s.stdev_salary
    FROM 
        department_salary_data dsd,
        stats s
)
SELECT 
    emp_no,
    dept_no,
    salary,
    (salary - average_salary) / stdev_salary AS z_score
FROM
    salary_data_with_stats
WHERE
    dept_no = 'd007'
HAVING z_score > 3 OR z_score < - 3;
-- We have around 7044 outliers in the salaries
-- Where 5288 or 75% of the outliers is in department 7 which is sales


-- End of the Project --