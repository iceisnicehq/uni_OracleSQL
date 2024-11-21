-- -- Drop dependent tables first
-- DROP TABLE Crew CASCADE CONSTRAINTS;
-- DROP TABLE Content_Genre CASCADE CONSTRAINTS;
-- DROP TABLE Favorite CASCADE CONSTRAINTS;
-- DROP TABLE Watch_History CASCADE CONSTRAINTS;
-- DROP TABLE Subscription_Access CASCADE CONSTRAINTS;

-- -- Drop primary tables
-- DROP TABLE Ratings CASCADE CONSTRAINTS;
-- DROP TABLE Payments CASCADE CONSTRAINTS;
-- DROP TABLE Genres CASCADE CONSTRAINTS;
-- DROP TABLE Subscriptions CASCADE CONSTRAINTS;
-- DROP TABLE People CASCADE CONSTRAINTS;
-- DROP TABLE Content CASCADE CONSTRAINTS;
-- DROP TABLE Users CASCADE CONSTRAINTS;


-- 1. Subscriptions
CREATE TABLE Subscriptions (
    subscription_id NUMBER NOT NULL,
    subs_name VARCHAR2(100) NOT NULL,
    subs_type VARCHAR2(100) NOT NULL,
    subs_price NUMBER(6,2) NOT NULL,
    CONSTRAINT pk_subscriptions PRIMARY KEY (subscription_id)
);

-- 2. Content
CREATE TABLE Content (
    content_id NUMBER NOT NULL,
    title VARCHAR2(255) NOT NULL,
    synopsis VARCHAR2(512),
    release_date DATE NOT NULL,
    country VARCHAR2(100) NOT NULL,
    type VARCHAR2(100) NOT NULL,
    age_rating VARCHAR2(3) NOT NULL,
    language VARCHAR2(50) NOT NULL,
    subtitles VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_content PRIMARY KEY (content_id)
);

-- 3. Genres
CREATE TABLE Genres (
    genre_id NUMBER NOT NULL,
    name VARCHAR2(100) NOT NULL,
    description VARCHAR2(512) NOT NULL,
    CONSTRAINT pk_genres PRIMARY KEY (genre_id)
);

-- 4. People
CREATE TABLE People (
    person_id NUMBER NOT NULL,
    first_name VARCHAR2(255) NOT NULL,
    last_name VARCHAR2(255) NOT NULL,
    height NUMBER,
    birth_place VARCHAR2(512),
    birth_date DATE NOT NULL,
    content_count NUMBER NOT NULL,
    CONSTRAINT pk_people PRIMARY KEY (person_id)
);

-- 5. Users
CREATE TABLE Users (
    user_id NUMBER NOT NULL,
    username VARCHAR2(100) NOT NULL,
    password VARCHAR2(30) NOT NULL,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(10) NOT NULL,
    reg_date DATE NOT NULL,
    birth_date DATE NOT NULL,
    bio VARCHAR2(255),
    location VARCHAR2(100),
    vk_link VARCHAR2(100),
    interests VARCHAR2(255),
    sex VARCHAR2(1),
    payment_id NUMBER,
    subs_status VARCHAR2(50) NOT NULL,
    ref_user_id NUMBER,
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT fk_users_payment FOREIGN KEY (payment_id) REFERENCES Payments(payment_id),
    CONSTRAINT fk_users_ref_user FOREIGN KEY (ref_user_id) REFERENCES Users(user_id)
);

-- 6. Payments
CREATE TABLE Payments (
    payment_id NUMBER NOT NULL,
    date DATE NOT NULL,
    amount NUMBER NOT NULL,
    method VARCHAR2(100) NOT NULL,
    user_id NUMBER NOT NULL,
    subs_id NUMBER NOT NULL,
    status VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_payments_subscription FOREIGN KEY (subs_id) REFERENCES Subscriptions(subscription_id)
);

-- 7. Ratings
CREATE TABLE Ratings (
    rating_id NUMBER NOT NULL,
    user_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    date DATE NOT NULL,
    rating NUMBER(2,0) NOT NULL,
    comment VARCHAR2(512),
    CONSTRAINT pk_ratings PRIMARY KEY (rating_id),
    CONSTRAINT fk_ratings_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_ratings_content FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

-- 8. Subscription Access
CREATE TABLE Subscription_Access (
    content_id NUMBER NOT NULL,
    subscription_id NUMBER NOT NULL,
    CONSTRAINT fk_access_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT fk_access_subscription FOREIGN KEY (subscription_id) REFERENCES Subscriptions(subscription_id),
    CONSTRAINT pk_subscription_access PRIMARY KEY (content_id, subscription_id)
);

-- 9. Watch History
CREATE TABLE Watch_History (
    user_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    watched_time NUMBER,
    CONSTRAINT fk_watch_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_watch_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT pk_watch_history PRIMARY KEY (user_id, content_id)
);

-- 10. Favorite
CREATE TABLE Favorite (
    user_id NUMBER NOT NULL,
    person_id NUMBER,
    content_id NUMBER,
    CONSTRAINT fk_favorite_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_favorite_person FOREIGN KEY (person_id) REFERENCES People(person_id),
    CONSTRAINT fk_favorite_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT pk_favorite PRIMARY KEY (user_id, person_id, content_id)
);

-- 11. Content Genre
CREATE TABLE Content_Genre (
    genre_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    CONSTRAINT fk_content_genre FOREIGN KEY (genre_id) REFERENCES Genres(genre_id),
    CONSTRAINT fk_genre_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT pk_content_genre PRIMARY KEY (genre_id, content_id)
);

-- 12. Crew
CREATE TABLE Crew (
    person_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    role VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_crew_person FOREIGN KEY (person_id) REFERENCES People(person_id),
    CONSTRAINT fk_crew_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT pk_crew PRIMARY KEY (person_id, content_id)
);
