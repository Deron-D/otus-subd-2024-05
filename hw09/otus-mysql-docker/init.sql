CREATE database otus;
USE otus;

CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT UNSIGNED NOT NULL,
  supplier_id INT UNSIGNED NOT NULL,
  manufacturer_id INT UNSIGNED NOT NULL,
  CONSTRAINT Products_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS categories (
  category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  CONSTRAINT Categories_pk PRIMARY KEY (category_id)
);

CREATE TABLE IF NOT EXISTS prices (
  price_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  product_id INT UNSIGNED NOT NULL,
  price numeric,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  CONSTRAINT Prices_pk PRIMARY KEY (price_id)
);

CREATE TABLE IF NOT EXISTS suppliers (
  supplier_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20),
  CONSTRAINT Suppliers_pk PRIMARY KEY (supplier_id)
);

CREATE TABLE IF NOT EXISTS manufacturers (
  manufacturer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20),
  CONSTRAINT manufacturers_pk PRIMARY KEY (manufacturer_id)
);

CREATE TABLE IF NOT EXISTS customers (
  customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20),
  CONSTRAINT Customers_pk PRIMARY KEY (customer_id)
);

CREATE TABLE purchases (
  purchase_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  price_id INT UNSIGNED NOT NULL,
  quantity INT NOT NULL,
  purchase_date DATE NOT NULL,
  CONSTRAINT Purchases_pk PRIMARY KEY (purchase_id)
);

ALTER TABLE products ADD CONSTRAINT productscategory_fk0 FOREIGN KEY (category_id) REFERENCES categories(category_id);
ALTER TABLE products ADD CONSTRAINT productssupplier_fk0 FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);
ALTER TABLE products ADD CONSTRAINT productsmanufacturer_fk0 FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(manufacturer_id);

ALTER TABLE prices ADD CONSTRAINT pricesproduct_fk0 FOREIGN KEY (product_id) REFERENCES products(id);

ALTER TABLE purchases ADD CONSTRAINT purchasescustomer_fk0 FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
ALTER TABLE purchases ADD CONSTRAINT purchasesproduct_fk0 FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE purchases ADD CONSTRAINT purchasesshopprice_fk0 FOREIGN KEY (price_id) REFERENCES prices(price_id);