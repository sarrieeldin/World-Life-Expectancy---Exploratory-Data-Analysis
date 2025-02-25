
-- Step-1 Analyzing the Life Expectancy for different countries, 
-- And which countries had the best  Life expectancy improvement over the last 15 years
-- Methodology : Find maximum and minimum life expectancies, then find difference for each country (using group by)

SELECT Country,
MIN(`Life expectancy`) AS Highest_Life_expectancy,
MAX(`Life expectancy`) AS Lowest_Life_expectancy,
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_expectancy_Increase
FROM world_life_expectancy.world_life_expectancy
GROUP BY Country 
ORDER BY Country DESC
 ;

-- Results: We Observed that Haiti, Zimbabwe, Eritream, Uganda, and Rwanda had the highest life expectancy increase
-- We  also Observed that Guyana, Seychelles, Kuwait, Venezuela, and Philippines had the lowest life expectancy increase
-- Finally, we Observed countries with ZERO life expectancy recorded
-- This probably means that these countries had no data for life expectancy in this survey 

-- STEP 2 : Analyze life expectancy by Year to get more insight 

SELECT YEAR,
ROUND(AVG(`Life expectancy`),1) AS Average_Life_expectancy
FROM world_life_expectancy.world_life_expectancy
GROUP BY YEAR 
ORDER BY YEAR DESC
;

-- Results: We Observed that 2022, 2021, 2020,2019 and 2018 have the highest Average life Expectancy respectively
-- This means that ,on average, life expectancy worldwide , based on this data, is improving 
-- However, it's important to note that the improvement worldwide is only 4.8 years 


-- STEP 3 : Analyze correlation between  life expectancy by GDP 
-- We will exclude countries with Non-reported life expectancies and Non-reported GDP's to have a more uniform and clean data

SELECT Country,
ROUND(AVG(`Life expectancy`),1) AS Average_Life_expectancy,
ROUND(AVG(GDP),1) AS Average_GDP
FROM world_life_expectancy.world_life_expectancy
GROUP BY Country 
HAVING Average_Life_expectancy > 0 AND Average_GDP > 0
ORDER BY Average_Life_expectancy DESC
;

-- Results: We found out there is a good correlation between GDP & Average life expectancy
-- However, the correlation is much more prominent at the lowest GDP's . Higher GDP's doesn't impact life expectancy in a drastic manner
-- Low GDP Countries such as Sierra Leone, Central African Republic, Lesotho , Angola and Malawi have the lowest Life expectancy (< 50 years old )

-- STEP 3 : Further Analyze Life expectancy correlation to GDP by segmenting Countries into LOW GDP's & High GDP's 
-- Methodology : We use a case statement based on GDP cut off of 5000 for low GDP to be able to count the rows that contains both high and low GDP's 
-- We will also calculate average life expectancy for these GDP values (Also Using CASE statement)

SELECT 
       ROUND(SUM(CASE WHEN GDP >=5000  THEN 1 ELSE 0 END ),1) AS High_GDP_COUNTRIES,
       ROUND(AVG(CASE WHEN GDP >=5000  THEN `Life expectancy` ELSE NULL END ),1) AS High_GDP_LIFE_Expectancy,
       ROUND(SUM(CASE WHEN GDP <=5000  THEN 1 ELSE 0 END ),1) AS LOW_GDP_COUNTRIES,
       ROUND(AVG(CASE WHEN GDP <=5000  THEN `Life expectancy` ELSE NULL END ),1) AS Low_GDP_LIFE_Expectancy
FROM world_life_expectancy.world_life_expectancy
;       

-- Results: We Found 713 High-GDP Countries with an Average of 76.4 Years life expectancy
-- And 2225 Low-GDP Countries with an Average of 66.6 Years life expectancy

-- STEP 4  : We Explore the correlation between Life Expectancy & Country Status ( Developing or Developed) 
-- Methodology : We will Count get the average life expectancy while grouping by status
-- We will also count the  number of the developed countries compared to developing countries

SELECT Status,
ROUND(AVG(`Life expectancy`),1) AS Average_Life_expectancy,
COUNT(DISTINCT Country) AS Number_of_Countries
FROM world_life_expectancy
GROUP BY Status ;

-- Results:  We found 32  "Developed" Countries with an average Life Expectancy of 79.2 Years
-- We also found 162 "Developing" Countries with an average Life Expectancy of 66.8 Years
-- These results align with the GDP results found earlier 

-- STEP 5  : We Explain the correlation between Infant Deaths & GDP
-- Methodology : Calculate average infant deaths, average GDP and then group by Country
-- We include countries with GDP > 0 to ensure uniform & Consistent data 


SELECT Country,
ROUND(AVG(`infant deaths`),1) AS Average_Infant_death,
ROUND(AVG(GDP),1) AS Average_GDP
FROM world_life_expectancy.world_life_expectancy
GROUP BY Country 
HAVING  Average_GDP > 0
ORDER BY Average_GDP ASC
;

-- Results : There are inconsistencies in the correlation between Infant deaths & GDP 
-- A "Possible" High Correlation at the higher GDP; Lower Infant deaths for higher GDP Countries
-- However, results are inconsistent for lower GDP's . Some Countries seem to manage infant deaths to a low number despite having a very low GDP


-- STEP 6  : We analyze the number of deaths ( Total Adult mortality), how they increase every year 
-- As well as exploring the  relationship to  between Adult Mortality &  Life expectancy
-- Methodology : We will Comapre life expectancy to the rolling total of Adult Mortality ( using a window Function)
-- In the window function we will partition by country and order results by year to see cumulative yearly death added
-- We will filter out results with zero life expectancy as these countries seem to have no results recorded

SELECT Country, 
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER (PARTITION BY COUNTRY ORDER BY YEAR ) AS Rolling_total_mortality
FROM world_life_expectancy
WHERE `Life expectancy` > 0
;

-- Results : Higher Adult Mortality in the last 15 years occured between  2010-2012 with a consistent 700 and and above per year and a very low life expectancy  
-- Countries with very high life expectancy like Belgium have a medium-low Adult mortality