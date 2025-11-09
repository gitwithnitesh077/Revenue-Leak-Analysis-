--create analysis_base_view 0

CREATE VIEW REVENUE_LEAK_VW AS
select p.payment_id,p.customer_id,c.customer_name , c.signup_date,
c.status ,p.expected_amount,p.amount_paid,p.payment_status,
(p.expected_amount - p.amount_paid ) as leak ,
case when expected_amount > amount_paid then 'leak'
else 'no leak'
end as leak_flag ,
ISNULL(latest_s_date,signup_date) as start_date ,
ISNULL( latest_is_active ,0) as is_active , 
CASE 
    WHEN p.amount_paid < 500 THEN 'Basic'
    WHEN p.amount_paid >= 500 AND p.amount_paid < 900 THEN 'Standard'
    WHEN p.amount_paid >= 900 AND p.amount_paid < 1300 THEN 'Premium'
    WHEN p.amount_paid >= 1300 AND p.amount_paid < 2000 THEN 'Business'
    WHEN p.amount_paid >= 2000 THEN 'Enterprise'
    ELSE 'Unpaid'
END AS plan_name
 from dbo.payments as p
left join dbo.customers as c
on p.customer_id = c.customer_id
left join 
(select customer_id ,
max( start_date) as latest_s_date,
MAX(is_active) as latest_is_active ,
max(plan_id) as plan_id 
from 
dbo.subscriptions 
group by customer_id) as s
on p.customer_id = s.customer_id
left join dbo.plans as pl 
on s.plan_id = pl.plan_id ;
 -- preview sample data
 
 select top 10 * from dbo.revenue_leak_vw
 -- count row for both table 
 select count (*)as total_row from revenue_leak_vw;
 select count(*)as total_row_of_payment from dbo.payments;
  -- spot checking data consistancy 
select * FROM DBO.REVENUE_LEAK_VW WHERE PAYMENT_ID = 'PAY00001';
SELECT * FROM DBO.payments WHERE payment_id = 'PAY00001';
-- CHEKING THE NULL IN TABLE 
 
 SELECT 
  SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS null_customers,
  SUM(CASE WHEN expected_amount IS NULL THEN 1 ELSE 0 END) AS null_expected,
  SUM(CASE WHEN amount_paid IS NULL THEN 1 ELSE 0 END) AS null_paid,
  SUM(CASE WHEN plan_name IS NULL THEN 1 ELSE 0 END) AS null_plans
FROM revenue_leak_vw


-- CALCULATE LEA BY REGION
SELECT 
    'Region' AS category_type,
    c.region AS category_value,
    ROUND(SUM(v.expected_amount), 2) AS total_expected,
    ROUND(SUM(v.amount_paid), 2) AS total_paid,
    ROUND(SUM(v.expected_amount - v.amount_paid), 2) AS total_leak,
    CONCAT(FORMAT(SUM(v.expected_amount - v.amount_paid) * 100.0 / SUM(v.expected_amount), 'N2'), '%') AS leak_percentage
FROM revenue_leak_VW AS V
LEFT JOIN customers AS c ON v.customer_id = c.customer_id
GROUP BY c.region

UNION ALL

-- CALCULATE LEAK BY PLAN 
SELECT 
    'Plan' AS category_type,
    v.plan_name AS category_value,
    ROUND(SUM(v.expected_amount), 2),
    ROUND(SUM(v.amount_paid), 2),
    ROUND(SUM(v.expected_amount - v.amount_paid), 2),
    CONCAT(FORMAT(SUM(v.expected_amount - v.amount_paid) * 100.0 / SUM(v.expected_amount), 'N2'), '%')
FROM revenue_leak_VW AS V 
GROUP BY v.plan_name

UNION ALL

-- CALCULATE LEAK BY PAYMENT
SELECT 
    'Payment Status' AS category_type,
    v.payment_status AS category_value,
    ROUND(SUM(v.expected_amount), 2),
    ROUND(SUM(v.amount_paid), 2),
    ROUND(SUM(v.expected_amount - v.amount_paid), 2),
    CONCAT(FORMAT(SUM(v.expected_amount - v.amount_paid) * 100.0 / SUM(v.expected_amount), 'N2'), '%')
FROM revenue_leak_VW AS V
GROUP BY v.payment_status

UNION ALL

-- CALCULATE OVERALL TOTAL LEAK 
SELECT 
    'Overall' AS category_type,
    'All Data' AS category_value,
    ROUND(SUM(v.expected_amount), 2),
    ROUND(SUM(v.amount_paid), 2),
    ROUND(SUM(v.expected_amount - v.amount_paid), 2),
    CONCAT(FORMAT(SUM(v.expected_amount - v.amount_paid) * 100.0 / SUM(v.expected_amount), 'N2'), '%')
FROM revenue_leak_VW AS V ;

-- DEEP ANALYSIS OF ALL PERCENTAGE 

CREATE VIEW DEEP_ANALYSIS_OF_LEAK AS
SELECT 
    c.region,
    v.plan_name,
    v.payment_status,
    ROUND(SUM(v.expected_amount), 2) AS total_expected,
    ROUND(SUM(v.amount_paid), 2) AS total_received,
    ROUND(SUM(v.expected_amount - v.amount_paid), 2) AS total_leak,
    CONCAT(
        FORMAT(
            (SUM(v.expected_amount - v.amount_paid) * 100.0 / SUM(v.expected_amount)), 
            'N2'
        ), 
        '%'
    ) AS leak_percentage
FROM revenue_leak_VW AS V
LEFT JOIN customers AS c 
    ON v.customer_id = c.customer_id
GROUP BY c.region, v.plan_name, v.payment_status
-- TOP LEAKING CUSTOMER 

ALTER VIEW RANK_LEAK_CUSTOMER AS
WITH CUSTOMER_LEAK AS (
    SELECT
        V.CUSTOMER_ID,
        V.CUSTOMER_NAME,
        C.REGION,
        ROUND(SUM(V.expected_amount), 2) AS total_expected,
        ROUND(SUM(V.amount_paid), 2) AS total_paid,
        ROUND(SUM(V.expected_amount - V.amount_paid), 2) AS total_leak,
        CONCAT(
            FORMAT(
                SUM(V.expected_amount - V.amount_paid) * 100.0 / NULLIF(SUM(V.expected_amount), 0),
                'N2'
            ),
            '%'
        ) AS leak_percentage
    FROM revenue_leak_VW AS V
    LEFT JOIN dbo.customers AS C
        ON V.customer_id = C.customer_id
    GROUP BY C.REGION, V.CUSTOMER_ID, V.CUSTOMER_NAME
)
SELECT 
    RANK() OVER (ORDER BY total_leak DESC) AS leak_rank,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    REGION,
    total_expected,
    total_paid,
    total_leak,
    leak_percentage
FROM CUSTOMER_LEAK;

