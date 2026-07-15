/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Views
Version: 1.0
=========================================================
*/

----------------------------------------------------------
-- CUSTOMER BALANCES
----------------------------------------------------------

CREATE OR REPLACE VIEW vw_customer_balances AS

SELECT

customer_code,

full_name,

mobile,

balance_type,

rial_balance,

gold_balance,

status

FROM customers;

----------------------------------------------------------
-- AVAILABLE PRODUCTS
----------------------------------------------------------

CREATE OR REPLACE VIEW vw_available_products AS

SELECT

p.id,

p.product_code,

p.title,

p.weight,

p.gold_purity,

p.selling_gold_price,

p.selling_labor_percent,

p.selling_accessories_price,

p.status

FROM products p

WHERE p.status = 'AVAILABLE';

----------------------------------------------------------
-- INVENTORY SUMMARY
----------------------------------------------------------

CREATE OR REPLACE VIEW vw_inventory_summary AS

SELECT

COUNT(*) AS total_products,

SUM(weight) AS total_weight,

SUM(selling_gold_price) AS total_gold_value

FROM products

WHERE status = 'AVAILABLE';
----------------------------------------------------------
-- SALES SUMMARY
----------------------------------------------------------

CREATE OR REPLACE VIEW vw_sales_summary AS

SELECT

COUNT(*) AS total_invoices,

COALESCE(SUM(final_amount),0) AS total_sales,

COALESCE(SUM(paid_amount),0) AS total_received,

COALESCE(SUM(remaining_amount),0) AS total_remaining

FROM sales_invoices;

----------------------------------------------------------
-- CUSTOMER CLUB SUMMARY
----------------------------------------------------------

CREATE OR REPLACE VIEW vw_customer_club AS

SELECT

c.customer_code,

c.full_name,

cc.level_name,

cc.points,

cc.total_purchase,

cc.total_gold_weight

FROM customer_club cc

INNER JOIN customers c

ON c.id = cc.customer_id;

----------------------------------------------------------
-- EXPENSE SUMMARY
----------------------------------------------------------

CREATE OR REPLACE VIEW vw_expense_summary AS

SELECT

category,

COUNT(*) AS total_count,

SUM(amount) AS total_amount

FROM expenses

GROUP BY category;

----------------------------------------------------------
-- CASHBOX SUMMARY
----------------------------------------------------------

CREATE OR REPLACE VIEW vw_cashbox_summary AS

SELECT

payment_method,

SUM(amount) AS total_amount,

SUM(gold_weight) AS total_gold

FROM cashbox_transactions

GROUP BY payment_method;
