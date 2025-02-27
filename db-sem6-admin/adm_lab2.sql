/*
Необходимо написать процедуру которая выгружает данные по операциям оплаты за оказанные услуги где в качестве плательщика выступает ФГУП за определенный период в таблицу. 
При этом период должен задаваться параметрами процедуры. Процедура должна фиксировать свои действия в таблице отладки (порядковый номер записи в таблице отладки, 
дата и время начала выполнения процедуры, входные параметры процедуры, кол-во вставленных записей, дата и время окончания выполнения процедуры, флаг успешного выполнения процедуры).
*/

CREATE OR REPLACE PROCEDURE fgup(date1 IN DATE, date2 IN DATE) IS
    -- Define a cursor to fetch the required data
    CURSOR cur_operations IS
        SELECT *
        FROM test_operation
        WHERE data_op BETWEEN date1 AND date2
          AND REGEXP_LIKE(descr, 'ФГУП', 'i');

    -- Variable to count the number of inserted rows
    v_cnt NUMBER := 0;

    -- Variable to store the start time of the procedure
    v_st_pr DATE := SYSDATE;
BEGIN
    -- Delete existing data from Payment_rent
    DELETE FROM Payment_rent;

    -- Process each row individually using a FOR loop
    FOR rec IN cur_operations LOOP
        -- Insert the current row into Payment_rent
        INSERT INTO Payment_rent VALUES rec;

        -- Increment the row counter
        v_cnt := v_cnt + 1;
    END LOOP;

    -- Log the successful execution
    INSERT INTO log (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
    VALUES (loggin_proc_seq.NEXTVAL, v_st_pr, date1, date2, v_cnt, SYSDATE, 1);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error
        INSERT INTO log (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
        VALUES (loggin_proc_seq.NEXTVAL, v_st_pr, date1, date2, v_cnt, SYSDATE, 0);

        COMMIT;
        RAISE; -- Re-raise the exception to notify the caller
END;