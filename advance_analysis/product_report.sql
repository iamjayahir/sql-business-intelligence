/*

Product Report

Purpose:
	- This report consolidates key customers metrics and behaviours

Highlights:
	1. Gathers essential field such as product names, category,subcategory and cost.
    2. segment products by revenue to identify High-Performers, Mid-range, or Low-Performers.
    3. Aggregate customer level metrics:
		- total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
	4. Calculate  valuable KPIs:
		- recency (month since last order)
        - average order revenue (AOR)
        average monthly revenue

*/

CREATE VIEW product_report AS
-- 1) Base Query: Retrives core columns from fact_sales and dim_products
WITH base_query AS(
	SELECT
		f.order_number,
		f.order_date,
		f.sales_amount,
		f.quantity,
        f.customer_key,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
	FROM fact_sales f 
	LEFT JOIN dim_products p
	ON p.product_key = f.product_key
	WHERE order_date IS NOT NULL
), product_aggregations AS (
-- 2.Product Aggregations: Summarize key metrics at product level
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
        cost,
		ROUND((DATEDIFF(MAX(order_date),MIN(order_date)) / 365) * 12,0) AS lifespan_month,
		MAX(order_date) AS last_order_date,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_key) AS total_customer,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		ROUND(AVG(sales_amount / NULLIF(quantity,0)),1) AS avg_selling_price
	FROM base_query
	GROUP BY
		product_key,
		product_name,
		category,
		subcategory,
        cost
)

-- 3 Final Query : combines all products results into one output.

SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order_date,
	ROUND((DATEDIFF(CURRENT_DATE(),last_order_date) / 365) *12,0) AS recency,
CASE
	WHEN total_sales > 50000 THEN 'High Performer'
	WHEN total_sales >= 10000 THEN 'Mid-Range'
    ELSE 'Low Performer'
END AS product_segment,
lifespan_month,
total_orders,
total_sales,
total_quantity,
total_customer,
avg_selling_price,

-- Average order revenue (AOR)
CASE 
	WHEN total_orders = 0 THEN 0
    ELSE total_sales / total_orders
END AS avg_order_revenue ,

-- Average Monthly revenue
CASE 
	WHEN lifespan_month = 0 THEN total_sales
    ELSE total_sales / lifespan_month
END  AS avg_monthly_revenue
FROM product_aggregations;
