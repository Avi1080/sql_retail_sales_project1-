create database sql_project_P1; 
use sql_project_p1;

create table retail_sales 
(
transactions_id	int primary key,
sale_date date, 
sale_time	time, 
customer_id int, 
gender	varchar (15),
age	int, 
category	varchar (15),
quantiy	int,
price_per_unit	float,
cogs	float,
total_sale float
)

select * 
from sql_project_p1.retail_sales;

-- Counting the Total Number of rows
select count(*)
from sql_project_p1.retail_sales;

-- Data Cleaning
-- Checking if there is any Null Values in all columns


select * 
from sql_project_p1.retail_sales
where transactions_id is null;

select * 
from sql_project_p1.retail_sales
where sale_date is null;

select * 
from sql_project_p1.retail_sales
where sale_time is null;

select * 
from sql_project_p1.retail_sales
where 
	transactions_id is null
	or sale_date is null
	or sale_time is null
	or customer_id is null 
	or gender is null
	or age is null
	or category is null
	or quantiy is null
	or price_per_unit is null 
	or cogs is null
	or total_sale is null; 
    
    select * 
from sql_project_p1.retail_sales
where quantiy is null;

-- Data Exploration

-- How many sales we have? 
select count(*) as total_sales
from sql_project_p1.retail_sales;

-- How many customers we have? 

select count(distinct customer_id) as number_of_customers
from sql_project_p1.retail_sales;

-- How many categories we have? 

select distinct category 
from sql_project_p1.retail_sales;

-- Data Analysis & Business Key Problems and Answers 

-- Q1. write a sql query to retrive all columns for sales made on '2022-11-05' 
select *
from sql_project_p1.retail_sales
where sale_date = '2022-11-05';

-- Q2. To find all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of Nov-2022
select *
from sql_project_p1.retail_sales
where 
	category = 'Clothing' 
	and quantiy >= 4
    and sale_date between '2022-11-01' and '2022-11-30';
    
-- Q3. To calculate the total sales for each category
select category, 
	sum(total_sale) as total_sales,
	count(*) as total_orders
from sql_project_p1.retail_sales
group by category;
    
-- Q4. Find the avg age of customers who purchased items from the 'Beauty' category
select 
	round(avg(age), 2) as average_age
from sql_project_p1.retail_sales
where category='Beauty';
    
-- Q5. to find all transactions where the total_sale is greather than 1000. 
select *
from sql_project_p1.retail_sales
where total_sale>1000;

-- Q6. to find the total numbers of transactions made by each gender in each category
select category, gender, count(*) as total_transactions
from sql_project_p1.retail_sales
group by category, gender 
order by category;

-- Q7. to calculate the average sale for each month. find out best selling month in each year 
with cte1 as (
select 
	year(sale_date) as sale_year,
    month(sale_date) as sale_month,
    avg(total_sale) as average_sales,
    rank() over(partition by (year(sale_date)) order by  avg(total_sale) desc) as rank1
from sql_project_p1.retail_sales
group by 
	year(sale_date),
    month(sale_date)
order by 
	sale_year,
   average_sales desc
 )
 
 select sale_year,sale_month,average_sales
 from cte1
 where rank1 = 1 ;


-- Q8. To find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as total_sale
from sql_project_p1.retail_sales
group by customer_id
order by total_sale desc    
limit 5;

 -- Q9. To find the Number of unique customers who purchased items from each category  
select category, count(distinct customer_id) as total_unique_customers 
from sql_project_p1.retail_sales
group by category;

-- Q10. To create each shift and number of orders (Example Morning before 12pm, Afternoon bewteen 12 & 17, evening after 17)
with cte3 as (
select *, 
	case
    when hour(sale_time) <= 12 then 'Morning' 
    when hour(sale_time) between 12 and 17 then 'Afternoon' 
    else 'Evening'
    end 'shift'
from sql_project_p1.retail_sales
)

select shift, count(transactions_id) as total_orders 
from cte3
group by shift
order by total_orders desc;

-- End of Project 1 ---------------------------