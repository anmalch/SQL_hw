Задание №1: Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT DISTINCT u.id, u.name
FROM users AS u 
	JOIN orders AS o
ON 
	u.id = o.user_id;

Задание №2: Выведите список товаров products и разделов catalogs, который соответствует товару.

 SELECT p2.name AS product,
 		c2.name AS catalog
 FROM products p2 
 LEFT JOIN catalogs c2 
 ON 
 	p2.catalog_id = c2.id;

 Задание №3: (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

 DROP DATABASE flights;
CREATE DATABASE flights;
USE flights;



DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255),
  `to` VARCHAR(255)
);

INSERT INTO flights VALUES
  (1, 'moscow', 'omsk'),
  (2, 'novgorod', 'kazan'),
  (3, 'irkutsk', 'moscow'),
  (4, 'omsk', 'irkutsk'),
  (5, 'moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  label VARCHAR(255),
  name VARCHAR(255)
);

INSERT INTO cities VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('kazan', 'Казань'),
  ('omsk', 'Омск');
  
SELECT c_from.name, c_to.name FROM flights f 
JOIN cities c_from ON f.`from` = c_from.label
JOIN cities c_to ON f.`to` = c_to.label;
