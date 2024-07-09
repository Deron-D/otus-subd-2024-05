-- создание табличных пространств
-- обычное: для справочников
-- быстрое: для индексов и транзакционных таблиц
CREATE TABLESPACE shoptablespace LOCATION '/var/shop/';
CREATE TABLESPACE fastspace LOCATION '/var/fastspace/';

-- создание базы данных
CREATE DATABASE shop TABLESPACE=shoptablespace;

\connect shop

-- создание схем
-- логическое разделение на склад и собственно магазин
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

CREATE TABLE stock.products (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  supplier_id INT NOT NULL,
  manufacturer_id INT NOT NULL
);

CREATE INDEX idx_products_name ON stock.products(name) TABLESPACE fastspace;
CREATE INDEX idx_products_category_id_name ON stock.products(category_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_name ON stock.products(supplier_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_manufacturer_id_name ON stock.products(manufacturer_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_manufacturer_id_category_id ON stock.products(supplier_id,manufacturer_id,category_id) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_manufacturer_id_name ON stock.products(supplier_id,manufacturer_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_category_id_name ON stock.products(supplier_id,category_id,name) TABLESPACE fastspace;

CREATE TABLE stock.categories (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_categories_name ON stock.categories(name) TABLESPACE fastspace;

CREATE TABLE shop.prices (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  price numeric CONSTRAINT positive_price CHECK (price > 0),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
);

CREATE INDEX idx_prices_product_id_start_date_end_date ON shop.prices(product_id,start_date,end_date) TABLESPACE fastspace;
CREATE INDEX idx_prices_price ON shop.prices(price) TABLESPACE fastspace;
CREATE INDEX idx_prices_start_date ON shop.prices(start_date) TABLESPACE fastspace;
CREATE INDEX idx_prices_end_date ON shop.prices(end_date) TABLESPACE fastspace;

CREATE TABLE stock.suppliers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_suppliers_name ON stock.suppliers(name) TABLESPACE fastspace;
CREATE INDEX idx_suppliers_address ON stock.suppliers(address) TABLESPACE fastspace;
CREATE INDEX idx_suppliers_phone ON stock.suppliers(phone) TABLESPACE fastspace;

CREATE TABLE stock.manufacturers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_manufacturers_name ON stock.manufacturers(name) TABLESPACE fastspace;
CREATE INDEX idx_manufacturers_address ON stock.manufacturers(address) TABLESPACE fastspace;
CREATE INDEX idx_manufacturers_phone ON stock.manufacturers(phone) TABLESPACE fastspace;

CREATE TABLE stock.customers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_customers_name ON stock.customers(name) TABLESPACE fastspace;
CREATE INDEX idx_customers_address ON stock.customers(address) TABLESPACE fastspace;
CREATE INDEX idx_customers_phone ON stock.customers(phone) TABLESPACE fastspace;

CREATE TABLE shop.purchases (
  id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  price_id INT NOT NULL,
  quantity INT NOT NULL,
  purchase_date DATE NOT NULL
) TABLESPACE fastspace;

CREATE INDEX idx_purchases_customer_id_purchase_date ON shop.purchases(customer_id,purchase_date,product_id) TABLESPACE fastspace;
CREATE INDEX idx_purchases_product_id ON shop.purchases(product_id) TABLESPACE fastspace;
CREATE INDEX idx_purchases_price_id ON shop.purchases(price_id) TABLESPACE fastspace;
CREATE INDEX idx_purchases_purchase_date ON shop.purchases(purchase_date) TABLESPACE fastspace;

ALTER TABLE stock.products ADD CONSTRAINT productscategory_fk0 FOREIGN KEY (category_id) REFERENCES stock.categories(id);
ALTER TABLE stock.products ADD CONSTRAINT productssupplier_fk0 FOREIGN KEY (supplier_id) REFERENCES stock.suppliers(id);
ALTER TABLE stock.products ADD CONSTRAINT productsmanufacturer_fk0 FOREIGN KEY (manufacturer_id) REFERENCES stock.manufacturers(id);

ALTER TABLE shop.prices ADD CONSTRAINT pricesproduct_fk0 FOREIGN KEY (product_id) REFERENCES stock.products(id);

ALTER TABLE shop.purchases ADD CONSTRAINT purchasescustomer_fk0 FOREIGN KEY (customer_id) REFERENCES stock.customers(id);
ALTER TABLE shop.purchases ADD CONSTRAINT purchasesproduct_fk0 FOREIGN KEY (product_id) REFERENCES stock.products(id);
ALTER TABLE shop.purchases ADD CONSTRAINT purchasesshopprice_fk0 FOREIGN KEY (price_id) REFERENCES shop.prices(id);

