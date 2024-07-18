## RETAIL SALES ANALYSIS

### Goal of the project:

The project aimed to discover trends and relationships in the sales data as well as to monitor business performance based on user-centric and revenue-centric KPIs. 

### The dataset:
Link to the [source](https://www.kaggle.com/datasets/gabrielsantello/wholesale-and-retail-orders-dataset).

The dataset collected on Kaggle contains two tables:
- orders.csv
- product-supplier.csv

Columns descriptions: 


Orders.csv:
- Customer ID - Unique identifier of each customer
- Customer Status - Priority of a customer (Silver, Gold, Platinum)
- Date Order was placed - self-explanatory
- Delivery Date - self-explanatory
- Order ID - Unique identifier of each order
- Product ID - Unique identifier of each product
- Quantity Ordered - Number of items per order
- Total Retail Price - Total price for the order (assumed currency: dollars)
- Cost Price Per Unit - Cost of a single product (assumed currency: dollars)


Product-supplier.csv:
- Product ID - Unique identifier of each product
- Product Line - eg. Children, Clothes & Shoes
- Product Category - eg. Children Outdoors
- Product Group - eg. Outdoor things, Kids
- Product Name - self-explanatory
- Supplier Country - self-explanatory
- Supplier Name - self-explanatory
- Supplier ID - Unique identifier of each supplier

Prior to the analysis the data was cleaned/preprocessed in the following way:
- Formatting of "Customer Status" column in orders.csv was unified
- "Date Order was placed" column was renamed to Order Date
- "Total Retail Price" was divided by the "Quantity Ordered" to obtain "Price per Unit" column

#### The KPIs used in the project:
User-centric KPIs:
- Number of new customers per month (date of registration is considered to be the date of the first order)
- Monthly Active Users (MAU)
- Customer Retention Rate

Revenue/order-centric KPIs:
- Average Revenue per User (ARPU)
- Growth Rate with respect to the revenue

Additional metrics/summaries derived from the dataset:
- Frequency histograms (distributions) of the number of orders per or revenue per user 
- Top 10 most frequently purchased items
- Top 10 customers by revenue
- Top 10 items by revenue
- Revenue by Customer Status
- Profitability of particular product lines
- Ranking of product categories with respect to the number of orders in 2021

