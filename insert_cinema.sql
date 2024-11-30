INSERT INTO Subscriptions (subs_name, subs_price)
VALUES ('Базовый', 499.00);

INSERT INTO Subscriptions (subs_name, subs_price)
VALUES ('Стандарт', 899.00);

INSERT INTO Subscriptions (subs_name, subs_price)
VALUES ('Премиум', 1299.00);
-----------------------------------------------------------------------------------
INSERT INTO Content (title, synopsis, release_date, country, type, age_rating, language, dubbing)
VALUES ('Начало', 'Фильм о вторжении в сознание через сны', DATE '2010-07-16', 125, 'США', 'Фильм', '16+', 'Английский', 'Да');

INSERT INTO Content (title, synopsis, release_date, country, type, age_rating, language, dubbing)
VALUES ('Паразиты', 'Драматическая история о классовом неравенстве', DATE '2019-05-30', 126, 'Южная Корея', 'Фильм', '18+', 'Корейский', 'Нет');

INSERT INTO Content (title, synopsis, release_date, country, type, age_rating, language, dubbing)
VALUES ('Ведьмак', 'Фэнтезийная сага о приключениях Геральта', DATE '2019-12-20', 155, 'Польша', 'Сериал', '18+', 'Английский', 'Да');
-----------------------------------------------------------------------------------
INSERT INTO Genres (name, description)
VALUES ('Боевик', 'Фильмы с высоким темпом и экшн-сценами.');

INSERT INTO Genres (name, description)
VALUES ('Драма', 'Эмоциональные и глубокие истории.');

INSERT INTO Genres (name, description)
VALUES ('Фантастика', 'Фильмы о будущем или научных изобретениях.');
-----------------------------------------------------------------------------------
INSERT INTO People (first_name, last_name, height, birth_country, birth_date)
VALUES ('Леонардо', 'Ди Каприо', 183, 'США', DATE '1974-11-11');

INSERT INTO People (first_name, last_name, height, birth_country, birth_date)
VALUES ('Сон', 'Кан Хо', 178, 'Южная Корея', DATE '1967-01-17');

INSERT INTO People (first_name, last_name, height, birth_country, birth_date)
VALUES ('Генри', 'Кавилл', 185, 'Великобритания', DATE '1983-05-05');
-----------------------------------------------------------------------------------
INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, bio, vk_link, interests, sex)
VALUES ('ivan_ivanov', 'пароль123', 'Иван', 'Иванов', 'ivan@example.com', '89101234567', SYSTIMESTAMP, DATE '1990-01-01', 'Любит кино.', NULL, 'Фильмы, Спорт', 'М');

INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, bio, vk_link, interests, sex)
VALUES ('anna_pet', 'защита123', 'Анна', 'Петрова', 'anna@example.com', '89087654321', SYSTIMESTAMP, DATE '1995-05-15', 'Обожает триллеры.', NULL, 'Путешествия, Книги', 'Ж');

INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, bio, vk_link, interests, sex)
VALUES ('mikhail_s', 'abcd1234', 'Михаил', 'Смирнов', 'mike@example.com', '89871234567', SYSTIMESTAMP, DATE '1985-09-10', 'Интересуется технологиями.', NULL, 'Игры, Кино', 'М');
-----------------------------------------------------------------------------------
INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status)
VALUES (SYSTIMESTAMP, 899.00, 'Банковская карта', 1, 2, 'Завершен');

INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status)
VALUES (SYSTIMESTAMP, 499.00, 'PayPal', 2, 1, 'Завершен');

INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status)
VALUES (SYSTIMESTAMP, 1299.00, 'Кредитная карта', 3, 3, 'Ожидает оплаты');
-----------------------------------------------------------------------------------
INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status)
VALUES (1, 2, 1, DATE '2024-01-01', DATE '2024-12-31', 'Активна');

INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status)
VALUES (2, 1, 2, DATE '2024-03-01', DATE '2024-08-31', 'Истекла');

INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status)
VALUES (3, 3, 3, DATE '2024-06-01', DATE '2025-05-31', 'Активна');
-----------------------------------------------------------------------------------
INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment)
VALUES (1, 1, SYSTIMESTAMP, 9, 'Потрясающий фильм!');

INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment)
VALUES (2, 2, SYSTIMESTAMP, 8, 'Хороший, но немного затянут.');

INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment)
VALUES (3, 3, SYSTIMESTAMP, 7, 'Интересный, но не мой жанр.');
-----------------------------------------------------------------------------------
INSERT INTO Subscription_Access (content_id, subscription_id)
VALUES (1, 2);

INSERT INTO Subscription_Access (content_id, subscription_id)
VALUES (2, 3);

INSERT INTO Subscription_Access (content_id, subscription_id)
VALUES (3, 1);
-----------------------------------------------------------------------------------
INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date)
VALUES (1, 1, 120, SYSTIMESTAMP);

INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date)
VALUES (2, 2, 90, SYSTIMESTAMP);

INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date)
VALUES (3, 3, 140, SYSTIMESTAMP);
-----------------------------------------------------------------------------------
INSERT INTO Favorite (user_id, person_id, content_id)
VALUES (1, 1, 1);

INSERT INTO Favorite (user_id, person_id, content_id)
VALUES (2, 2, 2);

INSERT INTO Favorite (user_id, person_id, content_id)
VALUES (3, 3, 3);
-----------------------------------------------------------------------------------
INSERT INTO Content_Genre (genre_id, content_id)
VALUES (1, 1);

INSERT INTO Content_Genre (genre_id, content_id)
VALUES (2, 2);

INSERT INTO Content_Genre (genre_id, content_id)
VALUES (3, 3);
-----------------------------------------------------------------------------------
