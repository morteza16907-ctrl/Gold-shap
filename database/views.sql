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
