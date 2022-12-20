SELECT *
FROM CovidDeaths$
order by 3,4

--SELECT * 
--FROM CovidVaccinations$
--order by 3,4

--select the data that we're going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths$
Order by 1,2

-- Total cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS Death_rate
FROM CovidDeaths$
Order by 1,2

--Looking at Kenya (Likelihood of death on contraction)
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS Death_rate
FROM CovidDeaths$
WHERE Location like '%Kenya%'
Order by 1,2

--Total cases vs population
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS Contraction_rate
FROM CovidDeaths$
WHERE Location like '%Kenya%'
Order by 1,2

--Countries with highest infection rate 
SELECT location,MAX(total_cases) as highest_infection_count, population, MAX(total_cases/population) * 100 AS highest_infection_rate
FROM CovidDeaths$
GROUP BY Location, population
Order by highest_infection_rate desc


--Highest death count per population
SELECT location,MAX(cast(total_deaths as int)) as highest_death_count, population, MAX(total_deaths/population) * 100 AS highest_death_rate
FROM CovidDeaths$
GROUP BY Location, population
Order by highest_death_rate desc

SELECT location,MAX(cast(total_deaths as int)) as Total_death_count
FROM CovidDeaths$
WHERE continent is null
GROUP BY Location
Order by Total_death_count desc

SELECT location,MAX(cast(total_deaths as int)) as Total_death_count
FROM CovidDeaths$
WHERE continent is  null
GROUP BY Location
Order by Total_death_count desc

-- World death percentage
SELECT SUM(new_cases) as totalcases, SUM(CAST(new_deaths as int)) as totaldeaths, SUM(CAST(new_deaths as int))/ SUM(new_cases) *100 AS globaldeathpercentage
FROM CovidDeaths$
WHERE continent is not null
Order by 1,2

SELECT *
FROM CovidVaccinations$

--Joining the Covid deaths and vaccinations tables
SELECT *
FROM CovidDeaths$ dea
join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date

 --Looking at total population vs vaccinations
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 FROM CovidDeaths$ dea
join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 order by 2,3

 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as Rollingpeoplevaccinated
 FROM CovidDeaths$ dea
join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 order by 2,3

 --USE CTE
 with popvsVac AS (continent, location,  Date,population,new_vaccinations,  Rollingpeoplevaccinated
 as
 (
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.Date) as Rollingpeoplevaccinated
 FROM CovidDeaths$ dea
join CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 WHERE dea.continent is not null
 --order by 2,3
 )
 SELECT *, (Rollingpeoplevaccinated/population) * 100
 FROM popvsVac





