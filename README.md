# India-export-and-import-analysis

## 1.Table Creation
### 1.1 Create region table
```
create table regions(
	region_id INT PRIMARY KEY,
	region VARCHAR(30) UNIQUE
);

select * from regions;
```
### 1.2 Create country table

```
create table country(
	country_id INT PRIMARY KEY,
	country VARCHAR(50) UNIQUE,
	region_id INT,
	FOREIGN KEY (region_id) REFERENCES regions(region_id)
);
```
### 1.3 Create commodity category table

```
create table commodity_category(
	category_id INT PRIMARY KEY,
	commodity_category VARCHAR(100) UNIQUE NOT NULL
);
```

### 1.4 Create commodity table

```
create table commodity(
	commodity_id INT PRIMARY KEY,
	commodity VARCHAR(250) NOT NULL,
	cleaned_commodity VARCHAR(250) NOT NULL,
	category_id INT,
	FOREIGN KEY (category_id) REFERENCES commodity_category(category_id)
);
```

### 1.4 Create commodity table

```
CREATE TABLE trades (
    trade_id SERIAL PRIMARY KEY,
	trade_type VARCHAR(50) NOT NULL,
	value NUMERIC NOT NULL,
    year INT NOT NULL,
    country_id INT,
    commodity_id INT,
    FOREIGN KEY (country_id) REFERENCES country (country_id),
    FOREIGN KEY (commodity_id) REFERENCES commodity (commodity_id)
);
```

## 2. Basic queries
### 2.1  Average trade values by country
```
SELECT c.country, AVG(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country ORDER BY avg_value desc;
```
### 2.2 Total trade values by country
```
SELECT c.country, SUM(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country ORDER BY avg_value desc;
```
### 2.3  Average trade values by country and trade type
```
SELECT c.country,t.trade_type, AVG(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country,t.trade_type ORDER BY avg_value desc;
```
### 2.4  Total trade values by country and trade type
```
SELECT c.country,t.trade_type,t.year, SUM(value) as avg_value from trades as t join country as c 
on t.country_id= c.country_id GROUP BY c.country,t.trade_type,t.year ORDER BY avg_value desc;
```
### 2.5  Total trade values by country and trade type=Exports
```
select country ,trade_type,sum(value) as s from trades t
join country c on c.country_id=t.country_id
group by country , trade_type
having trade_type='Exports'
order by s
```
### 2.6  Total trade values by country and trade type=Imports
```
select country ,trade_type,sum(value) as s from trades t
join country c on c.country_id=t.country_id
group by country , trade_type
having trade_type='Imports'
order by s desc
```



## 3. Total trade value
### 3.1 Total trade value by commodity category
```
SELECT cc.commodity_category,sum(t.value) as total_value FROM trades as t join commodity as c 
on t.commodity_id = c.commodity_id join commodity_category as cc
on c.category_id=cc.category_id group by cc.commodity_category order by total_value desc;
```
### 3.2 Total trade value by region
```
SELECT r.region, sum(value) as total_value FROM trades as t join country as c 
on t.country_id=c.country_id join regions as r 
on c.region_id=r.region_id group by r.region order by total_value desc;
```
### 3.3 Total trade value by year
```
select year,sum(value) as s from trades t
group by year
order by s desc
```
### 3.4 Total trade value by year , country
```
select year,c.country,sum(value) as s from trades t
join country c on c.country_id=t.country_id
group by year  , c.country 
order by s desc
```
## 4. Total trade balance
### 4.1 Total trade balance by country
```
select country ,
	sum(case when trade_type='Exports' then value else 0 end ) as Export_value,
	sum(case when trade_type='Imports' then value else 0 end ) as Import_value,
	sum(case when trade_type='Exports' then value else -value end ) as Trade_balance
from trades t
join country c  on c.country_id=t.country_id
group by country 
order by Trade_balance desc
```
### 4.2 Total trade balance by year,country
```
select year , country ,
	sum(case when trade_type='Exports' then value else 0 end ) as Export_value,
	sum(case when trade_type='Imports' then value else 0 end ) as Import_value,
	sum(case when trade_type='Exports' then value else -value end ) as Trade_balance
from trades t
join country c  on c.country_id=t.country_id
group by year , country 
order by Trade_balance desc
```
### 4.3 Total trade balance by country and sum of export value=0
```
SELECT country,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE 0 END) as export, 
	SUM (CASE WHEN trade_type='Import' THEN value ELSE 0 END) as import,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END) as trade_balance
	FROM trades as t join country as c on t.country_id=c.country_id 
	group by country HAVING SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END)=0 
	order by export desc;
```
### 4.4 Total trade balance by country and sum of export value<0
```
SELECT country,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE 0 END) as export, 
	SUM (CASE WHEN trade_type='Import' THEN value ELSE 0 END) as import,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END) as trade_balance
	FROM trades as t join country as c on t.country_id=c.country_id 
	group by country HAVING SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END)<0 
	order by export desc;
```
### 4.5 Total trade balance by country and sum of export value>0
```
SELECT country,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE 0 END) as export, 
	SUM (CASE WHEN trade_type='Import' THEN value ELSE 0 END) as import,
	SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END) as trade_balance
	FROM trades as t join country as c on t.country_id=c.country_id 
	group by country HAVING SUM(CASE WHEN trade_type='Export' THEN value ELSE - value END)>0 
	order by export desc;
```

