/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Indexes
Version: 1.0
=========================================================
*/

----------------------------------------------------------
-- CUSTOMERS
----------------------------------------------------------

CREATE INDEX idx_customers_full_name
ON customers(full_name);

CREATE INDEX idx_customers_mobile
ON customers(mobile);

CREATE INDEX idx_customers_status
ON customers(status);

----------------------------------------------------------
-- PRODUCTS
----------------------------------------------------------

CREATE INDEX idx_products_category
ON products(category_id);

CREATE INDEX idx_products_status
ON products(status);

CREATE INDEX idx_products_weight
ON products(weight);

----------------------------------------------------------
-- SALES
----------------------------------------------------------

CREATE INDEX idx_sales_invoice_customer_date
ON sales_invoices(customer_id, invoice_date);

CREATE INDEX idx_sales_invoice_created_at
ON sales_invoices(created_at);

----------------------------------------------------------
-- PAYMENTS
----------------------------------------------------------

CREATE INDEX idx_payments_date
ON payments(payment_date);

CREATE INDEX idx_payments_method
ON payments(payment_method_id);

----------------------------------------------------------
-- GOLD PURCHASES
----------------------------------------------------------

CREATE INDEX idx_gold_purchase_customer_date
ON gold_purchases(customer_id, purchase_date);

----------------------------------------------------------
-- CUSTOMER TRANSACTIONS
----------------------------------------------------------

CREATE INDEX idx_customer_transactions_reference
ON customer_transactions(reference_type, reference_id);

----------------------------------------------------------
-- REPAIRS
----------------------------------------------------------

CREATE INDEX idx_repairs_status
ON repairs(status);

----------------------------------------------------------
-- MANUFACTURING
----------------------------------------------------------

CREATE INDEX idx_manufacturing_status
ON manufacturing_orders(status);

----------------------------------------------------------
-- EXPENSES
----------------------------------------------------------

CREATE INDEX idx_expenses_title
ON expenses(title);

----------------------------------------------------------
-- AUDIT LOGS
----------------------------------------------------------

CREATE INDEX idx_audit_logs_user
ON audit_logs(user_id);

CREATE INDEX idx_audit_logs_record
ON audit_logs(record_id);

----------------------------------------------------------
-- ATTACHMENTS
----------------------------------------------------------

CREATE INDEX idx_attachments_record
ON attachments(table_name, record_id);
