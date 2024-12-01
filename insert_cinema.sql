-- Вставка данных в таблицу Subscriptions
INSERT INTO Subscriptions (subs_name, subs_price) 
VALUES ('Подписка на кино', 499);

INSERT INTO Subscriptions (subs_name, subs_price) 
VALUES ('Подписка на сериалы', 599);

INSERT INTO Subscriptions (subs_name, subs_price) 
VALUES ('Подписка на спорт', 799);

INSERT INTO Subscriptions (subs_name, subs_price) 
VALUES ('Подписка на новости', 199);

INSERT INTO Subscriptions (subs_name, subs_price) 
VALUES ('Подписка на образовательные материалы', 299);

-- Вставка данных в таблицу Content
INSERT INTO Content (title, synopsis, release_date, duration, country, type, age_rating, language, dubbing) 
VALUES ('Звездные войны', 'Научно-фантастическая эпопея о борьбе добра и зла.', TO_DATE('1977-05-25', 'YYYY-MM-DD'), 121, 'США', 'Фильм', '12+', 'Русский', 'Русский');

INSERT INTO Content (title, synopsis, release_date, duration, country, type, age_rating, language, dubbing) 
VALUES ('Друзья', 'Сериал о шестерых друзьях, которые переживают взлеты и падения в жизни.', TO_DATE('1994-09-22', 'YYYY-MM-DD'), 22, 'США', 'Сериал', '16+', 'Русский', 'Русский');

INSERT INTO Content (title, synopsis, release_date, duration, country, type, age_rating, language, dubbing) 
VALUES ('Интерстеллар', 'Фильм о путешествиях через червоточины в поисках нового дома для человечества.', TO_DATE('2014-11-07', 'YYYY-MM-DD'), 169, 'США', 'Фильм', '12+', 'Русский', 'Русский');

INSERT INTO Content (title, synopsis, release_date, duration, country, type, age_rating, language, dubbing) 
VALUES ('Теория большого взрыва', 'Ситком о группе друзей с необычным научным подходом к жизни.', TO_DATE('2007-09-24', 'YYYY-MM-DD'), 22, 'США', 'Сериал', '12+', 'Русский', 'Русский');

INSERT INTO Content (title, synopsis, release_date, duration, country, type, age_rating, language, dubbing) 
VALUES ('Матрица', 'Революционный фильм о реальности и виртуальном мире.', TO_DATE('1999-03-31', 'YYYY-MM-DD'), 136, 'США', 'Фильм', '16+', 'Русский', 'Русский');

-- Вставка данных в таблицу Genres
INSERT INTO Genres (name, description) 
VALUES ('Комедия', 'Жанр, в котором основное внимание уделяется созданию смеха и развлекательных ситуаций.');

INSERT INTO Genres (name, description) 
VALUES ('Драма', 'Жанр, сосредоточенный на серьезных и эмоциональных сюжетах.');

INSERT INTO Genres (name, description) 
VALUES ('Научная фантастика', 'Жанр, основанный на воображаемых научных и технологических достижениях.');

INSERT INTO Genres (name, description) 
VALUES ('Экшн', 'Жанр, фокусирующийся на быстром развитии событий и захватывающих сценах.');

INSERT INTO Genres (name, description) 
VALUES ('Ужасы', 'Жанр, создающий атмосферу страха и напряжения, часто с элементами сверхъестественного.');

-- Вставка данных в таблицу People
INSERT INTO People (first_name, last_name, birth_date, birth_country) 
VALUES ('Алексей', 'Иванов', TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'Россия');

INSERT INTO People (first_name, last_name, birth_date, birth_country) 
VALUES ('Мария', 'Смирнова', TO_DATE('1990-03-22', 'YYYY-MM-DD'), 'Россия');

INSERT INTO People (first_name, last_name, birth_date, birth_country) 
VALUES ('Иван', 'Петров', TO_DATE('1985-07-10', 'YYYY-MM-DD'), 'Украина');

INSERT INTO People (first_name, last_name, birth_date, birth_country) 
VALUES ('Екатерина', 'Сидорова', TO_DATE('1975-11-05', 'YYYY-MM-DD'), 'Беларусь');

INSERT INTO People (first_name, last_name, birth_date, birth_country) 
VALUES ('Дмитрий', 'Кузнецов', TO_DATE('1992-09-30', 'YYYY-MM-DD'), 'Россия');

-- Вставка данных в таблицу Users
INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, sex) 
VALUES ('user1', 'password1', 'Алексей', 'Иванов', 'alexey1@example.com', '89010000001', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('1980-05-15', 'YYYY-MM-DD'), 'муж');

INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, sex) 
VALUES ('user2', 'password2', 'Мария', 'Смирнова', 'maria2@example.com', '89010000002', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('1990-03-22', 'YYYY-MM-DD'), 'жен');

INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, sex) 
VALUES ('user3', 'password3', 'Иван', 'Петров', 'ivan3@example.com', '89010000003', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('1985-07-10', 'YYYY-MM-DD'), 'муж');

INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, sex) 
VALUES ('user4', 'password4', 'Екатерина', 'Сидорова', 'ekaterina4@example.com', '89010000004', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('1975-11-05', 'YYYY-MM-DD'), 'жен');

INSERT INTO Users (username, password, first_name, last_name, email, phone, reg_date, birth_date, sex) 
VALUES ('user5', 'password5', 'Дмитрий', 'Кузнецов', 'dmitriy5@example.com', '89010000005', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('1992-09-30', 'YYYY-MM-DD'), 'муж');

