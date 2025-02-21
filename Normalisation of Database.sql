CREATE DATABASE IF NOT EXISTS sales_db_v2;
USE sales_db_v2;

CREATE TABLE sales_records (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    customer_name VARCHAR(100),
    customer_email VARCHAR(100),
    customer_phone VARCHAR(20),
    order_date DATE,
    product_id INT,
    product_name VARCHAR(100),
    category_id INT,
    category_name VARCHAR(50),
    product_price DECIMAL(10,2),
    quantity INT,
    total_price DECIMAL(10,2),
    country_id INT,
    country_name VARCHAR(50),
    payment_method_id INT,
    payment_method VARCHAR(50)
);

DELIMITER $$

CREATE PROCEDURE InsertSalesData()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 5000 DO
        INSERT INTO sales_records (
            customer_id, customer_name, customer_email, customer_phone, order_date, 
            product_id, product_name, category_id, category_name, product_price, quantity, 
            total_price, country_id, country_name, payment_method_id, payment_method
        )
        VALUES (
            i,  
            CONCAT('Customer_', i),
            CONCAT('customer', i, '@example.com'),
            CONCAT('+234', FLOOR(RAND() * 1000000000)),
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY),
            FLOOR(RAND() * 1000) + 1, 
            CONCAT('Product_', FLOOR(RAND() * 100)),
            FLOOR(RAND() * 10) + 1,  
            CASE FLOOR(RAND() * 5) + 1  
                WHEN 1 THEN 'Electronics'
                WHEN 2 THEN 'Clothing'
                WHEN 3 THEN 'Home & Kitchen'
                WHEN 4 THEN 'Health & Beauty'
                ELSE 'Automobile'
            END,
            ROUND(RAND() * 500 + 50, 2),
            FLOOR(RAND() * 5) + 1,
            ROUND((RAND() * 500 + 50) * (FLOOR(RAND() * 5) + 1), 2),
            FLOOR(RAND() * 5) + 1,  
            CASE FLOOR(RAND() * 5) + 1  
                WHEN 1 THEN 'Nigeria'
                WHEN 2 THEN 'Ghana'
                WHEN 3 THEN 'Kenya'
                WHEN 4 THEN 'South Africa'
                ELSE 'Egypt'
            END,
            FLOOR(RAND() * 3) + 1,  
            CASE FLOOR(RAND() * 3) + 1  
                WHEN 1 THEN 'Credit Card'
                WHEN 2 THEN 'Bank Transfer'
                ELSE 'Mobile Money'
            END
        );
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

-- Call the procedure to insert 5000 rows
CALL InsertSalesData();


SELECT * FROM sales_records LIMIT 10;

-- create  a customer table
create table customers(
customer_id int primary key,
customer_name varchar(255) ,
customer_phone varchar(255),
customer_email varchar(255)
);




insert into customers
select 
	distinct customer_id, 
	customer_name,
    customer_phone,
    customer_email
from sales_records;

-- link the sales_records table to the customers table by creating a reletionship using the foreign key
alter table sales_records add constraint sales_customer_id
foreign key(customer_id) references customers(customer_id)
on delete cascade
on update cascade;

-- create product table

create table products(
product_id  int primary key,
product_name varchar(255),
product_price dec(6,2)
);


insert ignore into products
select distinct product_id,
		product_name,
        product_price
from sales_records; 

-- link the sales_records table to the product table by creating a reletionship using the foreign key
alter table sales_records add constraint sales_product_id
foreign key(product_id) references products(product_id)
on delete cascade
on update cascade;

select *
from sales_records;

-- create categories table

create table categories(
category_id  int primary key,
category_name  varchar(255)
);

insert ignore into categories
select 
	distinct category_id,
    category_name
from 
	sales_records;
    
-- link the sales_records table to the categories table by creating a reletionship using the foreign key
alter table sales_records
add constraint sales_category_id 
foreign key(category_id) references categories(category_id)
on delete cascade
on update cascade;

-- create country table

create table countries(
id int primary key,
country varchar(255)
);

insert ignore into countries
select 
	distinct country_id,
    country_name
from sales_records;

alter table sales_records
add constraint sales_country_id
foreign key(country_id) references countries(id)
on delete cascade
on update cascade; 


-- create payment method table

create table payment_methods(
id int primary key,
payment_method varchar(255)
);

insert ignore into payment_methods
select 
	distinct payment_method_id,
    payment_method
from 
	sales_records;
    
  --  -- link the sales_records table to the sales_payment_methods table by creating a reletionship using the foreign key
alter table sales_records 
add constraint sales_payment_method_id 
foreign key(payment_method_id) references payment_methods(id)
on delete cascade
on update cascade; 


-- drop columns

alter table sales_records
	drop column customer_name,
	drop column	customer_email,
	drop column customer_phone,
    drop column product_name,
	drop column category_name,
    drop column country_name,
	drop column payment_method,
    drop column product_price;



	









