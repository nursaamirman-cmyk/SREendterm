-- SRE Project Database Initialization

CREATE DATABASE IF NOT EXISTS products_db;
CREATE DATABASE IF NOT EXISTS orders_db;
CREATE DATABASE IF NOT EXISTS users_db;

-- Products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER DEFAULT 0,
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT NOW()
);

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT NOW()
);

-- Seed data
INSERT INTO products (name, price, stock, category) VALUES
    ('Laptop Pro', 1299.99, 50, 'Electronics'),
    ('Wireless Mouse', 29.99, 200, 'Accessories'),
    ('Mechanical Keyboard', 89.99, 100, 'Accessories'),
    ('4K Monitor', 499.99, 30, 'Electronics'),
    ('USB-C Hub', 49.99, 150, 'Accessories')
ON CONFLICT DO NOTHING;

INSERT INTO users (username, email, full_name, role) VALUES
    ('admin', 'admin@example.com', 'Admin User', 'admin'),
    ('user1', 'user1@example.com', 'Regular User', 'user'),
    ('testuser', 'test@example.com', 'Test User', 'user')
ON CONFLICT DO NOTHING;
