# **Лекция №12: Индексы**
> _Разработка проекта_

## **Задание:**
Индексы PostgreSQL

Цель:
Знать и уметь применять основные виды индексов PostgreSQL;
Построить и анализировать план выполнения запроса;
Оптимизировать запросы для с использованием индексов.


Описание/Пошаговая инструкция выполнения домашнего задания:
Создать индексы на БД, которые ускорят доступ к данным.

В данном задании тренируются навыки:

определения узких мест
- написания запросов для создания индекса
- оптимизации
- Необходимо:
1. Создать индекс к какой-либо из таблиц вашей БД
2. Прислать текстом результат команды explain,
в которой используется данный индекс
3. Реализовать индекс для полнотекстового поиска
4. Реализовать индекс на часть таблицы или индекс
на поле с функцией
5. Создать индекс на несколько полей
6. Написать комментарии к каждому из индексов
7. Описать что и как делали и с какими проблемами
столкнулись

Критерии оценки:
Выполнение ДЗ: 10 баллов
плюс 2 балла за красивое решение
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены
---

## **Выполнено:**

1. Создать индекс к какой-либо из таблиц вашей БД

Используем таблицу `Покупки (purchases)`
~~~roomsql
CREATE TABLE purchases (
id INT PRIMARY KEY,
customer_id INT NOT NULL,
product_id INT NOT NULL,
price_id INT NOT NULL,
quantity INT NOT NULL,
purchase_date DATE NOT NULL,
);
~~~

Заполним данными
~~~roomsql
INSERT INTO purchases (id, customer_id, product_id, price_id, quantity, purchase_date)
VALUES (11, 1, 1, 1, 2, '2024-08-01');
INSERT INTO purchases (id, customer_id, product_id, price_id, quantity, purchase_date)
VALUES (12, 1, 1, 1, 2, '2024-08-02');
INSERT INTO purchases (id, customer_id, product_id, price_id, quantity, purchase_date)
VALUES (13, 1, 1, 1, 2, '2024-08-03');
~~~

Создадим индекс
~~~roomsql
-- После создания индекса запросы, которые используют поле customer_id в условии WHERE, будут выполняться быстрее, 
-- так как база данных будет использовать индекс для поиска соответствующих записей в таблице purchases.
CREATE INDEX idx_customer_id ON purchases (customer_id);
~~~

2. Прислать текстом результат команды explain, в которой используется данный индекс

~~~roomsql
EXPLAIN 
SELECT customer_id FROM purchases WHERE customer_id = 1;
                       QUERY PLAN                        
---------------------------------------------------------
 Seq Scan on purchases  (cost=0.00..1.09 rows=7 width=4)
   Filter: (customer_id = 1)
(2 rows)

~~~

3. Реализовать индекс для полнотекстового поиска

Используем таблицу `Продукты (products)`
~~~roomsql
CREATE TABLE products (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  supplier_id INT NOT NULL,
  manufacturer_id INT NOT NULL,
);
~~~

~~~roomsql
CREATE EXTENSION pg_trgm;
CREATE EXTENSION btree_gin;
CREATE INDEX name_idx ON products USING GIN (name); -- поиск по названию продукта
~~~

4. Реализовать индекс на часть таблицы или индекс на поле с функцией

~~~roomsql
-- Индекс на первые 20 символов поля name в таблице products. 
-- Такой индекс может быть полезен, если мы часто ищем продукты по их названию 
-- и не нуждаемся в индексировании всего поля name.
CREATE INDEX idx_product_name ON products (name(20));
~~~


5. Создать индекс на несколько полей. 

~~~roomsql
-- Cоставной индекс на поля customer_id и purchase_date, для ускорения запросов, которые фильтруют данные по покупателю и дате покупки.
CREATE INDEX idx_customer_purchase ON purchases (customer_id, purchase_date);
~~~

6. Написать комментарии к каждому из индексов

```Комментарии написаны```

7. Описать что и как делали и с какими проблемами столкнулись

```Проблем не было```