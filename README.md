# SQL Data Cleaning Project: Layoffs Dataset:

## Project Overview:
This project involves cleaning a dataset on company layoffs using SQL. The dataset contains various fields such as company name, location, industry, and layoff statistics. The goal is to prepare the data for analysis by removing duplicates, standardizing data, handling null values, and optimizing the schema.

## Dataset Description
- **Name:** layoffs.csv
  
## Columns:
  - **company:** Name of the company.
  - **location:** Geographic location.
  - **industry:** Industry type.
  - **total_laid_off:** Number of employees laid off.
  - **percentage_laid_off:** Percentage of the workforce laid off.
  - **date:** Date of the layoff.
  - **stage:** Stage of the company (e.g., startup, growth).
  - **country:** Country of the company.
  - **funds_raised_millions:** Amount of funds raised in millions.

## 1. Remove Duplicates
- Created a duplicate table `(layoffs_duplicate)` to avoid modifying the original data.
- Used the `ROW_NUMBER()` function to identify and remove duplicate records.
- Created another table `(layoffs_duplicate2)` for managing duplicates.
- Finalized the cleaned dataset by deleting duplicate rows.
  
## Key SQL Commands:

WITH RemoveDuplicate AS (
    SELECT *, ROW_NUMBER() OVER (
    
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        
    ) AS ROW_NUM
    
    FROM layoffs_duplicate
    
)
SELECT * FROM RemoveDuplicate WHERE ROW_NUM > 1;


