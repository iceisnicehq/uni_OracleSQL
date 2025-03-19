drop trigger ddl_audit_trigger;
--drop table ddl_table_audit;
--drop table violation_attempts;
drop sequence ddl_seq_audit;
drop table ddl_table_audit;
drop trigger dml_audit_trigger;
drop sequence dml_seq_audit;
drop table dml_table_audit;
-- drop sequence seq_violation;


CREATE TABLE dml_table_audit (
    audit_id     NUMBER PRIMARY KEY,
    event_type   VARCHAR2(10),
    table_name   VARCHAR2(30),
    event_time   TIMESTAMP,
    username     VARCHAR2(30),
    status       VARCHAR2(50)
);

CREATE SEQUENCE dml_seq_audit START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER dml_audit_trigger
BEFORE INSERT OR UPDATE OR DELETE ON test_table
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION; 
    v_event_type VARCHAR2(10);
    v_table_name VARCHAR2(30) := 'test_table';
    v_status     VARCHAR2(50);
    v_day        VARCHAR2(20);
    v_time       VARCHAR2(8);
    v_error_code NUMBER;

BEGIN
    IF INSERTING THEN
        v_event_type := 'INSERT';
    ELSIF UPDATING THEN
        v_event_type := 'UPDATE';
    ELSIF DELETING THEN
        v_event_type := 'DELETE';
    END IF;

    v_day := TO_CHAR(SYSDATE, 'DY');
    v_time := TO_CHAR(SYSDATE, 'HH24:MI');

    BEGIN
        IF (v_day IN ('ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ') 
               AND v_time BETWEEN '09:00' AND '19:00') THEN
            v_status := 'ERROR_VIOLATION';
        ELSE
            v_status := 'SUCCESS_OPERATION';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            IF v_error_code = -942 THEN
                v_status := 'ERROR_ORA-00942';
            ELSE
                v_status := 'ERROR_UNKNOWN';
            END IF;
    END;

    INSERT INTO dml_table_audit VALUES (
        dml_seq_audit.NEXTVAL,
        v_event_type,
        v_table_name,
        SYSTIMESTAMP,
        USER,
        v_status
    );
    COMMIT;

    IF v_status = 'ERROR_VIOLATION' THEN
        RAISE_APPLICATION_ERROR(-20001, 'DML операции (INSERT, UPDATE, DELETE) запрещены в рабочее время (понедельник-пятница с 09.00 до 18.00)');
    ELSIF v_status = 'ERROR_ORA-00942' THEN
        RAISE_APPLICATION_ERROR(-20002, 'ORA-00942: Таблица или представление не существует');
    END IF;
END;



CREATE TABLE test_table (
    id NUMBER,
    name VARCHAR2(50)
);
INSERT INTO test_table (
    id, 
    name
    ) 
    VALUES (
    1,
    'user'
    );
DELETE FROM test_table where id=1;
SELECT * FROM dml_table_audit;




-- add status of the operation

-----MAINAINIAMIANIAMAINAIMIANIANIAMINAIN
CREATE TABLE ddl_table_audit (
    audit_id     NUMBER PRIMARY KEY,
    event_type   VARCHAR2(10),
    table_name   VARCHAR2(30),
    event_time   TIMESTAMP,
    username     VARCHAR2(30),
    status       VARCHAR2(50)
);

CREATE SEQUENCE ddl_seq_audit START WITH 1 INCREMENT BY 1;


CREATE OR REPLACE TRIGGER ddl_audit_trigger
BEFORE CREATE OR DROP ON SCHEMA
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION; 
    v_day        VARCHAR2(20);
    v_time       VARCHAR2(8);
    v_event_type VARCHAR2(10);
    v_table_name VARCHAR2(30);
    v_status     VARCHAR2(50);
    v_error_code NUMBER;

BEGIN
    v_event_type := ORA_SYSEVENT;
    v_table_name := ORA_DICT_OBJ_NAME;

    v_day := TO_CHAR(SYSDATE, 'DY');
    v_time := TO_CHAR(SYSDATE, 'HH24:MI');

    BEGIN
        IF v_event_type = 'DROP' THEN
            EXECUTE IMMEDIATE 'SELECT 1 FROM ' || v_table_name || ' WHERE 1=0';
        END IF;

        IF (v_day IN ('ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ') 
               AND v_time BETWEEN '09:00' AND '18:00') THEN
            v_status := 'ERROR_VIOLATION';
        ELSE
            v_status := 'SUCCESS_OPERATION';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            IF v_error_code = -942 THEN
                v_status := 'ERROR_ORA-00942';
            ELSE
                v_status := 'ERROR_UNKNOWN';
            END IF;
    END;

    INSERT INTO ddl_table_audit VALUES (
        ddl_seq_audit.NEXTVAL,
        v_event_type,
        v_table_name,
        SYSTIMESTAMP,
        USER,
        v_status
    );
    COMMIT;

    IF v_status = 'ERROR_VIOLATION' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Создание или удаление таблиц запрещено в рабочее время (понедельник-пятница с 09.00 до 18.00)');
    ELSIF v_status = 'ERROR_ORA-00942' THEN
        RAISE_APPLICATION_ERROR(-20002, 'ORA-00942: Таблица или представление не существует');
    END IF;
END;



CREATE TABLE test_table (
    id NUMBER,
    name VARCHAR2(50)
);

-- запрет изменения данных в таблице в рабочее время

drop table test_tabless;
SELECT * FROM ddl_table_audit;
SELECT * FROM dml_table_audit;
--SELECT * FROM violation_attempts;

CREATE TABLE test_table2 (
    id NUMBER,
    name VARCHAR2(50)
);

DROP TABLE table_audit;

DROP TABLE test_table;
DROP TABLE test_table2;
