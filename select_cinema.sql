-- 1. Get the total payment amount per user
SELECT u.user_name, SUM(p.amount) AS total_payments
FROM Users u
JOIN Payments p ON u.user_id = p.user_id
GROUP BY u.user_name
ORDER BY total_payments DESC;

-- 2. Get the average rating for each content
SELECT c.title, AVG(r.rating) AS avg_rating
FROM Content c
JOIN Ratings r ON c.content_id = r.content_id
GROUP BY c.title
ORDER BY avg_rating DESC;

-- 3. Get the number of content watched by each user
SELECT u.user_name, COUNT(w.content_id) AS content_watched
FROM Users u
JOIN Watch_History w ON u.user_id = w.user_id
GROUP BY u.user_name
ORDER BY content_watched DESC;

-- 4. Get the most popular genres based on the number of contents in each genre
SELECT g.genre_name, COUNT(cg.content_id) AS num_contents
FROM Genre g
JOIN Content_Genre cg ON g.genre_id = cg.genre_id
GROUP BY g.genre_name
ORDER BY num_contents DESC;

-- 5. Get the highest rated content for each subscription type
SELECT s.sub_name, c.title, MAX(r.rating) AS highest_rating
FROM Subscriptions s
JOIN User_Subscriptions us ON s.sub_id = us.sub_id
JOIN Ratings r ON us.user_id = r.user_id
JOIN Content c ON r.content_id = c.content_id
GROUP BY s.sub_name, c.title
ORDER BY s.sub_name, highest_rating DESC;

-- 6. Get the total number of ratings per user
SELECT u.user_name, COUNT(r.rating) AS total_ratings
FROM Users u
JOIN Ratings r ON u.user_id = r.user_id
GROUP BY u.user_name
ORDER BY total_ratings DESC;

-- 7. Get the number of active subscriptions per user
SELECT u.user_name, COUNT(us.subs_id) AS active_subscriptions
FROM Users u
JOIN User_Subscriptions us ON u.user_id = us.user_id
WHERE us.status = 'активна'
GROUP BY u.user_name
ORDER BY active_subscriptions DESC;

-- 8. Get the total revenue from each payment method
SELECT p.payment_method, SUM(p.amount) AS total_revenue
FROM Payments p
GROUP BY p.payment_method
ORDER BY total_revenue DESC;
