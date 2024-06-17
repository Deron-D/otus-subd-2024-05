CREATE TABLE products (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  supplier_id INT NOT NULL,
  manufacturer_id INT NOT NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
  FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

CREATE INDEX idx_name ON products(name);
CREATE INDEX idx_category_id_name ON products(category_id,name);
CREATE INDEX idx_supplier_id_name ON products(supplier_id,name);
CREATE INDEX idx_manufacturer_id_name ON products(manufacturer_id,name);
CREATE INDEX idx_supplier_id_manufacturer_id_category_id ON products(supplier_id,manufacturer_id,category_id);
CREATE INDEX idx_supplier_id_manufacturer_id_name ON products(supplier_id,manufacturer_id,name);
CREATE INDEX idx_supplier_id_category_id_name ON products(supplier_id,category_id,name);

CREATE TABLE categories (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_name ON categories(name);

CREATE TABLE prices (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  price numeric CONSTRAINT positive_price CHECK (price > 0),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE INDEX idx_product_id_start_date_end_date ON prices(product_id,start_date,end_date)
CREATE INDEX idx_price ON prices(price);
CREATE INDEX idx_start_date ON prices(start_date);
CREATE INDEX idx_end_date ON prices(end_date);

CREATE TABLE suppliers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_name ON suppliers(name);
CREATE INDEX idx_address ON suppliers(address);
CREATE INDEX idx_phone ON suppliers(phone)

CREATE TABLE manufacturers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_name ON manufacturers(name);
CREATE INDEX idx_address ON manufacturers(address);
CREATE INDEX idx_phone ON manufacturers(phone);

CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(32) UNIQUE,
  address VARCHAR(255),
  phone VARCHAR(20)
);

CREATE INDEX idx_name ON customers(name);
CREATE INDEX idx_address ON customers(address);
CREATE INDEX idx_phone ON customers(phone);

CREATE TABLE purchases (
  id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  price_id INT NOT NULL,
  quantity INT NOT NULL,
  purchase_date DATE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (price_id) REFERENCES prices(id)
);

CREATE INDEX idx_customer_id_purchase_date ON purchases(customer_id,purchase_date,product_id);
CREATE INDEX idx_product_id ON purchases(product_id);
CREATE INDEX idx_price_id ON purchases(price_id);
CREATE INDEX idx_purchase_date ON purchases(purchase_date);
