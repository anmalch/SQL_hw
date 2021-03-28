ТЕМА: Операторы, фильтрация, сортировка и ограничение

Задание №1: Пусть в таблице users поля created_at и updated_at 
оказались незаполненными. Заполните их текущими датой и временем.

DROP DATABASE users_database;
CREATE DATABASE users_database;
USE users_database;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';

DESCRIBE users;

INSERT users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
 
UPDATE users
  SET created_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP;

  
SELECT * FROM users;


Задание №2: Таблица users была неудачно спроектирована.
            Записи created_at и updated_at были заданы типом VARCHAR
            и в них долгое время помещались значения в формате 20.10.2017 8:10. 
            Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.


DROP DATABASE users_database;
CREATE DATABASE users_database;
USE users_database;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255), -- created_at VARCHAR
  updated_at VARCHAR (255) -- updated_at VARCHAR
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');

UPDATE users SET created_at = str_to_date(created_at, '%d.%m.%Y %H:%i');
UPDATE users SET updated_at = str_to_date(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;

SELECT * FROM users;



Задание №3: В таблице складских запасов storehouses_products в поле value 
            могут встречаться самые разные цифры: 0, если товар закончился 
            и выше нуля, если на складе имеются запасы. 
            Необходимо отсортировать записи таким образом,
            чтобы они выводились в порядке увеличения значения value. 
            Однако нулевые запасы должны выводиться в конце, после всех записей.

DROP DATABASE shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL  PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) UNIQUE COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX fk_of_catalog_id_idx (catalog_id),
  CONSTRAINT fk_of_catalog_id FOREIGN KEY (catalog_id) REFERENCES catalogs (id)
  
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);



DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO storehouses(name) VALUES 
('shop_1');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED,
  product_id BIGINT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX fk_of_product_id_idx (product_id),
  INDEX value_idx (value),
  CONSTRAINT fk_of_storehouse_id FOREIGN KEY (storehouse_id) REFERENCES storehouses (id),
  CONSTRAINT fk_of_product_id FOREIGN KEY (product_id) REFERENCES products (id)
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 1, 0),
  (1, 2, 2500),
  (1, 3, 0),
  (1, 4, 30),
  (1, 5, 500),
  (1, 6, 1);

SELECT * FROM storehouses_products ORDER BY value = 0, value;

SELECT * FROM storehouses;

Задание №4: (по желанию) Из таблицы users необходимо извлечь пользователей, 
            родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

DROP DATABASE users_database;
CREATE DATABASE users_database;
USE users_database;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at)
VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '2006-08-29');



-- SELECT name, birthday_at FROM users WHERE MONTHNAME(birthday_at) = 'May' OR MONTHNAME(birthday_at) = 'August';
SELECT name, birthday_at FROM users WHERE MONTHNAME(birthday_at) IN ('May', 'August');


Задание №5: (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
            SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, 
            заданном в списке IN.

/* «Операторы, фильтрация, сортировка и ограничение». Для задания 5. */
DROP DATABASE shop;
CREATE DATABASE shop;
USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT * FROM catalogs WHERE id IN (5, 1, 2) 
ORDER BY FIELD(id, 5, 1, 2);

Тема: Агрегация данных

Задание №1: Подсчитайте средний возраст пользователей в таблице users.

DROP DATABASE users_database;

CREATE DATABASE users_database;

USE users_database;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at)
VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '2006-08-29');


SELECT AVG(FLOOR((TO_DAYS(NOW()) - TO_DAYS(birthday_at))/365.25)) AS average 
FROM users;

Задание №2: Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

DROP DATABASE users_database;

CREATE DATABASE users_database;

USE users_database;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at)
VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '2006-08-29');


SELECT COUNT(*), DAYNAME(birthday_at) AS day 
FROM users GROUP BY day;

Задание №3: (по желанию) Подсчитайте произведение чисел в столбце таблицы.

DROP TABLE IF EXISTS x; 

CREATE TABLE x (id INT PRIMARY KEY);

INSERT INTO x VALUES (1), (2), (3), (4), (5);

SELECT exp(sum(LN(id))) AS product 
FROM x;

