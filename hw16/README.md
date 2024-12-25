# **Лекция №31: Оптимизация производительности. Профилирование. Мониторинг**
> _Разработка проекта_

## **Задание:**
Домашнее задание
Анализ и профилирование запроса

Цель:
Проанализировать план выполнения запроса, оценить, на чем теряется время.


Описание/Пошаговая инструкция выполнения домашнего задания:
возьмите сложную выборку из предыдущих ДЗ с несколькими join и подзапросами

постройте EXPLAIN в 3 формата

оцените план прохождения запроса, найдите самые тяжелые места


Задание со *:
оптимизировать запрос (можно использовать индексы, хинты, сбор статистики, гистограммы)


все действия и результаты опишите в README.md


Критерии оценки:
Выполнение ДЗ: 10 баллов
плюс 5 баллов за задание со *
плюс 2 балла за красивое решение
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены

---

## **Выполнено:**

Будем использовать учебную базу [AdventureWorks](https://github.com/tapsey/AdventureWorksMYSQL)


По аналогии с процедурой get_orders сформируем запрос который позволяет просматривать отчет по продажам за определенный период с  группировкой по товару:
```mysql
SELECT 
    p.Name AS productName, 
    SUM(sod.LineTotal) AS TotalSales, 
    SUM(sod.OrderQty) AS TotalQuantity
FROM salesorderheader soh
JOIN salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN product p ON sod.ProductID = p.ProductID
LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID
WHERE soh.OrderDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY p.ProductID, p.Name;
```

#### Выполним EXPLAIN в след. форматах

```console
explain SELECT      p.Name AS productName,      SUM(sod.LineTotal) AS TotalSales,      SUM(sod.OrderQty) AS TotalQuantity FROM salesorderheader soh JOIN salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID JOIN product p ON sod.ProductID = p.ProductID LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID WHERE soh.OrderDate BETWEEN '2004-01-01' AND '2004-01-31' GROUP BY p.ProductID, p.Name;
+----+-------------+-------+------------+--------+-------------------+----------+---------+---------------------------------------+-------+----------+------------------------------+
| id | select_type | table | partitions | type   | possible_keys     | key      | key_len | ref                                   | rows  | filtered | Extra                        |
+----+-------------+-------+------------+--------+-------------------+----------+---------+---------------------------------------+-------+----------+------------------------------+
|  1 | SIMPLE      | soh   | NULL       | ALL    | PRIMARY           | NULL     | NULL    | NULL                                  | 31307 |    11.11 | Using where; Using temporary |
|  1 | SIMPLE      | sod   | NULL       | ref    | my_fk_46,my_fk_47 | my_fk_46 | 4       | adventureworks.soh.SalesOrderID       |     4 |   100.00 | NULL                         |
|  1 | SIMPLE      | p     | NULL       | eq_ref | PRIMARY           | PRIMARY  | 4       | adventureworks.sod.ProductID          |     1 |   100.00 | NULL                         |
|  1 | SIMPLE      | psc   | NULL       | eq_ref | PRIMARY           | PRIMARY  | 4       | adventureworks.p.ProductSubcategoryID |     1 |   100.00 | NULL                         |
|  1 | SIMPLE      | pc    | NULL       | eq_ref | PRIMARY           | PRIMARY  | 4       | adventureworks.psc.ProductCategoryID  |     1 |   100.00 | Using index                  |
|  1 | SIMPLE      | pm    | NULL       | eq_ref | PRIMARY           | PRIMARY  | 4       | adventureworks.p.ProductModelID       |     1 |   100.00 | Using index                  |
+----+-------------+-------+------------+--------+-------------------+----------+---------+---------------------------------------+-------+----------+------------------------------+
6 rows in set, 1 warning (0.00 sec)
```

Самое тяжелое место c type JOIN = `ALL`:
~~~
|  1 | SIMPLE      | soh   | NULL       | ALL    | PRIMARY           | NULL     | NULL    | NULL                                  | 31307 |    11.11 | Using where; Using temporary |
~~~

```
explain SELECT      p.Name AS productName,      SUM(sod.LineTotal) AS TotalSales,      SUM(sod.OrderQty) AS TotalQuantity FROM salesorderheader soh JOIN salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID JOIN product p ON sod.ProductID = p.ProductID LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID WHERE soh.OrderDate BETWEEN '2004-01-01' AND '2004-01-31' GROUP BY p.ProductID, p.Name\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: soh
   partitions: NULL
         type: ALL
possible_keys: PRIMARY
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 31307
     filtered: 11.11
        Extra: Using where; Using temporary
*************************** 2. row ***************************
           id: 1
  select_type: SIMPLE
        table: sod
   partitions: NULL
         type: ref
possible_keys: my_fk_46,my_fk_47
          key: my_fk_46
      key_len: 4
          ref: adventureworks.soh.SalesOrderID
         rows: 4
     filtered: 100.00
        Extra: NULL
*************************** 3. row ***************************
           id: 1
  select_type: SIMPLE
        table: p
   partitions: NULL
         type: eq_ref
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: adventureworks.sod.ProductID
         rows: 1
     filtered: 100.00
        Extra: NULL
*************************** 4. row ***************************
           id: 1
  select_type: SIMPLE
        table: psc
   partitions: NULL
         type: eq_ref
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: adventureworks.p.ProductSubcategoryID
         rows: 1
     filtered: 100.00
        Extra: NULL
*************************** 5. row ***************************
           id: 1
  select_type: SIMPLE
        table: pc
   partitions: NULL
         type: eq_ref
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: adventureworks.psc.ProductCategoryID
         rows: 1
     filtered: 100.00
        Extra: Using index
*************************** 6. row ***************************
           id: 1
  select_type: SIMPLE
        table: pm
   partitions: NULL
         type: eq_ref
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 4
          ref: adventureworks.p.ProductModelID
         rows: 1
     filtered: 100.00
        Extra: Using index
6 rows in set, 1 warning (0.00 sec)
```

~~~console
explain format=json SELECT      p.Name AS productName,      SUM(sod.LineTotal) AS TotalSales,      SUM(sod.OrderQty) AS TotalQuantity FROM salesorderheader soh JOIN salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID JOIN product p ON sod.ProductID = p.ProductID LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID WHERE soh.OrderDate BETWEEN '2004-01-01' AND '2004-01-31' GROUP BY p.ProductID, p.Name\G
*************************** 1. row ***************************
~~~

~~~json
EXPLAIN: {
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "42395.98"
    },
    "grouping_operation": {
      "using_temporary_table": true,
      "using_filesort": false,
      "nested_loop": [
        {
          "table": {
            "table_name": "soh",
            "access_type": "ALL",
            "possible_keys": [
              "PRIMARY"
            ],
            "rows_examined_per_scan": 31307,
            "rows_produced_per_join": 3478,
            "filtered": "11.11",
            "cost_info": {
              "read_cost": "2871.13",
              "eval_cost": "347.82",
              "prefix_cost": "3218.95",
              "data_read_per_join": "2M"
            },
            "used_columns": [
              "SalesOrderID",
              "OrderDate"
            ],
            "attached_condition": "(`adventureworks`.`soh`.`OrderDate` between '2004-01-01' and '2004-01-31')"
          }
        },
        {
          "table": {
            "table_name": "sod",
            "access_type": "ref",
            "possible_keys": [
              "my_fk_46",
              "my_fk_47"
            ],
            "key": "my_fk_46",
            "used_key_parts": [
              "SalesOrderID"
            ],
            "key_length": "4",
            "ref": [
              "adventureworks.soh.SalesOrderID"
            ],
            "rows_examined_per_scan": 4,
            "rows_produced_per_join": 14721,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "14334.07",
              "eval_cost": "1472.18",
              "prefix_cost": "19025.19",
              "data_read_per_join": "2M"
            },
            "used_columns": [
              "SalesOrderID",
              "SalesOrderDetailID",
              "OrderQty",
              "ProductID",
              "LineTotal"
            ]
          }
        },
        {
          "table": {
            "table_name": "p",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "ProductID"
            ],
            "key_length": "4",
            "ref": [
              "adventureworks.sod.ProductID"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 14721,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "3680.44",
              "eval_cost": "1472.18",
              "prefix_cost": "24177.81",
              "data_read_per_join": "5M"
            },
            "used_columns": [
              "ProductID",
              "Name",
              "ProductSubcategoryID",
              "ProductModelID"
            ]
          }
        },
        {
          "table": {
            "table_name": "psc",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "ProductSubcategoryID"
            ],
            "key_length": "4",
            "ref": [
              "adventureworks.p.ProductSubcategoryID"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 14721,
            "filtered": "100.00",
            "cost_info": {
              "read_cost": "3680.44",
              "eval_cost": "1472.18",
              "prefix_cost": "29330.42",
              "data_read_per_join": "2M"
            },
            "used_columns": [
              "ProductSubcategoryID",
              "ProductCategoryID"
            ]
          }
        },
        {
          "table": {
            "table_name": "pc",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "ProductCategoryID"
            ],
            "key_length": "4",
            "ref": [
              "adventureworks.psc.ProductCategoryID"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 14721,
            "filtered": "100.00",
            "using_index": true,
            "cost_info": {
              "read_cost": "3680.44",
              "eval_cost": "1472.18",
              "prefix_cost": "34483.03",
              "data_read_per_join": "2M"
            },
            "used_columns": [
              "ProductCategoryID"
            ]
          }
        },
        {
          "table": {
            "table_name": "pm",
            "access_type": "eq_ref",
            "possible_keys": [
              "PRIMARY"
            ],
            "key": "PRIMARY",
            "used_key_parts": [
              "ProductModelID"
            ],
            "key_length": "4",
            "ref": [
              "adventureworks.p.ProductModelID"
            ],
            "rows_examined_per_scan": 1,
            "rows_produced_per_join": 14721,
            "filtered": "100.00",
            "using_index": true,
            "cost_info": {
              "read_cost": "6440.77",
              "eval_cost": "1472.18",
              "prefix_cost": "42395.98",
              "data_read_per_join": "2M"
            },
            "used_columns": [
              "ProductModelID"
            ]
          }
        }
      ]
    }
  }
}
~~~

