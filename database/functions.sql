/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Functions
Version: 1.0
=========================================================
*/

----------------------------------------------------------
-- CALCULATE PRODUCT PROFIT
----------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_product_profit(

purchase_gold NUMERIC,
selling_gold NUMERIC,
purchase_labor NUMERIC,
selling_labor NUMERIC,
purchase_accessories NUMERIC,
selling_accessories NUMERIC

)

RETURNS NUMERIC

AS
$$

DECLARE

profit NUMERIC;

BEGIN

profit :=

(selling_gold - purchase_gold)

+

(selling_labor - purchase_labor)

+

(selling_accessories - purchase_accessories);

RETURN profit;

END;

$$
LANGUAGE plpgsql IMMUTABLE;

----------------------------------------------------------
-- CALCULATE FINAL PRICE
----------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_final_price(

gold_amount NUMERIC,
labor_amount NUMERIC,
accessories_amount NUMERIC,
tax_amount NUMERIC,
discount_amount NUMERIC

)

RETURNS NUMERIC

AS
$$

BEGIN

RETURN

gold_amount

+

labor_amount

+

accessories_amount

+

tax_amount

-

discount_amount;

END;

$$
LANGUAGE plpgsql IMMUTABLE;

----------------------------------------------------------
-- CALCULATE GOLD VALUE
----------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_gold_value(

weight NUMERIC,
gold_price NUMERIC

)

RETURNS NUMERIC

AS
$$

BEGIN

RETURN weight * gold_price;

END;

$$
LANGUAGE plpgsql IMMUTABLE;
----------------------------------------------------------
-- CALCULATE LABOR PROFIT
----------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_labor_profit(

purchase_percent NUMERIC,
selling_percent NUMERIC,
gold_amount NUMERIC

)

RETURNS NUMERIC

AS
$$

BEGIN

RETURN

((selling_percent - purchase_percent) / 100) * gold_amount;

END;

$$
LANGUAGE plpgsql IMMUTABLE;

----------------------------------------------------------
-- CALCULATE ACCESSORY PROFIT
----------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_accessory_profit(

purchase_price NUMERIC,
selling_price NUMERIC

)

RETURNS NUMERIC

AS
$$

BEGIN

RETURN selling_price - purchase_price;

END;

$$
LANGUAGE plpgsql IMMUTABLE;

----------------------------------------------------------
-- CALCULATE TAX AMOUNT
----------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_tax_amount(

base_amount NUMERIC,
tax_percent NUMERIC

)

RETURNS NUMERIC

AS
$$

BEGIN

RETURN (base_amount * tax_percent) / 100;

END;

$$
LANGUAGE plpgsql IMMUTABLE;

----------------------------------------------------------
-- CALCULATE CUSTOMER CLUB POINTS
----------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_customer_points(

invoice_amount NUMERIC

)

RETURNS NUMERIC

AS
$$

BEGIN

RETURN FLOOR(invoice_amount / 100000);

END;

$$
LANGUAGE plpgsql IMMUTABLE;
