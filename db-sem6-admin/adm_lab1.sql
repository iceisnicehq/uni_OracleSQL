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
    FROM sh.test_operation
    WHERE kod = p_operation_id AND REGEXP_LIKE(UPPER(descr), 'ЗАРПЛАТА');
    RETURN v_result;
END;

SELECT * from sh.test_operation
WHERE REGEXP_LIKE(UPPER(descr), 'ЗАРПЛАТА');
-- KOD DESCR func

SELECT kod, descr, is_salary_operation(kod) AS result 
FROM sh.test_operation;


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
    FROM sh.test_operation
    WHERE kod = p_operation_id AND REGEXP_LIKE(UPPER(descr), 'ЗАРПЛАТА');
    RETURN v_return;
END;

SELECT kod, descr, is_salary_operation(kod) AS result 
FROM sh.test_operation
where is_salary_operation(kod) LIKE 'True';

-- последняя дата операции по ИНН получателя
