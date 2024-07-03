-- создание базы данных
CREATE DATABASE shop;

-- создание схем
CREATE SCHEMA shop;
CREATE SCHEMA stock;

-- Создание пользователя user и reader
CREATE USER "user" WITH ENCRYPTED PASSWORD 'password';
CREATE USER "reader" WITH ENCRYPTED PASSWORD 'password';

-- Назначению пользователю user всех привилегий
GRANT ALL PRIVILEGES ON DATABASE shop TO "user";

-- Создание роли только для чтения
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE shop TO readonly;
GRANT USAGE ON SCHEMA shop TO readonly;
GRANT USAGE ON SCHEMA stock TO readonly;

CREATE TABLE shop.products (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  supplier_id INT NOT NULL,
  manufacturer_id INT NOT NULL
);

CREATE INDEX idx_name ON shop.products(name);
CREATE INDEX idx_category_id_name ON shop.products(category_id,name);
CREATE INDEX idx_supplier_id_name ON shop.products(supplier_id,name);
CREATE INDEX idx_manufacturer_id_name ON shop.products(manufacturer_id,name);
CREATE INDEX idx_supplier_id_manufacturer_id_category_id ON shop.products(supplier_id,manufacturer_id,category_id);
CREATE INDEX idx_supplier_id_manufacturer_id_name ON shop.products(supplier_id,manufacturer_id,name);
CREATE INDEX idx_supplier_id_category_id_name ON shop.products(supplier_id,category_id,name);

CREATE TABLE shop.categories (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_name ON shop.categories(name);

CREATE TABLE shop.prices (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  price numeric CONSTRAINT positive_price CHECK (price > 0),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
);

CREATE INDEX idx_product_id_start_date_end_date ON shop.prices(product_id,start_date,end_date)
CREATE INDEX idx_price ON shop.prices(price);
CREATE INDEX idx_start_date ON shop.prices(start_date);
CREATE INDEX idx_end_date ON shop.prices(end_date);

CREATE TABLE stock.suppliers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_name ON stock.suppliers(name);
CREATE INDEX idx_address ON stock.suppliers(address);
CREATE INDEX idx_phone ON stock.suppliers(phone)

CREATE TABLE stock.manufacturers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_name ON stock.manufacturers(name);
CREATE INDEX idx_address ON stock.manufacturers(address);
CREATE INDEX idx_phone ON stock.manufacturers(phone);

CREATE TABLE stock.customers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_name ON stock.customers(name);
CREATE INDEX idx_address ON stock.customers(address);
CREATE INDEX idx_phone ON stock.customers(phone);

CREATE TABLE shop.purchases (
  id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  price_id INT NOT NULL,
  quantity INT NOT NULL,
  purchase_date DATE NOT NULL
);

CREATE INDEX idx_customer_id_purchase_date ON shop.purchases(customer_id,purchase_date,product_id);
CREATE INDEX idx_product_id ON shop.purchases(product_id);
CREATE INDEX idx_price_id ON shop.purchases(price_id);
CREATE INDEX idx_purchase_date ON shop.purchases(purchase_date);

ALTER TABLE shop.products ADD CONSTRAINT productcategory_fk0 FOREIGN KEY (category_id) REFERENCES shop.categories(id);
ALTER TABLE shop.products ADD CONSTRAINT productsupplier_fk0 FOREIGN KEY (supplier_id) REFERENCES stock.suppliers(id);
ALTER TABLE shop.products ADD CONSTRAINT productmanufacturer_fk0 FOREIGN KEY (manufacturer_id) REFERENCES stock.manufacturers(id);

ALTER TABLE shop.prices ADD CONSTRAINT pricesproduct_fk0 FOREIGN KEY (product_id) REFERENCES shop.products(id);

shop.purchases
  FOREIGN KEY (customer_id) REFERENCES stock.customers(id),
  FOREIGN KEY (product_id) REFERENCES shop.products(id),
  FOREIGN KEY (price_id) REFERENCES shop.prices(id)

