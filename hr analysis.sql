-- CLEANING
SELECT term_date 
FROM hremployee;

-- add age column
ALTER Table hremployee
ADD COLUMN age integer;

-- calculate the age
UPDATE hremployee
SET age = EXTRACT(YEAR FROM age(birthdate));

-- check minimum and max age
SELECT
	MIN(age) as youngest,
	MAX(age) as oldest
FROM hremployee;


--ANALYSIS
--1. What is the employee count by gender?
SELECT gender, COUNT(*) as Count
FROM hremployee
WHERE age >= 18 AND term_date ISNULL
GROUP BY gender;

--2. What is the employee count by race?
SELECT race, COUNT(*) as Count
FROM hremployee
WHERE age >= 18 AND term_date ISNULL
GROUP BY race
ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company?
SELECT 
	min(age) as youngest,
	max(age) as oldest
FROM hremployee
WHERE age >= 18 AND term_date ISNULL;

SELECT 
    CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        ELSE '54+'
    END AS age_group,
    count(*) AS count
FROM hremployee
WHERE age >= 18 AND term_date IS NULL
GROUP BY age_group
ORDER BY age_group;

SELECT 
    CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        ELSE '54+'
    END AS age_group,gender,
    count(*) AS count
FROM hremployee
WHERE age >= 18 AND term_date IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;


-- 4. What is the employee count by location?
SELECT location, count(*) as count
FROM hremployee
WHERE age >= 18 AND term_date ISNULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
    round(avg(EXTRACT(YEAR FROM AGE(term_date, hire_date))::numeric), 0) as avg_employment_length
FROM hremployee
WHERE term_date IS NOT NULL AND age >= 18;

-- 6. What is the gender distribution by department and job titles?
SELECT department, gender, COUNT(*)
FROM hremployee
WHERE age >= 18 AND term_date ISNULL
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS count
FROM hremployee
WHERE age >= 18 AND term_date ISNULL
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?
SELECT department, 
       total_count,
       terminated_count,
       (terminated_count::numeric / total_count) AS termination_rate
FROM (
    SELECT department,
           count(*) AS total_count,
           SUM(CASE WHEN term_date IS NOT NULL THEN 1 ELSE 0 END) AS terminated_count
    FROM hremployee
    WHERE age >= 18 
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS Count
FROM hremployee
WHERE age >= 18 AND term_date ISNULL
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the employee's cout changed over time based on hire and term dates?
SELECT 
    extract(YEAR FROM hire_date) AS year,
    hires,
    terminations,
    hires - terminations AS net_change,
    round((hires - terminations) / hires * 100, 2) AS net_change_percent
FROM (
    SELECT 
        extract(YEAR FROM hire_date) AS year,
        count(*) AS hires,
        SUM(CASE WHEN term_date IS NOT NULL AND term_date <= current_date THEN 1 ELSE 0 END) AS terminations
    FROM hremployee
    WHERE age >= 18
    GROUP BY extract(YEAR FROM hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT 
    department, 
    round(avg(EXTRACT(YEAR FROM AGE(term_date, hire_date))), 0) as avg_employment_length
FROM hremployee
WHERE age >= 18 AND term_date IS NOT NULL
GROUP BY department
ORDER BY avg_employment_length DESC;















		








