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
----------------------------------------------------------
-- PRODUCT STATUS AFTER SALE
----------------------------------------------------------

CREATE OR REPLACE FUNCTION mark_product_as_sold()

RETURNS TRIGGER
AS
$$
BEGIN

UPDATE products

SET
    status='SOLD',
    updated_at=NOW()

WHERE id=NEW.product_id;

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_product_after_sale

AFTER INSERT
ON sales_invoice_items

FOR EACH ROW

EXECUTE FUNCTION mark_product_as_sold();
----------------------------------------------------------
-- CREATE INVENTORY AFTER PRODUCT INSERT
----------------------------------------------------------

CREATE OR REPLACE FUNCTION create_inventory_record()

RETURNS TRIGGER
AS
$$
BEGIN

INSERT INTO inventory(

product_id,
quantity,
available_weight,
purchase_value,
market_value

)

VALUES(

NEW.id,
1,
NEW.weight,
0,
0

);

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_create_inventory

AFTER INSERT
ON products

FOR EACH ROW

EXECUTE FUNCTION create_inventory_record();
----------------------------------------------------------
-- UPDATE CUSTOMER BALANCE AFTER PAYMENT
----------------------------------------------------------

CREATE OR REPLACE FUNCTION update_customer_balance_after_payment()

RETURNS TRIGGER
AS
$$
BEGIN

IF NEW.amount > 0 THEN

UPDATE customers

SET

rial_balance = rial_balance - NEW.amount,

updated_at = NOW()

WHERE id = NEW.customer_id;

END IF;

IF NEW.gold_weight > 0 THEN

UPDATE customers

SET

gold_balance = gold_balance - NEW.gold_weight,

updated_at = NOW()

WHERE id = NEW.customer_id;

END IF;

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_update_customer_balance_after_payment

AFTER INSERT
ON payments

FOR EACH ROW

EXECUTE FUNCTION update_customer_balance_after_payment();

----------------------------------------------------------
-- UPDATE CUSTOMER CLUB AFTER SALE
----------------------------------------------------------

CREATE OR REPLACE FUNCTION update_customer_club_after_sale()

RETURNS TRIGGER
AS
$$
BEGIN

INSERT INTO customer_club(

customer_id,
points,
total_purchase,
total_gold_weight

)

VALUES(

NEW.customer_id,
NEW.final_amount / 100000,
NEW.final_amount,
0

)

ON CONFLICT (customer_id)

DO UPDATE

SET

points = customer_club.points + (NEW.final_amount / 100000),

total_purchase = customer_club.total_purchase + NEW.final_amount,

updated_at = NOW();

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER trg_customer_club_after_sale

AFTER INSERT
ON sales_invoices

FOR EACH ROW

EXECUTE FUNCTION update_customer_club_after_sale();
