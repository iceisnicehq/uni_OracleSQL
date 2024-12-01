CREATE TABLE Subscriptions (
    subscription_id NUMBER GENERATED ALWAYS AS IDENTITY,
    subs_name VARCHAR2(100) NOT NULL,
    subs_price NUMBER NOT NULL,
    CONSTRAINT pk_subscriptions PRIMARY KEY (subscription_id),
    CONSTRAINT chk_subscriptions_price CHECK (subs_price > 0),
    CONSTRAINT chk_subscriptions_name CHECK (REGEXP_LIKE(subs_name, '^[A-ZА-Я]'))
);

CREATE TABLE Content (
    content_id NUMBER GENERATED ALWAYS AS IDENTITY,
    title VARCHAR2(512) NOT NULL,
    synopsis VARCHAR2(512),
    release_date DATE NOT NULL,
    duration NUMBER NOT NULL,
    country VARCHAR2(100) NOT NULL,
    type VARCHAR2(100) NOT NULL,
    age_rating VARCHAR2(5) NOT NULL,
    language VARCHAR2(50) NOT NULL,
    dubbing VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_content PRIMARY KEY (content_id),
    CONSTRAINT chk_content_age_rating CHECK (age_rating IN ('0+', '6+', '12+', '16+', '18+')),
    CONSTRAINT chk_content_title CHECK (REGEXP_LIKE(title, '^[A-ZА-Я]'))
);

CREATE TABLE Genres (
    genre_id NUMBER GENERATED ALWAYS AS IDENTITY,
    name VARCHAR2(100) NOT NULL,
    description VARCHAR2(512) NOT NULL,
    CONSTRAINT pk_genres PRIMARY KEY (genre_id),
    CONSTRAINT chk_genres_name CHECK (REGEXP_LIKE(name, '^[A-ZА-Я]')),
    CONSTRAINT chk_genres_description CHECK (REGEXP_LIKE(description, '^[A-ZА-Я]'))
);

CREATE TABLE People (
    person_id NUMBER GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100) NOT NULL,
    height NUMBER,
    birth_country VARCHAR2(100),
    birth_date DATE NOT NULL,
    death_date DATE,
    CONSTRAINT pk_people PRIMARY KEY (person_id),
    CONSTRAINT chk_people_first_name CHECK (REGEXP_LIKE(first_name, '^[A-ZА-Я]')),
    CONSTRAINT chk_people_last_name CHECK (REGEXP_LIKE(last_name, '^[A-ZА-Я]')),
    CONSTRAINT chk_people_birth_country CHECK (REGEXP_LIKE(birth_country, '^[A-ZА-Я]'))
);

CREATE TABLE Users (
    user_id NUMBER GENERATED ALWAYS AS IDENTITY,
    username VARCHAR2(100) NOT NULL,
    password VARCHAR2(30) NOT NULL,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(15) NOT NULL,
    reg_date DATE NOT NULL,
    birth_date DATE NOT NULL,
    bio VARCHAR2(512),
    vk_link VARCHAR2(100),
    interests VARCHAR2(512),
    sex VARCHAR2(10),
    ref_user_id NUMBER,
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT fk_users_ref_user FOREIGN KEY (ref_user_id) REFERENCES Users(user_id),
    CONSTRAINT uq_users_username UNIQUE (username),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_users_sex CHECK (sex IN ('муж', 'жен') OR sex IS NULL),
    CONSTRAINT chk_users_birth_date CHECK (birth_date >= TO_DATE('1890-01-01', 'YYYY-MM-DD'))
);

CREATE TABLE Payments (
    payment_id NUMBER GENERATED ALWAYS AS IDENTITY,
    payment_date TIMESTAMP(0) NOT NULL,
    amount NUMBER NOT NULL,
    payment_method VARCHAR2(100) NOT NULL,
    user_id NUMBER NOT NULL,
    subs_id NUMBER NOT NULL,
    status VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_payments_subscription FOREIGN KEY (subs_id) REFERENCES Subscriptions(subscription_id),
    CONSTRAINT chk_payments_amount CHECK (amount > 0)
);

