SELECT CONCAT(SYSDATE, SYSTIMESTAMP)  AS X
FROM DUAL;

SELECT *
FROM hr.employees
WHERE department_id = 50;

SELECT 
    first_name AS Имя, 
    last_name AS Фамилия, 
    hire_date AS Дата_приема_на_работу, 
    FLOOR(MONTHS_BETWEEN((sysdate), hire_date)) AS Проработано_месяцев 
FROM hr.employees;

SELECT job_id, start_date, end_date
FROM hr.job_history
WHERE start_date > '31.12.03' AND end_date <= '31.12.08' AND (job_id = 'AC_ACCOUNT' OR job_id = 'AC_MGR');

SELECT employee_id, end_date, FLOOR(MONTHS_BETWEEN((SELECT SYSDATE FROM DUAL), end_date)) AS Months_since_end_date
FROM hr.job_history;
