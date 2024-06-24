# Covid-19 Data Analysis Project
by: Mahmoud Ghanem

## Project Overview
Comprehensive SQL analysis on COVID-19 data, involving over a million records to evaluate trends, mortality rates, and vaccination impacts across regions. Utilized advanced SQL techniques for data extraction, transformation, trend analysis, and performance optimization to derive actionable insights.

## Data Preparation
The data for this project is sourced from comprehensive Covid-19 datasets, including metrics on cases, deaths, and vaccinations, as well as demographic and regional details. The datasets are processed and analyzed to generate key insights into the global and regional impacts of the pandemic.

#### Covid Deaths Overview
The following SQL query explore basic Covid-19 statistics by location and date. It provides an overview of the spread and impact of Covid-19, including total cases, new cases, and total deaths:
```
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.coviddeaths
ORDER BY 1,2;
```


### Total Cases vs. Total Deaths
The following SQL query compares total cases with total deaths and calculates the death percentage for each location. This helps understand the lethality of the virus in different states:
```
SELECT Location, date, total_cases, total_deaths, round((total_deaths / total_cases)*100,2) as DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE Location LIKE '%state%'
ORDER BY 1,2;
```


### Average Death Percentage per Country
The following SQL query calculates the average death percentage for each country. This highlights the countries with higher fatality rates, which is crucial for understanding the impact of the virus across different regions:
```
SELECT Location, round(AVG((total_deaths / total_cases)*100),2) as DeathPercentage
FROM PortfolioProject.coviddeaths
GROUP BY 1
ORDER BY 2 DESC;
```


### Total Cases vs. Population
The following SQL query compares total cases with the population size and calculates the death percentage relative to the population. This assessment helps in understanding the virus's impact on different populations:
```
SELECT Location, date, total_cases, population, round((total_deaths / population)*100,2) as DeathPopulationPercentage
FROM PortfolioProject.coviddeaths
WHERE Location LIKE '%state%'
ORDER BY 1,2;
```


### Highest Infection Rate
The following SQL query identifies locations with the highest infection rates relative to their populations. This analysis pinpoints regions with the most severe outbreaks:
```
SELECT Location, population, MAX(total_cases) HighestInfectionCount, ROUND(MAX(total_cases / population)*100,2) as PercentagePopulationInfected
FROM PortfolioProject.coviddeaths
GROUP BY 1, 2
ORDER BY 4 DESC;
```


### Highest Death Count per Population
The following SQL query identifies locations with the highest death counts. This analysis focuses on smaller regions or countries with significant death counts:
```
SELECT Location, MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM PortfolioProject.coviddeaths
WHERE Location NOT IN ('Europe', 'North America', 'European Union', 'South America') AND continent <> ''
GROUP BY 1
ORDER BY 2 DESC;
```


### Analysis by Continent
The following SQL query aggregates the total deaths by continent. This provides a continental overview of Covid-19's impact:
```
SELECT continent, MAX(CAST(total_deaths AS SIGNED)) AS HighestDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;
```


### Global Numbers
The following SQL query summarizes the global Covid-19 cases and deaths, providing a comprehensive view of the pandemic's global impact:
```
SELECT date, SUM(new_cases) Total_Cases, SUM(CAST(new_deaths AS SIGNED)) Total_death, (SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject.coviddeaths
GROUP BY 1
ORDER BY 1 DESC;
```

## Conclusion
The SQL queries and subsequent analysis provide valuable insights into the Covid-19 pandemic. From understanding the spread and impact of the virus across different regions to identifying the severity of outbreaks and fatality rates, this project highlights the importance of data-driven approaches in managing and responding to global health crises.
