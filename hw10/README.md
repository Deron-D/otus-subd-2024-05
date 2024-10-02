# **Лекция №23: Типы данных в MySQL**
> _Разработка проекта_

## **Задание:**
Домашнее задание
Типы данных

Цель:
Подбирать нужные типы данных;
Определиться с типом ID;
Изучить тип JSON.


Описание/Пошаговая инструкция выполнения домашнего задания:
проанализировать типы данных в своем проекте, изменить при необходимости. В README указать что на что поменялось и почему.
добавить тип JSON в структуру. Проанализировать какие данные могли бы там хранится. привести примеры SQL для добавления записей и выборки.

Критерии оценки:
Выполнение ДЗ: 10 баллов
плюс 2 балла за красивое решение
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены
---

## **Выполнено:**

1. Добавил UNSIGNED NOT NULL UNIQUE к первичным ключам. Заменил создание связей между таблицами с конструкции
`ALTER TABLE ...` на `REFERENCES` в самих таблицах.

2. Добавлен в таблицу `products` тип JSON. 

```sql
CREATE TABLE IF NOT EXISTS products (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
--  description VARCHAR(1000) NOT NULL,
--  category_id INT UNSIGNED NOT NULL REFERENCES category (category_id),
--  supplier_id INT UNSIGNED NOT NULL REFERENCES supplier (supplier_id),
--  manufacturer_id INT UNSIGNED NOT NULL REFERENCES manufacturer (manufacturer_id),
  specifications JSON DEFAULT NULL
);
```
Заносим значения
```
INSERT INTO products(name, specifications) VALUES ('Water', '{"type": "Drinks", "Volume": 1500}');
```

Теперь можем искать с помощью `JSON_EXTRACT`
```
SELECT * FROM products WHERE JSON_EXTRACT(specifications, '$.type') = 'Drinks';
```
