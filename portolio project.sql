--SELECT * FROM CovidDeaths$ ORDER BY 3,4
--SELECT * FROM CovidVaccinations$ ORDER BY 3,4

-- select the data
--SELECT Location, date, total_cases, new_cases, total_deaths, population
--FROM CovidDeaths$ ORDER BY 1,2

--Looking at Total cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths$ 
WHERE location like '%kenya%'
and continent is not null
ORDER BY 1,2

--Looking at total cases vs population
--Shows percentage of population with covid
SELECT Location, date, total_cases,population, (total_cases/population)*100 AS Contractionpercentage
FROM CovidDeaths$ 
WHERE location like '%kenya%'
ORDER BY 1,2

--Looking at countries with highest infection rates compared to population
SELECT DISTINCT Location,max(total_cases) as Highestinfectionrate,population, (max(total_cases)/population)*100 AS Contractionpercentage
FROM CovidDeaths$ 
GROUP BY Location,population
ORDER BY Contractionpercentage desc

--Showing countries with highest deathcount per population
SELECT location, max(cast (Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths$
WHERE continent is not null
GROUP BY Location,population
ORDER BY TotalDeathCount desc

--Grouping deathcount by Continent
SELECT DISTINCT continent, max(cast (Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths$
WHERE continent is NOT null
GROUP BY continent
ORDER BY TotalDeathCount desc


--GLOBAL NUMBERS
SELECT DISTINCT continent, max(cast (Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths$
WHERE continent is NOT null
GROUP BY continent
ORDER BY TotalDeathCount desc

--Looking at total population vs vaccinations

SELECT * FROM CovidDeaths$ join CovidVaccinations$
on CovidDeaths$.location = CovidVaccinations$.location
and CovidDeaths$.date = CovidVaccinations$.date
where CovidDeaths$.continent is not null
Order by 2,3