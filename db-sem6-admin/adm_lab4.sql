CREATE TABLE table_audit (
    audit_id     NUMBER PRIMARY KEY,
    event_type   VARCHAR2(10),
    table_name   VARCHAR2(30),
    event_time   TIMESTAMP,
    username     VARCHAR2(30)
);

CREATE TABLE violation_attempts (
    violation_id NUMBER PRIMARY KEY,
    operation    VARCHAR2(10),
    table_name   VARCHAR2(30),
    attempt_time TIMESTAMP,
    username     VARCHAR2(30),
    error_msg    VARCHAR2(100)
);

CREATE SEQUENCE seq_audit START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_violation START WITH 1 INCREMENT BY 1;

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
    v_event_type := ORA_SYSEVENT;
    v_table_name := ORA_DICT_OBJ_NAME;

    v_day := TO_CHAR(SYSDATE, 'DY');
    v_time := TO_CHAR(SYSDATE, 'HH24:MI');

    IF (v_day IN ('ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ') 
        AND v_time BETWEEN '09:00' AND '18:00') THEN
        
        INSERT INTO violation_attempts VALUES (
            seq_violation.NEXTVAL,
            v_event_type,
            v_table_name,
            SYSTIMESTAMP,
            USER,
            'Операция запрещена в рабочее время (понедельник-пятница с 09.00 до 18.00)'
        );
        COMMIT;

        RAISE_APPLICATION_ERROR(-20001, 'Создание или удаление таблиц запрещено в рабочее время (понедельник-пятница с 09.00 до 18.00)');
    ELSE
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



-- Create a test table
CREATE TABLE test_table_allowed (
    id NUMBER,
    name VARCHAR2(50)
);

-- Query the table_audit table to verify the event was logged
SELECT * FROM table_audit;

-- Attempt to create a test table during restricted hours
CREATE TABLE test_table_blocked (
    id NUMBER,
    name VARCHAR2(50)
);

-- Query the violation_attempts table to verify the event was logged
SELECT * FROM violation_attempts;

-- Drop the test table created earlier
DROP TABLE test_table_allowed;

-- Query the table_audit table to verify the event was logged
SELECT * FROM table_audit;

-- Attempt to drop a test table during restricted hours
DROP TABLE test_table_blocked;

-- Query the violation_attempts table to verify the event was logged
SELECT * FROM violation_attempts;

-- Check the current value of the sequences
SELECT seq_audit.CURRVAL FROM dual;
SELECT seq_violation.CURRVAL FROM dual;

-- Drop the test tables (if they exist)
DROP TABLE test_table_allowed;
DROP TABLE test_table_blocked;

-- Clear the audit and violation tables (optional)
DELETE FROM table_audit;
DELETE FROM violation_attempts;

-- Reset the sequences (optional)
DROP SEQUENCE seq_audit;
DROP SEQUENCE seq_violation;
CREATE SEQUENCE seq_audit START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_violation START WITH 1 INCREMENT BY 1;
