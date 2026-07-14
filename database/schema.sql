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

----------------------------------------------------------
-- GOLD PURCHASES
----------------------------------------------------------

CREATE TABLE gold_purchases (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    purchase_number VARCHAR(30) UNIQUE NOT NULL,

    customer_id UUID NOT NULL REFERENCES customers(id),

    purchase_date TIMESTAMP NOT NULL DEFAULT NOW(),

    gold_price NUMERIC(18,2) NOT NULL,

    total_weight NUMERIC(12,3) NOT NULL,

    total_amount NUMERIC(18,2) NOT NULL,

    paid_amount NUMERIC(18,2) DEFAULT 0,

    remaining_amount NUMERIC(18,2) DEFAULT 0,

    remaining_weight NUMERIC(12,3) DEFAULT 0,

    description TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_gold_purchase_customer
ON gold_purchases(customer_id);

CREATE INDEX idx_gold_purchase_date
ON gold_purchases(purchase_date);

----------------------------------------------------------
-- GOLD PURCHASE ITEMS
----------------------------------------------------------

CREATE TABLE gold_purchase_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    purchase_id UUID NOT NULL REFERENCES gold_purchases(id) ON DELETE CASCADE,

    product_id UUID REFERENCES products(id),

    weight NUMERIC(12,3) NOT NULL,

    gold_price NUMERIC(18,2) NOT NULL,

    labor_percent NUMERIC(8,2) DEFAULT 0,

    accessories_cost NUMERIC(18,2) DEFAULT 0,

    total_price NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_gold_purchase_items_purchase
ON gold_purchase_items(purchase_id);

----------------------------------------------------------
-- SALES INVOICES
----------------------------------------------------------

CREATE TABLE sales_invoices (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    invoice_number VARCHAR(30) UNIQUE NOT NULL,

    customer_id UUID NOT NULL REFERENCES customers(id),

    invoice_date TIMESTAMP NOT NULL DEFAULT NOW(),

    gold_price NUMERIC(18,2) NOT NULL,

    total_gold_amount NUMERIC(18,2) DEFAULT 0,

    total_labor_amount NUMERIC(18,2) DEFAULT 0,

    total_accessories_amount NUMERIC(18,2) DEFAULT 0,

    discount_amount NUMERIC(18,2) DEFAULT 0,

    tax_amount NUMERIC(18,2) DEFAULT 0,

    final_amount NUMERIC(18,2) NOT NULL,

    paid_amount NUMERIC(18,2) DEFAULT 0,

    remaining_amount NUMERIC(18,2) DEFAULT 0,

    description TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_sales_customer
ON sales_invoices(customer_id);

CREATE INDEX idx_sales_date
ON sales_invoices(invoice_date);

----------------------------------------------------------
-- SALES INVOICE ITEMS
----------------------------------------------------------

CREATE TABLE sales_invoice_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    invoice_id UUID NOT NULL REFERENCES sales_invoices(id) ON DELETE CASCADE,

    product_id UUID NOT NULL REFERENCES products(id),

    weight NUMERIC(12,3) NOT NULL,

    gold_price NUMERIC(18,2) NOT NULL,

    purchase_labor_percent NUMERIC(8,2) DEFAULT 0,

    selling_labor_percent NUMERIC(8,2) DEFAULT 0,

    purchase_accessories_price NUMERIC(18,2) DEFAULT 0,

    selling_accessories_price NUMERIC(18,2) DEFAULT 0,

    tax_percent NUMERIC(8,2) DEFAULT 0,

    line_total NUMERIC(18,2) NOT NULL

);

CREATE INDEX idx_sales_items_invoice
ON sales_invoice_items(invoice_id);

CREATE INDEX idx_sales_items_product
ON sales_invoice_items(product_id);

----------------------------------------------------------
-- PAYMENT METHODS
----------------------------------------------------------

CREATE TABLE payment_methods (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) UNIQUE NOT NULL,

    is_active BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT NOW()

);

----------------------------------------------------------
-- PAYMENTS
----------------------------------------------------------

