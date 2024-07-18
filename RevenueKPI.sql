
/*
 * KPIs related to the revenue
*/

-- Revenue and profit per month
SELECT 
	DATE_TRUNC('month', "Order Date") :: DATE AS order_month,
	ROUND(
		SUM("Quantity Ordered" * "Price Per Unit") :: NUMERIC
	,1) AS Revenue,
	ROUND(
		(SUM("Quantity Ordered" * "Price Per Unit") - SUM("Quantity Ordered" * "Cost Per Unit")) :: NUMERIC
	,1) AS Profit
FROM "EcommerceAnalysis".orders o 
GROUP BY order_month
ORDER BY order_month;

-- Average Revenue per User (ARPU) per month 
WITH customers_revenue_per_month AS (
SELECT
	DATE_TRUNC('month', "Order Date") :: DATE AS order_month,
	COUNT(DISTINCT "Customer ID") AS n_cust,
	ROUND(
		SUM("Quantity Ordered" * "Price Per Unit") :: NUMERIC
	,1) AS Revenue
FROM "EcommerceAnalysis".orders o 
GROUP BY order_month
)
SELECT 
	order_month,
	ROUND(
		Revenue :: NUMERIC / GREATEST(n_cust, 1)
	,1)
FROM customers_revenue_per_month

-- Distribution (histogram) of the number of orders per user
SELECT 
	orders,
	COUNT(DISTINCT "Customer ID") AS n_cust
FROM (
	SELECT
		"Customer ID",
		COUNT(DISTINCT "Order ID") AS orders
	FROM "EcommerceAnalysis".orders o 
	GROUP BY "Customer ID" 
) sub
GROUP BY orders
ORDER BY orders 

-- Distribution (histogram) of the revenue per user 
SELECT 
	-- Create buckets by rounding the revenue to the nearest 100s
	ROUND(Revenue :: NUMERIC, -2) AS Revenue100, 
	COUNT(DISTINCT "Customer ID") AS n_cust
FROM (
	SELECT
		"Customer ID",
		SUM("Quantity Ordered" * "Price Per Unit") AS Revenue
	FROM "EcommerceAnalysis".orders o 
	GROUP BY "Customer ID" 
) sub
GROUP BY Revenue100
ORDER BY Revenue100

-- MoM Growth Rate
WITH revenue_per_month AS (
	SELECT 
		DATE_TRUNC('month', "Order Date") :: DATE AS order_month,
		ROUND(
			SUM("Quantity Ordered" * "Price Per Unit") :: NUMERIC
		,1) AS Revenue
	FROM "EcommerceAnalysis".orders o 
	GROUP BY order_month
),
lagged_revenue AS (
	SELECT
		order_month,
		Revenue,
		COALESCE(
			LAG(Revenue) OVER (ORDER BY order_month ASC)
		,1) AS lagged_revenue
	FROM revenue_per_month
	ORDER BY order_month
)
SELECT
	order_month,
	ROUND(
		(revenue - lagged_revenue) :: NUMERIC / lagged_revenue
	,2) AS growth
FROM lagged_revenue 
OFFSET 1; -- First date is irrelevant

-- Bucketing users by revenue
SELECT 
	CASE
		WHEN Revenue < 300 THEN 'Low-revenue'
		WHEN Revenue < 1000 THEN 'Mid-revenue'
		ELSE 'High revenue'
	END AS revenue_group,
	COUNT(DISTINCT "Customer ID") AS customer_count
FROM (
	SELECT
		"Customer ID",
		SUM("Quantity Ordered" * "Price Per Unit") AS Revenue
	FROM "EcommerceAnalysis".orders o 
	GROUP BY "Customer ID" 
) sub
GROUP BY revenue_group
ORDER BY customer_count

