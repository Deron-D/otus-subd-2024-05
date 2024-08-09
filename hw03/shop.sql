-- создание табличных пространств
-- обычное: для справочников
-- быстрое: для индексов и транзакционных таблиц
CREATE TABLESPACE shoptablespace LOCATION '/var/shop/';
CREATE TABLESPACE fastspace LOCATION '/var/fastspace/';

-- создание базы данных
CREATE DATABASE shop TABLESPACE=shoptablespace;

\connect shop

-- Создание пользователя user и reader
CREATE USER "user" WITH ENCRYPTED PASSWORD 'password';
CREATE USER "reader" WITH ENCRYPTED PASSWORD 'password';

-- Назначению пользователю user всех привилегий
GRANT ALL PRIVILEGES ON DATABASE shop TO "user";

-- Создание роли только для чтения
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE shop TO readonly;

CREATE TABLE products (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  supplier_id INT NOT NULL,
  manufacturer_id INT NOT NULL
);

CREATE INDEX idx_products_name ON products(name) TABLESPACE fastspace;
CREATE INDEX idx_products_category_id_name ON products(category_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_name ON products(supplier_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_manufacturer_id_name ON products(manufacturer_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_manufacturer_id_category_id ON products(supplier_id,manufacturer_id,category_id) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_manufacturer_id_name ON products(supplier_id,manufacturer_id,name) TABLESPACE fastspace;
CREATE INDEX idx_products_supplier_id_category_id_name ON products(supplier_id,category_id,name) TABLESPACE fastspace;

CREATE TABLE categories (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_categories_name ON categories(name) TABLESPACE fastspace;

CREATE TABLE prices (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  price numeric CONSTRAINT positive_price CHECK (price > 0),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
);

CREATE INDEX idx_prices_product_id_start_date_end_date ON prices(product_id,start_date,end_date) TABLESPACE fastspace;
CREATE INDEX idx_prices_price ON prices(price) TABLESPACE fastspace;
CREATE INDEX idx_prices_start_date ON prices(start_date) TABLESPACE fastspace;
CREATE INDEX idx_prices_end_date ON prices(end_date) TABLESPACE fastspace;

CREATE TABLE suppliers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_suppliers_name ON suppliers(name) TABLESPACE fastspace;
CREATE INDEX idx_suppliers_address ON suppliers(address) TABLESPACE fastspace;
CREATE INDEX idx_suppliers_phone ON suppliers(phone) TABLESPACE fastspace;

CREATE TABLE manufacturers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_manufacturers_name ON manufacturers(name) TABLESPACE fastspace;
CREATE INDEX idx_manufacturers_address ON manufacturers(address) TABLESPACE fastspace;
CREATE INDEX idx_manufacturers_phone ON manufacturers(phone) TABLESPACE fastspace;

CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_customers_name ON customers(name) TABLESPACE fastspace;
CREATE INDEX idx_customers_address ON customers(address) TABLESPACE fastspace;
CREATE INDEX idx_customers_phone ON customers(phone) TABLESPACE fastspace;

CREATE TABLE purchases (
  id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  price_id INT NOT NULL,
  quantity INT NOT NULL,
  purchase_date DATE NOT NULL
) TABLESPACE fastspace;

CREATE INDEX idx_purchases_customer_id_purchase_date ON purchases(customer_id,purchase_date,product_id) TABLESPACE fastspace;
CREATE INDEX idx_purchases_product_id ON purchases(product_id) TABLESPACE fastspace;
CREATE INDEX idx_purchases_price_id ON purchases(price_id) TABLESPACE fastspace;
CREATE INDEX idx_purchases_purchase_date ON purchases(purchase_date) TABLESPACE fastspace;

ALTER TABLE products ADD CONSTRAINT productscategory_fk0 FOREIGN KEY (category_id) REFERENCES categories(id);
ALTER TABLE products ADD CONSTRAINT productssupplier_fk0 FOREIGN KEY (supplier_id) REFERENCES suppliers(id);
ALTER TABLE products ADD CONSTRAINT productsmanufacturer_fk0 FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id);

ALTER TABLE prices ADD CONSTRAINT pricesproduct_fk0 FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE purchases ADD CONSTRAINT purchasescustomer_fk0 FOREIGN KEY (customer_id) REFERENCES customers(id);
ALTER TABLE purchases ADD CONSTRAINT purchasesproduct_fk0 FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE purchases ADD CONSTRAINT purchasesshopprice_fk0 FOREIGN KEY (price_id) REFERENCES prices(id);

