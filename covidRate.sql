SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..covidDeath
ORDER BY 1,2

--likelihood of death if getting covid in vietnam
CREATE VIEW VietnamCovidPercentage
AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as CovidPercentage
FROM PortfolioProject..covidDeath
WHERE location = 'Vietnam'
--ORDER BY 1,2

--country with highest infection rate
SELECT location, Population, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as InfectionRate
FROM PortfolioProject..covidDeath
GROUP BY location, population
ORDER BY InfectionRate DESC

SELECT location, Population, max(total_deaths) as HighestDeaths, MAX((total_deaths/population)) * 100 as DeathRate
FROM PortfolioProject..covidDeath
WHERE continent is not null
GROUP BY location, population
ORDER BY DeathRate DESC

--highest death rate in a day descending by location
SELECT location, date, max(cast(new_deaths as int)) as DeathRateHighest
FROM PortfolioProject..covidDeath
WHERE continent IS NOT NULL
GROUP BY location, date
ORDER BY DeathRateHighest DESC


--death by continent

SELECT location, max(cast(total_deaths as int)) as totalDeathCount
FROM PortfolioProject..covidDeath
WHERE continent IS NULL
GROUP BY location
ORDER BY totalDeathCount ASC 


--total cases of continents
SELECT continent,  MAX(total_cases)
FROM PortfolioProject..covidDeath
WHERE continent IS NOT NULL
GROUP BY continent

--GLOBAL DEATH RATE PER DAY
SELECT date, SUM(new_cases) AS newCases, SUM(CAST(new_deaths AS INT)) AS newDeaths, (SUM((CAST(new_deaths AS INT)))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject..covidDeath
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date ASC

--Total Case vs Death Globally UP UNTIL TODAY
CREATE VIEW CasesVSDeathGlobal 
AS
SELECT SUM(new_cases) as total_cases, SUM(CONVERT(INT,total_deaths)) as total_deaths, (SUM((CAST(new_deaths AS INT)))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject..covidDeath
WHERE continent IS NOT NULL


--vacinated vs cases per country

WITH VacVsCases (location, totalVaccinations, totalCases)
as
(
SELECT dea.location, MAX(vac.total_vaccinations) as totalVaccinations, MAX(dea.total_cases) AS totalCases
FROM PortfolioProject..covidDeath dea
JOIN PortfolioProject..covidVaccinated vac
ON dea.location=vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.location
)
SELECT location , totalVaccinations, totalCases
FROM VacVsCases
ORDER BY location ASC



