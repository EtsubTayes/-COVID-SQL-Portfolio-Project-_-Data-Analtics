/*
Etsub Taye
Data Analyst
Project Title: The Impact of COVID-19  
*/


/*
1) Calculating Global Death Percentage
This query calculates the total number of COVID-19 cases and deaths globally and derives the death percentage. 
The data excludes entries without continent information. This output is used to visualize the overall global death rate.
*/

SELECT 
    SUM(cast(new_cases as float)) as total_cases,
    SUM(cast(new_deaths as float)) as total_deaths, 
    SUM(cast(new_deaths as float))/SUM(cast(new_cases as float))*100 as DeathPercentage
FROM   
    SQLPortfolioProject..CovidDeaths 
WHERE 
    continent IS NOT NULL 
ORDER BY 
    1, 2;


/*
2) Visualizing Death Counts by Location (Map Visualization)
This query retrieves the total number of deaths for each country/location where the continent is unknown (typically small regions or individual countries).
The results are visualized on a map to show which locations have the highest death counts.
*/

SELECT 
    location, SUM(cast(new_deaths as float)) AS TotalDeathCount
FROM 
    SQLPortfolioProject..CovidDeaths
WHERE 
    continent IS NULL
    AND location NOT IN ('World', 'European union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


/*
3) Calculating Percentage of Infected Population (Chart Visualization)
This query calculates the highest infection count and the percentage of the population infected for each location.
It visualizes the percentage of the population that was infected in each country/region, using a chart to compare infection rates.
*/

SELECT 
    location, 
    population, 
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM 
    SQLPortfolioProject..CovidDeaths
GROUP BY 
    location, population
ORDER BY 
    PercentPopulationInfected DESC;


/*
4) Infected Population Percentage by Location (For Data Review)
This query is similar to the previous one, but it excludes the global locations ('World', 'European Union', 'International') and focuses on data with unknown continents.
The result is not intended for visualization but is used for data review and exploration.
*/

SELECT 
    location, 
    population, 
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM 
    SQLPortfolioProject..CovidDeaths
WHERE 
    continent IS NULL
    AND location NOT IN ('World', 'European union', 'International')
GROUP BY 
    location, population
ORDER BY 
    PercentPopulationInfected DESC;


/*
5) Infection Percentage Over Time (Chart Visualization)
This query tracks the percentage of the population infected by COVID-19 over time for each location.
It visualizes how the infection rate has evolved across different regions and periods, using a chart to illustrate trends.
*/

SELECT 
    location,
    population,
    date,
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100) AS PercentPopulationInfected
FROM 
    SQLPortfolioProject..CovidDeaths
GROUP BY
    location, population, date
ORDER BY
    PercentPopulationInfected DESC;
