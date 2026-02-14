CREATE DATABASE IF NOT EXISTS farmpoint;
USE farmpoint;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phonenumber VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    date_registered TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    account_type ENUM('buyer', 'seller', 'admin') DEFAULT 'buyer',
    business_name VARCHAR(255),
    business_address TEXT,
    state VARCHAR(100),
    locality VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Product Category Types Table
CREATE TABLE IF NOT EXISTS product_category_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Product Items Types Table (items belong to categories)
CREATE TABLE IF NOT EXISTS product_items_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    items_name VARCHAR(100) NOT NULL,
    category_ID INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_ID) REFERENCES product_category_types(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE KEY unique_item_per_category (items_name, category_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products Table with new schema
-- Note: Multiple products CAN have the same productCategoryID and productItemID
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    refNo VARCHAR(50) NOT NULL UNIQUE,
    seller_ID INT NOT NULL,
    productCategoryID INT NOT NULL,
    productItemID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    image_1 VARCHAR(500),
    image_2 VARCHAR(500),
    location VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seller_ID) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (productCategoryID) REFERENCES product_category_types(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (productItemID) REFERENCES product_items_types(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample users (sellers)
INSERT INTO users (firstname, lastname, email, phonenumber, password, account_type, business_name, business_address, state, locality) VALUES
('John', 'Doe', 'john@example.com', '1234567890', '$2y$10$abcdefghijklmnopqrstuv', 'seller', 'Green Valley Farms', '123 Farm Road', 'Oyo', 'Ibadan'),
('Jane', 'Smith', 'jane@example.com', '0987654321', '$2y$10$abcdefghijklmnopqrstuv', 'seller', 'Fresh Harvest Hub', '456 Orchard Lane', 'Lagos', 'Ikeja');

-- Insert sample product categories
INSERT INTO product_category_types (category_name) VALUES
('Vegetables'),
('Fruits'),
('Dairy'),
('Grains'),
('Livestock');

-- Insert sample product item types (items belong to specific categories)
-- Vegetables items
INSERT INTO product_items_types (items_name, category_ID) VALUES
('Root Vegetables', 1),
('Leafy Greens', 1),
('Organic Vegetables', 1);

-- Fruits items
INSERT INTO product_items_types (items_name, category_ID) VALUES
('Citrus Fruits', 2),
('Berries', 2),
('Organic Fruits', 2);

-- Dairy items
INSERT INTO product_items_types (items_name, category_ID) VALUES
('Milk Products', 3),
('Cheese', 3),
('Yogurt', 3);

-- Grains items
INSERT INTO product_items_types (items_name, category_ID) VALUES
('Whole Grains', 4),
('Processed Grains', 4),
('Rice', 4);

-- Livestock items
INSERT INTO product_items_types (items_name, category_ID) VALUES
('Poultry', 5),
('Beef', 5),
('Pork', 5);

-- Insert sample products with the new schema
INSERT INTO products (refNo, seller_ID, productCategoryID, productItemID, title, price, image_1, image_2, location) VALUES
('PROD-001', 1, 1, 1, 'Fresh Organic Carrots', 2.50, 'https://example.com/images/carrots-1.jpg', 'https://example.com/images/carrots-2.jpg', 'Ibadan, Oyo'),
('PROD-002', 1, 2, 6, 'Red Gala Apples', 3.00, 'https://example.com/images/apples-1.jpg', 'https://example.com/images/apples-2.jpg', 'Ibadan, Oyo'),
('PROD-003', 2, 4, 10, 'Premium Whole Grain Bread', 4.50, 'https://example.com/images/bread-1.jpg', 'https://example.com/images/bread-2.jpg', 'Ikeja, Lagos'),
('PROD-004', 2, 3, 7, 'Local Organic Milk', 8.00, 'https://example.com/images/milk-1.jpg', 'https://example.com/images/milk-2.jpg', 'Ikeja, Lagos');
