/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Constraints
Version: 1.0
=========================================================
*/

----------------------------------------------------------
-- CUSTOMERS
----------------------------------------------------------

ALTER TABLE customers
ADD CONSTRAINT chk_customer_rial_balance
CHECK (rial_balance >= 0);

ALTER TABLE customers
ADD CONSTRAINT chk_customer_gold_balance
CHECK (gold_balance >= 0);

----------------------------------------------------------
-- PRODUCTS
----------------------------------------------------------

ALTER TABLE products
ADD CONSTRAINT chk_product_weight
CHECK (weight > 0);

ALTER TABLE products
ADD CONSTRAINT chk_gold_purity
CHECK (gold_purity IN (750, 999));

ALTER TABLE products
ADD CONSTRAINT chk_purchase_gold_price
CHECK (purchase_gold_price >= 0);

ALTER TABLE products
ADD CONSTRAINT chk_selling_gold_price
CHECK (selling_gold_price >= 0);

----------------------------------------------------------
-- SALES
----------------------------------------------------------

ALTER TABLE sales_invoices
ADD CONSTRAINT chk_final_amount
CHECK (final_amount >= 0);

ALTER TABLE sales_invoices
ADD CONSTRAINT chk_paid_amount
CHECK (paid_amount >= 0);

ALTER TABLE sales_invoices
ADD CONSTRAINT chk_remaining_amount
CHECK (remaining_amount >= 0);

----------------------------------------------------------
-- PAYMENTS
----------------------------------------------------------

ALTER TABLE payments
ADD CONSTRAINT chk_payment_amount
CHECK (amount >= 0);

ALTER TABLE payments
ADD CONSTRAINT chk_payment_gold
CHECK (gold_weight >= 0);

----------------------------------------------------------
-- INSTALLMENTS
----------------------------------------------------------

ALTER TABLE installment_contracts
ADD CONSTRAINT chk_installment_weight
CHECK (total_gold_weight > 0);

ALTER TABLE installment_items
ADD CONSTRAINT chk_installment_item_weight
CHECK (gold_weight > 0);

----------------------------------------------------------
-- EXPENSES
----------------------------------------------------------

ALTER TABLE expenses
ADD CONSTRAINT chk_expense_amount
CHECK (amount > 0);

----------------------------------------------------------
-- CUSTOMER CLUB
----------------------------------------------------------

ALTER TABLE customer_club
ADD CONSTRAINT chk_points
CHECK (points >= 0);
