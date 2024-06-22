-- Data Cleaning and Exploration (Employees table)



-- Creating a staging area to avoid alteration in Masterdata (Employee)


CREATE TABLE employees_staging_data LIKE employees;
INSERT INTO employees_staging_data 
SELECT * 
FROM employees;

select * from employees_staging_data;

select count(*) from employees_staging_data;
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
select * from employees_staging_data
where first_name = 'Sampalli'; 

select * from employees_staging_data;

-- Verification

select distinct first_name , last_name from employees_staging_data;

-- Now 279408 rows have been returned but we had 300024 rows in the data

select COUNT(*) - COUNT(distinct first_name, last_name) as duplicate_count
from employees_staging_data;

-- Meaning 20616 are duplicated names, Let's verify with primary key

select distinct emp_no from employees_staging_data;

-- Proven we have no duplicates

-- Standardizing the data

select first_name , Trim(first_name)     -- taking white space off (If any)
from employees_staging_data;

select first_name , Trim(last_name)     -- taking white space off (If any)
from employees_staging_data;

select * from employees_staging_data;

-- Checking for Null values

select emp_no, birth_date, first_name, last_name, hire_date, gender
from employees_staging_data
where emp_no is null
   or birth_date is null
   or first_name is null
   or last_name is null
   or hire_date is null
   or gender is null; -- We have no null values

-- Formatting date into only Year for analysis


select * from employees_staging_data;

select birth_date, extract(year from birth_date)as birth_year
 from employees_staging_data;

alter table employees_staging_data
add column birth_year INT; -- Adding birth year in the staging data

update employees_staging_data
set birth_year = extract(year from birth_date);

select * from employees_staging_data;

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

select
    COUNT(case when gender = 'M' then 1 end) as Male_count,
    COUNT(case when gender = 'F' then 1 end) as Female_count
from employees_staging_data; 
-- The case statement is used to conditionally count occurrences based on the gender.
-- count function will count the occurrences of non-null values.
-- Count(case when gender = 'F' then 1 end) will count the rows where the condition is true.


-- Proportion of respective genders
select
    SUM(case when gender = 'M' then 1 else 0 end) / COUNT(*) * 100 as Male_proportion,
    SUM(case when gender = 'F' then 1 else 0 end) / COUNT(*) * 100 as Female_proportion
from employees_staging_data;
-- Male proportion = 59.98 %
-- Female proportion = 40.02% 


-- Finding age of the current age of the employees and average age of employees in the firm (2000 data)
select birth_year, 2000 - birth_year AS current_age
from employees_staging_data;

-- Average age of the employees i.e 42 years 
select avg(2000- birth_year) as average_age_of_employees from employees_staging_data;


-- How many years have been hiring going for
-- Finding year which hired the most people (Mode of hiring year)  

select distinct(hiring_year) from employees_staging_data order by hiring_year desc; -- For 15 years from 1985 to 2000

-- Year with most hiring -- 1986
select hiring_year from employees_staging_data
group by hiring_year order by COUNT(*) desc
limit 1; 

-- How many hires in particular year -- 36150 hires
select count(hiring_year) 
from employees_staging_data where hiring_year = '1986';

-- Average hiring every year -- 1990 hires
select avg(hiring_year) 
from employees_staging_data;

-- Number of hires in each year from 1985 to 2000
select hiring_year, COUNT(*) as count
from employees_staging_data group by hiring_year order by hiring_year; -- There is a negative decline in the hires 

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
select salary from salaries_staging_data;

select count(*) from salaries_staging_data; -- 967,330 records


select distinct(emp_no) from salaries_staging_data; -- 101,796 records

select distinct(emp_no) from employees_staging_data; -- 300,034 records


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

