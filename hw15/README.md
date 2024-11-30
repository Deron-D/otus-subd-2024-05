# **Лекция №30: Хранимые процедуры и триггеры**
> _Разработка проекта_

## **Задание:**
Добавляем в базу хранимые процедуры и триггеры

Цель:
Создавать пользователей, процедуры и триггеры.


Описание/Пошаговая инструкция выполнения домашнего задания:
Создать пользователей client, manager.
Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры
Также в качестве параметров передавать по какому полю сортировать выборку, и параметры постраничной выдачи

дать права да запуск процедуры пользователю client
Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя) с различными уровнями группировки (по товару, по категории, по производителю)
Права дать пользователю manager

Критерии оценки:
Выполнение ДЗ: 10 баллов
плюс 2 балла за красивое решение
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены


---

## **Выполнено:**

Будем использовать учебную базу [AdventureWorks](https://github.com/tapsey/AdventureWorksMYSQL)

### 1. Создать пользователей client, manager.

~~~mysql
-- Смотрим текущих пользователей
SELECT Host, User FROM mysql.user;

-- Создаем пользователей
CREATE USER 'client'@'%' IDENTIFIED BY 'changeit';
CREATE USER 'manager'@'%' IDENTIFIED BY 'changeit';

-- Проверяем их создание
SELECT Host, User FROM mysql.user;
+-----------+------------------+
| Host      | User             |
+-----------+------------------+
| %         | client           |
| %         | manager          |
| %         | root             |
| localhost | mysql.infoschema |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
~~~


### 2. Создать процедуру выборки товаров с использованием различных фильтров: категория, цена, производитель, различные дополнительные параметры

~~~mysql
DROP PROCEDURE IF EXISTS get_products;

DELIMITER $$

CREATE PROCEDURE get_products (
    IN categoryID INT,
    IN subcategoryID INT,
    IN minPrice DECIMAL(10,2),
    IN maxPrice DECIMAL(10,2),
    IN manufacturerID INT,
    IN additionalFilters JSON -- Для дополнительных параметров
)
BEGIN
    -- Базовый запрос
    SET @query = '
        SELECT 
            p.ProductID,
            p.Name AS ProductName,
            p.ListPrice,
            pc.Name AS CategoryName,
            psc.Name AS SubcategoryName,
            pm.Name AS ManufacturerName
        FROM product p
        LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
        LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
        LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID
        WHERE 1 = 1';

    -- Фильтр по категории
    IF categoryID IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND pc.ProductCategoryID = ', categoryID);
    END IF;

    -- Фильтр по подкатегории
    IF subcategoryID IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND p.ProductSubcategoryID = ', subcategoryID);
    END IF;

    -- Фильтр по минимальной цене
    IF minPrice IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND p.ListPrice >= ', minPrice);
    END IF;

    -- Фильтр по максимальной цене
    IF maxPrice IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND p.ListPrice <= ', maxPrice);
    END IF;

    -- Фильтр по производителю
    IF manufacturerID IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND pm.ProductModelID = ', manufacturerID);
    END IF;

    -- Дополнительные фильтры (например, цвет)
    IF additionalFilters IS NOT NULL THEN
        SET @additionalCondition = JSON_UNQUOTE(JSON_EXTRACT(additionalFilters, '$.color'));
        IF @additionalCondition IS NOT NULL THEN
            SET @query = CONCAT(@query, " AND p.Color = '", @additionalCondition, "'");
        END IF;

        SET @additionalCondition = JSON_UNQUOTE(JSON_EXTRACT(additionalFilters, '$.size'));
        IF @additionalCondition IS NOT NULL THEN
            SET @query = CONCAT(@query, " AND p.Size = '", @additionalCondition, "'");
        END IF;
    END IF;

    -- Выполнение запроса
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
~~~

#### Примеры запросов

~~~mysql
-- Выборка товаров определённой категории с диапозоном цен
CALL get_products(4, NULL, 100, 300, NULL, NULL);
+-----------+-------------------------+-----------+--------------+-----------------+------------------------+
| ProductID | ProductName             | ListPrice | CategoryName | SubcategoryName | ManufacturerName       |
+-----------+-------------------------+-----------+--------------+-----------------+------------------------+
|       876 | Hitch Rack - 4-Bike     |       120 | Accessories  | Bike Racks      | Hitch Rack - 4-Bike    |
|       879 | All-Purpose Bike Stand  |       159 | Accessories  | Bike Stands     | All-Purpose Bike Stand |
|       842 | Touring-Panniers, Large |       125 | Accessories  | Panniers        | Touring-Panniers       |
+-----------+-------------------------+-----------+--------------+-----------------+------------------------+

-- Выборка товаров определённой категории и фальтрацией по цвету
CALL get_products(4, NULL, NULL, NULL, NULL, '{"color": "Black"}');
-----------+-------------------------+-----------+--------------+-----------------+------------------+
| ProductID | ProductName             | ListPrice | CategoryName | SubcategoryName | ManufacturerName |
+-----------+-------------------------+-----------+--------------+-----------------+------------------+
|       708 | Sport-100 Helmet, Black |     34.99 | Accessories  | Helmets         | Sport-100        |
+-----------+-------------------------+-----------+--------------+-----------------+------------------+
~~~

### 3. Дать права на запуск процедуры get_products пользователю client
~~~mysql
GRANT EXECUTE ON PROCEDURE get_products TO 'client'@'%';
~~~

### 4. Создать процедуру get_orders - которая позволяет просматривать отчет по продажам за определенный период (час, день, неделя) с различными уровнями группировки (по товару, по категории, по производителю)
~~~mysq
DROP PROCEDURE IF EXISTS get_orders;
DELIMITER $$

CREATE PROCEDURE get_orders(
    IN startDate DATETIME,               -- Начало периода
    IN endDate DATETIME,                 -- Конец периода
    IN groupByLevel VARCHAR(20)          -- Уровень группировки: 'product', 'category', 'manufacturer'
)
BEGIN
    -- Основной запрос
    SET @query = '
        SELECT 
            ';

    -- Добавление группировки в зависимости от параметра
    CASE groupByLevel
        WHEN 'product' THEN
            SET @query = CONCAT(@query, 'p.Name AS ProductName, SUM(sod.LineTotal) AS TotalSales, SUM(sod.OrderQty) AS TotalQuantity');
            SET @groupBy = 'GROUP BY p.ProductID';
        WHEN 'category' THEN
            SET @query = CONCAT(@query, 'pc.Name AS CategoryName, SUM(sod.LineTotal) AS TotalSales, SUM(sod.OrderQty) AS TotalQuantity');
            SET @groupBy = 'GROUP BY pc.ProductCategoryID';
        WHEN 'manufacturer' THEN
            SET @query = CONCAT(@query, 'pm.Name AS ManufacturerName, SUM(sod.LineTotal) AS TotalSales, SUM(sod.OrderQty) AS TotalQuantity');
            SET @groupBy = 'GROUP BY pm.ProductModelID';
    END CASE;

    -- Добавление основной части запроса
    SET @query = CONCAT(@query, '
        FROM salesorderheader soh
        JOIN salesorderdetail sod ON soh.SalesOrderID = sod.SalesOrderID
        JOIN product p ON sod.ProductID = p.ProductID
        LEFT JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
        LEFT JOIN productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
        LEFT JOIN productmodel pm ON p.ProductModelID = pm.ProductModelID
        WHERE soh.OrderDate BETWEEN \'', startDate, '\' AND \'', endDate, '\' ');

    -- Добавление группировки
    SET @query = CONCAT(@query, @groupBy);

    -- Выполнение запроса
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
~~~

#### Примеры запросов
~~~
-- отчет по продажам за определенный период по товару
CALL get_orders('2004-01-01', '2004-01-31', 'product');

-- отчет по продажам за определенный период по по категории
CALL get_orders('2004-01-01', '2004-01-31', 'category');

-- отчет по продажам за определенный период по производителю
CALL get_orders('2004-01-01', '2004-01-31', 'manufacturer');
~~~

### 6. Права дать пользователю manager

~~~mysql
GRANT EXECUTE ON PROCEDURE get_orders TO 'manager'@'%';
~~~