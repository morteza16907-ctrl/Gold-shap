/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Migration
Version: 1.0.0
=========================================================
*/

BEGIN;

----------------------------------------------------------
-- DATABASE VERSION
----------------------------------------------------------

CREATE TABLE IF NOT EXISTS database_version (

    id SERIAL PRIMARY KEY,

    version VARCHAR(20) NOT NULL,

    description TEXT,

    executed_at TIMESTAMP DEFAULT NOW()

);

INSERT INTO database_version (
    version,
    description
)
VALUES (
    '1.0.0',
    'Initial database structure'
);

----------------------------------------------------------
-- DEFAULT ADMIN ROLE
----------------------------------------------------------

INSERT INTO roles (name, description)

SELECT
'Super Admin',
'System Owner'

WHERE NOT EXISTS (

SELECT 1
FROM roles
WHERE name='Super Admin'

);

----------------------------------------------------------
-- DEFAULT SETTINGS
----------------------------------------------------------

INSERT INTO settings
(setting_key,setting_value)

SELECT
'CURRENCY',
'IRR'

WHERE NOT EXISTS (

SELECT 1
FROM settings
WHERE setting_key='CURRENCY'

);

INSERT INTO settings
(setting_key,setting_value)

SELECT
'DEFAULT_GOLD_PURITY',
'750'

WHERE NOT EXISTS (

SELECT 1
FROM settings
WHERE setting_key='DEFAULT_GOLD_PURITY'

);

COMMIT;
