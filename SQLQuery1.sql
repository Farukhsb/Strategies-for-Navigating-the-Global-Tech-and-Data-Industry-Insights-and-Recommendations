-- Set the database context
USE Data1;

-- Display the initial table structure
SELECT * 
FROM [dbo].[jobs_in_data];

-- Modify table structure: Rename and drop columns
ALTER TABLE [dbo].[jobs_in_data] DROP COLUMN Company_size;
EXEC sp_rename 'dbo.jobs_in_data.companysize', 'company_size', 'COLUMN';

-- Data Validation: Records with NULL values in specific columns
SELECT *
FROM [dbo].[jobs_in_data]
WHERE 
    work_year IS NULL OR
    job_title IS NULL OR
    job_category IS NULL OR
    salary_currency IS NULL OR
    salary IS NULL OR
    salary_in_usd IS NULL OR
    employee_residence IS NULL OR
    experience_level IS NULL OR
    employment_type IS NULL OR
    work_setting IS NULL OR
    company_location IS NULL OR
    company_size IS NULL;

-- Descriptive Analysis: Count records by work_year and job_title
SELECT 
    work_year,
    job_title,
    COUNT(*) AS count_of_records
FROM 
    jobs_in_data
GROUP BY 
    work_year,
    job_title
ORDER BY 
    work_year;

-- Top 10 records by work_year, ordered by experience_level
WITH RankedJobs AS (
    SELECT 
        work_year,
        job_title,
        ROW_NUMBER() OVER (PARTITION BY work_year ORDER BY experience_level DESC) AS rn
    FROM 
        jobs_in_data
)

SELECT 
    work_year,
    job_title
FROM 
    RankedJobs
WHERE 
    rn <= 10
ORDER BY 
    work_year, 
    rn;

-- Top 5 company locations with highest employment counts
SELECT TOP 5
    company_location,
    COUNT(*) AS employment_count
FROM 
    jobs_in_data
GROUP BY 
    company_location
ORDER BY 
    employment_count DESC;

-- Top 5 company locations: Employment counts by work_year
WITH TopCountries AS (
    SELECT TOP 5
        company_location,
        COUNT(*) AS employment_count
    FROM 
        jobs_in_data
    GROUP BY 
        company_location
    ORDER BY 
        employment_count DESC
)

SELECT 
    tc.company_location,
    jid.work_year,
    COUNT(*) AS job_count
FROM 
    TopCountries tc
JOIN 
    jobs_in_data jid ON tc.company_location = jid.company_location
GROUP BY 
    tc.company_location,
    jid.work_year
ORDER BY 
    tc.company_location,
    jid.work_year;

-- Distribution of Experience Levels
SELECT 
    experience_level,
    COUNT(experience_level) AS experience
FROM 
    jobs_in_data
GROUP BY 
    experience_level
ORDER BY 
    experience DESC;

-- Salary Analysis: Distribution by Job Titles
SELECT 
    job_title,
    AVG(salary) AS average_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM 
    jobs_in_data
GROUP BY 
    job_title
ORDER BY 
    average_salary DESC;

-- Salary Analysis: Distribution by Experience Levels
SELECT 
    experience_level,
    AVG(salary) AS average_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM 
    jobs_in_data
GROUP BY 
    experience_level
ORDER BY 
    average_salary DESC;

-- Salary Analysis: Distribution by Company Locations
SELECT 
    company_location,
    AVG(salary) AS average_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM 
    jobs_in_data
GROUP BY 
    company_location
ORDER BY 
    average_salary DESC;

-- Salary Currency Analysis: Distribution and Conversion to USD
SELECT 
    salary_currency,
    COUNT(*) AS number_of_jobs,
    AVG(salary_in_usd) AS average_salary_in_usd,
    MIN(salary_in_usd) AS min_salary_in_usd,
    MAX(salary_in_usd) AS max_salary_in_usd
FROM 
    jobs_in_data
WHERE 
    salary_in_usd IS NOT NULL
GROUP BY 
    salary_currency
ORDER BY 
    average_salary_in_usd DESC;
