create table regions(
	region_id INT PRIMARY KEY,
	region VARCHAR(30) UNIQUE
);

select * from regions;


create table country(
	country_id INT PRIMARY KEY,
	country VARCHAR(50) UNIQUE,
	region_id INT,
	FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

select * from country;


create table commodity_category(
	category_id INT PRIMARY KEY,
	commodity_category VARCHAR(100) UNIQUE NOT NULL
);

select * from commodity_category;


create table commodity(
	commodity_id INT PRIMARY KEY,
	commodity VARCHAR(250) NOT NULL,
	cleaned_commodity VARCHAR(250) NOT NULL,
	category_id INT,
	FOREIGN KEY (category_id) REFERENCES commodity_category(category_id)
);

select * from commodity;

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

select * from trades;



