DROP TABLE Active_customer_transactions;
DROP TABLE Clients;
DROP TABLE Staff;
DROP TABLE Departments;
DROP TABLE Branch_offices;

CREATE TABLE Staff (
    Personal_access_code INT(10),
    Full_name VARCHAR(255) NOT NULL,
    Date_of_birth DATE NOT NULL,
    Position VARCHAR(255) NOT NULL,
    Phone_number CHAR(5) NOT NULL,
    Department INT(10) NOT NULL,
    CONSTRAINT pk_personal_access_code PRIMARY KEY (Personal_access_code),
    CONSTRAINT fk_department FOREIGN KEY (Department) REFERENCES Departments(Department_code)
);

CREATE TABLE Active_customer_transactions (
    Transaction_number INT(10),
    Date_of_transaction DATE NOT NULL,
    Organisation INT(10) NOT NULL,
    Transaction_amount INT(10) NOT NULL,
    Assignment_of_the_operation VARCHAR(255) NOT NULL,
    CONSTRAINT pk_transaction_number PRIMARY KEY (Transaction_number),
    CONSTRAINT fk_organisation FOREIGN KEY (Organisation) REFERENCES Clients(Client_code)
);

CREATE TABLE Branch_offices (
    Branch_code INT(10),
    Location VARCHAR(255) NOT NULL,
    Opening_hours VARCHAR(255) NOT NULL,
    List_of_services VARCHAR(255) NOT NULL,
    Phone_number CHAR(5) NOT NULL,
    CONSTRAINT pk_branch_code PRIMARY KEY (Branch_code)
);

CREATE TABLE Departments (
    Department_code INT(10),
    Department_name VARCHAR(255) NOT NULL,
    Opening_hours VARCHAR(255) NOT NULL,
    Branch INT(10) NOT NULL,
    Equipment INT(10) NOT NULL,
    CONSTRAINT pk_department_code PRIMARY KEY (Department_code),
    CONSTRAINT fk_branch FOREIGN KEY (Branch) REFERENCES Branch_offices(Branch_code)
);

CREATE TABLE Clients (
    Client_code INT(10),
    Full_name VARCHAR(255) NOT NULL,
    TIN INT(10) NOT NULL,
    Passport_information INT(10) NOT NULL,
    Personal_bank_account INT(10) NOT NULL,
    Personal_manager INT(10) NOT NULL,
    CONSTRAINT pk_client_code PRIMARY KEY (Client_code),
    CONSTRAINT fk_personal_manager FOREIGN KEY (Personal_manager) REFERENCES Staff(Personal_access_code)
);

-- Заполнение таблицы Branch_offices (Филиалы)
INSERT INTO Branch_offices (Branch_code, Location, Opening_hours, List_of_services, Phone_number) VALUES
(1, 'Москва, ул. Тверская, д. 12', '09:00-18:00', 'Консультации, Кредитование, Открытие счетов', '49512345'),
(2, 'Санкт-Петербург, Невский пр., д. 45', '10:00-19:00', 'Консультации, Операции с валютой, Депозиты', '81267890'),
(3, 'Новосибирск, ул. Ленина, д. 30', '08:00-17:00', 'Консультации, Открытие счетов, Кредиты', '38345678'),
(4, 'Екатеринбург, пр. Ленина, д. 25', '09:30-18:30', 'Операции с валютой, Депозиты, Страхование', '34323456'),
(5, 'Казань, ул. Кремлевская, д. 10', '10:00-18:00', 'Консультации, Депозиты, Страхование', '84334567');

-- Заполнение таблицы Departments (Отделы)
INSERT INTO Departments (Department_code, Department_name, Opening_hours, Branch, Equipment) VALUES
(1, 'Отдел кредитования', '09:00-18:00', 1, 15),
(2, 'Отдел консультаций', '09:00-18:00', 1, 10),
(3, 'Отдел депозитов', '10:00-19:00', 2, 12),
(4, 'Отдел валютных операций', '08:00-17:00', 3, 8),
(5, 'Отдел страхования', '09:30-18:30', 4, 7);

-- Заполнение таблицы Staff (Сотрудники)
INSERT INTO Staff (Personal_access_code, Full_name, Date_of_birth, Position, Phone_number, Department) VALUES
(101, 'Иванов Иван Иванович', '1985-03-12', 'Кредитный специалист', '495111', 1),
(102, 'Петрова Мария Сергеевна', '1990-06-25', 'Консультант', '495222', 2),
(103, 'Сидоров Алексей Петрович', '1978-11-08', 'Менеджер по депозитам', '812333', 3),
(104, 'Кузнецова Ольга Андреевна', '1982-04-17', 'Валютный кассир', '383444', 4),
(105, 'Смирнов Дмитрий Викторович', '1987-09-23', 'Страховой агент', '343555', 5);



-- Доп задания
-- 1. Добавление нового столбца к уже созданной таблице (например, к таблице Staff) и заполнение его данными:
-- Добавление нового столбца Email к таблице Staff
ALTER TABLE Staff ADD Email VARCHAR(255);

-- Заполнение нового столбца Email данными для существующих записей
UPDATE Staff SET Email = 'ivanov@example.com' WHERE Personal_access_code = 101;
UPDATE Staff SET Email = 'petrova@example.com' WHERE Personal_access_code = 102;
UPDATE Staff SET Email = 'sidorov@example.com' WHERE Personal_access_code = 103;
UPDATE Staff SET Email = 'kuznetsova@example.com' WHERE Personal_access_code = 104;
UPDATE Staff SET Email = 'smirnov@example.com' WHERE Personal_access_code = 105;

-- 2. Изменения типа данных одного из столбцов в уже заполненной таблице без удаления данных.
ALTER TABLE Branch_offices MODIFY Phone_number VARCHAR(10);

-- 3. Изменение значения в одном из атрибутов для 2-х записей в любой таблице.
-- Изменение значения атрибута Position для двух сотрудников
UPDATE Staff SET Position = 'Главный консультант' WHERE Personal_access_code = 102;
UPDATE Staff SET Position = 'Ведущий кредитный специалист' WHERE Personal_access_code = 101;

-- Изменение номера телефона для двух сотрудников
UPDATE Staff SET Phone_number = '495999' WHERE Personal_access_code = 101;
UPDATE Staff SET Phone_number = '495888' WHERE Personal_access_code = 102;
