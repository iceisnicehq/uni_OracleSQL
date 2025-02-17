-- MAIN
--select * from sh.test_operation
--where REGEXP_LIKE(UPPER(DESCR), 'ЗАРПЛАТА')
SELECT is_salary_operation(145) AS result FROM dual;

CREATE OR REPLACE FUNCTION is_salary_operation(p_operation_id IN NUMBER) 
RETURN NUMBER 
IS
    v_result NUMBER;
BEGIN
    SELECT CASE 
               WHEN COUNT(*) > 0 THEN 1
               ELSE 0
           END INTO v_result
    FROM test_operation -- sh.test_operation
    WHERE kod = p_operation_id AND REGEXP_LIKE(UPPER(descr), 'ЗАРПЛАТА');
    RETURN v_result;
END;

-- ADDITIONAL_1
-- KOD DESCR func
SELECT kod, descr, is_salary_operation(kod) AS result 
FROM test_operation; -- sh.test_operation

-- ADDITIONAL_2
-- false or True
CREATE OR REPLACE FUNCTION is_salary_operation(p_operation_id IN NUMBER) 
RETURN VARCHAR2
IS
    v_return VARCHAR2(10);
BEGIN
    SELECT CASE 
               WHEN COUNT(*) > 0 THEN 'True'
               ELSE 'False'
           END INTO v_return
    FROM test_operation -- sh.test_operation
    WHERE kod = p_operation_id AND REGEXP_LIKE(UPPER(descr), 'ЗАРПЛАТА');
    RETURN v_return;
END;

SELECT kod, descr, is_salary_operation(kod) AS result 
FROM test_operation; -- sh.test_operation

-- ADDITIONAL_3
-- последняя дата операции по ИНН получателя
select * from test_operation
where REGEXP_LIKE(UPPER(DESCR), 'ЗАРПЛАТА')
--772001588424
--7707083893
--7710026800
CREATE OR REPLACE FUNCTION last_operation_date(p_inn_pol IN test_operation.inn_pol%TYPE)
RETURN test_operation.data_op%TYPE
IS
    v_date test_operation.data_op%TYPE;
BEGIN
    SELECT data_op INTO v_date
    FROM (
        SELECT data_op
        FROM test_operation -- sh.test_operation
        WHERE inn_pol = p_inn_pol
            AND descr LIKE '%ЗАРПЛАТА%'
        ORDER BY TO_TIMESTAMP(data_op, 'YYYY-MM-DD HH24:MI:SS.FF') DESC  -- TO_DATE(data_op, 'YYYY--MM-DD')
    )
    WHERE ROWNUM = 1;
    RETURN v_date;
END;

SELECT last_operation_date(7707083893) AS result FROM dual;
