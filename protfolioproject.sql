SELECT * FROM protfolioproject..CovidDEeath
WHERE continent IS NULL
ORDER BY 3,4;

SELECT * FROM protfolioproject..Vaccination
ORDER BY 3,4;

--selecting data we'r going to use 
SELECT location,date,total_cases,new_cases,total_deaths,population 
FROM protfolioproject..CovidDEeath ORDER BY 1,2;
--loking at total cases vs total death
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Percentage_of_death 
FROM protfolioproject..CovidDEeath
WHERE location like'%states'
ORDER BY 1,2;

--looking at total cases vs population 
SELECT location,date,total_cases,population,(total_cases/population)*100 AS Percentage_of_infected
FROM protfolioproject..CovidDEeath
ORDER BY 1,2;

--country with higest death count per population 

SELECT location,MAX(cast(total_deaths as int)) AS totat_death_count
FROM protfolioproject..CovidDEeath
where continent is not null
group by location
order by totat_death_count desc;

--lestssee by contient 
SELECT location,MAX(cast(total_deaths as int)) AS totat_death_count
FROM protfolioproject..CovidDEeath
where continent is NOT null
group by location
order by totat_death_count desc;



--joining 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as roolingpeoplevaccinated
FROM protfolioproject..CovidDEeath dea 
JOIN protfolioproject..Vaccination vac
ON dea.location=vac.location and 
dea.date=vac.date
where dea.continent is not null
order by 2,3;


--using cte
with popvsvac(continent,location,date,population,new_vaccinations,roolingpeoplevaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date) as roolingpeoplevaccinated
FROM protfolioproject..CovidDEeath dea 
JOIN protfolioproject..Vaccination vac
ON dea.location=vac.location and 
dea.date=vac.date
where dea.continent is not null
)
select *,(roolingpeoplevaccinated/population)*100
from popvsvac