-- 1. Get all subscription details
SELECT * 
FROM Subscriptions;

-- 2. Retrieve content titles with their genres
SELECT C.title AS "Название контента", 
       G.name AS "Жанр"
FROM Content C
JOIN Content_Genre CG ON C.content_id = CG.content_id
JOIN Genres G ON CG.genre_id = G.genre_id;

-- 3. Find users and their favorite content
SELECT U.username AS "Пользователь", 
       C.title AS "Любимый контент"
FROM Users U
JOIN Favorite F ON U.user_id = F.user_id
JOIN Content C ON F.content_id = C.content_id;

-- 4. Get the watch history of each user
SELECT U.username AS "Пользователь", 
       C.title AS "Контент", 
       WH.time_stamp AS "Время просмотра (мин)", 
       WH.watch_date AS "Дата просмотра"
FROM Watch_History WH
JOIN Users U ON WH.user_id = U.user_id
JOIN Content C ON WH.content_id = C.content_id;

-- 5. List users with their active subscriptions
SELECT U.username AS "Пользователь", 
       S.subs_name AS "Подписка", 
       US.start_date AS "Дата начала", 
       US.end_date AS "Дата окончания", 
       US.status AS "Статус"
FROM User_Subscriptions US
JOIN Users U ON US.user_id = U.user_id
JOIN Subscriptions S ON US.subs_id = S.subscription_id
WHERE US.status = 'Активна';

-- 6. Find ratings given by users along with comments
SELECT U.username AS "Пользователь", 
       C.title AS "Контент", 
       R.rating AS "Рейтинг", 
       R.rating_comment AS "Комментарий"
FROM Ratings R
JOIN Users U ON R.user_id = U.user_id
JOIN Content C ON R.content_id = C.content_id;

-- 7. Find content available in a specific subscription
SELECT S.subs_name AS "Подписка", 
       C.title AS "Контент"
FROM Subscription_Access SA
JOIN Subscriptions S ON SA.subscription_id = S.subscription_id
JOIN Content C ON SA.content_id = C.content_id;

-- 8. Get the people involved in content production (crew) and their roles
SELECT C.title AS "Контент", 
       P.first_name || ' ' || P.last_name AS "Имя человека", 
       Cr.role AS "Роль"
FROM Crew Cr
JOIN Content C ON Cr.content_id = C.content_id
JOIN People P ON Cr.person_id = P.person_id;

-- 9. Find the top-rated content
SELECT C.title AS "Контент", 
       AVG(R.rating) AS "Средний рейтинг"
FROM Ratings R
JOIN Content C ON R.content_id = C.content_id
GROUP BY C.title
ORDER BY AVG(R.rating) DESC
FETCH FIRST 5 ROWS ONLY;

-- 10. Check how many users are subscribed to each subscription
SELECT S.subs_name AS "Подписка", 
       COUNT(US.user_id) AS "Количество пользователей"
FROM User_Subscriptions US
JOIN Subscriptions S ON US.subs_id = S.subscription_id
GROUP BY S.subs_name;
