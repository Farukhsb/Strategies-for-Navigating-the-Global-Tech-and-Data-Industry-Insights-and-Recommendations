# Strategies for Navigating the Global Tech and Data Industry Insights, Recommendations and Limitations

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
```
### Results
1. Geographical Distribution of Jobs:
United States Dominance: The United States stands out with the highest number of job roles mentioned, indicating its leading position in the tech and data industry.
European Presence: European countries like the UK, Germany, and Spain also have a notable presence, suggesting a strong tech and data market in Europe.
2. Job Roles and Seniority Levels:
Diverse Roles: A wide array of job roles, ranging from Data Scientists and Engineers to Machine Learning Managers and AI Researchers, points to a mature and diverse industry landscape.
Seniority: The data also provides a breakdown of roles by seniority levels (e.g., Executive, Senior, Mid-level, Entry-level), highlighting the organizational hierarchy and career progression opportunities within the industry.
3. Global Salary Trends:
Regional Disparities: The salary data reveals significant regional disparities, with countries like the United States, Canada, and Germany offering higher salary ranges compared to others.
Currency Valuation: The currency-wise compensation data underscores the impact of currency valuation and economic conditions on salary structures across different countries.
4. Economic Insights:
Emerging Markets: Countries like Brazil, Turkey, and India, with emerging markets, show lower median salary ranges, reflecting economic conditions, currency valuation, and market dynamics.
Currency Analysis: The detailed compensation data across various currencies offers insights into currency strength, economic stability, and market competitiveness in different regions.
5. Industry Trends and Roles Demand:
Demand for Data and ML Roles: The prevalence of roles like Data Scientists, Machine Learning Engineers, and AI Researchers indicates the growing demand for expertise in these areas, driven by advancements in technology and increasing reliance on data-driven decision-making across industries.
Strategic Roles: Positions like Head of Data, Director of Data Science, and Managing Director Data Science highlight the strategic importance of data leadership roles in organizations.

### Recommendations 
- Prioritize the U.S. Market: Focus on talent and business strategies in the U.S., given its dominance in the tech and data sector.

- Diversify Talent Management: Cater to a broad range of roles from Data Science to AI, emphasizing career progression and multidisciplinary skills.

- Optimize Global Salaries: Adjust salary structures considering regional disparities and currency valuations to remain competitive.

- Explore Emerging Markets Cautiously: Consider growth opportunities in emerging markets like Brazil, Turkey, and India, aligning with local economic conditions.

- Invest in Data Leadership: Prioritize hiring for strategic roles like Head of Data and Director of Data Science to drive organizational success.

- Continuous Talent Development: Offer ongoing training and development in areas like Data Science and Machine Learning to meet industry demands.
### Limitations 
- Data Specificity: The recommendation is based on the given data snapshot. It might not account for real-time changes, emerging trends, or nuances in the industry.

- One-size-fits-all: The recommendation is broad and may not cater to the unique needs and challenges of individual organizations or industries.

- External Factors: The recommendation does not account for external factors such as geopolitical events, regulatory changes, or technological breakthroughs that 
  could impact the tech and data industry.

- Implementation Challenges: Implementing the recommendation may require significant resources, expertise, and time, which could vary based on organizational 
  capabilities.

- Market Dynamics: The recommendation assumes a certain level of stability and predictability in the market, which may not always be the case.
