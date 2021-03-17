DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;

USE vk;

SHOW tables;

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL,
  last_name VARCHAR(145) NOT NULL,
  email VARCHAR(145) NOT NULL,
  phone INT UNSIGNED,
  password_hash CHAR(65) DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  UNIQUE INDEX email_unique (email),
  UNIQUE INDEX phone_unique (phone)
) ENGINE=InnoDB;


DESCRIBE users;

-- 1:1 связь
CREATE TABLE profiles (
  user_id BIGINT UNSIGNED NOT NULL,
  gender ENUM('f', 'm', 'x') NOT NULL,
  birthday DATE NOT NULL,
  photo_id INT UNSIGNED,
  user_status VARCHAR(30),
  city VARCHAR(130),
  country VARCHAR(130),
  UNIQUE INDEX fk_profiles_users_to_idx (user_id),
  
  
  CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users (id)
);

DESCRIBE profiles;

-- n:m связь

CREATE TABLE messages (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- id= 1 сообщения
  from_user_id BIGINT UNSIGNED NOT NULL, -- user with id=1 send
  to_user_id BIGINT UNSIGNED NOT NULL, -- user id =2 receive 
  txt TEXT NOT NULL, -- txt = Hi!
  is_delivered BOOLEAN DEFAULT False, -- доставлено ли сообщение
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- когда создано/отправлено сообщение
  update_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- ON UPDATE CURRENT_TIMESTAMP, когда обновлено/изменено сообщение 
  INDEX fk_messages_from_user_idx (from_user_id),
  INDEX fk_messages_to_user_idx (to_user_id),
  CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE messages;

-- n:m связь
-- запрос в друзья	
CREATE TABLE friend_requests (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- id= 1 сообщения
  from_user_id BIGINT UNSIGNED NOT NULL, -- user with id=1 send
  to_user_id BIGINT UNSIGNED NOT NULL, -- user id =2 receive 
  accepted BOOLEAN DEFAULT False, -- принял ли заявку в друзья
  INDEX fk_friend_requests_from_user_idx (from_user_id),
  INDEX fk_friend_requests_to_user_idx (to_user_id),
  CONSTRAINT fk_friend_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

DESCRIBE friend_requests;

CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL,
  admin_id BIGINT UNSIGNED NOT NULL,
  INDEX fk_communities_users_admin_idx (admin_id), -- по этому индексу ищутся сообщества, в которых пользователь администратор
  CONSTRAINT fk_communities_users FOREIGN KEY (admin_id) REFERENCES users (id)
) ENGINE=InnoDB;

DESCRIBE friend_requests;


-- n:m связь
-- создаем связи между пользователями и сообществами (каждый пользователь может вступить в сообщество)
CREATE TABLE communities_users (
  community_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (community_id, user_id), -- составной primary key, user не может дважды вступитьв одно и тоже сообщество
  INDEX fk_communities_users_comm_idx (community_id),
  INDEX fk_communities_users_users_idx (user_id),
  CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;

DESCRIBE communities_users;

CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(45) NOT NULL -- храним типы: фото, музыка, документы
);
DESCRIBE media_types;

-- 1:n

CREATE TABLE media (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- картинка 1
  user_id BIGINT UNSIGNED NOT NULL, -- кто выложил видео
  media_types_id INT UNSIGNED NOT NULL,  -- TYPE ENUM('photo', ...), -- тип картинки 1 фото
  file_name VARCHAR(245) DEFAULT NULL,
  file_size BIGINT DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX fk_media_users_idx (user_id),
  INDEX fk_media_media_types_idx (media_types_id),
  CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users (id), --
  CONSTRAINT fk_media_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id)
);
DESCRIBE media;



CREATE TABLE post_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(45) NOT NULL -- храним типы: фото, музыка, документы
);
DESCRIBE post_types;


CREATE TABLE post (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- id пост
  user_id BIGINT UNSIGNED NOT NULL, -- id кто выложил пост
  post_types_id INT UNSIGNED NOT NULL,
  txt TEXT NOT NULL, 
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX fk_post_users_idx (user_id),
  INDEX fk_post_created_at_idx (created_at),
  CONSTRAINT fk_post_users FOREIGN KEY (user_id) REFERENCES users (id), --
  CONSTRAINT fk_post_post_types FOREIGN KEY (post_types_id) REFERENCES post_types (id)
);
DESCRIBE post;

CREATE TABLE likes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 
  from_user_id BIGINT UNSIGNED NOT NULL, -- от пользователя 
  to_post_id BIGINT UNSIGNED NOT NULL, -- к посту  
  INDEX fk_likes_to_post_idx (to_post_id),
  CONSTRAINT fk_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id)
    
);
DESCRIBE likes;



