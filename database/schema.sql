/*
=========================================================
Gold ERP
Enterprise Jewelry ERP
Database Schema
Version: 1.0
=========================================================
*/

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

----------------------------------------------------------
-- ENUM TYPES
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

CREATE TYPE product_status AS ENUM (
    'AVAILABLE',
    'SOLD',
    'RESERVED',
    'REPAIR',
    'MELTED',
    'ARCHIVED'
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

CREATE INDEX idx_customer_name
ON customers(full_name);

CREATE INDEX idx_customer_mobile
ON customers(mobile);

----------------------------------------------------------
-- PRODUCT CATEGORIES
----------------------------------------------------------

CREATE TABLE product_categories (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    deleted_at TIMESTAMP

);

----------------------------------------------------------
-- PRODUCTS
----------------------------------------------------------

CREATE TABLE products (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_code VARCHAR(30) UNIQUE NOT NULL,

    barcode VARCHAR(100),

    qr_code VARCHAR(255),

    serial_number VARCHAR(100) UNIQUE,

    category_id UUID REFERENCES product_categories(id),

    title VARCHAR(200) NOT NULL,

    description TEXT,

    gold_purity SMALLINT NOT NULL DEFAULT 750,

    weight NUMERIC(12,3) NOT NULL,

    purchase_gold_price NUMERIC(18,2) DEFAULT 0,

    selling_gold_price NUMERIC(18,2) DEFAULT 0,

    purchase_labor_percent NUMERIC(8,2) DEFAULT 0,

    selling_labor_percent NUMERIC(8,2) DEFAULT 0,

    purchase_accessories_cost NUMERIC(18,2) DEFAULT 0,

    selling_accessories_price NUMERIC(18,2) DEFAULT 0,

    tax_percent NUMERIC(8,2) DEFAULT 0,

    image_url TEXT,

    status product_status DEFAULT 'AVAILABLE',

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    deleted_at TIMESTAMP

);

CREATE INDEX idx_product_code
ON products(product_code);

CREATE INDEX idx_product_barcode
ON products(barcode);

CREATE INDEX idx_product_serial
ON products(serial_number);
----------------------------------------------------------
-- PRODUCT IMAGES
----------------------------------------------------------

CREATE TABLE product_images (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

    image_url TEXT NOT NULL,

    sort_order INTEGER DEFAULT 1,

    created_at TIMESTAMP DEFAULT NOW()

);

----------------------------------------------------------
-- INVENTORY
----------------------------------------------------------

CREATE TABLE inventory (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID UNIQUE NOT NULL REFERENCES products(id),

    quantity INTEGER DEFAULT 1,

    available_weight NUMERIC(12,3) NOT NULL,

    purchase_value NUMERIC(18,2) DEFAULT 0,

    market_value NUMERIC(18,2) DEFAULT 0,

    gold_difference NUMERIC(12,3) DEFAULT 0,

    location VARCHAR(100),

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_inventory_product
ON inventory(product_id);

----------------------------------------------------------
-- GOLD PRICE HISTORY
----------------------------------------------------------

CREATE TABLE gold_price_history (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    price_750 NUMERIC(18,2) NOT NULL,

    price_999 NUMERIC(18,2),

    source VARCHAR(100),

    created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_gold_price_date
ON gold_price_history(created_at);
----------------------------------------------------------
-- ACCESSORIES
----------------------------------------------------------

CREATE TABLE accessories (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) NOT NULL,

    purchase_price NUMERIC(18,2) DEFAULT 0,

    selling_price NUMERIC(18,2) DEFAULT 0,

    description TEXT,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

----------------------------------------------------------
-- PRODUCT ACCESSORIES
----------------------------------------------------------

CREATE TABLE product_accessories (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,

    accessory_id UUID NOT NULL REFERENCES accessories(id),

    quantity NUMERIC(10,2) DEFAULT 1,

    purchase_total NUMERIC(18,2) DEFAULT 0,

    selling_total NUMERIC(18,2) DEFAULT 0,

    created_at TIMESTAMP DEFAULT NOW()

);

----------------------------------------------------------
-- PRODUCT STOCK MOVEMENTS
----------------------------------------------------------

CREATE TABLE inventory_movements (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL REFERENCES products(id),

    movement_type VARCHAR(30) NOT NULL,

    quantity INTEGER DEFAULT 1,

    weight NUMERIC(12,3),

    description TEXT,

    created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_inventory_movements_product
ON inventory_movements(product_id);

----------------------------------------------------------
-- PRODUCT TAGS
----------------------------------------------------------

CREATE TABLE product_tags (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) UNIQUE NOT NULL

);

CREATE TABLE product_tag_items (

    product_id UUID REFERENCES products(id) ON DELETE CASCADE,

    tag_id UUID REFERENCES product_tags(id) ON DELETE CASCADE,

    PRIMARY KEY(product_id, tag_id)

);

----------------------------------------------------------
-- USERS
----------------------------------------------------------

CREATE TABLE users (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    full_name VARCHAR(150) NOT NULL,

    username VARCHAR(100) UNIQUE NOT NULL,

    password_hash TEXT NOT NULL,

    mobile VARCHAR(20),

    email VARCHAR(150),

    is_active BOOLEAN DEFAULT TRUE,

    last_login TIMESTAMP,

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW(),

    deleted_at TIMESTAMP

);

----------------------------------------------------------
-- ROLES
----------------------------------------------------------

CREATE TABLE roles (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT

);

----------------------------------------------------------
-- PERMISSIONS
----------------------------------------------------------

CREATE TABLE permissions (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    permission_key VARCHAR(150) UNIQUE NOT NULL,

    description TEXT

);

----------------------------------------------------------
-- USER ROLES
----------------------------------------------------------

CREATE TABLE user_roles (

    user_id UUID REFERENCES users(id) ON DELETE CASCADE,

    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,

    PRIMARY KEY(user_id, role_id)

);

----------------------------------------------------------
-- ROLE PERMISSIONS
----------------------------------------------------------

CREATE TABLE role_permissions (

    role_id UUID REFERENCES roles(id) ON DELETE CASCADE,

    permission_id UUID REFERENCES permissions(id) ON DELETE CASCADE,

    PRIMARY KEY(role_id, permission_id)

);

CREATE INDEX idx_users_username
ON users(username);

CREATE INDEX idx_users_mobile
ON users(mobile);
