# **Лекция №22: Внутренняя архитектура СУБД MySQL**
> _Разработка проекта_

## **Задание:**
Домашнее задание
Создаем базу данных MySQL в докере

Цель:
Упаковать скрипы создания БД в контейнер.


Описание/Пошаговая инструкция выполнения домашнего задания:
забрать стартовый репозиторий https://github.com/aeuge/otus-mysql-docker
прописать sql скрипт для создания своей БД в init.sql
проверить запуск и работу контейнера следую описанию в репозитории

Задания повышенной сложности*

прописать кастомный конфиг - настроить innodb_buffer_pool и другие параметры по желанию
протестить сисбенчем - результат теста приложить в README

Возможные проблемы:

не подключается к БД - https://stackoverflow.com/questions/19101243/error-1130-hy000-host-is-not-allowed-to-connect-to-this-mysql-server

на m1 не запускается - https://stackoverflow.com/questions/65456814/docker-apple-silicon-m1-preview-mysql-no-matching-
manifest-for-linux-arm64-v8

Критерии оценки:
10 - контейнер с базой запускается, база создается
плюс 2 балла - также реализован кастомный конфиг
плюс 3 балла - приложены результаты сисбенча
---

## **Выполнено:**

- прописать sql скрипт для создания своей БД в init.sql
- проверить запуск и работу контейнера следую описанию в репозитории

поднимаем сервис и подключаемся
~~~bash
cd ./otus-mysql-docker
docker-compose up -d
docker-compose exec otusdb mysql
~~~

~~~sql
CREATE USER 'root'@'%' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
~~~

проверяем
~~~console
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| otus               |
| performance_schema |
| sbtest             |
| sys                |
+--------------------+
6 rows in set (0.00 sec)

mysql> SHOW TABLES;
+----------------+
| Tables_in_otus |
+----------------+
| categories     |
| customers      |
| manufacturers  |
| prices         |
| products       |
| purchases      |
| suppliers      |
+----------------+
7 rows in set (0.00 sec)
~~~

- прописать кастомный конфиг - настроить innodb_buffer_pool и другие параметры по желанию
```bash
cd ./otus-mysql-docker
docker-compose up -d
docker-compose exec otusdb mysql -u root -p12345 otus
```
~~~sql
SELECT @@innodb_buffer_pool_size/1024/1024/1024;
~~~
~~~console
+------------------------------------------+
| @@innodb_buffer_pool_size/1024/1024/1024 |
+------------------------------------------+
|                           0.125000000000 |
+------------------------------------------+
1 row in set (0.00 sec)
~~~
добавим параметр в [hw09/otus-mysql-docker/custom.conf/my.cnf](hw09/otus-mysql-docker/custom.conf/my.cnf)

~~~ini
innodb-buffer-pool-size=10G
~~~

~~~bash
cd ./otus-mysql-docker
docker-compose down
docker-compose up -d
docker-compose exec otusdb mysql -u root -p12345 otus
~~~

~~~sql
SELECT @@innodb_buffer_pool_size/1024/1024/1024;
~~~

~~~console
+------------------------------------------+
| @@innodb_buffer_pool_size/1024/1024/1024 |
+------------------------------------------+
|                          10.000000000000 |
+------------------------------------------+
1 row in set (0.00 sec)
~~~


- протестить сисбенчем - результат теста приложить в README
```bash
sysbench  \
    --mysql-host=127.0.0.1 \
    --mysql-port=3309 \
    --mysql-db=sbtest \
    --mysql-user=root \
    --mysql-password=12345 \
    --tables=3 \
    --table_size=10000 \
    oltp_read_write prepare
```
```bash
sysbench  \
    --mysql-host=127.0.0.1 \
    --mysql-port=3309 \
    --mysql-db=sbtest \
    --mysql-user=root \
    --mysql-password=12345 \
    --tables=3 \
    --table_size=10000 \
    oltp_read_write run
```

```console
sysbench 1.0.20 (using system LuaJIT 2.1.0-beta3)

Running the test with following options:
Number of threads: 1
Initializing random number generator from current time


Initializing worker threads...

Threads started!

SQL statistics:
    queries performed:
        read:                            34608
        write:                           9888
        other:                           4944
        total:                           49440
    transactions:                        2472   (247.09 per sec.)
    queries:                             49440  (4941.81 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          10.0036s
    total number of events:              2472

Latency (ms):
         min:                                    3.11
         avg:                                    4.04
         max:                                   12.70
         95th percentile:                        4.65
         sum:                                 9995.49

Threads fairness:
    events (avg/stddev):           2472.0000/0.00
    execution time (avg/stddev):   9.9955/0.00

```