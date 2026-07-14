/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Triggers
Version: 1.0
=========================================================
*/

----------------------------------------------------------
-- UPDATE updated_at AUTOMATICALLY
----------------------------------------------------------

CREATE OR REPLACE FUNCTION update_updated_at_column()

RETURNS TRIGGER
AS
$$
BEGIN

NEW.updated_at = NOW();

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

----------------------------------------------------------
-- CUSTOMERS
----------------------------------------------------------

CREATE TRIGGER trg_customers_updated_at

BEFORE UPDATE
ON customers

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- PRODUCTS
----------------------------------------------------------

CREATE TRIGGER trg_products_updated_at

BEFORE UPDATE
ON products

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- PRODUCT CATEGORIES
----------------------------------------------------------

CREATE TRIGGER trg_product_categories_updated_at

BEFORE UPDATE
ON product_categories

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- INVENTORY
----------------------------------------------------------

CREATE TRIGGER trg_inventory_updated_at

BEFORE UPDATE
ON inventory

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- USERS
----------------------------------------------------------

CREATE TRIGGER trg_users_updated_at

BEFORE UPDATE
ON users

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- GOLD PURCHASES
----------------------------------------------------------

CREATE TRIGGER trg_gold_purchases_updated_at

BEFORE UPDATE
ON gold_purchases

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- SALES INVOICES
----------------------------------------------------------

CREATE TRIGGER trg_sales_invoices_updated_at

BEFORE UPDATE
ON sales_invoices

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- INSTALLMENT CONTRACTS
----------------------------------------------------------

CREATE TRIGGER trg_installments_updated_at

BEFORE UPDATE
ON installment_contracts

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- REPAIRS
----------------------------------------------------------

CREATE TRIGGER trg_repairs_updated_at

BEFORE UPDATE
ON repairs

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();

----------------------------------------------------------
-- MANUFACTURING ORDERS
----------------------------------------------------------

CREATE TRIGGER trg_manufacturing_updated_at

BEFORE UPDATE
ON manufacturing_orders

FOR EACH ROW

EXECUTE FUNCTION update_updated_at_column();
