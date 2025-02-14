/**
1. Добавления еще одной таблицы в созданную схему без удаления уже созданных таблиц. Новая таблица должна быть связана с ранее созданными и иметь не менее 5-ти атрибутов и не менее 3-х ограничений целостности.

2. Изменения типа данных одного из первичных ключей в любой таблице на ваше усмотрение. На этот первичный ключ должен ссылаться хотя бы один внешний ключ. При этом созданные таблицы нельзя удалять, только изменять.
**/
DROP TABLE Zakaz_klienta CASCADE CONSTRAINTS;
DROP TABLE Service_History CASCADE CONSTRAINTS;
DROP TABLE Uslugi CASCADE CONSTRAINTS;
DROP TABLE Oborudovanie CASCADE CONSTRAINTS;
DROP TABLE Zapchasti CASCADE CONSTRAINTS;
DROP TABLE Avtomobil CASCADE CONSTRAINTS;
DROP TABLE Rabotniki CASCADE CONSTRAINTS;
DROP TABLE Klient CASCADE CONSTRAINTS;


CREATE TABLE Rabotniki (
    Seria_i_nomer_pasporta VARCHAR2(10),
    FIO VARCHAR2(100) NOT NULL,
    Data_rojdenia DATE NOT NULL,
    Mesto_propiski VARCHAR2(100) NOT NULL,
    Telefon CHAR(10) NOT NULL,
    INN VARCHAR2(12) NOT NULL,
    CONSTRAINT pk_rabotniki PRIMARY KEY (Seria_i_nomer_pasporta)
);

CREATE TABLE Oborudovanie (
    Seriynyy_nomer CHAR(25),
    Brend VARCHAR2(50) NOT NULL,
    Strana_proizvoditelya VARCHAR2(25) NOT NULL,
    Stoimost NUMBER NOT NULL,
    data_registracii DATE,
    Naimenovanie_oborudovania VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_oborudovanie PRIMARY KEY (Seriynyy_nomer)
);

CREATE TABLE Zapchasti (
    Seriynyy_nomer CHAR(25),
    Naimenovanie VARCHAR2(100) NOT NULL,
    Stoimost NUMBER NOT NULL,
    Proizvoditel VARCHAR2(100) NOT NULL,
    Kolichestvo NUMBER NOT NULL,
    CONSTRAINT pk_zapchasti PRIMARY KEY (Seriynyy_nomer)
);

CREATE TABLE Klient (
    Telefon CHAR(10),
    FIO VARCHAR2(100) NOT NULL,
    Mesto_propiski VARCHAR2(100),
    Nomer_scheta VARCHAR2(25) NOT NULL,
    Nomer_voditelskogo_udostoverenia CHAR(10) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_klient PRIMARY KEY (Telefon)
);

CREATE TABLE Avtomobil (
    Nomer_avtomobilia VARCHAR2(10),
    Probeg_km NUMBER NOT NULL,
    Marka_avtomobilia VARCHAR2(50) NOT NULL,
    Proizvoditel VARCHAR2(100) NOT NULL,
    data_vypuska DATE NOT NULL,
    Vladelec_FIO VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_avtomobil PRIMARY KEY (Nomer_avtomobilia),
    -- CONSTRAINT fk_avto_vladelec FOREIGN KEY (Vladelec_FIO) REFERENCES Avtomobil(Proizvoditel)
);

