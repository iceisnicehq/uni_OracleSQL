/*
Необходимо написать процедуру которая выгружает данные по операциям оплаты за оказанные услуги где в качестве плательщика выступает ФГУП за определенный период в таблицу. 
При этом период должен задаваться параметрами процедуры. Процедура должна фиксировать свои действия в таблице отладки (порядковый номер записи в таблице отладки, 
дата и время начала выполнения процедуры, входные параметры процедуры, кол-во вставленных записей, дата и время окончания выполнения процедуры, флаг успешного выполнения процедуры).
*/

DROP TABLE fgup_payer;

CREATE TABLE fgup_payer AS
    SELECT * FROM sh.test_operation
    WHERE 1 = 0;

DROP PROCEDURE fgup;
DROP TABLE logger;

DROP SEQUENCE log_proc_seq;

CREATE TABLE logger (
    ID NUMBER PRIMARY KEY,
    DATE_PROC_START DATE NOT NULL,
    DATE_FROM DATE NOT NULL,
    DATE_TO DATE NOT NULL,
    COUNT_INSERT NUMBER NOT NULL,
    DATE_PROC_END DATE NOT NULL,
    FLAG NUMBER NOT NULL
);

CREATE SEQUENCE log_proc_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE OR REPLACE PROCEDURE fgup(date1 IN DATE, date2 IN DATE) IS
    CURSOR cur_operations IS
        SELECT * FROM sh.test_operation
        WHERE data_op BETWEEN date1 AND date2 AND REGEXP_LIKE(upper(descr), 'ФГУП');
    v_cnt NUMBER := 0;
    v_st_pr DATE := SYSDATE;
BEGIN
    DELETE FROM fgup_payer;
    FOR rec IN cur_operations LOOP
        INSERT INTO fgup_payer VALUES rec;
        v_cnt := v_cnt + 1;
    END LOOP;

    INSERT INTO logger (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
             VALUES (log_proc_seq.NEXTVAL, v_st_pr, date1, date2, v_cnt, SYSDATE, 1);
EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO logger (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
                 VALUES (log_proc_seq.NEXTVAL, v_st_pr, date1, date2, v_cnt, SYSDATE, 0);
END;

begin 
    fgup(to_date('01.01.2001'),to_date('01.01.2010'));
end;

select * from logger;
SELECT * FROM fgup_payer;
