/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Schema
Version: 1.0
=========================================================
*/

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE EXTENSION IF NOT EXISTS pgcrypto;

----------------------------------------------------------
-- ENUMS
----------------------------------------------------------

CREATE TYPE customer_type AS ENUM (
'PERSON',
'COMPANY'
);

CREATE TYPE customer_balance_type AS ENUM (
'DEBIT',
'CREDIT',
'ZERO'
);

CREATE TYPE customer_status AS ENUM (
'ACTIVE',
'INACTIVE'
);

----------------------------------------------------------
-- CUSTOMERS
----------------------------------------------------------

CREATE TABLE customers (

id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

customer_code VARCHAR(30) UNIQUE NOT NULL,

full_name VARCHAR(150) NOT NULL,

national_code VARCHAR(20),

mobile VARCHAR(20),

phone VARCHAR(20),

address TEXT,

description TEXT,

customer_type customer_type NOT NULL DEFAULT 'PERSON',

balance_type customer_balance_type NOT NULL DEFAULT 'ZERO',

rial_balance NUMERIC(18,2) DEFAULT 0,

gold_balance NUMERIC(18,3) DEFAULT 0,

status customer_status DEFAULT 'ACTIVE',

created_at TIMESTAMP DEFAULT NOW(),

updated_at TIMESTAMP DEFAULT NOW(),

deleted_at TIMESTAMP

);

CREATE INDEX idx_customer_code
ON customers(customer_code);

CREATE INDEX idx_customer_mobile
ON customers(mobile);

CREATE INDEX idx_customer_name
ON customers(full_name);
