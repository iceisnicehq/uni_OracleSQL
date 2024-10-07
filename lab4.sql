/**
1. Добавления еще одной таблицы в созданную схему без удаления уже созданных таблиц. Новая таблица должна быть связана с ранее созданными и иметь не менее 5-ти атрибутов и не менее 3-х ограничений целостности.

2. Изменения типа данных одного из первичных ключей в любой таблице на ваше усмотрение. На этот первичный ключ должен ссылаться хотя бы один внешний ключ. При этом созданные таблицы нельзя удалять, только изменять.
**/
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
    Vladelec_FIO CHAR(100) NOT NULL,
    CONSTRAINT pk_avtomobil PRIMARY KEY (Nomer_avtomobilia),
    CONSTRAINT fk_avto_vladelec FOREIGN KEY (Vladelec_FIO) REFERENCES Klient(FIO)
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
    CONSTRAINT fk_zakaz_rabotnik FOREIGN KEY (Rabotnik) REFERENCES Rabotniki(Seria_i_nomer_pasporta)
);

CREATE TABLE Strahovka (
    id_strahovka NUMBER,
    Nomer_avtomobilia CHAR(15) NOT NULL, -- Связана с автомобилем
    Telefon_klienta CHAR(10) NOT NULL, -- Связана с клиентом
    Data_nachala DATE NOT NULL,
    Data_okonchaniya DATE NOT NULL,
    CONSTRAINT pk_strahovka PRIMARY KEY (id_insurance),
    CONSTRAINT fk_strahovka_avtomobil FOREIGN KEY (Nomer_avtomobilia) REFERENCES Avtomobil(Nomer_avtomobilia),
    CONSTRAINT fk_strahovka_klient FOREIGN KEY (Telefon_klienta) REFERENCES Klient(Telefon)
);

-- Для таблицы Avtomobil
ALTER TABLE Avtomobil
MODIFY Nomer_avtomobilia VARCHAR2(12);
-- Для таблицы Zakaz_klienta
ALTER TABLE Zakaz_klienta
MODIFY Nomer_avtomobilia VARCHAR2(12);

-- Для новой таблицы Strahovka
ALTER TABLE Strahovka
MODIFY Nomer_avtomobilia VARCHAR2(12);

