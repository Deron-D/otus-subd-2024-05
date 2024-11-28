# **Лекция №27: Индексы**
> _Разработка проекта_

## **Задание:**
Индексы

Цель:
Использовать индексы в MySQL.


Описание/Пошаговая инструкция выполнения домашнего задания:
Пересматриваем индексы на своем проекте. По необходимости меняем.


Задача - сделать полнотекстовый индекс, который ищет по свойствам, названию товара и описанию. Если нет аналогичной задачи в проекте - имитируем.


Итог: анализируем свой проект - добавляем или обновляем индексы.

в README пропишите какие индексы были изменены или добавлены.

explain и результаты выборки без индекса и с индексом.

Реализация полнотекстового индекса.


Критерии оценки:
Выполнение ДЗ: 10 баллов
плюс 2 балла за красивое решение
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены

---

## **Выполнено:**

В качестве БД с большим объемом данных будем использовать учебную базу [AdventureWorks](https://github.com/tapsey/AdventureWorksMYSQL)
```
source /home/root/AdventureWorks-MySQL-with-FKs.sql;
```

- Проверяем, есть ли таблицы без индексов
```mysql
SELECT TABLE_SCHEMA, TABLE_NAME
FROM information_schema.tables AS t
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'adventureworks'
  AND NOT EXISTS (
    SELECT 1
    FROM information_schema.statistics AS s
    WHERE s.TABLE_SCHEMA = t.TABLE_SCHEMA
      AND s.TABLE_NAME = t.TABLE_NAME
  );
```
```console
Empty set (0.00 sec)
```

- Смотрим, какие таблицы уже имеют индексы:

```mysql
SELECT TABLE_SCHEMA, TABLE_NAME
FROM information_schema.tables
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'adventureworks'
  AND TABLE_SCHEMA NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys');
```

- Смотрим описание `productdescription`

```
DESCRIBE productdescription;
+----------------------+---------------+------+-----+-------------------+-------------------+
| Field                | Type          | Null | Key | Default           | Extra             |
+----------------------+---------------+------+-----+-------------------+-------------------+
| ProductDescriptionID | int(11)       | NO   | PRI | NULL              | auto_increment    |
| Description          | mediumtext    | NO   |     | NULL              |                   |
| rowguid              | varbinary(16) | NO   |     | NULL              |                   |
| ModifiedDate         | timestamp     | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
+----------------------+---------------+------+-----+-------------------+-------------------+
```

- Смотрим, какие индексы у `productdescription`
```mysql
SHOW INDEX FROM productdescription;
+--------------------+------------+----------+--------------+----------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| Table              | Non_unique | Key_name | Seq_in_index | Column_name          | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment | Visible | Expression |
+--------------------+------------+----------+--------------+----------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
| productdescription |          0 | PRIMARY  |            1 | ProductDescriptionID | A         |         762 |     NULL |   NULL |      | BTREE      |         |               | YES     | NULL       |
+--------------------+------------+----------+--------------+----------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+---------+------------+
3 rows in set (0.01 sec)
```


- Пробуем выполнить запрос

```mysql
SELECT 
    pm.Name AS ModelName,
    pd.Description AS ModelDescription,
    c.Name AS CultureName
FROM productmodel pm
JOIN productmodelproductdescriptionculture pmpdc 
    ON pm.ProductModelID = pmpdc.ProductModelID
JOIN productdescription pd 
    ON pmpdc.ProductDescriptionID = pd.ProductDescriptionID
JOIN culture c 
    ON pmpdc.CultureID = c.CultureID
WHERE c.CultureID = 'en'
  AND (
      MATCH(pm.Name) AGAINST('Mountain Bottle Cage' IN NATURAL LANGUAGE MODE)
      OR MATCH(pd.Description) AGAINST('Washes off' IN NATURAL LANGUAGE MODE)
  );
```
```console
ERROR 1191 (HY000): Can't find FULLTEXT index matching the column list
```

-  cоздаем полнотекстовые индексы
~~~
ALTER TABLE productmodel
ADD FULLTEXT INDEX ft_name (Name);
~~~
~~~
ALTER TABLE productdescription
ADD FULLTEXT INDEX ft_description (Description);
~~~

- Повторяем запрос и получаем итог

~~~console
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+
| ModelName                 | ModelDescription                                                                                                                                                                                                              | CultureName |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+
| HL Mountain Frame         | Each frame is hand-crafted in our Bothell facility to the optimum diameter and wall-thickness required of a premium mountain frame. The heat-treated welded aluminum frame has a larger diameter tube that absorbs the bumps. | English     |
| LL Mountain Frame         | Our best value utilizing the same, ground-breaking frame technology as the ML aluminum frame.                                                                                                                                 | English     |
| ML Mountain Frame         | The ML frame is a heat-treated aluminum frame made with the same detail and quality as our HL frame. It offers superior performance. Women's version.                                                                         | English     |
| ML Mountain Frame-W       | The ML frame is a heat-treated aluminum frame made with the same detail and quality as our HL frame. It offers superior performance. Men's version.                                                                           | English     |
| Mountain Bike Socks       | Combination of natural and synthetic fibers stays dry and provides just the right cushioning.                                                                                                                                 | English     |
| Mountain-100              | Top-of-the-line competition mountain bike. Performance-enhancing options include the innovative HL Frame, super-smooth front suspension, and traction for all terrain.                                                        | English     |
| Mountain-200              | Serious back-country riding. Perfect for all levels of competition. Uses the same HL Frame as the Mountain-100.                                                                                                               | English     |
| Mountain-300              | For true trail addicts.  An extremely durable bike that will go anywhere and keep you in control on challenging terrain - without breaking your budget.                                                                       | English     |
| Mountain-400-W            | This bike delivers a high-level of performance on a budget. It is responsive and maneuverable, and offers peace-of-mind when you decide to go off-road.                                                                       | English     |
| Mountain-500              | Suitable for any type of riding, on or off-road. Fits any budget. Smooth-shifting with a comfortable ride.                                                                                                                    | English     |
| Women's Mountain Shorts   | Heavy duty, abrasion-resistant shorts feature seamless, lycra inner shorts with anti-bacterial chamois for comfort.                                                                                                           | English     |
| Mountain-400              | Suitable for any type of off-road trip. Fits any budget.                                                                                                                                                                      | English     |
| LL Mountain Front Wheel   | Replacement mountain wheel for entry-level rider.                                                                                                                                                                             | English     |
| ML Mountain Front Wheel   | Replacement mountain wheel for the casual to serious rider.                                                                                                                                                                   | English     |
| HL Mountain Front Wheel   | High-performance mountain replacement wheel.                                                                                                                                                                                  | English     |
| LL Mountain Handlebars    | All-purpose bar for on or off-road.                                                                                                                                                                                           | English     |
| ML Mountain Handlebars    | Tough aluminum alloy bars for downhill.                                                                                                                                                                                       | English     |
| HL Mountain Handlebars    | Flat bar strong enough for the pro circuit.                                                                                                                                                                                   | English     |
| LL Mountain Pedal         | Expanded platform so you can ride in any shoes; great for all-around riding.                                                                                                                                                  | English     |
| ML Mountain Pedal         | Lightweight, durable, clipless pedal with adjustable tension.                                                                                                                                                                 | English     |
| HL Mountain Pedal         | Stainless steel; designed to shed mud easily.                                                                                                                                                                                 | English     |
| LL Mountain Seat/Saddle 1 | Refillable shoes; polished aluminum calipers.                                                                                                                                                                                 | English     |
| ML Mountain Seat/Saddle 1 | 10-speed aluminum derailleur with sealed pulley bearings.                                                                                                                                                                     | English     |
| HL Mountain Seat/Saddle 1 | Replacement rear mountain wheel for entry-level rider.                                                                                                                                                                        | English     |
| LL Mountain Seat/Saddle 2 | Synthetic leather. Features gel for increased comfort.                                                                                                                                                                        | English     |
| ML Mountain Seat/Saddle 2 | Designed to absorb shock.                                                                                                                                                                                                     | English     |
| HL Mountain Seat/Saddle 2 | Anatomic design for a full-day of riding in comfort. Durable leather.                                                                                                                                                         | English     |
| LL Mountain Tire          | Comparible traction, less expensive wire bead casing.                                                                                                                                                                         | English     |
| ML Mountain Tire          | Great traction, high-density rubber.                                                                                                                                                                                          | English     |
| HL Mountain Tire          | Incredible traction, lightweight carbon reinforced.                                                                                                                                                                           | English     |
| Mountain Tire Tube        | Self-sealing tube.                                                                                                                                                                                                            | English     |
| Water Bottle              | AWC logo water bottle - holds 30 oz; leak-proof.                                                                                                                                                                              | English     |
| Mountain Bottle Cage      | Tough aluminum cage holds bottle securly on tough terrain.                                                                                                                                                                    | English     |
| Road Bottle Cage          | Aluminum cage is lighter than our mountain version; perfect for long distance trips.                                                                                                                                          | English     |
| Mountain Pump             | Simple and light-weight. Emergency patches stored in handle.                                                                                                                                                                  | English     |
| Bike Wash                 | Washes off the toughest road grime; dissolves grease, environmentally safe. 1-liter bottle.                                                                                                                                   | English     |
| Fender Set - Mountain     | Clip-on fenders fit most mountain bikes.                                                                                                                                                                                      | English     |
| LL Mountain Rear Wheel    | Replacement mountain wheel for entry-level rider.                                                                                                                                                                             | English     |
| ML Mountain Rear Wheel    | Replacement mountain wheel for the casual to serious rider.                                                                                                                                                                   | English     |
| HL Mountain Rear Wheel    | High-performance mountain replacement wheel.                                                                                                                                                                                  | English     |
+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-------------+
~~~

- Запускаем с EXPLAIN
~~~
 EXPLAIN SELECT      pm.Name AS ModelName,     pd.Description AS ModelDescription,     c.Name AS CultureName FROM productmodel pm JOIN productmodelproductdescriptionculture pmpdc      ON pm.ProductModelID = pmpdc.ProductModelID JOIN productdescription pd      ON pmpdc.ProductDescriptionID = pd.ProductDescriptionID JOIN culture c      ON pmpdc.CultureID = c.CultureID WHERE c.CultureID = 'en'   AND (       MATCH(pm.Name) AGAINST('Mountain Bottle Cage' IN NATURAL LANGUAGE MODE)       OR MATCH(pd.Description) AGAINST('Washes off' IN NATURAL LANGUAGE MODE)   );
+----+-------------+-------+------------+--------+---------------------------+----------+---------+-------------------------------------------+------+----------+--------------------------+
| id | select_type | table | partitions | type   | possible_keys             | key      | key_len | ref                                       | rows | filtered | Extra                    |
+----+-------------+-------+------------+--------+---------------------------+----------+---------+-------------------------------------------+------+----------+--------------------------+
|  1 | SIMPLE      | c     | NULL       | const  | PRIMARY                   | PRIMARY  | 20      | const                                     |    1 |   100.00 | NULL                     |
|  1 | SIMPLE      | pm    | NULL       | ALL    | PRIMARY                   | NULL     | NULL    | NULL                                      |  128 |   100.00 | NULL                     |
|  1 | SIMPLE      | pmpdc | NULL       | ref    | PRIMARY,my_fk_33,my_fk_34 | my_fk_34 | 24      | const,adventureworks.pm.ProductModelID    |    1 |   100.00 | Using where; Using index |
|  1 | SIMPLE      | pd    | NULL       | eq_ref | PRIMARY                   | PRIMARY  | 4       | adventureworks.pmpdc.ProductDescriptionID |    1 |   100.00 | Using where              |
+----+-------------+-------+------------+--------+---------------------------+----------+---------+-------------------------------------------+------+----------+--------------------------+
4 rows in set, 1 warning (0.00 sec)
~~~

- Не находим использование полнотекстового поиска и пробуем упростить запрос
```sql
SELECT 
    pm.Name AS ModelName,
    pd.Description AS ModelDescription,
    c.Name AS CultureName
FROM productmodel pm
JOIN productmodelproductdescriptionculture pmpdc 
    ON pm.ProductModelID = pmpdc.ProductModelID
JOIN productdescription pd 
    ON pmpdc.ProductDescriptionID = pd.ProductDescriptionID
JOIN culture c 
    ON pmpdc.CultureID = c.CultureID
WHERE c.CultureID = 'en'
  AND MATCH(pm.Name) AGAINST('Mountain Bottle Cage' IN NATURAL LANGUAGE MODE);
```

```console
EXPLAIN SELECT      pm.Name AS ModelName,     pd.Description AS ModelDescription,     c.Name AS CultureName FROM productmodel pm JOIN productmodelproductdescriptionculture pmpdc      ON pm.ProductModelID = pmpdc.ProductModelID JOIN productdescription pd      ON pmpdc.ProductDescriptionID = pd.ProductDescriptionID JOIN culture c      ON pmpdc.CultureID = c.CultureID WHERE c.CultureID = 'en'   AND MATCH(pm.Name) AGAINST('Mountain Bottle Cage' IN NATURAL LANGUAGE MODE);
+----+-------------+-------+------------+----------+---------------------------+----------+---------+-------------------------------------------+------+----------+-------------------------------+
| id | select_type | table | partitions | type     | possible_keys             | key      | key_len | ref                                       | rows | filtered | Extra                         |
+----+-------------+-------+------------+----------+---------------------------+----------+---------+-------------------------------------------+------+----------+-------------------------------+
|  1 | SIMPLE      | c     | NULL       | const    | PRIMARY                   | PRIMARY  | 20      | const                                     |    1 |   100.00 | NULL                          |
|  1 | SIMPLE      | pm    | NULL       | fulltext | PRIMARY,ft_name           | ft_name  | 0       | const                                     |    1 |   100.00 | Using where; Ft_hints: sorted |
|  1 | SIMPLE      | pmpdc | NULL       | ref      | PRIMARY,my_fk_33,my_fk_34 | my_fk_34 | 24      | const,adventureworks.pm.ProductModelID    |    1 |   100.00 | Using where; Using index      |
|  1 | SIMPLE      | pd    | NULL       | eq_ref   | PRIMARY                   | PRIMARY  | 4       | adventureworks.pmpdc.ProductDescriptionID |    1 |   100.00 | NULL                          |
+----+-------------+-------+------------+----------+---------------------------+----------+---------+-------------------------------------------+------+----------+-------------------------------+
4 rows in set, 1 warning (0.00 sec)
```
и видим, что для `ft_name` в `productmodel` используется `fulltext`