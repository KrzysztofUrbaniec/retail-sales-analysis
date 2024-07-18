SELECT * FROM "EcommerceAnalysis".product_supplier ps 

/*
 * Product-centric metrics
*/

-- Which product line generates the most revenue and how it compares to the profit?
WITH product_line_profitability AS (
	SELECT 
		DATE_TRUNC('year',o."Order Date") :: DATE AS order_year,
		ps."Product Line",
		ps."Product Category",
		ROUND(
			SUM("Quantity Ordered" * "Price Per Unit") :: NUMERIC
		,1) AS revenue,
		ROUND(
			SUM("Quantity Ordered" * ("Price Per Unit" - "Cost Per Unit")) :: NUMERIC
		,1) AS profit
	FROM "EcommerceAnalysis".orders o 
	LEFT JOIN "EcommerceAnalysis".product_supplier ps 
	ON o."Product ID" = ps."Product ID" 
	GROUP BY order_year, ps."Product Line", ps."Product Category" 
	ORDER BY order_year, revenue DESC
)
SELECT
	order_year,
	"Product Line",
	"Product Category",
	ROUND(
		profit :: NUMERIC / revenue
	,2) AS profit_margin
FROM product_line_profitability;

-- Products from which category were ordered most frequently in 2021? 
-- Create a cross table with ranks
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
	WITH category_order_freq AS (
		SELECT 
			ps."Product Category",
			TO_CHAR(o."Order Date", '"Q"Q YYYY') AS order_quarter,
			COUNT(DISTINCT o."Order ID") AS count_orders
		FROM "EcommerceAnalysis".orders o 
		LEFT JOIN "EcommerceAnalysis".product_supplier ps 
		ON o."Product ID" = ps."Product ID" 
		WHERE DATE_TRUNC('year',o."Order Date") = '2021-01-01'
		GROUP BY order_quarter, ps."Product Category"
		ORDER BY order_quarter, count_orders DESC
	) 
	SELECT 
		"Product Category" :: TEXT,
		order_quarter :: TEXT,
		RANK() OVER (PARTITION BY order_quarter ORDER BY count_orders DESC) :: INT AS rankk
	FROM category_order_freq
	ORDER BY "Product Category", order_quarter;
$$)
AS ct ("Product Category" TEXT,
		"Q1 2021" INT,
		"Q2 2021" INT,
		"Q3 2021" INT,
		"Q4 2021" INT);
		
	