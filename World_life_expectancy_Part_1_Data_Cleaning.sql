
-- Step-0 We uploaded the table as well as a backup copy
-- Table Data is now loaded into SQL and queried as follows :

SELECT * FROM world_life_expectancy.world_life_expectancy;


-- Step 1 - Identifying Duplicates
-- Concept : we combine both country and year to get "Unique" rows and then we remove any duplicates that we find 
-- Methodology : We use CONCAT to combine "Country" and "Year", as well as COUNT to identify the duplicates

SELECT Country, Year, CONCAT(Country,Year) , COUNT(CONCAT(Country,Year)) 
FROM world_life_expectancy
GROUP BY Country, Year , CONCAT(Country,Year)
HAVING COUNT(CONCAT(Country,Year)) > 1
;

-- Step 2 - Removing duplicates from the table
-- We identified 3  Entries from the table ( 3 Countries at different years) to be removed:
-- Ireland in 2022, Senegal in 2009 , and Zimbabwe in 2019
-- Metholody : identify duplicates the "Row_ID" column by filtering on a  ROW_NUMBER Function in a subquery
-- Followed by deleting the identified corresponding "ROW ID" entries from the table   

SELECT *
FROM 
      (
	  SELECT Row_ID,
	  CONCAT(Country,Year),
      ROW_NUMBER() OVER (PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS row_num 
      FROM world_life_expectancy
      ) AS row_table 
WHERE row_num >1 ;

DELETE FROM world_life_expectancy
WHERE 
		Row_ID IN
      (
	  SELECT Row_ID
      FROM(
			SELECT Row_ID,
	       CONCAT(Country,Year),
            ROW_NUMBER() OVER (PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) AS row_num 
           FROM world_life_expectancy
           ) AS row_table 
      WHERE row_num >1 
      ) ;

-- Step 3 - Updating blank rows in the "Status" column
-- Status is either "Developing" or "Developed" 
-- Methodology : use a "Self Join" clause to update "Status" column as follows :

-- Updating Developing Countries 

UPDATE world_life_expectancy t1
JOIN  world_life_expectancy t2
	ON t1.Country =t2.Country 
SET t1.Status = 'Developing'
WHERE t1.Status =''
AND t2.Status <> ''
AND t2.Status ='Developing'
;

-- Updating Developed Countries 
UPDATE world_life_expectancy t1
JOIN  world_life_expectancy t2
	ON t1.Country =t2.Country 
SET t1.Status = 'Developed'
WHERE t1.Status =''
AND t2.Status <> ''
AND t2.Status ='Developed'
;

-- We confirm the above changes by running the following query :

SELECT * FROM world_life_expectancy.world_life_expectancy
WHERE STATUS IS  NULL  ;

-- Step 4- Filling missing numerical values for "Life Expectancy" using averages from rows above and below 
-- Methodology : UPDATE table  an Using "Self-Join" of our original table (t1) to t2 ( with rows above) and to t3 ( rows below)
-- Then we calculate the average values from tables t2 and t3 to fill the blank t1 original table as follows :


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country 
    AND t1.Year = t3.Year +1
SET t1.`Life expectancy` = ROUND(( t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` =''
;

-- To Confirm the above changes we use the following query
-- We should get a an empty table as all blank values are filled

SELECT * FROM world_life_expectancy.world_life_expectancy
WHERE `Life expectancy` = ''
;