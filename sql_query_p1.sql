-- SQL Retail Sales Analysis - Project1
--Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
			    transactions_id INT PRIMARY KEY,
				sale_date DATE,	
				sale_time TIME,	
				customer_id INT,	
				gender VARCHAR(15),	
				age INT,	
				category VARCHAR(15),	
				quantiy INT,
				price_per_unit FLOAT,	
				cogs FLOAT,	
				total_sale FLOAT

			);

SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT(*) FROM retail_sales

-- Data Cleaning

SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration

-- sales count
SELECT COUNT(*) AS total_sale FROM retail_sales

-- customer count
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales

-- Distinct category 
SELECT DISTINCT category AS total_sale FROM retail_sales

-- Data anlaysis and Business key problems and answers

-- all columns for sales made in 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- all transactions where the category is Clothing and the quantity is more than 3 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND to_char(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy > 3

-- the total sales for each category
SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

-- average age of customers who purchased items from 'Beauty' category
SELECT 
	ROUND(AVG(age))
FROM retail_sales
WHERE category = 'Beauty'

-- finding all transactions where the total_sale is greater than 1000
SELECT
	transactions_id,
	total_sale
FROM 
	retail_sales
WHERE
	total_sale > 1000
ORDER BY transactions_id ASC

-- finding the total number of transaction (transactions_id) made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(*) AS total_transaction
FROM 
	retail_sales
GROUP BY
	category,
	gender
ORDER BY 1


-- calculating the average sale for each month and the best selling month in each year 

SELECT * FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		round(AVG(total_sale)) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY ROUND(AVG(total_sale)) DESC) AS rank
	FROM retail_sales
	GROUP BY 1,2
	ORDER BY 1,3 DESC
) AS t1
WHERE rank = 1

-- finding the top 5 customers based on the highest total sales

SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 desc
LIMIT 5

-- number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM
	retail_sales
GROUP BY 1
ORDER BY 2 ASC

-- creating each shift with number of orders (example Morning <12, Afternoon between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
)
SELECT
	shift,
	COUNT( *) AS total_orders
FROM hourly_sale
GROUP BY shift

