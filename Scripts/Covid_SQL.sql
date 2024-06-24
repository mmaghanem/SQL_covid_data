-- Covid Deaths
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.coviddeaths
order by 1,2;

-- Total Cases Vs Total Deaths
SELECT Location, date, total_cases, total_deaths, round((total_deaths / total_cases)*100,2) as DeathPercentage
FROM PortfolioProject.coviddeaths
Where Location like '%state%'
order by 1,2;

-- AVG death percentage per country
SELECT Location,  round(AVG((total_deaths / total_cases)*100),2) as DeathPercentage
FROM PortfolioProject.coviddeaths
GROUP BY 1
order by 2 DESC;

-- Total Cases Vs Population
SELECT Location, date, total_cases, population, round((total_deaths / population)*100,2) as DeathPopulationPercentage
FROM PortfolioProject.coviddeaths
Where Location like '%state%'
order by 1,2;

-- Looking at Country with Highest infection rate
SELECT Location, population, MAX(total_cases) HighestInfectionCount, ROUND(MAX(total_cases / population)*100,2) as PercentagePopulationInfected
FROM PortfolioProject.coviddeaths
GROUP BY 1, 2
ORDER BY 4 DESC;

-- Country with Highest Deahth count per Population
SELECT Location, MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM PortfolioProject.coviddeaths
WHERE Location NOT IN ('Europe',  'North America', 'European Union', 'South America') AND continent <> ''
GROUP BY 1
ORDER BY 2 DESC;

-- Analysis by Continent
SELECT Location, MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent = ''
GROUP BY 1
ORDER BY 2 DESC;

SELECT continent, MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

SELECT continent, Location, MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1, 2
ORDER BY 1 DESC;

-- Gloabl Numbers
SELECT date, SUM(new_cases) Total_Cases, SUM(CAST(new_deaths AS SIGNED)) Total_death, (SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject.coviddeaths
GROUP BY 1;

SELECT SUM(new_cases) Total_Cases, SUM(CAST(new_deaths AS SIGNED)) Total_death, (SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE continent != '';

-- Covid Vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent != ''
ORDER by 2,3;

-- Total Vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) Rolling_Total_New_Vac
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent != ''
ORDER by 2,3;

-- CTE
WITH popvsvac (Continent, Location, Date, Population, New_Vaccinations, Rolling_Total_New_Vac)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) Rolling_Total_New_Vac
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent != ''
ORDER by 2,3
)
SELECT *, (Rolling_Total_New_Vac/Population)*100 percentage
FROM popvsvac;

-- Temp Table
DROP TABLE IF EXISTS PerPopVac;
CREATE TEMPORARY TABLE PerPopVac
(
Continent CHAR(255),
Location CHAR(255),
date CHAR(255),
Population NUMERIC,
New_Vaccination CHAR(255),
Rolling_Total_New_Vac NUMERIC
);

INSERT INTO PerPopVac
SELECT dea.continent, dea.location, 
DATE_FORMAT(STR_TO_DATE(dea.date, '%m/%d/%y'), '%m/%d/%y'),
dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, DATE_FORMAT(STR_TO_DATE(dea.date, '%m/%d/%y'), '%m/%d/%y')) AS Rolling_Total_New_Vac
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
AND DATE_FORMAT(STR_TO_DATE(dea.date, '%m/%d/%y'), '%m/%d/%y') = DATE_FORMAT(CONVERT(vac.date, DATE), '%y/%m/%d')
WHERE dea.continent != ''
ORDER BY 2,3;

SELECT *, Rolling_Total_New_Vac
FROM PerPopVac
ORDER BY Location, date DESC;

-- Creating View for Visulaization
DROP VIEW IF EXISTS PerPopVac;
CREATE VIEW PerPopVac AS
SELECT dea.continent, dea.location, 
DATE_FORMAT(STR_TO_DATE(dea.date, '%m/%d/%y'), '%m/%d/%y') as Date,
dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, DATE_FORMAT(STR_TO_DATE(dea.date, '%m/%d/%y'), '%m/%d/%y')) AS Rolling_Total_New_Vac
FROM PortfolioProject.coviddeaths dea
JOIN PortfolioProject.covidvaccinations vac
ON dea.location = vac.location
AND DATE_FORMAT(STR_TO_DATE(dea.date, '%m/%d/%y'), '%m/%d/%y') = DATE_FORMAT(CONVERT(vac.date, DATE), '%y/%m/%d')
WHERE dea.continent != '';

SELECT *
FROM PortfolioProject.perpopvac;

