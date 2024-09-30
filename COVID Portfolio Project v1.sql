-- Portfolio Project Data Exploration  --
--- Covid CovidDeaths and CovidVaccination --- 


--- cheacking data for covidVaccination---
SELECT 
	* from SQLPortfolioProject..CovidVaccination 
order by 3,4



--- cheacking data for CovidDeaths---
SELECT 
	* from SQLPortfolioProject..CovidDeaths
order by 3,4


--Selection of Attributes that will be important--
SELECT location ,date ,total_cases , total_deaths,population
	  from SQLPortfolioProject..CovidDeaths
	  order by 1,2


--Data Exploration--
---Looking At Total Cases vs Total Deaths--
---What is the percentage of people who passed away who had the virus around the wolrd --

SELECT 
    location,date,total_cases,total_deaths,
    (CAST(total_deaths AS FLOAT) / total_cases) * 100 AS DeathPercentage
FROM 
    SQLPortfolioProject..CovidDeaths

ORDER BY 
    location, date;

---- What is the Death percentile in a given country (Ethiopia)---

select 
	location,date,total_cases,total_deaths,
	(CAST(total_deaths AS float) / total_cases)*100  AS DeathPercentage
From 
	SQLPortfolioProject..CovidDeaths
	where location like '%Ethiopia%'
Order  By
	location,date;


---Looking at Total Cases vs population (INFECTIONRATE)---

SELECT 
    location,date,population, total_cases,

    (CAST(total_cases AS FLOAT) /CAST(population AS FLOAT) ) * 100 AS INFECTIONRATE
FROM 
    SQLPortfolioProject..CovidDeaths
	 
ORDER BY
	location,date;

-- Calculating the Infection Rate as a Percentage of the Population for Ethiopia --

SELECT 
    location, 
    date, 
    population, 
    total_cases,
    (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS InfectionRate
FROM 
    SQLPortfolioProject..CovidDeaths
WHERE 
    location LIKE '%Ethiopia%' 
    AND population > 0 -- To avoid division by zero errors
ORDER BY 
    location, date ASC;


-- Finding Countries with the Highest Infection Rate Compared to Population --

SELECT
    location, 
    population,
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    (MAX(CAST(total_cases AS FLOAT)) / CAST(population AS FLOAT)) * 100 AS InfectionRate
FROM 
    SQLPortfolioProject..CovidDeaths
WHERE population > 0 -- To avoid division by zero errors
GROUP BY 
    location, 
    population
ORDER BY 
    InfectionRate DESC;

-- Showing Countries with Highest Death Count per population 
SELECT 
    location, 

    MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount,
    (MAX(CAST(total_deaths AS FLOAT)) / MAX(CAST(population AS FLOAT))) * 100 AS Death_Rate
FROM 
    SQLPortfolioProject..CovidDeaths
WHERE 
    population > 0 
    AND total_deaths > 0  -- To avoid division by zero
    AND continent IS NOT NULL
GROUP BY 
    location
ORDER BY 
    TotalDeathCount DESC;


-- Breaking Things Down by Continent: Total Deaths and Death Rate --
---showing contintents with the highest death count per populaion ---

SELECT  
	location ,  
MAX(CAST(total_deaths AS int)) AS TotalDeathCount,
MAX(CAST(total_deaths AS FLOAT)) / MAX(CAST(population AS FLOAT)) * 100 AS Death_Rate
FROM SQLPortfolioProject..CovidDeaths
where 
	continent is null
	AND
    population > 0 
    AND 
	total_deaths > 0  -- To avoid division by zero

GROUP BY 
    location
order by 
	TotalDeathCount desc

--GLOBAL NUMBERS --
select 
	date ,sum(new_cases) as Total_Cases,
	sum(cast(new_deaths as float)) as Total_Deaths ,
	sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercentage
From 
	SQLPortfolioProject..CovidDeaths
	 Where
	 continent is not null
GROUP BY date
Order  By
	1,2

--Global Cases ,Death and DeathPercentage

select 
	 sum(new_cases) as GlobalTotal_Cases,
	sum(cast(new_deaths as float)) as GlobalTotal_Deaths ,
	sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as GlobalDeathPercentage
From 
	SQLPortfolioProject..CovidDeaths
	 Where
	 continent is not null
 
Order  By
	1,2

-- Looking at Total Population vs Vaccination ---
--- What percentage of the population is vaccinated --

Select  
	dea.continent ,
	dea.location, 
	dea.date ,
	dea.population,
	vac.new_vaccinations,
	SUM (CONVERT (int ,vac.new_vaccinations)) OVER (PARTITION by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated

FROM SQLPortfolioProject..CovidDeaths dea

JOIN ---JOINING THE TWO TABLES --

SQLPortfolioProject..CovidVaccination vac
	on dea.location =vac.location
	and dea.date =vac.date
	 Where
	 dea.continent is not null 

ORDER BY 1,2,3


--USING CTE FOR CALCULATION

with popVSvac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) as (

Select  
	dea.continent ,
	dea.location, 
	dea.date ,
	dea.population,
	vac.new_vaccinations,
	SUM (CONVERT (int ,vac.new_vaccinations)) OVER (PARTITION by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated

FROM SQLPortfolioProject..CovidDeaths dea

JOIN ---JOINING THE TWO TABLES --

SQLPortfolioProject..CovidVaccination vac
	on dea.location =vac.location
	and dea.date =vac.date
	 Where
	 dea.continent is not null 
	 
)
Select *,(RollingPeopleVaccinated/CAST(population AS FLOAT))*100 as VaccinationRate
	FROM popVSvac


--CREATEING VIEW FOR VIZULAIZATION 

create view PercentagePopulationVaccinated as 
Select  
	dea.continent ,
	dea.location, 
	dea.date ,
	dea.population,
	vac.new_vaccinations,
	SUM (CONVERT (int ,vac.new_vaccinations)) OVER (PARTITION by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated

FROM SQLPortfolioProject..CovidDeaths dea

JOIN ---JOINING THE TWO TABLES --

SQLPortfolioProject..CovidVaccination vac
	on dea.location =vac.location
	and dea.date =vac.date
	 Where
	 dea.continent is not null 

SELECT *
  FROM [SQLPortfolioProject].[dbo].[PercentagePopulationVaccinated]
