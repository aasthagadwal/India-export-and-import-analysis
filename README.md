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





