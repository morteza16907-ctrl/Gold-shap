/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Seed Data
=========================================================
*/

----------------------------------------------------------
-- ROLES
----------------------------------------------------------

INSERT INTO roles (name, description) VALUES
('Admin','Full Access'),
('Manager','Store Manager'),
('Cashier','Sales Operator'),
('Accountant','Accounting'),
('Viewer','Read Only');

----------------------------------------------------------
-- PAYMENT METHODS
----------------------------------------------------------

INSERT INTO payment_methods (name) VALUES
('Cash'),
('Card'),
('Bank Transfer'),
('Gold'),
('Cheque');

----------------------------------------------------------
-- PRODUCT CATEGORIES
----------------------------------------------------------

INSERT INTO product_categories (name) VALUES
('Ring'),
('Necklace'),
('Bracelet'),
('Earring'),
('Pendant'),
('Coin'),
('Chain'),
('Anklet'),
('Kids'),
('Set');

----------------------------------------------------------
-- SETTINGS
----------------------------------------------------------

INSERT INTO settings
(setting_key,setting_value,description)
VALUES
('SHOP_NAME','Gallery Fanos','Shop Name'),
('DEFAULT_GOLD_PURITY','750','Default Purity'),
('DEFAULT_TAX_PERCENT','3','Default Tax'),
('DEFAULT_LABOR_PERCENT','7','Default Labor'),
('POINTS_PER_100K','1','Customer Club');
