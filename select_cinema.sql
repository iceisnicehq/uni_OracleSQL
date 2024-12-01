-- 1. Retrieve user details along with their active subscriptions:
SELECT u.username, u.first_name, u.last_name, us.start_date, us.end_date, s.subs_name, us.status
FROM Users u
JOIN User_Subscriptions us ON u.user_id = us.user_id
JOIN Subscriptions s ON us.subs_id = s.subscription_id
WHERE us.status = 'активна'
ORDER BY u.username;

-- 2. Retrieve content details along with its genre and ratings:
SELECT c.title, g.name AS genre, AVG(r.rating) AS avg_rating
FROM Content c
JOIN Content_Genre cg ON c.content_id = cg.content_id
JOIN Genres g ON cg.genre_id = g.genre_id
JOIN Ratings r ON c.content_id = r.content_id
GROUP BY c.title, g.name
ORDER BY avg_rating DESC;

-- 3. List the top-rated content for each genre:
SELECT g.name AS genre, c.title, MAX(r.rating) AS max_rating
FROM Content c
JOIN Content_Genre cg ON c.content_id = cg.content_id
JOIN Genres g ON cg.genre_id = g.genre_id
JOIN Ratings r ON c.content_id = r.content_id
GROUP BY g.name, c.title
ORDER BY g.name, max_rating DESC;

-- 4. List the users who made payments, with subscription details and the payment status:
SELECT u.username, p.payment_date, p.amount, s.subs_name, p.status
FROM Users u
JOIN Payments p ON u.user_id = p.user_id
JOIN Subscriptions s ON p.subs_id = s.subscription_id
ORDER BY p.payment_date DESC;

-- 5. Show the crew members (role and person) for each content:
SELECT c.title, p.first_name, p.last_name, cr.role
FROM Crew cr
JOIN Content c ON cr.content_id = c.content_id
JOIN People p ON cr.person_id = p.person_id
ORDER BY c.title, cr.role;

-- 6. Display the most recent watch history for each user:
SELECT u.username, c.title, w.watch_date
FROM Watch_History w
JOIN Users u ON w.user_id = u.user_id
JOIN Content c ON w.content_id = c.content_id
ORDER BY w.watch_date DESC;

-- 7. Show the total number of ratings for each content:
SELECT c.title, COUNT(r.rating_id) AS total_ratings
FROM Content c
JOIN Ratings r ON c.content_id = r.content_id
GROUP BY c.title
ORDER BY total_ratings DESC;

-- 8. Retrieve the favorite content for each user along with the associated person (actor/director):
SELECT u.username, c.title, p.first_name, p.last_name
FROM Favorite f
JOIN Users u ON f.user_id = u.user_id
JOIN Content c ON f.content_id = c.content_id
JOIN People p ON f.person_id = p.person_id
ORDER BY u.username, c.title;

-- 9. Retrieve subscription details with the total amount paid by users:
SELECT u.username, s.subs_name, SUM(p.amount) AS total_spent
FROM Users u
JOIN Payments p ON u.user_id = p.user_id
JOIN Subscriptions s ON p.subs_id = s.subscription_id
GROUP BY u.username, s.subs_name
ORDER BY total_spent DESC;

-- 10. List the content and its access by each subscription:
SELECT s.subs_name, c.title, COUNT(sa.access_id) AS access_count
FROM Subscription_Access sa
JOIN Subscriptions s ON sa.subscription_id = s.subscription_id
JOIN Content c ON sa.content_id = c.content_id
GROUP BY s.subs_name, c.title
ORDER BY s.subs_name, access_count DESC;
