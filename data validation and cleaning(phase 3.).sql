-- checking the validate relationship between sub. and customers table
select 
s.subscription_id,s.customer_id,c.customer_id, c.customer_name
from 
dbo.subscriptions as s
left join dbo.customers as c
on s.customer_id = c.customer_id
where c.customer_id is null ;
---- checking the validate relationship between subs and payment
select 
s.subscription_id,s.plan_id,p.plan_id
from 
dbo.subscriptions as s
left join dbo.plans as p
on s.plan_id = p.plan_id
where p.plan_id  is null ;

--checking the validate relationship between subs and payment
select 
p.customer_id,p.payment_id,c.customer_id
from 
dbo.payments as p
left join dbo.customers as c
on p.customer_id = c.customer_id
where p.customer_id  is null ;
-- checking the nulls in customers table tables 
select * from dbo.customers where customer_id is null 
or customer_name is null or
region is null or
signup_date is null or 
status is null;
-- checking the nulls in payment table tables 
select * from dbo.payments where payment_id is null or
customer_id is null or payment_month is null or 
expected_amount is null or amount_paid is null or
payment_status is null;
--checking the nulls in plans table tables 
select * from dbo.plans where plan_id is null or 
plan_name is null or monthly_fee is null or 
discount_rate is null ;
--checking the nulls in subscription table tables 
select * from dbo.subscriptions
where subscription_id is null or customer_id is null or 
plan_id is null or start_date is null or end_date is null or is_active is null ;

-- checking overpayment 

select customer_id, payment_id ,expected_amount ,amount_paid from dbo.payments where  amount_paid > expected_amount
-- checking negative or zero plan 
select * from dbo.plans where monthly_fee < 0 ;
-- check invalid discount 
SELECT *
FROM plans
WHERE discount_rate < 0 OR discount_rate > 1;
--  checking negative or zero expected amount 
select * from dbo.payments where expected_amount <= 0 ;
--checking negative amount paid 

select * from dbo.payments where amount_paid <= 0 ;

-- customers sign up date 
select * from dbo.customers where signup_date >GETDATE() ;

--subscription date logic 
select * from dbo.subscriptions where start_date >= end_date ;
--optional - end date should exist for inactive subs
SELECT *
FROM subscriptions
WHERE is_active = 0 AND end_date IS NULL;
--find active subs that should be inactive 
SELECT subscription_id, customer_id, start_date, end_date, is_active
FROM subscriptions
WHERE end_date < GETDATE() AND is_active = 1;

-- update table where end date expire but is marked is_active 
update subscriptions
set is_active = 0 
where end_date < GETDATE () and is_active = 1;

-- find inactive subscription that should be active 
select subscription_id, customer_id , start_date ,end_date,is_active
from dbo.subscriptions where end_date >= GETDATE () and is_active = 0;

--- update table where end date due but is marked as inactive
update dbo.subscriptions
set is_active = 1 
where end_date >= getdate() and is_active = 0 ;

-- find subs.where end date is missing 
select subscription_id, customer_id, start_date, end_date 
from dbo.subscriptions where end_date is null and is_active = 0;

