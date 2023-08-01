select *
from portofolioCovid..portofolio_covid

select * 
from portofolioCovid..portofolio_covidVaksin

Use portofolioCovid
alter table portofolio_covid
alter column total_cases FLOAT

select location, date, total_cases, new_cases, total_deaths, population
from portofolioCovid..portofolio_covid

--- mencari total kasus vs total kematian

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as persentase_kematian
from portofolioCovid..portofolio_covid
where continent is not null

--- Mencari Total kasus vs populasi

select location, date, total_cases, population, (total_cases/population)*100 as persentase_kasus
from portofolioCovid..portofolio_covid
where continent is not null


--- mencari kota dengan infeksi tertinggi
select location, population, MAX(total_cases) as maksimal_kasus,  (max(total_cases)/population)*100 as persentase_kasus
from portofolioCovid..portofolio_covid
where continent is not null
group by location, population
order by persentase_kasus desc


SELECT SQL_VARIANT_PROPERTY(total_deaths, 'BaseType') AS DataType
FROM portofolioCovid..portofolio_covid;

Use portofolioCovid
alter table portofolio_covid
alter column total_deaths FLOAT

UPDATE portofolio_covid
SET total_deaths = 0
WHERE total_deaths IS NULL;

--Menunjukan kematian tertinggi 
select location, MAX(total_deaths) as maksimal_kematian
from portofolioCovid..portofolio_covid
where continent is not null
group by location
order by maksimal_kematian desc

--kasus berdasarkan Benua

select continent, MAX(total_deaths) as maksimal_kematian
from portofolioCovid..portofolio_covid
where continent is not null
group by continent
order by maksimal_kematian desc


--kasus berdasarkan Benua

select location, MAX(total_deaths) as maksimal_kematian
from portofolioCovid..portofolio_covid
where continent is not null
group by location
order by maksimal_kematian desc

-- Menunjukan benua dengan kematian tertingi setiap populasi

select continent, MAX(total_deaths) as maksimal_kematian
from portofolioCovid..portofolio_covid
where continent is not null
group by continent
order by maksimal_kematian desc

-- Global Number

SELECT date, sum(new_cases) as Kasus_baru,
       CASE
           WHEN sum(new_deaths) = 0 THEN NULL
           ELSE sum(new_deaths)
       END AS max_kematian,
	   (CASE
           WHEN sum(new_deaths) = 0 THEN NULL
           ELSE sum(new_deaths)
       END / sum(new_cases)) * 100 as persentase_kematianbaru
FROM portofolioCovid..portofolio_covid 
WHERE continent IS NOT NULL
GROUP BY date

--Join table
select *
from portofolioCovid..portofolio_covidVaksin

--- mencari total population vs vaksin

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location)as vcksinsetiap_orang
--,(vcksinsetiap_orang/dea.population)*100 as persentasevaksin
from portofolioCovid..portofolio_covid dea
join portofolioCovid..portofolio_covidVaksin vac
	on dea.location=vac.location
	and dea.date = vac.date
where dea.continent is not null

gunakan CTE

with popvsvac
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location)as vcksinsetiap_orang
--,(vcksinsetiap_orang/dea.population)*100 as persentasevaksin
from portofolioCovid..portofolio_covid dea
join portofolioCovid..portofolio_covidVaksin vac
	on dea.location=vac.location
	and dea.date = vac.date
where dea.continent is not null)
select *, (vcksinsetiap_orang/population)*100 as persenvac_populasi
from popvsvac


---temp table

create table persen_populasi_vaksin
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vcksinsetiap_orang numeric
)

insert into persen_populasi_vaksin
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location order by dea.location)as vcksinsetiap_orang
--,(vcksinsetiap_orang/dea.population)*100 as persentasevaksin
from portofolioCovid..portofolio_covid dea
join portofolioCovid..portofolio_covidVaksin vac
	on dea.location=vac.location
	and dea.date = vac.date
where dea.continent is not null

select *, (vcksinsetiap_orang/population)*100 as persenvac_populasi
from persen_populasi_vaksin