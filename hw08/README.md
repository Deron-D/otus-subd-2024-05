# **Лекция №19: Репликация**
> _Разработка проекта_

## **Задание:**
Делаем физическую и логическую репликации

Цель:
Настраивать физическую и логическую репликации.


Описание/Пошаговая инструкция выполнения домашнего задания:
Физическая репликация:

Весь стенд собирается в Docker образах или ВМ. Необходимо:

- Настроить физическую репликации между двумя кластерами базы данных
- Репликация должна работать использую "слот репликации"
- Реплика должна отставать от мастера на 5 минут

Логическая репликация:
В стенд добавить еще один кластер Postgresql. Необходимо:
- Создать на первом кластере базу данных, таблицу и наполнить ее данными (на ваше усмотрение)
- На нем же создать публикацию этой таблицы
- На новом кластере подписаться на эту публикацию
- Убедиться что она среплицировалась. Добавить записи в эту таблицу на основном сервере и убедиться, что они видны на логической реплике

Версия PostgreSQL на ваше усмотрение

Критерии оценки:
Выполнение ДЗ: 10 баллов
плюс 2 балла за красивое решение
минус 2 балла за рабочее решение, и недостатки указанные преподавателем не устранены
---

## **Выполнено:**

### 1. Физическая репликация

- Запускам стенд
~~~bash
cd ./physical
vagrant up
~~~

- Проверяем статус работы мастера:
~~~bash
cd ./physical
vagrant ssh master
sudo su postgres
psql -c 'select * from pg_stat_replication;'
~~~

~~~console
 pid  | usesysid | usename | application_name |  client_addr   | client_hostname | client_port |         backend_start         | backend_xmin |   state   | sent_lsn  | write_lsn | flush_lsn | replay_lsn | write_lag | flush_lag | replay_lag | sync_priority | sync_state |          reply_time           
------+----------+---------+------------------+----------------+-----------------+-------------+-------------------------------+--------------+-----------+-----------+-----------+-----------+------------+-----------+-----------+------------+---------------+------------+-------------------------------
 8149 |    16384 | replica | 15/main          | 192.168.56.151 |                 |       48162 | 2024-09-23 21:11:56.499925+00 |              | streaming | 0/3000148 | 0/3000148 | 0/3000148 | 0/3000148  |           |           |            |             0 | async      | 2024-09-23 21:18:16.657895+00
(1 row)
~~~

- Заносим данные на мастере
~~~bash
cd ./physical
vagrant ssh master
sudo su postgres
psql
CREATE DATABASE test_bd;
\c test_bd
CREATE TABLE t (t int);
INSERT INTO t VALUES(99);
\q
~~~

- Проверяем на реплике через 5 минут
~~~bash
cd ./physical
vagrant ssh slave
sudo su postgres
psql
\c test_bd
SELECT * FROM t;
\q
~~~

~~~console
 t  
----
 99
(1 row)
~~~

- Проверяем размер во времени в отставании реплики от мастера
~~~sql

SELECT now() - pg_last_xact_replay_timestamp();
~~~

~~~console
 SELECT now() - pg_last_xact_replay_timestamp();
    ?column?     
-----------------
 00:05:25.787869
(1 row)
~~~

- Удаляем стенд
~~~bash
cd ./physical
vagrant destroy -f
~~~

### 2. Логическая репликация

- Запускам стенд
~~~bash
cd ./logical
vagrant up
~~~

- Создаем публикацию на мастере
~~~bash
cd ./logical
vagrant ssh master
sudo su postgres
psql
CREATE DATABASE test_bd;
\c test_bd
GRANT pg_read_all_data TO replica;
CREATE TABLE test (t int);
INSERT INTO test VALUES(99);
CREATE PUBLICATION test_pub FOR TABLE test;
SELECT * from pg_publication;
~~~

~~~console
  oid  | pubname  | pubowner | puballtables | pubinsert | pubupdate | pubdelete | pubtruncate | pubviaroot 
-------+----------+----------+--------------+-----------+-----------+-----------+-------------+------------
 16397 | test_pub |       10 | f            | t         | t         | t         | t           | f
(1 row)
~~~

- Создадим подписку на втором экземпляре и проверяем
~~~bash
cd ./logical
vagrant ssh logic
sudo su postgres
psql
CREATE DATABASE test_bd;
\c test_bd
CREATE TABLE test (t int);
CREATE SUBSCRIPTION test_sub CONNECTION 'host=192.168.56.150 port=5432 user=replica password=123456 dbname=test_bd' PUBLICATION test_pub;
SELECT * from test;
SELECT * from pg_subscription;
~~~
 
~~~console
 t  
----
 99
(1 row)

  oid  | subdbid | subskiplsn | subname  | subowner | subenabled | subbinary | substream | subtwophasestate | subdisableonerr |                                subconninfo                                | subslotname | subsynccommit | subpublications 
-------+---------+------------+----------+----------+------------+-----------+-----------+------------------+-----------------+---------------------------------------------------------------------------+-------------+---------------+-----------------
 16392 |   16388 | 0/0        | test_sub |       10 | t          | f         | f         | d                | f               | host=192.168.56.150 port=5432 user=replica password=123456 dbname=test_bd | test_sub    | off           | {test_pub}
(1 row)
~~~