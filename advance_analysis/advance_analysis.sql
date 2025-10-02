/* Advance Data Analytics
[Answer Business Questions]
*/

-- Changes over Time Analysis 

/* Analyze how measure evolves over time. 
 - Helps  to track trends and identify seasonality in your data.
 
 By using 'Aggregate Function [ Measure] By [Date Dimension]'
 i.e Total sales by year, Average cost by month etc */
 
 -- Analyze Sales performance over time
 /* Changes over years
	- A high level overview insights that helps with strategic decision making. 
*/

 SELECT 
	YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- Analyze over months and years

 SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	YEAR(order_date),
    MONTH(order_date)
ORDER BY
	YEAR(order_date),
    MONTH(order_date);
    
/* Cumulative Analysis
- Aggregate the data progressively over time.
- Help to understand whether our business is growing or decling.

By using 'Aggregate function[Cumulative Measure] By [ Date Dimension]'
i.e running totals of sales by year, moving average of sales by month 
*/

-- 1. Calculate the total sales per month, the running total of sales, moving average of sales over time. 
SELECT 
	order_year,
    order_month,
    total_sales,
    SUM(total_sales) OVER(ORDER BY order_year,order_month) AS running_total_sales,
	AVG(avg_price) OVER(ORDER BY order_year,order_month) AS moving_avg_sales

FROM (
    
		SELECT
			YEAR(order_date) AS order_year,
			MONTH(order_date) AS order_month,
			SUM(sales_amount) AS total_sales,
            AVG(price) AS avg_price
		FROM fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY
			YEAR(order_date),
			 MONTH(order_date)
		
) t;

/* Performance Analysis
 - Comapring the current value to a target value
 - help to measure success and compare performance.
 
 by using 'Current[measure] - Target[Measure]'
 i.e current year sales - previous year sales (Y-O-Y Analysis)
 
 */
 
 /* 1. Analyze yearly performance of the products by comparing
 each product sales  to both average sales performance  and the previous 
 year's sales */
 
 WITH yearly_product_sales AS (
	 SELECT
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM fact_sales f
	LEFT JOIN dim_products p 
	ON p.product_key = f.product_key 
	WHERE order_date IS NOT NULL
	GROUP BY 
		YEAR(f.order_date),
		p.product_name
)

SELECT
	order_year,
    product_name,
    current_sales,
    ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) AS avg_sales,
    current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0)  AS diff_avg,
    CASE 
		WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0)  > 0 THEN 'Above Avg' 
		WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0)  < 0 THEN 'Below Avg' 
        ELSE 'AVG'
	END Avg_change,
-- Year - over - Year Analysis
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ) py_sales, 
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ) AS diff_py,
     CASE 
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year )  > 0 THEN 'Increase' 
		WHEN  current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year )  < 0 THEN 'Decrease' 
        ELSE 'No Change'
	END py_change
FROM yearly_product_sales
ORDER BY 
	product_name,
    order_year;
    

/* Part - To - Whole Analysis  (proportional Analysis )
- Analyze how an individual part is performing compared to the overall, allowing us to understand which category has
the greatest impact on the business.

By using '([Measure]/Total[Measure])*100 By [Dimension]'
i.e  (Sales / Total Sales ) * 100 by Category , 
	(Quantity / Total Quantity ) * 100 by Country
*/

-- Which category contribute the most to overall sales ?

WITH category_sales AS (

	SELECT
		p.category,
		SUM(f.sales_amount) AS total_sales
	FROM fact_sales f 
	LEFT JOIN dim_products p 
	ON p.product_key = f.product_key
	GROUP BY 
		category 
)

SELECT 
	category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
  CONCAT(ROUND( ( total_sales / SUM(total_sales) OVER() ) * 100 ,2),'%') AS percentage_of_total 
FROM category_sales
ORDER BY
	total_sales DESC;
 
 /* Data Segmentation
  -  Group the data based on specific range.
  -  Helps to understand the correlation between two measures.
  
  BY using '[Measure] By [Measure]'
  i.e Total products By Sales Range, Total Customer by Age
  
  */
  
-- Segment products into cost ranges and  count how many products fall into each segment.
 
 WITH product_segments AS (
 
	 SELECT
		product_key,
		product_name,
		cost,
	CASE
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Aove 1000'
	END cost_range 
	FROM dim_products
)

SELECT 
	cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Group customers into three segments  based on their spending behaviour:
 - VIP: at least 12 months of history and spending more than 5000
 - Regular: at least 12 months of history but spending 5000 or less.
 - New: lifespan less than  12 months.
 And find the total number of customers in each group.
*/

WITH customer_spending AS (

	SELECT 
		c.customer_key,
		SUM(f.sales_amount) AS total_spending , 
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		ROUND(((DATEDIFF(MAX(order_date),MIN(order_date))/ 365) * 12),0)AS lifespan_months
	FROM fact_sales f
	LEFT JOIN dim_customers c
	ON c.customer_key = f.customer_key
	GROUP BY
		c.customer_key
)
SELECT 
	customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
	SELECT 
	customer_key,
	CASE 
		WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segment
	FROM customer_spending 
) t 
GROUP BY
	customer_segment
ORDER BY total_customers DESC;	

