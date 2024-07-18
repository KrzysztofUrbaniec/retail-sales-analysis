/*
 * User-centeric KPIs
 */

-- Number of registrations per month (registration is the date of first order)
WITH reg_dates AS (
	SELECT
		"Customer ID",
		MIN("Order Date") AS reg_date
	FROM "EcommerceAnalysis".orders o
	GROUP BY "Customer ID" 
)
SELECT
	DATE_TRUNC('month', reg_date) :: DATE AS reg_month,
	COUNT(DISTINCT "Customer ID") AS regs
FROM reg_dates
GROUP BY reg_month
ORDER BY reg_month;

-- Monthly Active Users (MAU) (active = placed an order)
SELECT 
	DATE_TRUNC('month', "Order Date") :: DATE AS order_date,
	COUNT(DISTINCT "Customer ID") AS MAU
FROM "EcommerceAnalysis".orders o 
GROUP BY order_date
ORDER BY order_date;

-- Registrations running total
WITH reg_dates AS (
	SELECT
		"Customer ID",
		MIN("Order Date") AS reg_date
	FROM "EcommerceAnalysis".orders o
	GROUP BY "Customer ID" 
),
new_users AS (
	SELECT
		DATE_TRUNC('month', reg_date) :: DATE AS reg_month,
		COUNT(DISTINCT "Customer ID") AS regs
	FROM reg_dates
	GROUP BY reg_month
	ORDER BY reg_month
)
SELECT 
	reg_month,
	SUM(regs) OVER (ORDER BY reg_month ASC) AS rolling_regs
FROM new_users
ORDER BY reg_month;

-- Customer retention rate (fraction of customers, who used the service in the previous month and continued to do so in the next month)

-- Select a list of customer ids per each month and perform self-join to check, who used the service for two consecutive months
WITH customer_monthly_activity AS (
	SELECT
		DISTINCT DATE_TRUNC('month', "Order Date") :: DATE AS order_month,
		"Customer ID" 
	FROM "EcommerceAnalysis".orders o 
)
SELECT
	cma_previous.order_month,
	ROUND (
		COUNT(DISTINCT cma_current."Customer ID") :: NUMERIC /
		GREATEST(COUNT(DISTINCT cma_previous."Customer ID"), 1)
	,2)
FROM customer_monthly_activity cma_previous
LEFT JOIN customer_monthly_activity cma_current
ON cma_previous.order_month = (cma_current.order_month - INTERVAL '1 month') 
AND cma_previous."Customer ID" = cma_current."Customer ID"
GROUP BY cma_previous.order_month
ORDER BY cma_previous.order_month;

