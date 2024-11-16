# SQL Data Cleaning Project: Layoffs Dataset:

## Project Overview:
This project involves cleaning a dataset on company layoffs using SQL. The dataset contains various fields such as company name, location, industry, and layoff statistics. The goal is to prepare the data for analysis by removing duplicates, standardizing data, handling null values, and optimizing the schema.

## Dataset Description
- **Name:** layoffs.csv
- **data set:** https://github.com/sufyan356/Data-Cleaning-SQL/blob/main/layoffs.csv
  
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

## 2. Standardize the Data
- Trimmed extra spaces from text fields such as company, location, and industry.
- Unified naming conventions (e.g., "Crypto Currency" changed to "Crypto").
- Converted text-based dates into SQL DATE format.

## Key SQL Commands:

UPDATE layoffs_duplicate2

SET industry = "Crypto" WHERE industry LIKE "Crypto%";

UPDATE layoffs_duplicate2

SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_duplicate2 MODIFY COLUMN `date` DATE;

## 3. Handle Null and Blank Values
- Replaced blank strings with NULL.
- Filled missing values in industry using data from matching records.
  
## Key SQL Commands:

UPDATE layoffs_duplicate2

SET industry = NULL WHERE industry = '';

UPDATE layoffs_duplicate2 t1

JOIN layoffs_duplicate2 t2

ON t1.company = t2.company AND t1.location = t2.location

SET t1.industry = t2.industry

WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

## 4. Remove Irrelevant Columns
- Removed unnecessary columns `(ROW_NUM)`.
- Deleted rows where critical columns `(percentage_laid_off and total_laid_off)` were null.
  
## Key SQL Commands:

ALTER TABLE layoffs_duplicate2 DROP COLUMN ROW_NUM;

DELETE FROM layoffs_duplicate2

WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL;

## Tools and Technologies
- Database: MySQL
- Language: SQL
- Dataset Format: CSV

## Outcomes
- Duplicate records removed, resulting in unique entries.
- Consistent and standardized text data across columns.
- All dates converted to a proper SQL DATE format.
- Missing values handled, improving data integrity.
- Columns cleaned up for optimized schema design.



