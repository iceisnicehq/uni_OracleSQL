-- INT(10) to NUMBER(10)

DROP TABLE Active_customer_transactions CASCADE CONSTRAINTS;
DROP TABLE Clients CASCADE CONSTRAINTS;
DROP TABLE Staff CASCADE CONSTRAINTS;
DROP TABLE Departments CASCADE CONSTRAINTS;
DROP TABLE Branch_offices CASCADE CONSTRAINTS;
-- отличие ноль ограничение запятые  

--CREATE TABLE Branch_offices (
--    Branch_code NUMBER(10),
--    Location int NOT NULL,
--    Opening_hours VARCHAR2(255) NOT NULL,
--    List_of_services VARCHAR2(255) NOT NULL,
--    Phone_number CHAR(5) NOT NULL,
--    CONSTRAINT pk_branch_code PRIMARY KEY (Branch_code)
--);
--
--INSERT INTO Branch_offices (Branch_code, Location, Opening_hours, List_of_services, Phone_number) 
--VALUES (001, 001, '09:00-18:00', 'Консультации, Кредитование, Открытие счетов', '49512');
--SELECT * FROM Branch_offices;

-- 1. ни от чего
CREATE TABLE Branch_offices (
    Branch_code NUMBER(10),
    Location VARCHAR2(255) NOT NULL,
    Opening_hours VARCHAR2(255) NOT NULL,
    List_of_services VARCHAR2(255) NOT NULL,
    Phone_number CHAR(5) NOT NULL,
    CONSTRAINT pk_branch_code PRIMARY KEY (Branch_code)
);

-- 2. От веток офиса
CREATE TABLE Departments (
    Department_code NUMBER(10),
    Department_name VARCHAR2(255) NOT NULL,
    Opening_hours VARCHAR2(255) NOT NULL,
    Branch NUMBER(10) NOT NULL,
    Equipment NUMBER(10) NOT NULL,
    CONSTRAINT pk_department_code PRIMARY KEY (Department_code),
    CONSTRAINT fk_branch FOREIGN KEY (Branch) REFERENCES Branch_offices(Branch_code)
);

-- 3. От департаментов
CREATE TABLE Staff (
    Personal_access_code NUMBER(10),
    Full_name VARCHAR2(255) NOT NULL,
    Date_of_birth DATE NOT NULL,
    Position VARCHAR2(255) NOT NULL,
    Phone_number CHAR(5) NOT NULL,
    Department NUMBER(10) NOT NULL,
    CONSTRAINT pk_personal_access_code PRIMARY KEY (Personal_access_code),
    CONSTRAINT fk_department FOREIGN KEY (Department) REFERENCES Departments(Department_code)
);

-- 4. ОТ стаффа
CREATE TABLE Clients (
    Client_code NUMBER(10),
    Full_name VARCHAR2(255) NOT NULL,
    TIN NUMBER(10) NOT NULL,
    Passport_information NUMBER(10) NOT NULL,
    Personal_bank_account NUMBER(10) NOT NULL,
    Personal_manager NUMBER(10) NOT NULL,
    CONSTRAINT pk_client_code PRIMARY KEY (Client_code),
    CONSTRAINT fk_personal_manager FOREIGN KEY (Personal_manager) REFERENCES Staff(Personal_access_code)
);
-- 5. от Клиента
CREATE TABLE Active_customer_transactions (
    Transaction_number NUMBER(10),
    Date_of_transaction DATE NOT NULL,
    Organisation NUMBER(10) NOT NULL,
    Transaction_amount NUMBER(19,4) NOT NULL,
    Assignment_of_the_operation VARCHAR2(255) NOT NULL,
    CONSTRAINT pk_transaction_number PRIMARY KEY (Transaction_number),
    CONSTRAINT fk_organisation FOREIGN KEY (Organisation) REFERENCES Clients(Client_code)
);

-- 1 
-- Branch_offices
INSERT INTO Branch_offices (Branch_code, Location, Opening_hours, List_of_services, Phone_number) 
VALUES (1, 'Алушта, ул. Губкина, д. 65', '09:00-18:00', 'Консультации, Кредитование, Открытие счетов', '49512');

