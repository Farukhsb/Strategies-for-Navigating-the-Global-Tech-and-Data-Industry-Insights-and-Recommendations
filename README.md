# Strategies for Navigating the Global Tech and Data Industry: Insights, Recommendations, and Limitations

## Table of Contents
- [Project Overview](#project-overview)
- [Data source](#data-source)
- [Programming Language](#programming-language)
- [Data Preparation](#data-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Results](#results)
- [Recommendations](#recommendations)
- [Limitations](#limitations)
    

### project overview
The project aims to analyze job-related data, examining job distributions, experience levels, salary trends, and regional variations. It aims to reveal patterns and insights within the dataset, benefiting stakeholders, decision-makers, and those interested in the represented job landscape.

### Data source
Jobs and Salaries in Data Science: the primary dataset used for this analysis is the jobs-in-data.csv from kaggle

### Programming Language
- SQL - Data Analysis [Download here](https://www.microsoft.com/en-GB/sql-server/sql-server-downloads)

### Data Preparation 
In the initial data preparation phase, i performed the following tasks
1. Data loading and inspection.
2. Data cleaning and formatting.

### Exploratory Data Analysis
- Which records have NULL values in specific columns?
- How many records exist for each job title in each year?
- What are the top 10 records by work year when sorted by experience level?
- Which 5 company locations have the highest employment counts?
- How do the employment counts in these top 5 locations vary by work year?
- How are roles distributed across different experience levels?
- What is the average, minimum, and maximum salary for each job title?
- What is the average, minimum, and maximum salary for each experience level?
- What is the average, minimum, and maximum salary for each company location?
- How are salaries distributed across different currencies when converted to USD, and what are the average, minimum, and maximum converted salary values?

  ### Data Analysis
```sql
 -- SQL Code for Data Analysis

-- Set the database context
USE Data1;

-- Display the initial table structure
SELECT * 
FROM jobs_in_data;

-- Modify table structure: Rename and drop columns
ALTER TABLE jobs_in_data DROP COLUMN Company_size;
EXEC sp_rename 'jobs_in_data.companysize', 'company_size', 'COLUMN';

-- Data Validation: Records with NULL values in specific columns
SELECT *
FROM jobs_in_data
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
```
### Results
1.	Geographical Distribution of Jobs
• The United States accounts for 86.9% of all roles, showing overwhelming global dominance.
• The UK, Germany, and Spain emerge as the strongest European contributors.
• Emerging markets like India, Turkey, and Brazil appear in smaller volumes but indicate growing participation.

2.	Job Roles and Seniority Levels
A wide distribution of roles Data Scientists, ML Engineers, Architects suggests a mature market. Seniority spans Executive to Entry-level, indicating career progression opportunities.

3.	Global Salary Trends
• Executive roles earn 114% more than entry-level positions ($189k vs $88k on average).
• Salary leadership remains concentrated in the US, Canada, and Germany.
• A structured pay hierarchy exists across experience levels.

4.	Economic Insights
• Compensation in emerging markets reflects substantial variance:
 – Brazil: $58.6k
 – India: $43.4k
 – Turkey: $22.3k
• These differences align with currency strength and economic conditions.

5.	Industry Trends and Role Demand
High demand is evident for Data Scientists and ML Engineers, reinforced by the presence of strategic leadership roles across organizations.

### Recommendations 
- Prioritize the U.S. Market
(Accounts for 86.9% of global roles)

- Optimize Global Salaries
(~8.5x difference between highest and lowest paying regions)

- Diversify Talent Management
Support multiple roles and progression levels across Data, ML, and AI.

- Explore Emerging Markets Cautiously
Benchmark against salary bands in India ($43k), Brazil ($58k), Turkey ($22k)

- Invest in Data Leadership
Executive roles attract 114% higher pay, signaling strategic value.

- Enable Continuous Talent Development
Prioritize upskilling in Data Science and Machine Learning.
### Limitations 
- Data Specificity: The recommendation is based on the given data snapshot. It might not account for real-time changes, emerging trends, or nuances in the industry.

- One-size-fits-all: The recommendation is broad and may not cater to the unique needs and challenges of individual organizations or industries.

- External Factors: The recommendation does not account for external factors such as geopolitical events, regulatory changes, or technological breakthroughs that 
  could impact the tech and data industry.

- Implementation Challenges: Implementing the recommendation may require significant resources, expertise, and time, which could vary based on organizational 
  capabilities.

- Market Dynamics: The recommendation assumes a certain level of stability and predictability in the market, which may not always be the case.
