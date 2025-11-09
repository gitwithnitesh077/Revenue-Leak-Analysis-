--- create a data base for revenue leak project 
create database revenue_leak_detection;

--Create plans table 

CREATE TABLE plans 
( plan_id VARCHAR(10) PRIMARY KEY, 
plan_name VARCHAR(50), 
monthly_fee DECIMAL(10,2), 
discount_rate DECIMAL(5,2) ); 

-- Create customers table 
CREATE TABLE customers 
( customer_id VARCHAR(10) PRIMARY KEY,
name VARCHAR(100), 
region VARCHAR(50),
signup_date DATE, 
status VARCHAR(20) );

-- Create subscriptions table 
CREATE TABLE subscriptions 
( subscription_id VARCHAR(10) PRIMARY KEY,
customer_id VARCHAR(10), plan_id VARCHAR(10),
start_date DATE, end_date DATE NULL, is_active TINYINT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id), 
FOREIGN KEY (plan_id) REFERENCES plans(plan_id) );

 -- Create payments table 
 CREATE TABLE payments ( payment_id VARCHAR(15) PRIMARY KEY, 
 customer_id VARCHAR(10), payment_month VARCHAR(7), 
 expected_amount DECIMAL(10,2), amount_paid DECIMAL(10,2),
 payment_status VARCHAR(20), 
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id) )















