-- Data Cleaning 
-- show imported data
SELECT *
FROM world_layoffs.layoffs;


-- make a copy of our data / insert layoffs staging
CREATE TABLE world_layoffs.layoff_staging
LIKE world_layoffs.layoffs;
-- insert layoffs staging
INSERT layoff_staging
SELECT * FROM world_layoffs.layoffs;


-- 1. Remove Duplicates
-- create row_number columns to know duplicates 
SELECT company, location, industry, total_laid_off, date, ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, date) 
FROM world_layoffs.layoff_staging;

SELECT *
FROM (
		SELECT company, 
				location,
                industry,
                total_laid_off,
                date,
                ROW_NUMBER() OVER (
					PARTITION BY company, location, industry, total_laid_off, date)
                    as row_num
		FROM world_layoffs.layoff_staging 
) as duplicates
WHERE row_num > 1;

-- checking duplicates in rows
SELECT *
FROM  (
SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country,
 funds_raised_millions, ROW_NUMBER() OVER (
 PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
 ) As Row_name
 FROM world_layoffs.layoff_staging
 ) duplicates
 WHERE
		Row_name >1;

-- so now we get the values we want to delete Row_name>1
WITH DELETE_CTE AS
(
SELECT *
FROM ( SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
,ROW_NUMBER() OVER ( PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) AS Row_name
FROM World_layoffs.layoff_staging
) dyplicates
WHERE Row_name>1
)
DELETE 
FROM DELETE_CTE
;
-- Error Code: The target table DELETE_CTE of the DELETE is not updatable
ALTER TABLE world_layoffs.layoff_staging ADD Row_name int;
SELECT *
FROM world_layoffs.layoff_staging
;
CREATE TABLE `world_layoffs`.`layoff_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_num INT
);

INSERT INTO `world_layoffs`.`layoff_staging2`
( `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
row_num)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
				ROW_NUMBER() OVER (
                PARTITION BY `company`,`location`,`industry`,`total_laid_off`,`percentage_laid_off`,`date`,`stage`,`country`,`funds_raised_millions`
                          ) AS Row_name
FROM world_layoffs.layoff_staging;
;
DELETE FROM world_layoffs.layoff_staging2
WHERE Row_name >=2;


-- 2. Standarize Data
SELECT *
FROM world_layoffs.layoff_staging2;

-- Fetch distinct industries

SELECT DISTINCT industry
FROM world_layoffs.layoff_staging2
ORDER BY industry;
-- #there are null values, crypto currency/crypto
SELECT *
FROM world_layoffs.layoff_staging2
WHERE industry IS NULL
OR industry = ""
ORDER BY industry;

SELECT *
FROM world_layoffs.layoff_staging2
ORDER BY company;

SELECT *
FROM world_layoffs.layoff_staging2
WHERE company LIKE "Bally%";

SELECT *
FROM world_layoffs.layoff_staging2
WHERE company LIKE "airbnb%";


--- CONVERT ALL "" TO NULL
UPDATE  world_layoffs.layoff_staging2
SET industry = NULL
WHERE industry = '';

SELECT * 
FROM world_layoffs.layoff_staging2
WHERE industry IS NULL
OR industry =''
ORDER BY industry;

-- populate industry column to null
UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
ON t1.company =t2.company
SET t1.industry= t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


SELECT * 
FROM world_layoffs.layoff_staging2
WHERE industry IS NULL
OR industry =''
ORDER BY industry;
-- Unify Values
SELECT DISTINCT industry
FROM world_layoffs.layoff_staging2
ORDER BY industry;
-- Note that crypto is represented by three expressions Crypto,Crypto Currency, CryptoCurrency
UPDATE layoff_staging2
SET industry="Crypto"
WHERE Industry IN ("Crypto Currency", "CryptoCurrency");

SELECT *
FROM world_layoffs.layoff_staging2
ORDER BY industry;

SELECT DISTINCT country
FROM world_layoffs.layoff_staging2
ORDER BY country;

-- United state has two version inited state, united state.
UPDATE layoff_staging2
SET country = TRIM(TRAILING "." FROM country);
-- FIXED !

SELECT date
From world_layoffs.layoff_staging2;
-- type of date is text "string" !
UPDATE world_layoffs.layoff_staging2
SET date =STR_TO_DATE (date, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoff_staging2
MODIFY COLUMN date Date;

--- NULL VALUES
SELECT *
FROM world_layoffs.layoff_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL
;
DELETE FROM world_layoffs.layoff_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL
;
ALTER TABLE layoff_staging2
DROP COLUMN row_num;
;
SELECT *
FROM world_layoffs.layoff_staging2
order by country
;
--     END OF DATA CLEANING  --







