Задание №1: Пусть задан некоторый пользователь.
			Найдите человека, который больше всех общался с нашим пользователем, иначе, кто написал пользователю наибольшее число сообщений. (можете взять пользователя с любым id).

SELECT COUNT(from_user_id), from_user_id FROM messages WHERE to_user_id=6 
GROUP BY from_user_id
ORDER BY COUNT(from_user_id) DESC 
LIMIT 1;



Задание №2: Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.

SELECT COUNT(like_type) FROM posts_likes WHERE user_id IN 
	(SELECT user_id 
	 FROM profiles
	 WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18);


Задание №3: Определить, кто больше поставил лайков (всего) - мужчины или женщины?

SELECT (SELECT p.gender FROM profiles p WHERE p.user_id = l.user_id) AS gender, COUNT(*) AS likes_count
FROM posts_likes l
GROUP BY gender
ORDER BY gender='x',likes_count DESC 
LIMIT 1;
