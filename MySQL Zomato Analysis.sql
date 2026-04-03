CREATE DATABASE zomato_db;
USE zomato_db;

desc country;
drop table country;
select* from zomato;
select* from country;

CREATE TABLE zomato (
    restaurant_id INT,

    restaurant_name VARCHAR(255)
        CHARACTER SET utf8mb4
        COLLATE utf8mb4_unicode_ci,

    country_code INT,

    city VARCHAR(100)
        CHARACTER SET utf8mb4
        COLLATE utf8mb4_unicode_ci,

    cuisines VARCHAR(255)
        CHARACTER SET utf8mb4
        COLLATE utf8mb4_unicode_ci,

    currency VARCHAR(100),

    has_table_booking VARCHAR(5),
    has_online_delivery VARCHAR(5),
    is_delivering_now VARCHAR(5),
    switch_to_order_menu VARCHAR(5),

    price_range INT,
    votes INT,

    average_cost_for_2 INT,
    rating DECIMAL(3,1),

    year_opening INT,
    month_opening INT,
    day_opening INT,
    dates date
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

create table country (CountryID int,
        Countryname varchar(50) 
        CHARACTER SET utf8mb4
        COLLATE utf8mb4_unicode_ci)
        ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

 LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Zomato/country.csv' into table country
 CHARACTER SET utf8mb4
FIELDS TERMINATED by ','
optionally  enclosed by '"'
lines terminated by '\r\n'
IGNORE 1 rows;

 desc zomato;
 
 LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Zomato/Zomato.csv' into table Zomato
CHARACTER SET utf8mb4
FIELDS TERMINATED by ','
optionally  enclosed by '"'
lines terminated by '\r\n'
IGNORE 1 rows;



## Q4

SELECT
    c.Countryname,z.city,
    COUNT(*) AS number_of_restaurants
FROM zomato z
JOIN country c
    ON z.country_code = c.CountryID
GROUP BY c.Countryname,z.city
ORDER BY c.Countryname,number_of_restaurants DESC;


### Q5  

SELECT
  YEAR(dates) AS year,
  COUNT(restaurant_id) AS restaurants_opened
FROM zomato
GROUP BY YEAR(dates)
ORDER BY year;


SELECT
  month(dates) AS month,
  COUNT(restaurant_id) AS restaurants_opened
FROM zomato
GROUP BY month(dates)
ORDER BY month;


SELECT
  CONCAT('Q',QUARTER(dates)) AS quarter,
  COUNT(restaurant_id) AS restaurants_opened
FROM zomato
GROUP BY quarter
order by quarter;

### 6

SELECT
    CASE
        WHEN rating >= 1 AND rating < 2 THEN '1-2'
        WHEN rating >= 2 AND rating < 3 THEN '2-3'
        WHEN rating >= 3 AND rating < 4 THEN '3-4'
        WHEN rating >= 4 AND rating <= 5 THEN '4-5'
        ELSE 'No Rating'
    END AS rating_bucket,
    COUNT(*) AS number_of_restaurants
FROM zomato
GROUP BY rating_bucket
ORDER BY rating_bucket;


### 7

SELECT
    CASE
        WHEN avg_cost_usd < 20 THEN 'Low'
        WHEN avg_cost_usd BETWEEN 20 AND 50 THEN 'Medium'
        ELSE 'High'
    END AS price_bucket_usd,
    COUNT(*) AS number_of_restaurants
FROM (
    SELECT
        CASE
            WHEN currency = 'Indian Rupees(Rs.)' THEN average_cost_for_2 * 0.012
            WHEN currency = 'Dollar($)' THEN average_cost_for_2 * 1
            WHEN currency = 'Pounds(Œ£)' THEN average_cost_for_2 * 1.24
            WHEN currency = 'NewZealand($)' THEN average_cost_for_2 * 0.6
            WHEN currency = 'Emirati Diram(AED)' THEN average_cost_for_2 * 0.27
            WHEN currency = 'Brazilian Real(R$)' THEN average_cost_for_2 * 0.2
            WHEN currency = 'Turkish Lira(TL)' THEN average_cost_for_2 * 0.05
            WHEN currency = 'Qatari Rial(QR)' THEN average_cost_for_2 * 0.27
            WHEN currency = 'Rand(R)' THEN average_cost_for_2 * 0.051
            WHEN currency = 'Botswana Pula(P)' THEN average_cost_for_2 * 0.073
            WHEN currency = 'Sri Lankan Rupee(LKR)' THEN average_cost_for_2 * 0.0034
            WHEN currency = 'Indonesian Rupiah(IDR)' THEN average_cost_for_2 * 0.000067
            
            ELSE average_cost_for_2
        END AS avg_cost_usd
    FROM zomato
    WHERE average_cost_for_2 > 0
) t
GROUP BY price_bucket_usd
ORDER BY number_of_restaurants DESC;




### 8

SELECT
  has_table_booking,
  COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato) AS percentage
