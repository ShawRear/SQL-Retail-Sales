-- SQL Retail Sales Analysis - Project1
--Create Table
DROP TABLE IF EXISTS retail_sales;
Create table retail_sales
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
WHERE transactions_id is null

SELECT * FROM retail_sales
WHERE sale_date is null

SELECT * FROM retail_sales
WHERE sale_time is null

SELECT * FROM retail_sales
WHERE 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null

delete from retail_sales
WHERE 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;

-- Data Exploration

-- sales count
select count(*) as total_sale from retail_sales

-- customer count
select count(Distinct customer_id) as total_sale from retail_sales

-- Distinct category 
select Distinct category as total_sale from retail_sales

-- Data anlaysis and Business key problems and answers

-- all columns for sales made in 2022-11-05
select *
from retail_sales
where sale_date = '2022-11-05';

-- all transactions where the category is Clothing and the quantity is more than 3 in the month of Nov-2022
select *
from retail_sales
where category = 'Clothing'
	and to_char(sale_date, 'YYYY-MM') = '2022-11'
	and quantiy > 3

-- the total sales for each category
select 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by 1

-- average age of customers who purchased items from 'Beauty' category
select 
	round(avg(age))
from retail_sales
where category = 'Beauty'

-- finding all transactions where the total_sale is greater than 1000
select
	transactions_id,
	total_sale
from 
	retail_sales
where
	total_sale > 1000
order by transactions_id asc

-- finding the total number of transaction (transactions_id) made by each gender in each category
select 
	category,
	gender,
	count(*) as total_transaction
from 
	retail_sales
group by
	category,
	gender
order by 1


-- calculating the average sale for each month and the best selling month in each year 

select * from
(
	select 
		extract(YEAR from sale_date) as year,
		extract(MONTH from sale_date) as month,
		round(avg(total_sale)) as avg_sale,
		rank() over(partition by extract(YEAR from sale_date) order by round(avg(total_sale)) desc) as rank
	from retail_sales
	group by 1,2
	order by 1,3 desc
) as t1
where rank = 1

-- finding the top 5 customers based on the highest total sales

select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

-- number of unique customers who purchased items from each category

select
	category,
	count(distinct customer_id) as unique_customers
from
	retail_sales
group by 1
order by 2 asc

-- creating each shift with number of orders (example Morning <12, Afternoon between 12 & 17, Evening >17)
with hourly_sale
as
(
select *,
	case
		when extract(HOUR from sale_time) < 12 then 'Morning'
		when extract(HOUR from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift

