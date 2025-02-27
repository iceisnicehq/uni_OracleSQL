/*
Необходимо написать процедуру которая выгружает данные по операциям оплаты за оказанные услуги где в качестве плательщика выступает ФГУП за определенный период в таблицу. 
При этом период должен задаваться параметрами процедуры. Процедура должна фиксировать свои действия в таблице отладки (порядковый номер записи в таблице отладки, 
дата и время начала выполнения процедуры, входные параметры процедуры, кол-во вставленных записей, дата и время окончания выполнения процедуры, флаг успешного выполнения процедуры).
*/

DROP TABLE fgup_payer;
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

CREATE TABLE fgup_payer AS
    SELECT * FROM sh.test_operation
    WHERE rownum < 1;

ALTER TABLE fgup_payer 
    ADD proc_id NUMBER;
    


CREATE SEQUENCE log_proc_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

CREATE OR REPLACE PROCEDURE fgup(date1 IN DATE, date2 IN DATE, oper_descr IN sh.test_operation.descr%TYPE) IS
    CURSOR cur_operations IS
        SELECT * FROM sh.test_operation
        WHERE data_op BETWEEN date1 AND date2 
            AND REGEXP_LIKE(upper(descr), 'ФГУП')
            AND REGEXP_LIKE(upper(descr), oper_descr);
    v_cnt NUMBER := 0;
    v_st_pr DATE := SYSDATE;
    seq_val NUMBER;
BEGIN
    seq_val := log_proc_seq.NEXTVAL;
   -- DELETE FROM fgup_payer;    
    FOR i IN cur_operations LOOP
        INSERT INTO fgup_payer(KOD,DOG,DATA_DOG,SUMMA_DOG,BIC_PL,KORCH_PL,RASCH_PL,INN_PL,BIC_POL,KORSCH_POL,RASCH_POL,INN_POL,DESCR,DATA_OP,SUMMA_OP,RULE,PRIZ,proc_id) 
        VALUES (i.KOD,i.DOG,i.DATA_DOG,i.SUMMA_DOG,i.BIC_PL,i.KORCH_PL,i.RASCH_PL,i.INN_PL,i.BIC_POL,i.KORSCH_POL,i.RASCH_POL,i.INN_POL,i.DESCR,i.DATA_OP,i.SUMMA_OP,i.RULE,i.PRIZ,seq_val);
        v_cnt := v_cnt + 1;
    END LOOP;

INSERT INTO logger (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
        VALUES (seq_val, v_st_pr, date1, date2, v_cnt, SYSDATE, 1);
         

EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO logger (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
                 VALUES (seq_val, v_st_pr, date1, date2, v_cnt, SYSDATE, 0);
    RAISE;
END;

BEGIN
    fgup(to_date('01.01.2001'),to_date('01.01.2010'), 'НДС');
    fgup(to_date('01.01.2001'),to_date('01.01.2010'), 'УГОЛЬ');
END;
SELECT * FROM logger;

SELECT * FROM fgup_payer;

SELECT * FROM sh.test_operation
WHERE data_op BETWEEN to_date('01.01.2001') AND ('01.01.2010') 
    AND REGEXP_LIKE(upper(descr), 'ФГУП')
    AND REGEXP_LIKE(upper(descr), 'НДС');

SELECT * FROM sh.test_operation
WHERE data_op BETWEEN to_date('01.01.2001') AND ('01.01.2010') 
    AND REGEXP_LIKE(upper(descr), 'ФГУП')
    AND REGEXP_LIKE(upper(descr), 'УГОЛЬ');

-- параметр на вход для описания процедуры
-- аппенд данных без очистки
-- доп столбец в фгуп пэйер для указания номера процедуры



ALTER TABLE fgup_payer
    ADD CONSTRAINT fk_proc_id FOREIGN KEY (proc_id)
    REFERENCES logger(ID);
