-- Create database and use it
CREATE DATABASE superstore_sales;
USE superstore_sales;

-- Create the table
CREATE TABLE superstore (
  order_id VARCHAR(20) NOT NULL PRIMARY KEY,
  order_date DATETIME NOT NULL,
  ship_date DATE NOT NULL,
  ship_mode VARCHAR(50) NOT NULL,
  customer_name VARCHAR(100) NOT NULL,
  country VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  region VARCHAR(50) NOT NULL,
  category VARCHAR(50) NOT NULL,
  sub_category VARCHAR(50) NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  sales DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  discount DECIMAL(5,2) NOT NULL,
  profit DECIMAL(10,2) NOT NULL
);
-- Data Cleaning
-- Datetime Transformation for Time-of-Day Classification

SELECT STR_TO_DATE(order_date, '%Y-%m-%d') AS converted_date
FROM superstore

select * from superstore

-- Feature Engineering

-- 1. Time of Day Classification
ALTER TABLE superstore
ADD COLUMN time_of_day VARCHAR(20);



UPDATE superstore
SET time_of_day = (
  CASE DAYOFWEEK(order_date)
    WHEN 1 THEN 'Evening'   -- Sunday
    WHEN 2 THEN 'Morning'   -- Monday
    WHEN 3 THEN 'Afternoon' -- Tuesday
    WHEN 4 THEN 'Night'     -- Wednesday
    WHEN 5 THEN 'Morning'   -- Thursday
    WHEN 6 THEN 'Afternoon' -- Friday
    ELSE 'Evening'          -- Saturday
  END
);

SET SQL_SAFE_UPDATES = 1;

-- 2. Weekday Analysis
ALTER TABLE superstore ADD COLUMN day_name VARCHAR(10);

UPDATE superstore
SET day_name = DAYNAME(order_date);
-- 3. Monthly Analysis
ALTER TABLE superstore ADD COLUMN month_name VARCHAR(10);

UPDATE superstore
SET month_name = MONTHNAME(order_date);

-- View the data
SELECT * FROM superstore;


-- Business Quastion 

-- Sales & Revenue Insights

-- 1. Which product category generates the highest total sales?
	  SELECT category, SUM(sales) AS total_sales from superstore group by category order by total_sales limit 1;

-- 2. Which sub-category is the most profitable despite low sales volume?
      SELECT sub_category, SUM(profit) AS total_profit, SUM(sales) AS total_sales FROM superstore GROUP BY sub_category
	  ORDER BY total_profit DESC
      limit 1;
     
-- 3. What are the top 5 products by total sales?
       select `Product_ Name` ,sum(sales) as total_sales from superstore group by 1 order by total_sales desc limit 5;

      
--   4.Which region drives the most sales and which drives the least?
	    select region ,sum(sales) as total_sales from superstore group by region order by total_sales desc limit 1;
     
   --  Profit & Discount Analysis
   
--   6. What is the impact of discount on profit — is there a threshold where profit drops sharply?
        SELECT discount, AVG(profit) AS avg_profit FROM superstore GROUP BY discount ORDER BY discount;

--   7. Which product or sub-category yields the lowest profit despite high sales?
        select sub_category ,sum(sales) as total_sales ,sum(profit) as total_profit from superstore
        group by 1 order by total_profit asc
        limit 1;
      
 --  8. Which city has the highest loss in profit after applying discounts?    
	   select city, sum(profit)  as total_profilt  from superstore 
	   group by 1 order by total_profilt asc limit 1;
        
 --  9. What is the average discount given per region?
	   select region , avg(discount) as avg_discount from superstore group by 1 order by avg_discount limit 1;
      
--   10. Are higher discounts correlated with lower profit margins across categories?
	      SELECT category, AVG(discount) AS avg_discount, AVG(profit/sales) AS avg_profit_margin FROM superstore GROUP BY category;
    
  --  Product & Category Performance
  
--   11. Which products are sold the most but generate low profit?
         select `Product_ Name`,  SUM(quantity) AS total_quantity, SUM(profit) AS total_profit FROM superstore GROUP BY 1
         ORDER BY total_quantity DESC limit 5 ;
        
  -- 12. How does performance vary across categories during different months?
         SELECT category, MONTH(order_date) AS month, SUM(sales) AS monthly_sales
         FROM superstore GROUP BY category, MONTH(order_date)
         ORDER BY category, month;  
         
--   13. What are the least sold sub-categories that may need marketing boost?
		 SELECT sub_category, SUM(quantity) AS total_quantity FROM superstore GROUP BY sub_category ORDER BY total_quantity ASC
		 LIMIT 5; 
         
--   14. Are there any sub-categories that consistently perform poorly across all regions?
		 SELECT region, sub_category, SUM(profit) AS total_profit FROM superstore GROUP BY region, sub_category ORDER BY total_profit ASC;
         
--   15. Which sub-categories show seasonal trends in sales or profits?
		 SELECT sub_category, MONTH(order_date) AS month, SUM(sales) AS monthly_sales from superstore
        GROUP BY sub_category, MONTH(order_date) ORDER BY sub_category, month;
        
--  Time-Based Performance

--   16. What is the sales trend across months — are there seasonal peaks?
         SELECT month_name, SUM(sales) AS total_sales FROM superstore
         GROUP BY 1 ORDER BY 1; 
         
 --  17.Which day of the week sees the most orders placed?
        select day_name ,count(order_id) as total_orders from superstore
        group by 1 order by 1;
        
 --  18.Which time of day sees maximum orders?
        select time_of_day ,count(order_id) as total_orders from superstore
        group by 1 order by 2 desc;
        
 --  19.How has profit changed over the years — is it growing or declining?
		SELECT YEAR(order_date) AS year, SUM(profit) AS total_profit FROM superstore
        GROUP BY YEAR(order_date) ORDER BY year;
        
 --  20.Which months consistently underperform in terms of revenue?
		select month_name, sum(sales) as total_sales from superstore
        group by 1 order by 2 asc 
        
        
        



 




	


   
 
      
          
                      






