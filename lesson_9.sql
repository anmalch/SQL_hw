Практическое задание по теме “Транзакции, переменные, представления”

1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION; 
INSERT INTO sample.users (id, name) SELECT id, name FROM shop.users WHERE id = 1;
DELETE FROM shop.users WHERE id = 1;

COMMIT;


2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.


CREATE VIEW name AS 
SELECT p2.name AS  products,
     c2.name AS catalogs
FROM products p2 
JOIN catalogs c2 
  ON 
  p2.catalog_id = c2.id;



Практическое задание по теме “Хранимые процедуры и функции, триггеры"

1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello ()
RETURNS VARCHAR(255) DETERMINISTIC 
BEGIN
	IF '06:00:00' <= CURRENT_TIME() AND CURRENT_TIME() < '12:00:00' THEN 
		RETURN 'Доброе утро';
	
	ELSEIF '12:00:00' <= CURRENT_TIME() AND CURRENT_TIME() < '18:00:00' THEN 
		RETURN 'Добрый день';
		
	ELSE 
	 	RETURN 'Доброй ночи';
	END IF;
END //

DELIMITER ;

SELECT hello();


2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.



DROP TRIGGER IF EXISTS check_name_and_description_before_insert;
DROP TRIGGER IF EXISTS check_name_and_description_before_update;

DELIMITER //

CREATE TRIGGER check_name_and_description_before_insert  BEFORE INSERT ON products
FOR EACH ROW
BEGIN 
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='INSERT is canceled. Field\'s name and description can not be Null at the same time. At least one of the fields must be filled out.';
	END IF;
END //

CREATE TRIGGER check_name_and_description_before_update  BEFORE UPDATE ON products
FOR EACH ROW
BEGIN 
	IF (NEW.name IS NULL AND NEW.description IS NULL) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='UPDATE is canceled. Field\'s name and description can not be Null at the same time. At least one of the fields must be filled out.';
	END IF;
END //

DELIMITER ;

INSERT INTO products (name, description) VALUES
	(NULL, NULL);

SELECT * FROM products p ;