FROM zomato
GROUP BY has_table_booking;


### 9 

SELECT
  has_online_delivery,
  COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato) AS percentage
FROM zomato
GROUP BY has_online_delivery;


### 10

##1
SELECT
    cuisines,
    COUNT(*) AS number_of_restaurants
FROM zomato
GROUP BY cuisines
ORDER BY number_of_restaurants DESC;

##2
SELECT
    cuisines,
    ROUND(AVG(rating),2) AS avg_rating
FROM zomato
WHERE rating > 0
GROUP BY cuisines
ORDER BY avg_rating DESC;

###3
SELECT
    city,
    COUNT(*) AS total_restaurants,
    SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END) AS online_delivery_restaurants
FROM zomato
GROUP BY city
ORDER BY online_delivery_restaurants DESC;



###4
SELECT
    price_bucket,
    COUNT(*) AS number_of_restaurants,
    ROUND(AVG(rating), 2) AS avg_rating
FROM (
    SELECT
        rating,
        CASE
            WHEN
                CASE
                     WHEN currency = 'Indian Rupees(Rs.)' THEN average_cost_for_2 * 0.012
            WHEN currency = 'Dollar($)' THEN average_cost_for_2 * 1
            WHEN currency = 'Pounds(Œ£)' THEN average_cost_for_2 * 1.24
            WHEN currency = 'NewZealand($)' THEN average_cost_for_2 * 0.6
            WHEN currency = 'Emirati Diram(AED)' THEN average_cost_for_2 * 0.27
            WHEN currency = 'Brazilian Real(R$)' THEN average_cost_for_2 * 0.2
            WHEN currency = 'Turkish Lira(TL)' THEN average_cost_for_2 * 0.05
            WHEN currency = 'Qatari Rial(QR)' THEN average_cost_for_2 * 0.27
            WHEN currency = 'Rand(R)' THEN average_cost_for_2 * 0.051
            WHEN currency = 'Botswana Pula(P)' THEN average_cost_for_2 * 0.073
            WHEN currency = 'Sri Lankan Rupee(LKR)' THEN average_cost_for_2 * 0.0034
            WHEN currency = 'Indonesian Rupiah(IDR)' THEN average_cost_for_2 * 0.000067
                END < 20 THEN 'Low'

            WHEN
                CASE
                    WHEN currency = 'Indian Rupees(Rs.)' THEN average_cost_for_2 * 0.012
            WHEN currency = 'Dollar($)' THEN average_cost_for_2 * 1
            WHEN currency = 'Pounds(Œ£)' THEN average_cost_for_2 * 1.24
            WHEN currency = 'NewZealand($)' THEN average_cost_for_2 * 0.6
            WHEN currency = 'Emirati Diram(AED)' THEN average_cost_for_2 * 0.27
            WHEN currency = 'Brazilian Real(R$)' THEN average_cost_for_2 * 0.2
            WHEN currency = 'Turkish Lira(TL)' THEN average_cost_for_2 * 0.05
            WHEN currency = 'Qatari Rial(QR)' THEN average_cost_for_2 * 0.27
            WHEN currency = 'Rand(R)' THEN average_cost_for_2 * 0.051
            WHEN currency = 'Botswana Pula(P)' THEN average_cost_for_2 * 0.073
            WHEN currency = 'Sri Lankan Rupee(LKR)' THEN average_cost_for_2 * 0.0034
            WHEN currency = 'Indonesian Rupiah(IDR)' THEN average_cost_for_2 * 0.000067
                END BETWEEN 20 AND 50 THEN 'Medium'

            ELSE 'High'
        END AS price_bucket
    FROM zomato
    WHERE rating > 0
      AND average_cost_for_2 > 0
) t
GROUP BY price_bucket
ORDER BY number_of_restaurants desc;








