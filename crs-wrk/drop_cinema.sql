-- Drop dependent tables first
DROP TABLE Crew CASCADE CONSTRAINTS;
DROP TABLE Content_Genre CASCADE CONSTRAINTS;
DROP TABLE Favorite CASCADE CONSTRAINTS;
DROP TABLE Watch_History CASCADE CONSTRAINTS;
DROP TABLE Subscription_Access CASCADE CONSTRAINTS;

-- Drop primary tables
DROP TABLE Ratings CASCADE CONSTRAINTS;
DROP TABLE Payments CASCADE CONSTRAINTS;
DROP TABLE Genres CASCADE CONSTRAINTS;
DROP TABLE Subscriptions CASCADE CONSTRAINTS;
DROP TABLE People CASCADE CONSTRAINTS;
DROP TABLE Content CASCADE CONSTRAINTS;
DROP TABLE Users CASCADE CONSTRAINTS;
DROP TABLE User_Subscriptions CASCADE CONSTRAINTS;
