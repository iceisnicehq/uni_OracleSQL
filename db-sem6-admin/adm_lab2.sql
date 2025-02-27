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

    -- Define a collection to hold the fetched data
    TYPE operation_table IS TABLE OF test_operation%ROWTYPE;
    v_operations operation_table;

    -- Variables for logging
    var_st_pr DATE := SYSDATE;
BEGIN
    -- Open the cursor and fetch data into the collection
    OPEN cur_operations;
    FETCH cur_operations BULK COLLECT INTO v_operations;
    CLOSE cur_operations;

    -- Delete existing data from Payment_rent
    DELETE FROM Payment_rent;

    -- Use FORALL to perform bulk insert
    IF v_operations.COUNT > 0 THEN
        FORALL i IN 1 .. v_operations.COUNT
            INSERT INTO Payment_rent VALUES v_operations(i);
    END IF;

    -- Log the successful execution
    INSERT INTO log (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
    VALUES (loggin_proc_seq.NEXTVAL, var_st_pr, date1, date2, v_operations.COUNT, SYSDATE, 1);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Log the error
        INSERT INTO log (ID, DATE_PROC_START, DATE_FROM, DATE_TO, COUNT_INSERT, DATE_PROC_END, FLAG)
        VALUES (loggin_proc_seq.NEXTVAL, var_st_pr, date1, date2, v_operations.COUNT, SYSDATE, 0);

        COMMIT;
        RAISE; -- Re-raise the exception to notify the caller
END;
/