## 4. Top commodities for every country
### 4.1 Top commodities by country , cleaned commodity
```
select cc.country , cleaned_commodity , sum(value) as total_value from trades t 
join commodity c on c.commodity_id=t.commodity_id
join country cc on cc.country_id=t.country_id
group by country,cleaned_commodity
order by total_value desc
```
### 4.2 Top commodities by country ,commodity category
```
select cc.country , commodity_category , sum(value) as total_value from trades t 
join commodity c on c.commodity_id=t.commodity_id
join country cc on cc.country_id=t.country_id
join commodity_category ccc on ccc.category_id=c.category_id
group by country,commodity_category
order by total_value desc
```
### 4.3 Top commodities by region
```
select region, sum(value) as total_value from trades t 
join country c  on c.country_id=t.country_id
join regions r on r.region_id=c.region_id
group by region
order by total_value desc
```
### 4.4 Top commodities by region,trade type
```
select region,trade_type , sum(value) as total_value from trades t 
join country c  on c.country_id=t.country_id
join regions r on r.region_id=c.region_id
group by region,trade_type
order by total_value desc
```
### 4.5
```
select region ,
	sum(case when trade_type='Exports' then value else 0 end ) as Export_value,
	sum(case when trade_type='Imports' then value else 0 end ) as Import_value,
	sum(case when trade_type='Exports' then value else -value end ) as Trade_balance
from trades t
join country c  on c.country_id=t.country_id
join regions r on r.region_id=c.region_id
group by region
order by Trade_balance desc
```
### 4.6
```
select year , commodity ,
	sum(value) as total_value from trades t
join commodity c  on c.commodity_id=t.commodity_id
group by year , commodity 
having sum(value)>(
select avg(value)*1.5 from trades
)
order by total_value desc
```
### 4.7
```
select country , year ,
	sum(value) as total_value from trades t
join country c  on c.country_id=t.country_id
group by country , year
having sum(value)>(
select avg(value)*1.5 from trades
)
order by total_value desc
```
## 5. Extreme outliers
```
select country , year ,
	sum(value) as total_value from trades t
join country c  on c.country_id=t.country_id
group by country , year
having sum(value)>(
select avg(value)*2 from trades
)
order by total_value desc
```
## 6. Max trade between 2 countries
```
SELECT c.country as c1 , c11.country as c2,SUM(t.value + t1.value) AS total_value
FROM trades t
JOIN trades t1 ON t.commodity_id = t1.commodity_id
join country  c on t.country_id=c.country_id
join country c11 on t1.country_id=c11.country_id
WHERE t.trade_type = 'Exports' AND t1.trade_type = 'Imports'
GROUP BY c1, c2
ORDER BY total_value DESC;
```