CREATE TABLE Uslugi (
    Nomer_uslugi NUMBER,
    Naimenovanie_uslugi VARCHAR2(100) NOT NULL,
    Stoimost NUMBER NOT NULL,
    Oborudovanie CHAR(25) NOT NULL,
    Vremennie_ramki VARCHAR2(100),
    Zapchasti CHAR(25) NOT NULL,
    CONSTRAINT pk_uslugi PRIMARY KEY (Nomer_uslugi),
    CONSTRAINT fk_uslugi_oborud FOREIGN KEY (Oborudovanie) REFERENCES Oborudovanie(Seriynyy_nomer),
    CONSTRAINT fk_uslugi_zapchasti FOREIGN KEY (Zapchasti) REFERENCES Zapchasti(Seriynyy_nomer)
);
CREATE TABLE Zakaz_klienta (
    Nomer_avtomobilia VARCHAR2(10) NOT NULL,
    Nomer_uslugi NUMBER NOT NULL,
    Rabotnik VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_zakaz_klienta PRIMARY KEY (Nomer_avtomobilia, Nomer_uslugi, Rabotnik),
    CONSTRAINT fk_zakaz_avtomobil FOREIGN KEY (Nomer_avtomobilia) REFERENCES Avtomobil(Nomer_avtomobilia), 
    CONSTRAINT fk_zakaz_uslugi FOREIGN KEY (Nomer_uslugi) REFERENCES Uslugi(Nomer_uslugi),
    CONSTRAINT fk_zakaz_rabotnik FOREIGN KEY (Rabotnik) REFERENCES Rabotniki(Seria_i_nomer_pasporta),
    -- constraint fk_itself FOREIGN KEY (
);
----1111----
CREATE TABLE Service_History (
    Nomer_avtomobilia VARCHAR2(10) NOT NULL,
    Nomer_uslugi NUMBER NOT NULL,
    Data_servisa DATE NOT NULL,
    Stoimost_servisa NUMBER NOT NULL,
    Opisanie_servisa VARCHAR2(1024) NOT NULL,
    CONSTRAINT pk_service_history PRIMARY KEY (Nomer_avtomobilia, Nomer_uslugi, Data_servisa),
    CONSTRAINT fk_service_history_avtomobil FOREIGN KEY (Nomer_avtomobilia) REFERENCES Avtomobil(Nomer_avtomobilia),
    CONSTRAINT fk_service_history_uslugi FOREIGN KEY (Nomer_uslugi) REFERENCES Uslugi(Nomer_uslugi)
);

----
alter table Klient Rename to Client 
-- таблицу доставки автомобилей
CREATE TABLE car_delivery (
    Delivery_ID NUMBER,
    Nomer_avtomobilia VARCHAR2(10) NOT NULL,
    Brand VARCHAR2(50) NOT NULL,
    Delivery_date DATE NOT NULL,
    Recipient_telefon CHAR(10) NOT NULL,
    CONSTRAINT pk_car_delivery PRIMARY KEY (Delivery_ID),
    CONSTRAINT fk_car_delivery_avtomobil FOREIGN KEY (Nomer_avtomobilia) REFERENCES Avtomobil(Nomer_avtomobilia),
    CONSTRAINT fk_car_delivery_telefon FOREIGN KEY (Recipient_telefon) REFERENCES Client(Telefon)
);
SELECT TABLE_NAME, COMMENTS 
FROM ALL_TAB_COMMENTS 
WHERE TABLE_NAME = 'CAR_DELIVERY';

SELECT TABLE_NAME, COLUMN_NAME, COMMENTS 
FROM ALL_COL_COMMENTS 
WHERE TABLE_NAME = 'CAR_DELIVERY';

SeLECT * from car_delivery

COMMENT ON TABLE car_delivery IS 'Таблица для хранения информации о доставке автомобилей';
COMMENT ON COLUMN car_delivery.Delivery_ID IS 'Уникальный идентификатор доставки';
COMMENT ON COLUMN car_delivery.Nomer_avtomobilia IS 'Номер автомобиля, который доставляется';
COMMENT ON COLUMN car_delivery.Brand IS 'Марка автомобиля';
COMMENT ON COLUMN car_delivery.Delivery_date IS 'Дата доставки автомобиля';
COMMENT ON COLUMN car_delivery.Recipient_telefon IS 'Телефон получателя автомобиля';
----2222----
ALTER TABLE Uslugi
DROP CONSTRAINT fk_uslugi_oborud;

ALTER TABLE Oborudovanie
MODIFY Seriynyy_nomer VARCHAR2(30);

ALTER TABLE Uslugi
MODIFY Oborudovanie VARCHAR2(30);

ALTER TABLE Uslugi
ADD CONSTRAINT fk_uslugi_oborud FOREIGN KEY (Oborudovanie) REFERENCES Oborudovanie(Seriynyy_nomer);
----

