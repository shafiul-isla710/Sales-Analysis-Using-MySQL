-- step 1 Database setup
CREATE DATABASE company_db;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL
);

CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    customer_id INT,
    region VARCHAR(100),
    product_id INT,
    quantity INT,
    sales_amount DECIMAL(10, 2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

INSERT INTO products (product_id, product_name, category) VALUES
(101, 'Wireless Mouse', 'Electronics'),
(102, 'Mechanical Keyboard', 'Electronics'),
(103, 'HD Monitor 27-inch', 'Electronics'),
(104, 'Ergonomic Office Chair', 'Furniture'),
(105, 'Standing Desk', 'Furniture'),
(106, 'Noise Cancelling Headphones', 'Electronics'),
(107, 'USB-C Docking Station', 'Electronics'),
(108, 'LED Desk Lamp', 'Furniture'),
(109, 'External Hard Drive 2TB', 'Electronics'),
(110, 'Webcam 1080p', 'Electronics'),
(111, 'Filing Cabinet', 'Furniture'),
(112, 'Bluetooth Speaker', 'Electronics');


INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'Alice Smith'),
(2, 'Bob Johnson'),
(3, 'Charlie Brown'),
(4, 'Diana Prince'),
(5, 'Ethan Hunt'),
(6, 'Fiona Gallagher'),
(7, 'George Clark'),
(8, 'Hannah Abbott'),
(9, 'Ian Malcolm'),
(10, 'Julia Roberts'),
(11, 'Kevin Bacon'),
(12, 'Laura Croft');

INSERT INTO sales (order_id, customer_id, region, product_id, quantity, sales_amount, order_date) VALUES
(5001, 1, 'North', 101, 2, 50.00, '2026-01-10'),
(5002, 2, 'South', 103, 1, 250.00, '2026-01-12'),
(5003, 3, 'East', 104, 1, 180.00, '2026-01-15'),
(5004, 4, 'West', 102, 2, 160.00, '2026-01-18'),
(5005, 5, 'North', 105, 1, 450.00, '2026-01-20'),
(5006, 6, 'South', 106, 1, 200.00, '2026-01-22'),
(5007, 7, 'East', 107, 3, 360.00, '2026-02-01'),
(5008, 8, 'West', 108, 2, 80.00, '2026-02-03'),
(5009, 9, 'North', 109, 1, 90.00, '2026-02-05'),
(5010, 10, 'South', 110, 2, 140.00, '2026-02-08'),
(5011, 1, 'East', 102, 1, 80.00, '2026-02-10'),
(5012, 11, 'West', 111, 1, 210.00, '2026-02-12'),
(5013, 12, 'North', 112, 4, 240.00, '2026-02-15'),
(5014, 3, 'South', 101, 5, 125.00, '2026-02-18'),
(5015, 5, 'West', 103, 2, 500.00, '2026-02-20');

select * from sales;
select * from products;
select * from customers;

-- step 2 Using multiple joins
select 
sales.order_id,
customers.customer_name,
products.category,
products.product_name,
sales.region,
sales.quantity,
sales.sales_amount
from sales
inner join products
on sales.product_id = products.product_id
inner join customers
on sales.customer_id = customers.customer_id;


-- step 3 Creating subqueries for filtering

select 
products.product_id,
products.product_name,
sales.sales_amount
from products
inner join sales
on products.product_id = sales.product_id
where sales.sales_amount > (select avg(sales.sales_amount) from sales);

-- step 4 Nested aggregation queries

SELECT 
    region,
    SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region
HAVING SUM(sales_amount) = (
    -- Outer nested query: finds the MAX of all regional totals
    SELECT MAX(region_total)
    FROM (
        -- Inner nested query: gets total sales for every region
        SELECT SUM(sales_amount) AS region_total
        FROM sales
        GROUP BY region
    ) AS regional_totals
);

-- step 5 Advanced grouping

select 
sales.region,
products.category,
sum(sales.sales_amount) as Total_sales
from sales 
inner join products
on sales.product_id = products.product_id
group by sales.region,products.category;

-- step 6 Using HAVING clause

select 
sales.region,
products.category,
sum(sales.sales_amount) as Total_sales
from sales 
inner join products
on sales.product_id = products.product_id
group by sales.region,products.category
having Total_sales = 380;

-- step 7 Subqueries in SELECT
select
sub.total_sales,
sub.avg_sales
from(
  select
		sum(sales_amount) as total_sales,
		avg(sales_amount) as avg_sales
  from sales) as sub;
  
-- step 8 Dashboard summary queries

select
date_format(sales.order_date,'%y,%m') as months,
customers.customer_name,
sum(sales.sales_amount) as total_sales
from sales
inner join customers
on sales.customer_id = customers.customer_id
group by months, customers.customer_name
order by total_sales desc limit 5;

select 
customers.customer_name,
sales.sales_amount
from customers
inner join sales
on customers.customer_id = sales.customer_id
order by sales.sales_amount desc limit 5;