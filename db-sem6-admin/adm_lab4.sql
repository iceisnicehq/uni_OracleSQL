-- Создание таблицы для аудита создания/удаления таблиц
CREATE TABLE table_audit (
    audit_id     NUMBER PRIMARY KEY,
    event_type   VARCHAR2(10),
    table_name   VARCHAR2(30),
    event_time   TIMESTAMP,
    username     VARCHAR2(30)
);

-- Создание таблицы для записи нарушений рабочего времени
CREATE TABLE violation_attempts (
    violation_id NUMBER PRIMARY KEY,
    operation    VARCHAR2(10),
    table_name   VARCHAR2(30),
    attempt_time TIMESTAMP,
    username     VARCHAR2(30),
    error_msg    VARCHAR2(100)
);

-- Создание последовательностей для первичных ключей
CREATE SEQUENCE seq_audit START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_violation START WITH 1 INCREMENT BY 1;

-- Триггер для проверки времени и записи событий DDL
CREATE OR REPLACE TRIGGER ddl_audit_trigger
BEFORE CREATE OR DROP ON SCHEMA
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_day        VARCHAR2(20);
    v_time       VARCHAR2(8);
    v_event_type VARCHAR2(10);
    v_table_name VARCHAR2(30);
    v_error_msg  VARCHAR2(100);
BEGIN
    -- Определение типа события (CREATE или DROP)
    v_event_type := ORA_SYSEVENT;
    v_table_name := ORA_DICT_OBJ_NAME;

    -- Проверка дня недели и времени
    v_day := TO_CHAR(SYSDATE, 'DY');
    v_time := TO_CHAR(SYSDATE, 'HH24:MI');

    -- Если событие происходит в рабочее время (Пн-Пт 09:00-18:00)
    IF (v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') 
        AND v_time BETWEEN '09:00' AND '18:00') THEN
        
        -- Запись о нарушении
        INSERT INTO violation_attempts VALUES (
            seq_violation.NEXTVAL,
            v_event_type,
            v_table_name,
            SYSTIMESTAMP,
            USER,
            'Операция запрещена в рабочее время'
        );
        COMMIT;

        -- Вызов исключения
        RAISE_APPLICATION_ERROR(-20001, 'Создание/удаление таблиц запрещено с 09:00 до 18:00 в рабочие дни.');
    ELSE
        -- Запись в аудит, если время не рабочее
        INSERT INTO table_audit VALUES (
            seq_audit.NEXTVAL,
            v_event_type,
            v_table_name,
            SYSTIMESTAMP,
            USER
        );
        COMMIT;
    END IF;
END;
/
