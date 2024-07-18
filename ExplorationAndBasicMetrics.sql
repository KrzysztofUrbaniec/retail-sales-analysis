/*
 * Getting familiar with the data
 */ 

SELECT * FROM "EcommerceAnalysis".orders o;

-- Total number of orders
SELECT COUNT(*)
FROM "EcommerceAnalysis".orders o; 

-- Total number of customers
SELECT COUNT(DISTINCT "Customer ID")
FROM "EcommerceAnalysis".orders o; 

-- Date of the first and last order
SELECT MIN("Order Date"), MAX("Order Date")  
FROM "EcommerceAnalysis".orders o; 

-- Customer Status types
SELECT DISTINCT "Customer Status " 
FROM "EcommerceAnalysis".orders o;

-- Number of unique items
SELECT COUNT(DISTINCT "Product ID")
FROM "EcommerceAnalysis".product_supplier ps;

-- Are there any orders, which were not delivered?
SELECT COUNT(*)
FROM "EcommerceAnalysis".orders o 
WHERE "Order Date" IS NOT NULL AND "Delivery Date" IS NULL;

-- Are there any items, which were delivered earlier than they were ordered (errors)?
SELECT COUNT(*)
FROM "EcommerceAnalysis".orders o 
WHERE "Delivery Date" < "Order Date"; 

/*
 * Basic Exploration
 */

-- Top products by revenue
SELECT
	o."Product ID" ,
	ps."Product Name",
	ps."Product Category",
	ROUND(
		SUM("Quantity Ordered" * "Price Per Unit") :: NUMERIC
	,1) AS Revenue
FROM "EcommerceAnalysis".orders o
LEFT JOIN "EcommerceAnalysis".product_supplier ps
ON o."Product ID" = ps."Product ID" 
GROUP BY o."Product ID", ps."Product Name", ps."Product Category" 
ORDER BY Revenue DESC
LIMIT 10;

-- Top customers by revenue
SELECT 
	"Customer ID" ,
	ROUND(
		SUM("Quantity Ordered" * "Price Per Unit") :: NUMERIC
	,2) AS Revenue
FROM "EcommerceAnalysis".orders o 
GROUP BY "Customer ID" 
ORDER BY Revenue DESC
LIMIT 10;

-- The most popular products
SELECT 
	o."Product ID",
	ps."Product Name" ,
	ps."Product Category",
	SUM("Quantity Ordered") AS "Total Quantity"
FROM "EcommerceAnalysis".orders o 
LEFT JOIN "EcommerceAnalysis".product_supplier ps 
ON o."Product ID" = ps."Product ID" 
GROUP BY o."Product ID",  ps."Product Name", ps."Product Category"
ORDER BY "Total Quantity" DESC
LIMIT 10;

-- Revenue and profit per Customer status
SELECT 
	"Customer Status " ,
	ROUND(
		SUM("Quantity Ordered" * "Price Per Unit") :: NUMERIC
	,0) AS Revenue,
	ROUND(
		SUM("Quantity Ordered" * ("Price Per Unit" - "Cost Per Unit")) :: NUMERIC
	,0) AS Profit
FROM "EcommerceAnalysis".orders o 
GROUP BY "Customer Status " 
ORDER BY Profit DESC;
