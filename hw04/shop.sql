-- создание базы данных
CREATE DATABASE otus;

\connect otus

-- создание схем
CREATE SCHEMA shop;

CREATE TABLESPACE fastspace LOCATION '/var/shop/';
SET default_tablespace = fastspace;

-- Создание пользователя user и reader
CREATE USER "user" WITH ENCRYPTED PASSWORD 'password';
CREATE USER "reader" WITH ENCRYPTED PASSWORD 'password';

-- Назначению пользователю user всех привилегий
GRANT ALL PRIVILEGES ON DATABASE otus TO "user";

-- Создание роли только для чтения
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE otus TO readonly;
GRANT USAGE ON SCHEMA shop TO readonly;


CREATE TABLE shop.products (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  supplier_id INT NOT NULL,
  manufacturer_id INT NOT NULL
);

CREATE INDEX idx_products_name ON shop.products(name);
CREATE INDEX idx_products_category_id_name ON shop.products(category_id,name);
CREATE INDEX idx_products_supplier_id_name ON shop.products(supplier_id,name);
CREATE INDEX idx_products_manufacturer_id_name ON shop.products(manufacturer_id,name);
CREATE INDEX idx_products_supplier_id_manufacturer_id_category_id ON shop.products(supplier_id,manufacturer_id,category_id);
CREATE INDEX idx_products_supplier_id_manufacturer_id_name ON shop.products(supplier_id,manufacturer_id,name);
CREATE INDEX idx_products_supplier_id_category_id_name ON shop.products(supplier_id,category_id,name);

CREATE TABLE shop.categories (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_categories_name ON shop.categories(name);

CREATE TABLE shop.prices (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  price numeric CONSTRAINT positive_price CHECK (price > 0),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
);

CREATE INDEX idx_prices_product_id_start_date_end_date ON shop.prices(product_id,start_date,end_date);
CREATE INDEX idx_prices_price ON shop.prices(price);
CREATE INDEX idx_prices_start_date ON shop.prices(start_date);
CREATE INDEX idx_prices_end_date ON shop.prices(end_date);

CREATE TABLE shop.suppliers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_suppliers_name ON shop.suppliers(name);
CREATE INDEX idx_suppliers_address ON shop.suppliers(address);
CREATE INDEX idx_suppliers_phone ON shop.suppliers(phone);

CREATE TABLE shop.manufacturers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_manufacturers_name ON shop.manufacturers(name);
CREATE INDEX idx_manufacturers_address ON shop.manufacturers(address);
CREATE INDEX idx_manufacturers_phone ON shop.manufacturers(phone);

CREATE TABLE shop.customers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_customers_name ON shop.customers(name);
CREATE INDEX idx_customers_address ON shop.customers(address);
CREATE INDEX idx_customers_phone ON shop.customers(phone);

CREATE TABLE shop.purchases (
  id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  price_id INT NOT NULL,
  quantity INT NOT NULL,
  purchase_date DATE NOT NULL
);

CREATE INDEX idx_purchases_customer_id_purchase_date ON shop.purchases(customer_id,purchase_date,product_id);
CREATE INDEX idx_purchases_product_id ON shop.purchases(product_id);
CREATE INDEX idx_purchases_price_id ON shop.purchases(price_id);
CREATE INDEX idx_purchases_purchase_date ON shop.purchases(purchase_date);

ALTER TABLE shop.products ADD CONSTRAINT productscategory_fk0 FOREIGN KEY (category_id) REFERENCES shop.categories(id);
ALTER TABLE shop.products ADD CONSTRAINT productssupplier_fk0 FOREIGN KEY (supplier_id) REFERENCES shop.suppliers(id);
ALTER TABLE shop.products ADD CONSTRAINT productsmanufacturer_fk0 FOREIGN KEY (manufacturer_id) REFERENCES shop.manufacturers(id);

ALTER TABLE shop.prices ADD CONSTRAINT pricesproduct_fk0 FOREIGN KEY (product_id) REFERENCES shop.products(id);

ALTER TABLE shop.purchases ADD CONSTRAINT purchasescustomer_fk0 FOREIGN KEY (customer_id) REFERENCES shop.customers(id);
ALTER TABLE shop.purchases ADD CONSTRAINT purchasesproduct_fk0 FOREIGN KEY (product_id) REFERENCES shop.products(id);
ALTER TABLE shop.purchases ADD CONSTRAINT purchasesshopprice_fk0 FOREIGN KEY (price_id) REFERENCES shop.prices(id);

