CREATE DATABASE IF NOT EXISTS `quarkus-social`;
USE `quarkus-social`;

CREATE TABLE IF NOT EXISTS USERS (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  age INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS posts (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  post_text VARCHAR(150) NOT NULL,
  dateTime TIMESTAMP NOT NULL,
  user_id BIGINT NOT NULL,
  CONSTRAINT fk_posts_user
    FOREIGN KEY (user_id) REFERENCES USERS (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS followers (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  follower_id BIGINT NOT NULL,
  CONSTRAINT fk_followers_user
    FOREIGN KEY (user_id) REFERENCES USERS (id),
  CONSTRAINT fk_followers_follower
    FOREIGN KEY (follower_id) REFERENCES USERS (id),
  CONSTRAINT uk_followers_user_follower UNIQUE (user_id, follower_id)
) ENGINE=InnoDB;

INSERT INTO USERS (id, name, age) VALUES
  (1, 'Ana', 25),
  (2, 'Bruno', 30),
  (3, 'Carla', 28)
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  age = VALUES(age);

INSERT INTO followers (user_id, follower_id) VALUES
  (1, 2)
ON DUPLICATE KEY UPDATE
  user_id = VALUES(user_id);

INSERT INTO posts (post_text, dateTime, user_id) VALUES
  ('Primeiro post da Ana', NOW(), 1),
  ('Segundo post da Ana', NOW(), 1);