~~~console
explain analyze SELECT      p.Name AS productName,      SUM(sod.LineTotal) AS TotalSales,      SUM(sod.OrderQty) AS TotalQuantity FROM salesorderheader soh JOIN salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID JOIN product p ON sod.ProductID = p.ProductID LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID WHERE soh.OrderDate BETWEEN '2004-01-01' AND '2004-01-31' GROUP BY p.ProductID, p.Name\G
*************************** 1. row ***************************
EXPLAIN: -> Table scan on <temporary>  (actual time=0.002..0.017 rows=102 loops=1)
-> Aggregate using temporary table  (actual time=46.340..46.360 rows=102 loops=1)
-> Nested loop left join  (cost=42395.98 rows=14722) (actual time=12.908..41.956 rows=4486 loops=1)
-> Nested loop left join  (cost=34483.03 rows=14722) (actual time=12.901..38.722 rows=4486 loops=1)
-> Nested loop left join  (cost=29330.42 rows=14722) (actual time=12.897..36.807 rows=4486 loops=1)
-> Nested loop inner join  (cost=24177.81 rows=14722) (actual time=12.889..34.195 rows=4486 loops=1)
-> Nested loop inner join  (cost=19025.19 rows=14722) (actual time=12.877..29.501 rows=4486 loops=1)
-> Filter: (soh.OrderDate between '2004-01-01' and '2004-01-31')  (cost=3218.95 rows=3478) (actual time=12.836..23.024 rows=1806 loops=1)
-> Table scan on soh  (cost=3218.95 rows=31307) (actual time=0.032..6.950 rows=31465 loops=1)
-> Index lookup on sod using my_fk_46 (SalesOrderID=soh.SalesOrderID)  (cost=4.12 rows=4) (actual time=0.003..0.003 rows=2 loops=1806)
-> Single-row index lookup on p using PRIMARY (ProductID=sod.ProductID)  (cost=0.25 rows=1) (actual time=0.001..0.001 rows=1 loops=4486)
-> Single-row index lookup on psc using PRIMARY (ProductSubcategoryID=p.ProductSubcategoryID)  (cost=0.25 rows=1) (actual time=0.000..0.000 rows=1 loops=4486)
-> Single-row index lookup on pc using PRIMARY (ProductCategoryID=psc.ProductCategoryID)  (cost=0.25 rows=1) (actual time=0.000..0.000 rows=1 loops=4486)
-> Single-row index lookup on pm using PRIMARY (ProductModelID=p.ProductModelID)  (cost=0.44 rows=1) (actual time=0.001..0.001 rows=1 loops=4486)

