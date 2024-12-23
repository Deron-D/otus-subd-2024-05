# **Лекция №31: Резервное копирование и восстановление**
> _Разработка проекта_

## **Задание:**
Домашнее задание
Восстановить таблицу из бэкапа

Цель:
использовать инструмент для резервного копирования и восстановления - xtrabackup;
восстановить конкретную таблицу из сжатого и шифрованного бэкапа;


Описание/Пошаговая инструкция выполнения домашнего задания:
В материалах приложен файл бэкапа backup_des.xbstream.gz.des3 и дамп структуры базы world-db.sql

Бэкап выполнен с помощью команды:

sudo xtrabackup --backup --stream=xbstream
--target-dir=/tmp/backups/xtrabackup/stream
| gzip - | openssl des3 -salt -k "password"
> stream/backup_des.xbstream.gz.des3

Требуется восстановить таблицу world.city из бэкапа и выполнить оператор:
select count(*) from city where countrycode = 'RUS';

Результат оператора написать в чат с преподавателем.


Критерии оценки:
9 баллов - задание выполнено, но есть недочеты
10 баллов - задание выполнено в полном объеме

---

## **Выполнено:**

#### 1. Разворачиваем  `percona-mysql` и `percona-xtrabackup` через docker-compose
~~~bash
docker-compose up -d
~~~

#### 2. Расшифуем архив с бэкапом базы
~~~bash
openssl des3 -d -in backup_des.xbstream.gz-195395-c2cf64.des3 -out backup_des.xbstream.gz -k "password"
~~~

#### 3. Восстановим данные

~~~bash
docker-compose exec percona-mysql bash
~~~

~~~bash
mysql -u root -p12345 world < /tmp/world_db.sql
mysql -u root -p12345 world -e "alter table city discard tablespace;"

cp /tmp/world/city.ibd /var/lib/mysql/world

mysql -u root -p12345 world -e "alter table city import tablespace;"
~~~

#### 4. Выполним оператор

~~~bash
mysql -u root -p12345 world -e "select count(*) from city where countrycode = 'RUS';"
~~~

~~~console
+----------+
| count(*) |
+----------+
|      189 |
+----------+
~~~