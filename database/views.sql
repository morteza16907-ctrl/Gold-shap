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
