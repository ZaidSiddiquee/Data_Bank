SELECT * FROM regions;
SELECT * FROM customer_nodes LIMIT 10;
SELECT * FROM customer_transactions limit 10;

#Q1. How many different nodes make up the Data Bank network?

SELECT COUNT(DISTINCT(node_id)) FROM customer_nodes;

#Q2. How many nodes are there in each region?

SELECT COUNT(cn.node_id) AS No_of_nodes , r.region_name FROM customer_nodes as cn INNER JOIN regions as r
ON cn.region_id = r.region_id
GROUP BY r.region_name
ORDER BY No_of_nodes desc; 

#Q3. How many customers are divided among the regions
SELECT COUNT(distinct(ct.customer_id)) AS No_of_customers, r.region_name FROM customer_transactions AS ct INNER JOIN customer_nodes as cn
ON ct.customer_id = cn.customer_id INNER JOIN regions as r ON cn.region_id = r.region_id
GROUP BY r.region_name
ORDER BY No_of_customers desc;

#Q4. Determine the total amount of transactions for each region name.

SELECT r.region_name, SUM(ct.txn_amount) as Total_transactions  FROM customer_transactions AS ct INNER JOIN customer_nodes as cn
ON ct.customer_id = cn.customer_id INNER JOIN regions as r ON cn.region_id = r.region_id
GROUP BY r.region_name
ORDER BY Total_transactions desc;

#Q5. How long does it take on an average to move clients to a new node?

SELECT round(AVG(DATEDIFF(end_date,start_date)),2) as Avg_days FROM customer_nodes
where end_date != "9999-12-31" ;

#Q6. What is the unique count and total amount for each transaction type?

SELECT Txn_type, COUNT(*) AS Unique_count, SUM(txn_amount) as Total_amount
FROM customer_transactions
GROUP BY Txn_type;

#Q7. What is the average number and size of past deposits across all customers?

SELECT ROUND(COUNT(customer_id)/(SELECT COUNT(DISTINCT(customer_id)) FROM customer_transactions)) as Avg_deposit_amount
FROM customer_transactions
WHERE Txn_type = "deposit";

#Q8. For each month how many Data Bank customers make more than 1 deposit and at least either 1 purchase or 1 withdrawal in a single month

WITH transaction_count_per_month_cte as
(SELECT customer_id, month(txn_date) as txn_months, SUM(if(txn_type = "deposit",1,0)) as deposit_count,
SUM(if(txn_type = "withdrawal",1,0)) as withdrawl_count,
SUM(if(txn_type = "purchase",1,0)) as purchase_count
FROM customer_transactions
GROUP BY customer_id,  txn_months)

SELECT txn_months, COUNT(DISTINCT(customer_id)) as customer_count FROM transaction_count_per_month_cte
where deposit_count > 1 AND 
purchase_count > 1 or 
 withdrawl_count > 1
 GROUP BY txn_months



 









