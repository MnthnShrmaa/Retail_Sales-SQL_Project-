-- creating the Database
create database sql_project_1

-- creating the table
DROP TABLE IF EXISTS retail_sales;
create Table retail_sales
			(
				transactions_id INT PRIMARY KEY,
                sale_date Date,
                sale_time time,
                customer_id INT,
                gender Varchar(20),
                age INT,
                category Varchar(20),
                quantiy Int,
                price_per_unit Float,
                cogs FLOAT,
                total_sale FLOAT
);

SELECT * FROM retail_sales
limit 10;

select count(*) from retail_sales;

-- 
SELECT * FROM retail_sales
where transactions_id is null;

SELECT * FROM retail_sales
where sale_date is null
	or transactions_id is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantiy is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;

DELETE FROM retail_sales
where sale_date is null
	or transactions_id is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantiy is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;
    
-- How many sales do we have?
	SELECT count(*) AS total_sales FROM retail_sales;
    
-- How many unique customers do we had?
SELECT COUNT(DISTINCT CUSTOMER_ID ) AS customer_count FROM retail_sales;

-- how many unique categories do we have?
 select DISTINCT CATEGORY FROM retail_sales;
 
 -- DATA ANALYSIS/ BUSINESS KEY PROBLEMS $ ANSWERS
 -- Q1). WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05'
 SELECT *
 FROM retail_sales
 WHERE sale_date = '2022-11-05';
 
 -- Q2). WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS CLOTHING AND THE QUANTITY SOLD IS MORE THAN OR EQUAL TO 2 IN THE MONTH OF NOV-2022.
 SELECT *
 FROM retail_sales
 WHERE category = 'Clothing' 
 AND quantiy >= 2
 having sale_date like '2022-11%';
 
 -- Q3). write a sql query to calculate the total sales(total_sales) for each category
 SELECT category,
 SUM(total_sale) as total_sales,
 COUNT(transactions_id) AS count_of_transactions
 FROM retail_sales
 GROUP BY category;
 
 -- Q4). WRITE A SQL QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO PURCHASED ITEMS FROM THE BEAUTY CATEGORY
 
 SELECT ROUND(AVG(age), 2) AS avg_age
 FROM retail_sales
 WHERE category = 'Beauty';
 
 -- Q5). WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE THE total_sales IS GREATER THAN 1000.
 
 SELECT * 
 FROM retail_sales
 WHERE total_sale > 1000;
 
 -- Q6). WRITE A SQL QUERY TO FIND THE TOTAL NUMBER OF TRANSACTION (transactions_id)  MADE BY EACH GENDER IN EACH CATEGORY.
 
 SELECT category, gender,
 COUNT(transactions_id) as total_transactions
 FROM retail_sales
 GROUP BY category, gender
 ORDER BY category;
 
 -- Q7). WRITE A SQL QUERY TO CALCULATE THE AVERAGE SALE FOR EACH MONTH. FIND OUT THE BEST SELLING MONTH IN EACH YEAR
 
 WITH CTE AS (
 SELECT 
	YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS avg_sale_month,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale), 2) DESC) as rnk
 FROM retail_sales
 GROUP BY YEAR(sale_date), MONTH(sale_date)
 -- ORDER BY YEAR(sale_date), ROUND(AVG(total_sale), 2) DESC
 )
 SELECT year, month, avg_sale_month
 FROM CTE
 WHERE rnk =1;
 
 -- Q8). WRITE AN SQL QUERY TO FIND THE TOP 5 CUSTOMRS BASED ON THE HIGHEST TOTAL SALES
 
 SELECT 
	customer_id, 
	SUM(total_sale)
 FROM retail_sales
 GROUP BY customer_id
 ORDER BY SUM(total_sale) DESC
 limit 5;
 
 -- Q9). WRITE A SQL QUERY TO FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY
 
 SELECT 
	category,
    COUNT(distinct customer_id) as total_customers
FROM retail_sales
GROUP BY category;

-- write a sql query to create each shift and number of orders. ( example morning <=12, afternoon between 12 and 17, evening > 17)

WITH t as 
(
SELECT *,
	CASE 
		WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shifts
FROM retail_sales
)
SELECT
	shifts,
	COUNT(transactions_id) AS no_of_orders
FROM t
group by shifts;