INSERT INTO Branch_offices (Branch_code, Location, Opening_hours, List_of_services, Phone_number) 
VALUES (2, 'Москва, ул. Льва Толстого, д. 16', '10:00-19:00', 'Консультации, Операции с валютой, Депозиты', '81267');

INSERT INTO Branch_offices (Branch_code, Location, Opening_hours, List_of_services, Phone_number) 
VALUES (3, 'Губкин, ул. Ленина, д. 65, к. 2', '08:00-17:00', 'Консультации, Открытие счетов, Кредиты', '38345');

INSERT INTO Branch_offices (Branch_code, Location, Opening_hours, List_of_services, Phone_number) 
VALUES (4, 'Москва, Ленинский пр., д. 65, к. 1', '09:30-18:30', 'Операции с валютой, Депозиты, Страхование', '34323');

INSERT INTO Branch_offices (Branch_code, Location, Opening_hours, List_of_services, Phone_number) 
VALUES (5, 'Москва, ул. Бутлерова, д. 1', '10:00-18:00', 'Консультации, Депозиты, Страхование', '84334');


-- Departments
INSERT INTO Departments (Department_code, Department_name, Opening_hours, Branch, Equipment) 
VALUES (1, 'Отдел кредитования', '09:00-18:00', 1, 15);

INSERT INTO Departments (Department_code, Department_name, Opening_hours, Branch, Equipment) 
VALUES (2, 'Отдел консультаций', '09:00-18:00', 1, 10);

INSERT INTO Departments (Department_code, Department_name, Opening_hours, Branch, Equipment) 
VALUES (3, 'Отдел депозитов', '10:00-19:00', 2, 12);

INSERT INTO Departments (Department_code, Department_name, Opening_hours, Branch, Equipment) 
VALUES (4, 'Отдел валютных операций', '08:00-17:00', 3, 8);

INSERT INTO Departments (Department_code, Department_name, Opening_hours, Branch, Equipment) 
VALUES (5, 'Отдел страхования', '09:30-18:30', 4, 7);


--Staff
INSERT INTO Staff (Personal_access_code, Full_name, Date_of_birth, Position, Phone_number, Department) 
VALUES (1, 'Абдуллин Тагир Ренатович', TO_DATE('2004-07-04', 'YYYY-MM-DD'), 'Валютный кассир', '38344', 4);

INSERT INTO Staff (Personal_access_code, Full_name, Date_of_birth, Position, Phone_number, Department) 
VALUES (2, 'Поляков Кирилл Александрович', TO_DATE('2004-10-10', 'YYYY-MM-DD'), 'Страховой агент', '34355', 5);

INSERT INTO Staff (Personal_access_code, Full_name, Date_of_birth, Position, Phone_number, Department) 
VALUES (3, 'Сабиров Данияр Серикович', TO_DATE('2003-10-08', 'YYYY-MM-DD'), 'Кредитный специалист', '49511', 1);

INSERT INTO Staff (Personal_access_code, Full_name, Date_of_birth, Position, Phone_number, Department) 
VALUES (4, 'Сизов Игорь Михайлович', TO_DATE('2004-08-20', 'YYYY-MM-DD'), 'Консультант', '49522', 2);

INSERT INTO Staff (Personal_access_code, Full_name, Date_of_birth, Position, Phone_number, Department) 
VALUES (5, 'Сулимов Александр Дмитриевич', TO_DATE('2004-09-16', 'YYYY-MM-DD'), 'Менеджер по депозитам', '81233', 3);




-- Доп задания
-- 1. Добавление нового столбца к уже созданной таблице (например, к таблице Staff) и заполнение его данными:
-- Добавление нового столбца Email к таблице Staff
ALTER TABLE Staff ADD Email VARCHAR(255);

-- Email
UPDATE Staff SET Email = 'tabd@gubkin.ru' WHERE Personal_access_code = 1;
UPDATE Staff SET Email = 'kpol@gubkin.ru' WHERE Personal_access_code = 2;
UPDATE Staff SET Email = 'dsab@gubkin.ru' WHERE Personal_access_code = 3;
UPDATE Staff SET Email = 'isiz@gubkin.ru' WHERE Personal_access_code = 4;
UPDATE Staff SET Email = 'asul@gubkin.ru' WHERE Personal_access_code = 5;