-- Вставка данных в таблицу Payments
INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status) 
VALUES (TO_TIMESTAMP('2024-12-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 499, 'Кредитная карта', 1, 1, 'Успешный');

INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status) 
VALUES (TO_TIMESTAMP('2024-12-02 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 599, 'Банковский перевод', 2, 2, 'Успешный');

INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status) 
VALUES (TO_TIMESTAMP('2024-12-03 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), 799, 'Электронные деньги', 3, 3, 'Успешный');

INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status) 
VALUES (TO_TIMESTAMP('2024-12-04 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), 199, 'Кредитная карта', 4, 4, 'Успешный');

INSERT INTO Payments (payment_date, amount, payment_method, user_id, subs_id, status) 
VALUES (TO_TIMESTAMP('2024-12-05 14:15:00', 'YYYY-MM-DD HH24:MI:SS'), 299, 'Банковский перевод', 5, 5, 'Успешный');

-- Вставка данных в таблицу User_Subscriptions
INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status) 
VALUES (1, 1, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), TO_DATE('2025-12-01', 'YYYY-MM-DD'), 'активна');

INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status) 
VALUES (2, 2, 2, TO_DATE('2024-12-02', 'YYYY-MM-DD'), TO_DATE('2025-12-02', 'YYYY-MM-DD'), 'активна');

INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status) 
VALUES (3, 3, 3, TO_DATE('2024-12-03', 'YYYY-MM-DD'), TO_DATE('2025-12-03', 'YYYY-MM-DD'), 'активна');

INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status) 
VALUES (4, 4, 4, TO_DATE('2024-12-04', 'YYYY-MM-DD'), TO_DATE('2025-12-04', 'YYYY-MM-DD'), 'активна');

INSERT INTO User_Subscriptions (user_id, subs_id, payment_id, start_date, end_date, status) 
VALUES (5, 5, 5, TO_DATE('2024-12-05', 'YYYY-MM-DD'), TO_DATE('2025-12-05', 'YYYY-MM-DD'), 'активна');

-- Вставка данных в таблицу Ratings
INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment) 
VALUES (1, 1, TO_TIMESTAMP('2024-12-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 'Отличный фильм!');

INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment) 
VALUES (2, 2, TO_TIMESTAMP('2024-12-02 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8, 'Очень хороший сериал, но затянут.');

INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment) 
VALUES (3, 3, TO_TIMESTAMP('2024-12-03 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10, 'Шедевр кино!');

INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment) 
VALUES (4, 4, TO_TIMESTAMP('2024-12-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7, 'Сериал хороший, но иногда скучноват.');

INSERT INTO Ratings (user_id, content_id, rating_date, rating, rating_comment) 
VALUES (5, 5, TO_TIMESTAMP('2024-12-05 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9, 'Фильм очень интересный, но концовка могла бы быть лучше.');

-- Вставка данных в таблицу Subscription_Access
INSERT INTO Subscription_Access (content_id, subscription_id) 
VALUES (1, 1);

INSERT INTO Subscription_Access (content_id, subscription_id) 
VALUES (2, 2);

INSERT INTO Subscription_Access (content_id, subscription_id) 
VALUES (3, 3);

INSERT INTO Subscription_Access (content_id, subscription_id) 
VALUES (4, 4);

INSERT INTO Subscription_Access (content_id, subscription_id) 
VALUES (5, 5);

-- Вставка данных в таблицу Watch_History
INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date) 
VALUES (1, 1, 120, TO_TIMESTAMP('2024-12-01 20:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date) 
VALUES (2, 2, 100, TO_TIMESTAMP('2024-12-02 21:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date) 
VALUES (3, 3, 150, TO_TIMESTAMP('2024-12-03 22:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date) 
VALUES (4, 4, 90, TO_TIMESTAMP('2024-12-04 23:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Watch_History (user_id, content_id, time_stamp, watch_date) 
VALUES (5, 5, 130, TO_TIMESTAMP('2024-12-05 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));

-- Вставка данных в таблицу Favorite
INSERT INTO Favorite (user_id, person_id, content_id) 
VALUES (1, 1, 1);

INSERT INTO Favorite (user_id, person_id, content_id) 
VALUES (2, 2, 2);

INSERT INTO Favorite (user_id, person_id, content_id) 
VALUES (3, 3, 3);

INSERT INTO Favorite (user_id, person_id, content_id) 
VALUES (4, 4, 4);

INSERT INTO Favorite (user_id, person_id, content_id) 
VALUES (5, 5, 5);

-- Вставка данных в таблицу Content_Genre
INSERT INTO Content_Genre (genre_id, content_id) 
VALUES (1, 1);

INSERT INTO Content_Genre (genre_id, content_id) 
VALUES (2, 2);

INSERT INTO Content_Genre (genre_id, content_id) 
VALUES (3, 3);

INSERT INTO Content_Genre (genre_id, content_id) 
VALUES (4, 4);

INSERT INTO Content_Genre (genre_id, content_id) 
VALUES (5, 5);

-- Вставка данных в таблицу Crew
INSERT INTO Crew (person_id, content_id, role) 
VALUES (1, 1, 'Режиссер');

INSERT INTO Crew (person_id, content_id, role) 
VALUES (2, 2, 'Актер');

INSERT INTO Crew (person_id, content_id, role) 
VALUES (3, 3, 'Сценарист');

INSERT INTO Crew (person_id, content_id, role) 
VALUES (4, 4, 'Продюсер');

INSERT INTO Crew (person_id, content_id, role) 
VALUES (5, 5, 'Оператор');
