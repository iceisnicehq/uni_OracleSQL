-- Table: Rabotniki
CREATE TABLE Rabotniki (
    Seria_i_nomer_pasporta VARCHAR2(20) PRIMARY KEY,
    FIO VARCHAR2(100),
    Data_rojdenia DATE,
    Mesto_propiski VARCHAR2(100),
    Telefon CHAR(15),
    INN VARCHAR2(20)
);

-- Table: Oborudovanie
CREATE TABLE Oborudovanie (
    Seriynyy_nomer CHAR(15) PRIMARY KEY,
    Brend VARCHAR2(50),
    Strana_proizvoditelya VARCHAR2(50),
    Stoimost NUMBER,
    Data_registracii DATE,
    Naimenovanie_oborudovania VARCHAR2(100)
);

-- Table: Zapchasti
CREATE TABLE Zapchasti (
    Seriynyy_nomer CHAR(15) PRIMARY KEY,
    Naimenovanie VARCHAR2(100),
    Stoimost NUMBER,
    Proizvoditel VARCHAR2(100),
    Kolichestvo NUMBER
);

-- Table: Avtomobil
CREATE TABLE Avtomobil (
    Nomer_avtomobilia VARCHAR2(20) PRIMARY KEY,
    Probeg_km NUMBER,
    Marka_avtomobilia VARCHAR2(50),
    Proizvoditel VARCHAR2(100),
    Data_vypuska DATE,
    Vladelec_FIO CHAR(15) REFERENCES Klient(Telefon)
);

-- Table: Klient
CREATE TABLE Klient (
    Telefon CHAR(15) PRIMARY KEY,
    FIO VARCHAR2(100),
    Mesto_propiski VARCHAR2(100),
    Nomer_scheta VARCHAR2(20),
    Nomer_voditelskogo_udostoverenia CHAR(20),
    email VARCHAR2(100)
);

-- Table: Uslugi
CREATE TABLE Uslugi (
    Nomer_uslugi NUMBER PRIMARY KEY,
    Naimenovanie_uslugi VARCHAR2(100),
    Stoimost NUMBER,
    Oborudovanie CHAR(15) REFERENCES Oborudovanie(Seriynyy_nomer),
    Vremennie_ramki VARCHAR2(100) NULL,
    Zapchasti CHAR(15) REFERENCES Zapchasti(Seriynyy_nomer)
);

-- Table: Zakaz_klienta
CREATE TABLE Zakaz_klienta (
    Nomer_avtomobilia VARCHAR2(20) REFERENCES Avtomobil(Nomer_avtomobilia),
    Nomer_uslugi NUMBER REFERENCES Uslugi(Nomer_uslugi),
    Rabotnik VARCHAR2(20) REFERENCES Rabotniki(Seria_i_nomer_pasporta),
    PRIMARY KEY (Nomer_avtomobilia, Nomer_uslugi, Rabotnik)
);
