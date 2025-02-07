-- Creating Categories Table
CREATE TABLE categories(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(30),
	description VARCHAR(100)
);

-- Creating a product table
CREATE TABLE products(
	product_id VARCHAR(10)PRIMARY KEY,
	product_name VARCHAR(500),
	quantity_per_unit VARCHAR(50),
	unit_price NUMERIC(10,2),
	discontinued INT,
	category_id INT REFERENCES categories(category_id)
);

-- Creating Customer table
CREATE TABLE customers(
	customer_id VARCHAR(10)PRIMARY KEY,
	company_name VARCHAR(100),
	contact_name VARCHAR(50),
	contact_title VARCHAR(100),
	city VARCHAR(20),
	country VARCHAR(30)
);

-- Creating Employees Table
CREATE TABLE employees(
	employee_id INT PRIMARY KEY,
	employee_name VARCHAR(30),
	title VARCHAR(35),
	city VARCHAR(20),
	country VARCHAR(10),
	reports_to INT
);

-- Creating Shippers Table
CREATE TABLE shippers(
	shipper_id INT PRIMARY KEY,
	company_name VARCHAR(30)
);

-- Creating Orders table
CREATE TABLE orders(
	order_id INT PRIMARY KEY,
	customer_id VARCHAR(10) REFERENCES customers(customer_id),
	employee_id INT REFERENCES employees(employee_id),
	order_date DATE,
	required_date DATE,
	shipped_date DATE,
	shipper_id INT REFERENCES shippers(shipper_id),
	freight NUMERIC(10,2)
);

-- Creating Order Details Table
CREATE TABLE order_details(
	order_id INT REFERENCES orders(order_id),
	product_id VARCHAR(10) REFERENCES products(product_id),
	quantity INT,
	discount NUMERIC(10,2)
);


--KEY METRICS

--A. TOTAL ORDERS
SELECT COUNT(order_id) AS total_orders
FROM orders;

--B. TOTAL REVENUE
SELECT SUM(od.quantity * p.unit_price * (1-od.discount)) AS total_revenue
FROM order_details AS od
JOIN products  p ON od.product_id = p.product_id;

--C. AVERAGE ORDER VALUE
SELECT AVG(order_value) AS avg_order_value
FROM(
	SELECT SUM(od.quantity * p.unit_price * (1-od.discount)) AS order_value
	FROM order_details AS od
	JOIN products p on od.product_id = p.product_id
	GROUP BY od.order_id) As subquery;
	
--D. SHIPPING EFFICIENCY
SELECT ROUND(AVG(shipped_date - order_date),0) AS avg_shipping_time
FROM orders
WHERE shipped_date IS NOT NULL;

--BUSINESS QUESTIONS
--1.Are they any noticeable sales trend over time?
--SALES TREND OVER TIME

SELECT
    EXTRACT(YEAR FROM o.order_date) AS order_year,
	EXTRACT(MONTH FROM order_date) AS order_month,
	       SUM(od.quantity * p.unit_price * (1-od.discount)) AS monthly_revenue
    FROM orders As o
JOIN order_details od ON o.order_id = od.order_id
	JOIN products p ON od.product_id = p.product_id
	GROUP BY EXTRACT(YEAR FROM o.order_date),
	         EXTRACT(MONTH FROM o.order_date)
	ORDER BY order_year, order_month;
	
--2. Best and worst  selling products.
--Best Selling Products (Showing Top 5)
SELECT p.product_name,
       SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

--Worst SelLing Products  (Show top 5)
SELECT p.product_name,
        SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold ASC
LIMIT 5; 

--3.Key Customers   (Show top 5 customers)
SELECT c.company_name,
        SUM(od.quantity * p.unit_price * (1-od.discount)) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.company_name
ORDER BY total_revenue DESC
LIMIT 5;

--4.Are shipping cost consistent across providers?
--Shipping consistency across providers 
SELECT s.company_name AS shipper,
         AVG(o.freight) AS avg_shipping_cost,
		 MAX(o.freight) AS max_shipping_cost,
		 MIN(o.freight) AS min_shipping_cost,
		 MAX(o.freight) - MIN(o.freight) AS shipping_cost_range
FROM shippers s
JOIN orders o ON s.shipper_id = o.shipper_id
    GROUP BY s.company_name;
	

--5.Delivery Service speed(on-time vs. Late orders)
--Delivery Service speed. On time vs late orders.
SELECT
        CASE
            WHEN o.required_date < o.shipped_date THEN 'Late'
            ELSE 'On Time'
        END AS delivery_status,
        COUNT(*) AS number_of_orders
FROM orders o
GROUP BY delivery_status;