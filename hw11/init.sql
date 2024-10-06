DROP database otus;
CREATE database IF NOT EXISTS otus;
USE otus;

CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
--  description VARCHAR(1000) NOT NULL,
--  category_id INT UNSIGNED NOT NULL REFERENCES category (category_id),
--  supplier_id INT UNSIGNED NOT NULL REFERENCES supplier (supplier_id),
  manufacturer_id INT UNSIGNED REFERENCES manufacturer (manufacturer_id)
--  specifications JSON DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS manufacturers (
  manufacturer_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL
--  email VARCHAR(32) UNIQUE,
--  address VARCHAR(255),
--  phone VARCHAR(20)
);


CREATE TABLE IF NOT EXISTS prices (
  price_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
  product_id INT UNSIGNED,
  price numeric,
  start_date DATE,
  end_date DATE
--  CONSTRAINT Prices_pk PRIMARY KEY (price_id)
);


INSERT INTO manufacturers
    (manufacturer_id, name)
VALUES
    (default, 'Вимм-Билль-Данн'),
    (default, 'Юг Руси'),
    (default, 'Объединенные кондитеры'),
    (default, 'Объединенная сахарная компания» («Продимекс»)'),
    (default, 'Группа “Черкизово'),
    (default, 'Компания “Юнимилк'),
    (default, 'АПХ “Мираторг');

INSERT INTO products
    (id, name, manufacturer_id)
VALUES
    (default, 'Сок яблочный', 1),
    (default, 'Сок томатный', 1),
    (default, 'Йогурт', 1),
    (default, 'Печенье', 3),
    (default, 'Шоколад', 3),
    (default, 'Сервелат', 7),
    (default, 'Вода минеральная', NULL),
    (default, 'Свинина', NULL);

INSERT INTO prices
    (price_id, product_id, price, start_date, end_date)
VALUES
    (default, '1', '45', '2024-09-01', '2024-09-30'),
    (default, '2', '55', '2024-09-01', '2024-09-30');

