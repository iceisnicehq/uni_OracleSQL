SELECT e.first_name, e.last_name, d.department_name 
FROM hr.employees e 
JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_name IN ('IT', 'Sales');

SELECT e.first_name, e.last_name, d.department_name, c.country_name
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.locations l ON d.location_id = l.location_id
JOIN hr.countries c ON l.country_id = c.country_id
WHERE c.country_name = 'United States of America' and d.department_name IN ('Shipping','Finance');

SELECT e1.last_name AS "Фамилия_Р", e1.hire_date AS "Дата_Р", e2.last_name AS "Фамилия_М", e2.hire_date AS "Дата_М"
FROM hr.employees e1
JOIN hr.employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.hire_date < e2.hire_date;


SELECT e1.last_name AS "Фамилия_Р", e1.hire_date AS "Дата_Р", e2.last_name AS "Фамилия_М", e2.hire_date AS "Дата_М"
FROM hr.employees e1
JOIN hr.employees e2 ON e1.manager_id = e2.employee_id
WHERE e1.hire_date < e2.hire_date;

SELECT first_name AS Имя, last_name AS Фамилия
FROM hr.employees e
WHERE e.employee_id IN (SELECT manager_id FROM hr.employees);