CREATE TABLE User_Subscriptions (
    user_subscription_id NUMBER GENERATED ALWAYS AS IDENTITY,
    user_id NUMBER NOT NULL,
    subs_id NUMBER NOT NULL, 
    payment_id NUMBER NOT NULL, 
    start_date DATE NOT NULL, 
    end_date DATE NOT NULL, 
    status VARCHAR2(30) NOT NULL, 
    CONSTRAINT pk_user_subscriptions PRIMARY KEY (user_subscription_id),
    CONSTRAINT fk_user_subscriptions_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_user_subscriptions_subscription FOREIGN KEY (subs_id) REFERENCES Subscriptions(subscription_id),
    CONSTRAINT fk_user_subscriptions_payment FOREIGN KEY (payment_id) REFERENCES Payments(payment_id),
    CONSTRAINT chk_user_subscriptions_status CHECK (status IN ('активна', 'неактивна'))
);

CREATE TABLE Ratings (
    rating_id NUMBER GENERATED ALWAYS AS IDENTITY,
    user_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    rating_date TIMESTAMP(0) NOT NULL,
    rating NUMBER(2, 0) NOT NULL,
    rating_comment VARCHAR2(512),
    CONSTRAINT pk_ratings PRIMARY KEY (rating_id),
    CONSTRAINT fk_ratings_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_ratings_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT chk_ratings_rating CHECK (rating BETWEEN 0 AND 10)
);


CREATE TABLE Subscription_Access (
    access_id NUMBER GENERATED ALWAYS AS IDENTITY,
    content_id NUMBER,
    subscription_id NUMBER NOT NULL,
    CONSTRAINT pk_subscription_access PRIMARY KEY (access_id),
    CONSTRAINT fk_access_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT fk_access_subscription FOREIGN KEY (subscription_id) REFERENCES Subscriptions(subscription_id)
);

CREATE TABLE Watch_History (
    history_id NUMBER GENERATED ALWAYS AS IDENTITY, 
    user_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    time_stamp NUMBER,
    watch_date TIMESTAMP(0),
    CONSTRAINT pk_watch_history PRIMARY KEY (history_id),
    CONSTRAINT fk_watch_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_watch_content FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Favorite (
    favorite_id NUMBER GENERATED ALWAYS AS IDENTITY, 
    user_id NUMBER NOT NULL,
    person_id NUMBER,
    content_id NUMBER,
    CONSTRAINT pk_favorite PRIMARY KEY (favorite_id),
    CONSTRAINT fk_favorite_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_favorite_person FOREIGN KEY (person_id) REFERENCES People(person_id),
    CONSTRAINT fk_favorite_content FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Content_Genre (
    genre_assignment_id NUMBER GENERATED ALWAYS AS IDENTITY, 
    genre_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    CONSTRAINT pk_content_genre PRIMARY KEY (genre_assignment_id),
    CONSTRAINT fk_content_genre FOREIGN KEY (genre_id) REFERENCES Genres(genre_id),
    CONSTRAINT fk_genre_content FOREIGN KEY (content_id) REFERENCES Content(content_id)
);

CREATE TABLE Crew (
    crew_id NUMBER GENERATED ALWAYS AS IDENTITY, 
    person_id NUMBER NOT NULL,
    content_id NUMBER NOT NULL,
    role VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_crew PRIMARY KEY (crew_id),
    CONSTRAINT fk_crew_person FOREIGN KEY (person_id) REFERENCES People(person_id),
    CONSTRAINT fk_crew_content FOREIGN KEY (content_id) REFERENCES Content(content_id),
    CONSTRAINT chk_crew_role CHECK (role IN (
        'Режиссер', 
        'Актер', 
        'Продюсер', 
        'Режиссер дубляжа', 
        'Актер дубляжа', 
        'Сценарист', 
        'Оператор', 
        'Композитор', 
        'Художник', 
        'Монтажер'
    ))
);