-- 2. Изменения типа данных одного из столбцов в уже заполненной таблице без удаления данных.
ALTER TABLE Branch_offices MODIFY Phone_number VARCHAR(10);

-- 3. Изменение значения в одном из атрибутов для 2-х записей в любой таблице.
-- Position
UPDATE Staff SET Position = 'Главный консультант' WHERE Personal_access_code = 3;
UPDATE Staff SET Position = 'Заместитель главного консультанта' WHERE Personal_access_code = 5;

-- Изменение номера телефона
UPDATE Staff SET Phone_number = '77777' WHERE Personal_access_code = 3;
UPDATE Staff SET Phone_number = '99999' WHERE Personal_access_code = 5;

SELECT * FROM Branch_offices;
SELECT * FROM Departments;
SELECT * FROM Staff;
SELECT * FROM Clients;
SELECT * FROM Active_customer_transactions;
-- вывести сотрудника его фамилия возраст в формате РФ колво клиентов и сумму их транзакций
SELECT 
    REGEXP_SUBSTR(s.Full_name, '\w*[ \s]', 1, 1, 'i') AS Фамилия, 
    FLOOR(MONTHS_BETWEEN(SYSDATE, Date_of_birth)/12) Возраст,
    COUNT(c.Client_code) AS Число_клиентов,
    NVL(SUM(t.Transaction_amount), 0) AS Сумма_транзакций
FROM Staff s
LEFT JOIN Clients c ON s.Personal_access_code = c.Personal_manager
LEFT JOIN Active_customer_transactions t ON c.Client_code = t.Organisation
GROUP BY s.Full_name, s.Date_of_birth
ORDER BY s.Full_name;

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 1, 10000.0000, 'Оплата услуг');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (2, TO_DATE('2022-01-15', 'YYYY-MM-DD'), 2, 20000.0000, 'Покупка товара');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (3, TO_DATE('2022-02-01', 'YYYY-MM-DD'), 3, 30000.0000, 'Оплата услуг');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (4, TO_DATE('2022-03-01', 'YYYY-MM-DD'), 4, 40000.0000, 'Покупка товара');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (5, TO_DATE('2022-04-01', 'YYYY-MM-DD'), 5, 50000.0000, 'Оплата услуг');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (6, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 1, 100010.0000, 'Оплата услуг');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (7, TO_DATE('2022-01-15', 'YYYY-MM-DD'), 2, 200020.0000, 'Покупка товара');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (8, TO_DATE('2022-02-01', 'YYYY-MM-DD'), 3, 300030.0000, 'Оплата услуг');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (9, TO_DATE('2022-03-01', 'YYYY-MM-DD'), 4, 400040.0000, 'Покупка товара');

INSERT INTO Active_customer_transactions (Transaction_number, Date_of_transaction, Organisation, Transaction_amount, Assignment_of_the_operation) 
VALUES (10, TO_DATE('2022-04-01', 'YYYY-MM-DD'), 5, 500050.0000, 'Оплата услуг');

INSERT INTO Clients (Client_code, Full_name, TIN, Passport_information, Personal_bank_account, Personal_manager) 
VALUES (1, 'Иванов Иван Иванович', 1234567890, 9876543210, 1111111111, 1);

INSERT INTO Clients (Client_code, Full_name, TIN, Passport_information, Personal_bank_account, Personal_manager) 
VALUES (2, 'Петров Петр Петрович', 2345678901, 8765432109, 2222222222, 2);

INSERT INTO Clients (Client_code, Full_name, TIN, Passport_information, Personal_bank_account, Personal_manager) 
VALUES (3, 'Сидоров Сергей Сергеевич', 3456789012, 7654321098, 3333333333, 3);

INSERT INTO Clients (Client_code, Full_name, TIN, Passport_information, Personal_bank_account, Personal_manager) 
VALUES (4, 'Кузнецов Константин Константинович', 4567890123, 6543210987, 4444444444, 4);

INSERT INTO Clients (Client_code, Full_name, TIN, Passport_information, Personal_bank_account, Personal_manager) 
VALUES (5, 'Николаев Николай Николаевич', 5678901234, 5432109876, 5555555555, 5);
