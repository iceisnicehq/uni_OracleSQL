CREATE USER Abdullin_T_R
IDENTIFIED BY 0000;

GRANT CREATE SESSION TO Abdullin_T_R;
GRANT CREATE SEQUENCE, CREATE TABLE TO Abdullin_T_R;
GRANT SELECT ON sh.test_operation, sh.test_uchast TO Abdullin_T_R;

CREATE TABLE sh.moscow
AS SELECT o.*
    FROM sh.test_operation o
    JOIN sh.test_uchast u ON u.inn = o.inn_pl
    WHERE REGEXP_LIKE(o.bic_pl, '^0445') AND REGEXP_LIKE(u.naimen, '(Б[AА][HН][KК])|([BВ][AА]N[KК])')
    

GRANT SELECT, ALL ON sh.moscow TO KC2203_01;

UPDATE sh.moscow
SET descr = 'Погасил заранее',
    data_op = '13.10.24'
WHERE KOD = 3;

REVOKE SELECT, ALL ON sh.moscow FROM KC2203_01;

SELECT DISTINCT s4.БИК_ИНН_МОСКВА, s1.БИК_МОСКВА, s2.ИНН_МОСКВА, s3.ОБЩЕЕ
FROM sh.test_operation o
    JOIN sh.test_uchast u ON u.inn = o.inn_pl,
    (SELECT COUNT(*) AS БИК_МОСКВА
     FROM sh.test_operation o1
     JOIN sh.test_uchast u1 ON u1.inn = o1.inn_pl
     WHERE REGEXP_LIKE(o1.bic_pl, '^0445') AND REGEXP_LIKE(UPPER(u1.naimen), '(Б[AА][HН][KК])|([BВ][AА]N[KК])|([СC]Б[ЕE][РP])')) s1,
     (SELECT COUNT(*) AS ИНН_МОСКВА
     FROM sh.test_operation o2
     JOIN sh.test_uchast u2 ON u2.inn = o2.inn_pl
     WHERE REGEXP_LIKE(o2.inn_pl, '^77') AND REGEXP_LIKE(UPPER(u2.naimen), '(Б[AА][HН][KК])|([BВ][AА]N[KК])|([СC]Б[ЕE][РP])')) s2,
     (SELECT COUNT(*) AS ОБЩЕЕ
     FROM sh.test_operation o3
     JOIN sh.test_uchast u3 ON u3.inn = o3.inn_pl) s3,
     (SELECT COUNT(*) AS БИК_ИНН_МОСКВА
     FROM sh.test_operation o4
     JOIN sh.test_uchast u4 ON u4.inn = o4.inn_pl
     WHERE REGEXP_LIKE(o4.bic_pl, '^0445') AND REGEXP_LIKE(UPPER(u4.naimen), '(Б[AА][HН][KК])|([BВ][AА]N[KК])|([СC]Б[ЕE][РP])') AND REGEXP_LIKE(o4.inn_pl, '^77')) s4;
     
SELECT u.naimen, o.*
     FROM sh.test_operation o
     JOIN sh.test_uchast u ON u.inn = o.inn_pl AND u.inn = o.inn_pol
     WHERE REGEXP_LIKE(o.bic_pl, '^0445') AND REGEXP_LIKE(UPPER(u.naimen), '(Б[AА][HН][KК])|([BВ][AА]N[KК])|([СC]Б[ЕE][РP])') AND REGEXP_LIKE(o.inn_pl, '^77');
     
CREATE TABLE sh.moscow
AS SELECT u.naimen, o.*
    FROM sh.test_operation o
    JOIN sh.test_uchast u ON u.inn = o.inn_pl
    WHERE REGEXP_LIKE(o.bic_pl, '^0445') AND REGEXP_LIKE(u.naimen, '(Б[AА][HН][KК])|([BВ][AА]N[KК])|([СC]Б[ЕE][РP])') AND REGEXP_LIKE(o.inn_pl, '^77');
