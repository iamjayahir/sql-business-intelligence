/*


Customer Report


Purpose:
	- This report consolidates key customers metrics and behaviours

Highlights:
	1. Gathers essential field such as names, ages, and transaction details. 
    2. segment customers into categories (VIP, Regular, New ) and age groups. 
    3. Aggregate customer level metrics
		- total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
	4. Calculate  valuable KPIs:
		- recency (month since last order)
        - average order value
        average monthly spend


*/
/*
STEPS that I am going to follow
	1. Base Query
    2. Transformation
    3.Aggregations
    4.Final results with tranformation if needed
*/
    

CREATE VIEW report_customers AS
WITH base_query AS (
/*
1. Base Query: Retrives core column from tables
*/
	SELECT
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name," ",c.last_name) AS customer_name,
		ROUND((DATEDIFF(CURRENT_DATE(),c.birthdate) / 365 ),0) AS age
	FROM fact_sales f 
	LEFT JOIN dim_customers c 
	ON c.customer_key = f.customer_key
	WHERE order_date IS NOT NULL 
),
customer_aggregation AS (
/*
  2. Customer Aggregations: Summarizes key metric at the customer level
*/

	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key ) AS total_products,
		MAX(order_date) AS last_order_date,
		ROUND(((DATEDIFF(MAX(order_date),MIN(order_date))/ 365) * 12),0)AS lifespan_months
	FROM base_query
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		age
)

SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
CASE
	WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 AND 29 THEN '20-29'
    WHEN age BETWEEN 30 AND 39 THEN '30-39'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    ELSE '50 and above'
END  AS age_group,
CASE 
		WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales<= 5000 THEN 'Regular'
		ELSE 'New'
	END customer_segment,
	last_order_date,
    ROUND((DATEDIFF(CURRENT_DATE(),last_order_date) / 365) *12,0) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan_months,
-- Compute average order value (AVO)
CASE
	WHEN total_orders = 0 THEN 0
    ELSE Round(total_sales / total_orders,0)   
END avg_order_value,

-- Compute average monthly spend
CASE 
	WHEN lifespan_months = 0 THEN total_sales
    ELSE Round(total_sales / lifespan_months,0)  
END AS avg_monthly_spend
FROM customer_aggregation;

SELECT 
	*
FROM report_customers;
    