CREATE TABLE payments (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    payment_number VARCHAR(30) UNIQUE NOT NULL,

    customer_id UUID REFERENCES customers(id),

    sales_invoice_id UUID REFERENCES sales_invoices(id),

    gold_purchase_id UUID REFERENCES gold_purchases(id),

    payment_method_id UUID REFERENCES payment_methods(id),

    payment_date TIMESTAMP DEFAULT NOW(),

    amount NUMERIC(18,2) DEFAULT 0,

    gold_weight NUMERIC(12,3) DEFAULT 0,

    reference_number VARCHAR(100),

    description TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_payments_customer
ON payments(customer_id);

CREATE INDEX idx_payments_invoice
ON payments(sales_invoice_id);

CREATE INDEX idx_payments_purchase
ON payments(gold_purchase_id);

----------------------------------------------------------
-- CUSTOMER ACCOUNT TRANSACTIONS
----------------------------------------------------------

CREATE TABLE customer_transactions (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    customer_id UUID NOT NULL REFERENCES customers(id),

    transaction_date TIMESTAMP DEFAULT NOW(),

    transaction_type VARCHAR(30) NOT NULL,

    reference_type VARCHAR(30),

    reference_id UUID,

    debit_amount NUMERIC(18,2) DEFAULT 0,

    credit_amount NUMERIC(18,2) DEFAULT 0,

    debit_gold NUMERIC(12,3) DEFAULT 0,

    credit_gold NUMERIC(12,3) DEFAULT 0,

    balance_rial NUMERIC(18,2) DEFAULT 0,

    balance_gold NUMERIC(12,3) DEFAULT 0,

    description TEXT,

    created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_customer_transactions_customer
ON customer_transactions(customer_id);

CREATE INDEX idx_customer_transactions_date
ON customer_transactions(transaction_date);
----------------------------------------------------------
-- WEIGHT BASED INSTALLMENTS
----------------------------------------------------------

CREATE TABLE installment_contracts (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    contract_number VARCHAR(30) UNIQUE NOT NULL,

    customer_id UUID NOT NULL REFERENCES customers(id),

    sales_invoice_id UUID REFERENCES sales_invoices(id),

    contract_date TIMESTAMP DEFAULT NOW(),

    total_gold_weight NUMERIC(12,3) NOT NULL,

    delivered_gold_weight NUMERIC(12,3) DEFAULT 0,

    remaining_gold_weight NUMERIC(12,3) NOT NULL,

    installment_count INTEGER NOT NULL,

    first_due_date DATE,

    status VARCHAR(30) DEFAULT 'ACTIVE',

    description TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMP DEFAULT NOW(),

    updated_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_installment_customer
ON installment_contracts(customer_id);

----------------------------------------------------------
-- INSTALLMENT ITEMS
----------------------------------------------------------

CREATE TABLE installment_items (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    contract_id UUID NOT NULL REFERENCES installment_contracts(id) ON DELETE CASCADE,

    installment_no INTEGER NOT NULL,

    due_date DATE NOT NULL,

    gold_weight NUMERIC(12,3) NOT NULL,

    paid_gold_weight NUMERIC(12,3) DEFAULT 0,

    remaining_gold_weight NUMERIC(12,3) DEFAULT 0,

    payment_date TIMESTAMP,

    status VARCHAR(30) DEFAULT 'PENDING',

    created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_installment_items_contract
ON installment_items(contract_id);

----------------------------------------------------------
-- CASHBOX
----------------------------------------------------------

CREATE TABLE cashbox_transactions (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    transaction_date TIMESTAMP DEFAULT NOW(),

    transaction_type VARCHAR(30) NOT NULL,

    payment_method VARCHAR(30) NOT NULL,

    amount NUMERIC(18,2) DEFAULT 0,

    gold_weight NUMERIC(12,3) DEFAULT 0,

    reference_type VARCHAR(30),

    reference_id UUID,

    description TEXT,

    created_by UUID REFERENCES users(id),

    created_at TIMESTAMP DEFAULT NOW()

);

CREATE INDEX idx_cashbox_date
ON cashbox_transactions(transaction_date);
