

SELECT location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 AS Death_percentage 
FROM [PortfolioProject].[dbo].['Covid deaths]
WHERE location like '%China%'
ORDER BY 1,2


SELECT location, date,total_cases, population, (total_cases/population)*100 AS Contraction_percentage 
FROM [PortfolioProject].[dbo].['Covid deaths]
ORDER BY 1,2


SELECT location,population, MAX(total_cases) AS Highest_infection_count, MAX(total_cases/population)*100 AS Highest_Contraction_percentage 
FROM [PortfolioProject].[dbo].['Covid deaths]
GROUP BY location, population
ORDER BY Highest_Contraction_percentage DESC

--determning which country had the highest number of deaths as compared with her population 
SELECT location,population, MAX(total_deaths) AS Highest_death_count, MAX(total_deaths/population)*100 AS Highest_Contraction_percentage 
FROM [PortfolioProject].[dbo].['Covid deaths]
WHERE continent is not null
GROUP BY location, population
ORDER BY Highest_Contraction_percentage DESC


--determning which country had the highest number of deaths due to covid-19
SELECT location, MAX(total_deaths) AS Highest_death_count 
FROM [PortfolioProject].[dbo].['Covid deaths]
WHERE continent is not null
GROUP BY location
ORDER BY Highest_death_count DESC 


--determning which continent had the highest number of covid-19 cases
SELECT location, MAX(total_cases) AS Highest_infection_count 
FROM [PortfolioProject].[dbo].['Covid deaths]
WHERE continent is null
AND location not like '%income'
GROUP BY location
ORDER BY Highest_infection_count DESC


SELECT SUM(new_cases) AS [TOTAL INFECTED PERSONS], SUM(CAST (new_deaths AS int)) AS [ TOTAL DEATH COUNT ], (SUM(CAST (new_deaths AS int))/SUM(new_cases))*100 AS Percentage_death
FROM [PortfolioProject].[dbo].['Covid deaths]
WHERE continent is not null


SELECT dea.continent, dea.location, dea.date, dea.population, vacc.new_vaccinations
FROM [PortfolioProject].[dbo].['Covid deaths] dea 
JOIN [PortfolioProject].[dbo].[Covidvaccinations] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.continent is not null
ORDER BY dea.location


WITH Populationvaccinated ( continent, population, date, new_vaccinations, rolling_people_vaccinated)
AS
( SELECT dea.continent, dea.population, dea.date, vacc.new_vaccinations,
SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated

FROM [PortfolioProject].[dbo].['Covid deaths] dea 
JOIN [PortfolioProject].[dbo].[Covidvaccinations] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.continent is not null
)

SELECT *
FROM Populationvaccinated


CREATE VIEW Populationvaccinated AS 
SELECT dea.continent, dea.population, dea.date, vacc.new_vaccinations,
SUM(CONVERT(bigint, vacc.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated

FROM [PortfolioProject].[dbo].['Covid deaths] dea 
JOIN [PortfolioProject].[dbo].[Covidvaccinations] vacc
	ON dea.location = vacc.location
	AND dea.date = vacc.date
WHERE dea.continent is not null


CREATE VIEW HighestContractionPercentage AS 
SELECT location,population, MAX(total_cases) AS Highest_infection_count, MAX(total_cases/population)*100 AS Highest_Contraction_percentage 
FROM [PortfolioProject].[dbo].['Covid deaths]
GROUP BY location, population
