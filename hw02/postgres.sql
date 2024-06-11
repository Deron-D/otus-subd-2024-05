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

CREATE TABLE categories (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE INDEX idx_name ON categories(name);

CREATE TABLE prices (
  id INT PRIMARY KEY,
  product_id INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products(id)
);

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

CREATE INDEX idx_quantity ON purchases(quantity);