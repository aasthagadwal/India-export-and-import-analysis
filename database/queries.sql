SELECT c.country, AVG(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country ORDER BY avg_value desc;

SELECT c.country, SUM(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country ORDER BY avg_value desc;

SELECT c.country,t.trade_type, AVG(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country,t.trade_type ORDER BY avg_value desc;


SELECT c.country,t.trade_type,t.year, AVG(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country,t.trade_type,t.year ORDER BY avg_value desc;

select country ,trade_type,sum(value) as s from trades t
join country c on c.country_id=t.country_id
group by country , trade_type
having trade_type='Exports'
order by s 

select country ,trade_type,sum(value) as s from trades t
join country c on c.country_id=t.country_id
group by country , trade_type
having trade_type='Imports'
order by s desc


-----------------------------------------------------

select year,sum(value) as s from trades t
group by year
order by s desc


select year,c.country,sum(value) as s from trades t
join country c on c.country_id=t.country_id
group by year  , c.country 
order by s desc

-----------------------------------------------------
--total trade value by commodity category	
SELECT cc.commodity_category,sum(t.value) as total_value FROM trades as t join commodity as c 
on t.commodity_id = c.commodity_id join commodity_category as cc
on c.category_id=cc.category_id group by cc.commodity_category order by total_value desc;


--total trade value by region
SELECT r.region, sum(value) as total_value FROM trades as t join country as c 
on t.country_id=c.country_id join regions as r 
on c.region_id=r.region_id group by r.region order by total_value desc;


-----------------------------------------------------
--TRADE BALANCE

select country ,
	sum(case when trade_type='Exports' then value else 0 end ) as Export_value,
	sum(case when trade_type='Imports' then value else 0 end ) as Import_value,
	sum(case when trade_type='Exports' then value else -value end ) as Trade_balance
from trades t
join country c  on c.country_id=t.country_id
group by country 
order by Trade_balance desc

select year , country ,
	sum(case when trade_type='Exports' then value else 0 end ) as Export_value,
	sum(case when trade_type='Imports' then value else 0 end ) as Import_value,
	sum(case when trade_type='Exports' then value else -value end ) as Trade_balance
from trades t
join country c  on c.country_id=t.country_id
group by year , country 
order by Trade_balance desc

SELECT country,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE 0 END) as export, 
	SUM (CASE WHEN trade_type='Import' THEN value ELSE 0 END) as import,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END) as trade_balance
	FROM trades as t join country as c on t.country_id=c.country_id 
	group by country HAVING SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END)=0 
	order by export desc;

SELECT country,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE 0 END) as export, 
	SUM (CASE WHEN trade_type='Import' THEN value ELSE 0 END) as import,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END) as trade_balance
	FROM trades as t join country as c on t.country_id=c.country_id 
	group by country HAVING SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END)<0 
	order by export desc;

SELECT country,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE 0 END) as export, 
	SUM (CASE WHEN trade_type='Import' THEN value ELSE 0 END) as import,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END) as trade_balance
	FROM trades as t join country as c on t.country_id=c.country_id 
	group by country HAVING SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END)>0 
	order by export desc;

 
-------------------------------------------------------------------------------------
--TOP COMMODITIES FOR EVERY COUNTRY

select cc.country , cleaned_commodity , sum(value) as total_value from trades t 
join commodity c on c.commodity_id=t.commodity_id
join country cc on cc.country_id=t.country_id
group by country,cleaned_commodity
order by total_value desc 

select cc.country , commodity_category , sum(value) as total_value from trades t 
join commodity c on c.commodity_id=t.commodity_id
join country cc on cc.country_id=t.country_id
join commodity_category ccc on ccc.category_id=c.category_id
group by country,commodity_category
order by total_value desc 


select region, sum(value) as total_value from trades t 
join country c  on c.country_id=t.country_id
join regions r on r.region_id=c.region_id
group by region
order by total_value desc 



select region,trade_type , sum(value) as total_value from trades t 
join country c  on c.country_id=t.country_id
join regions r on r.region_id=c.region_id
group by region,trade_type
order by total_value desc 


select region ,
	sum(case when trade_type='Exports' then value else 0 end ) as Export_value,
	sum(case when trade_type='Imports' then value else 0 end ) as Import_value,
	sum(case when trade_type='Exports' then value else -value end ) as Trade_balance
from trades t
join country c  on c.country_id=t.country_id
join regions r on r.region_id=c.region_id
group by region
order by Trade_balance desc


select year , commodity ,
	sum(value) as total_value from trades t
join commodity c  on c.commodity_id=t.commodity_id
group by year , commodity 
having sum(value)>(
select avg(value)*1.5 from trades
)
order by total_value desc


select country , year ,
	sum(value) as total_value from trades t
join country c  on c.country_id=t.country_id
group by country , year
having sum(value)>(
select avg(value)*1.5 from trades
)
order by total_value desc
---EXTREME OUTLIERS
select country , year ,
	sum(value) as total_value from trades t
join country c  on c.country_id=t.country_id
group by country , year
having sum(value)>(
select avg(value)*2 from trades
)
order by total_value desc

-----------------------------------------
--MAX TRADES BETWEEN TWO COUNTRIES


SELECT c.country as c1 , c11.country as c2,SUM(t.value + t1.value) AS total_value
FROM trades t
JOIN trades t1 ON t.commodity_id = t1.commodity_id
join country  c on t.country_id=c.country_id
join country c11 on t1.country_id=c11.country_id
WHERE t.trade_type = 'Exports' AND t1.trade_type = 'Imports'
GROUP BY c1, c2
ORDER BY total_value DESC;