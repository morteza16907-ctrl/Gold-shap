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
