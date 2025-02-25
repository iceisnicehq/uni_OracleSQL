/*
Необходимо написать функцию, которая определяет относится ли операция к операциям начисления заработной платы. При этом входным параметром функции должен быть id конкретной операции, результат должен возвращаться в виде числа, и принимать одно из двух возможных значений:
0-если операция не соответствует данному коду;
1-соответвует.
*/

----------- PERFIL

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



 ----------------KUKON

CREATE OR REPLACE FUNCTION is_salary_operation(p_operation_id IN NUMBER) 
RETURN NUMBER 
IS
    v_result NUMBER;
BEGIN
    SELECT CASE 
               WHEN COUNT(*) > 0 THEN 1
               ELSE 0
           END INTO v_result
    FROM sh.test_operation
    WHERE kod = p_operation_id AND REGEXP_LIKE(UPPER(descr), 'ЗАРПЛАТА');
    RETURN v_result;
END;

SELECT is_salary_operation(545) AS result FROM dual;
-- функция должна брать на вход сумму(varchar2) после этого она должна сравнить ее с диапозоном, затем, вывести, разницу с нижней границей
-- то есть вывод должен быть - код, разница, и столбец (выше или ниже), если в диапозоне, то разница NULL, и следущий столбец тоже NULL
-- проверка диапозона (если входит в диапазон, то средняя зп), если выходит, то опреация отличается на min-salary, c нижней границей
select * from sh.test_operation where REGEXP_LIKE(UPPER(DESCR), 'ЗАРПЛАТА')
-- 15000 - 30000

CREATE OR REPLACE FUNCTION salary_difference(p_operation_id IN NUMBER) 
RETURN VARCHAR2
IS
    v_diff      NUMBER(10, 2);
    v_summa_op  NUMBER(10, 2);
    max_salary  NUMBER(10, 2) := 30000;
    min_salary  NUMBER(10, 2) := 15000;
    low_high    VARCHAR2(25);
BEGIN
    SELECT TO_NUMBER(summa_op) INTO v_summa_op
    FROM sh.test_operation
    WHERE kod = p_operation_id AND REGEXP_LIKE(UPPER(descr), 'ЗАРПЛАТА');

    IF v_summa_op BETWEEN min_salary AND max_salary THEN
        RETURN v_summa_op || ' --- в диапазоне';
    ELSE
        v_diff := ABS(v_summa_op - min_salary);
        IF v_summa_op < min_salary THEN
            low_high := 'Ниже';
        ELSE
            low_high := 'Выше';
        END IF;
        RETURN v_diff || ' --- ' || low_high;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Операция не зарплатная';
END;

SELECT salary_difference(145) AS result FROM dual;
SELECT summa_op, salary_difference(145) AS result FROM sh.test_operation 
WHERE KOD=145;

SELECT salary_difference(7265) AS result FROM dual;
SELECT summa_op, salary_difference(7265) AS result FROM sh.test_operation 
WHERE KOD=7265;


