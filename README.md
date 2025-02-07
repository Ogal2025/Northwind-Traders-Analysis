# Northwind-Traders-Analysis
is a specialty food Importer and Exporter  company that manages orders, products, customers, and Suppliers. 

### Project Overview
This  data analysis project  aims to   provide insights into the sales performance of a Specalty food company over the past two years, by analysing the various aspects of the sales data, we seek to identify trends, make data driven recommendation, and gain a deeper understanding of the company's performance.

### Data Source
Sales Data: The primary dataset used for this analysis is the "Northwind_sales_data.csv" file, containing detailed information about each sales made by the company.

### Tools
- Excel- used for data cleaning [Download Here] (https://microsoft.com)
- SQL Server- used for data analysis
- Power BI- creating reports and visualization.

 ### Data Cleaning/Preparation
  In the initial data cleaning and preparation phase, we performed the following task:
  1. Data Loading and inspection.
  2. Handling Missing Values.
  3. Data Cleaning and Formatting

### Exploratory Data Analysis(EDA)
EDA invoves exploring the sales data to answer key questions such as :

- Are there any noticeable sales trends over time?
- Which are the best and worst selling products?
- Can you identify any key customers?
- are shipping costs consistent across providers?
- How fast is their delivery service, how many orders are delivered on time or late?

### Data Analysis 
Incudes some interesting code/features worked with:

```sql
SELECT
    EXTRACT(YEAR FROM o.order_date) AS order_year,
	EXTRACT(MONTH FROM order_date) AS order_month,
	       SUM(od.quantity * p.unit_price * (1-od.discount)) AS monthly_revenue
    FROM orders As o
JOIN order_details od ON o.order_id = od.order_id
	JOIN products p ON od.product_id = p.product_id
	GROUP BY EXTRACT(YEAR FROM o.order_date),
	         EXTRACT(MONTH FROM o.order_date)
	ORDER BY order_year,order_month;
  
### Results/findings
  