1 row in set (0.05 sec)
~~~

#### Оптимизация

Попробуем оптимизировать запрос. Как мы видим в предыдущих построениях `EXPLAIN` получаем:
~~~
"query_cost": "42395.98"
~~~

Из строки с EXPLAIN
~~~
|  1 | SIMPLE      | soh   | NULL       | ALL    | PRIMARY           | NULL     | NULL    | NULL                                  | 31307 |    11.11 | Using where; Using temporary |
~~~

логично, что первочередно лучше добавить индекс на OrderDate
~~~
ALTER TABLE salesorderheader MODIFY COLUMN OrderDate DATETIME DEFAULT '2000-01-01';
CREATE INDEX idx_order_date ON salesorderheader (OrderDate);
~~~

Проверяем
~~~mysql
explain format=json 
SELECT 
    p.Name AS productName, 
    SUM(sod.LineTotal) AS TotalSales, 
    SUM(sod.OrderQty) AS TotalQuantity
FROM salesorderheader soh
JOIN salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN product p ON sod.ProductID = p.ProductID
LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID
WHERE soh.OrderDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY p.ProductID, p.Name;
~~~

~~~json
EXPLAIN: {
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "20706.33"
    },
...
~~~

- Добавление индекса на productName
~~~
CREATE INDEX idx_product_name ON product (Name);
~~~

~~~json
 {
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "15174.62"
    },

~~~

#### Итог: 'query_cost' запроса снизилась с "42395.98" -> "15174.62"