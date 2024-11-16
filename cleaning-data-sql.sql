-- DATA CLEANING PROJECT

-- REMOVE DEPLICATES
-- STANDARDIZE THE DATA
-- NULL VALUES OR BLANK VALUES
-- REMOVE ANY COLUMNS

-- DUPLICATE SCHEMA FROM LAYOFF'S TABLE
CREATE TABLE layoffs_duplicate
LIKE layoffs;

-- DUPLICATE DATA FROM LAYOFF'S TABLE
INSERT INTO layoffs_duplicate
SELECT * FROM layoffs;

-- REMOVE DUPLICATED DATA
WITH RemoveDuplicate AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location , industry ,total_laid_off, percentage_laid_off, `date` , stage , country , funds_raised_millions
) AS ROW_NUM
FROM layoffs_duplicate
)
SELECT * FROM RemoveDuplicate
WHERE ROW_NUM > 1;

-- create another table to delete duplicated data
CREATE TABLE layoffs_duplicate2
LIKE layoffs_duplicate;

-- add column
ALTER TABLE layoffs_duplicate2
ADD COLUMN ROW_NUM INT;

INSERT INTO layoffs_duplicate2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location , industry ,total_laid_off, percentage_laid_off, `date` , stage , country , funds_raised_millions
) AS ROW_NUM
FROM layoffs_duplicate;

-- finally remove duplicated data
DELETE FROM layoffs_duplicate2
WHERE ROW_NUM > 1;

SELECT * FROM layoffs_duplicate2;

-- STANDARDIZE THE DATA

-- (1) REMOVING EXTRA SPACES
UPDATE layoffs_duplicate2
SET 
	company = TRIM(company),
	location = TRIM(location),
	industry = TRIM(industry),
	total_laid_off = TRIM(total_laid_off),
	percentage_laid_off = TRIM(percentage_laid_off),
	date = TRIM(date),
	stage = TRIM(stage),
	country = TRIM(country),
	funds_raised_millions = TRIM(funds_raised_millions);

-- (2) NAMING CONVERSIONS SUPER COMMAN LIKE CRYPTO CURRENCY TO CRYPTO
SELECT DISTINCT(company)
FROM layoffs_duplicate2
ORDER BY 1;

SELECT DISTINCT(location)
FROM layoffs_duplicate2
ORDER BY 1;

SELECT DISTINCT(industry)
FROM layoffs_duplicate2
ORDER BY 1;

UPDATE layoffs_duplicate2
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

SELECT DISTINCT(total_laid_off)
FROM layoffs_duplicate2
ORDER BY 1;

SELECT DISTINCT(percentage_laid_off)
FROM layoffs_duplicate2
ORDER BY 1;

SELECT DISTINCT(date)
FROM layoffs_duplicate2
ORDER BY 1;

SELECT DISTINCT(stage)
FROM layoffs_duplicate2
ORDER BY 1;

SELECT DISTINCT(country)
FROM layoffs_duplicate2
ORDER BY 1;

UPDATE layoffs_duplicate2
SET country = "United States"
WHERE country LIKE "United States%";

SELECT DISTINCT(funds_raised_millions)
FROM layoffs_duplicate2
ORDER BY 1;


-- (3) CHANGED TEXT TO DATE DATA TYPE 
SELECT `date` , str_to_date(`date` , '%m/%d/%Y')
FROM layoffs_duplicate2;

UPDATE layoffs_duplicate2
SET `date` = str_to_date(`date` , '%m/%d/%Y');

ALTER TABLE layoffs_duplicate2
MODIFY COLUMN `date` DATE;

-- -- NULL VALUES OR BLANK VALUES
UPDATE layoffs_duplicate2
SET industry = NULL
WHERE industry = '';

SELECT t1.industry , t2.industry
FROM layoffs_duplicate2 t1
JOIN layoffs_duplicate2 t2
ON t1.company = t2.company AND
   t1.location = t2.location 
WHERE t1.industry IS NULL AND
	  t2.industry IS NOT NULL;
      
UPDATE layoffs_duplicate2 t1
JOIN layoffs_duplicate2 t2
ON t1.company = t2.company AND
   t1.location = t2.location 
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND
	  t2.industry IS NOT NULL;
      
SELECT *
FROM layoffs_duplicate2;
-- REMOVE ANY COLUMNS
DELETE FROM
layoffs_duplicate2
WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL;

ALTER TABLE layoffs_duplicate2
DROP COLUMN ROW_NUM;


SELECT * FROM layoffs_duplicate2;




