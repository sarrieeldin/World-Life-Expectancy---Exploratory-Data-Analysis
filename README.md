# World Life Expectancy Project

## Table of Contents
- [Introduction](#introduction)
- [Data Cleaning](#data-cleaning)
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
- [Summary of Key Findings](#summary-of-key-findings)
- [Recommendations for Future Data Collection](#recommendations-for-future-data-collection)

---

## Introduction
This project examines the **World Life Expectancy** dataset to identify trends in global health and their connections to economic factors. The dataset includes key variables such as life expectancy, GDP, infant deaths, adult mortality, and country status (developed or developing) across multiple years. The analysis unfolds in two main phases: **data cleaning** and **exploratory data analysis (EDA)**. The findings reveal significant health disparities influenced by economic development, laying the groundwork for practical recommendations to improve future data collection efforts.

---

## Data Cleaning
To prepare the dataset for reliable analysis, the following steps were implemented:

- **Removing Duplicates**:  
  - Duplicates were detected using a unique identifier ('Country' and 'Year' combination) and removed with the SQL `ROW_NUMBER()` function.  
  - Three duplicate records were eliminated: Ireland (2022), Senegal (2009), and Zimbabwe (2019).  

- **Handling Missing Values**:  
  - Missing "Status" values were imputed via a self-join, referencing known status data for the same country.  
  - Missing "Life Expectancy" values were filled by averaging the values from the previous and subsequent years for the same country.  

These actions ensured a clean, consistent dataset ready for exploration.

---

## Exploratory Data Analysis (EDA)
The EDA phase uncovered critical trends and relationships within the data:

- **Life Expectancy Improvements**:  
  - Countries such as Haiti, Zimbabwe, Eritrea, Uganda, and Rwanda demonstrated significant gains.  
  - Guyana, Seychelles, Kuwait, Venezuela, and the Philippines showed minimal progress.  

- **Life Expectancy by Year**:  
  - Global life expectancy rose by approximately 4.8 years, with a peak between 2018 and 2022.  

- **Correlation with GDP**:  
  - Countries with high GDP (GDP > 5000) averaged 76.4 years, compared to 66.6 years for low GDP countries.  
  - The correlation was more pronounced at lower GDP levels, with diminishing returns as GDP increased.  

- **Country Status Impact**:  
  - Developed countries (32) averaged 79.2 years, while developing countries (162) averaged 66.8 years.  

- **Infant Deaths and GDP**:  
  - Higher GDP typically aligned with lower infant mortality, though some low GDP countries also reported low infant deaths, suggesting additional influencing factors.  

- **Adult Mortality**:  
  - Peaks in adult mortality between 2010 and 2012 corresponded with lower life expectancies, while countries like Belgium, with high life expectancy, exhibited lower mortality rates.  

---

## Summary of Key Findings
- **Life Expectancy Insights**:  
  - Global life expectancy increased by ~4.8 years, peaking in 2018-2022.  
  - Haiti and Zimbabwe led improvements, while Guyana and Venezuela lagged.  

- **Economic Patterns**:  
  - High GDP countries averaged 76.4 years versus 66.6 years for low GDP countries.  
  - The link between GDP and infant mortality was inconsistent, hinting at other variables.  

- **Data Challenges**:  
  - Missing or zero life expectancy values and anomalies (e.g., adult mortality spikes in 2010-2012) indicate flaws in data collection processes.  

---

## Recommendations for Future Data Collection
To improve the quality and reliability of future datasets, I propose the following actionable steps:

1. **Set Clear Data Standards**:  
   - Standardize collection and reporting methods to reduce errors and enhance cross-country comparisons.  
2. **Train Data Collectors**:  
   - Offer regular training to ensure accurate and consistent data entry practices.  
3. **Use Tech Tools**:  
   - Implement digital tools with real-time error-checking features to validate data during collection.  
4. **Target Data Gaps**:  
   - Increase survey efforts in underrepresented regions to build a more comprehensive global dataset.  
5. **Check Data Regularly**:  
   - Conduct annual audits to identify and resolve inconsistencies promptly.  

---
