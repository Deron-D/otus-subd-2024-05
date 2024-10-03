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
    (default, 'Йогурт', 1),
    (default, 'Печенье', 2),
    (default, 'Шоколад', 2),
    (default, 'Сервелат', 3),
    (default, 'Вода минеральная', NULL),
    (default, 'Свинина', NULL);


