    select distinct REGEXP_REPLACE(NAIMEN, '^.*?([ИЧП]{2,3}|ПРЕДПРИНИМАТЕЛЬ|ПБО[ЮЛ]{2}|НОТАРИУС|РОССИЙСКИЙ)\s*', '') AS Справочник from uch_vse
    where REGEXP_LIKE(upper(naimen), '^(\w+\s){2,3}\w+$')
    AND REGEXP_LIKE(upper(naimen), '[\s ]?\w*(ОВИЧ|ЕВИЧ|ИЧ|ОВНА|ЕВНА|ИЧНА|ИНЧНА|ОВ|ЕВ|ИН|ОВА|ЕВА|ИНА)$')
    AND REGEXP_COUNT(REGEXP_REPLACE(NAIMEN, '^.*?([ИЧП]{2,3}|ПРЕДПРИНИМАТЕЛЬ|ПБО[ЮЛ]{2}|НОТАРИУС|РОССИЙСКИЙ)\s*', ''), '[  \s]+') = 2;
    
SELECT DISTINCT REGEXP_SUBSTR(REGEXP_REPLACE(NAIMEN, '^.*?([ИЧП]{2,3}|ПРЕДПРИНИМАТЕЛЬ|ПБОЮЛ|ПБОЛЮ||НОТАРИУС)\s*', ''), '\w+', 1, 2) AS ИМЕНА
FROM uch_vse
WHERE REGEXP_LIKE(upper(naimen), '^(\w+\s){2,3}\w+$')
AND REGEXP_LIKE(upper(naimen), '[\s ]?\w*(ОВИЧ|ЕВИЧ|ИЧ|ОВНА|ЕВНА|ИЧНА|ИНЧНА|ОВ|ЕВ|ИН|ОВА|ЕВА|ИНА)$')
AND REGEXP_COUNT(REGEXP_REPLACE(NAIMEN, '^.*?([ИЧП]{2,3}|ПРЕДПРИНИМАТЕЛЬ|ПБОЮЛ|ПБОЛЮ||НОТАРИУС)\s*', ''), '\s+') <= 2;

SELECT naimen, 
       REGEXP_SUBSTR(upper(naimen), '\s([ГСCП]|ПГ[ТT]|П\.Г\.[TТ])[ \s\.]{1,2}[А-Я]+(\s|$)') AS REGEXP
FROM uch_vse
WHERE upper(naimen) NOT LIKE '%С ОГРАНИЧЕННОЙ%';

Г. Москва
Г.Москва
Г Москва
С. Москва
С Москва
С Москва
ПГТ Москва
П.Г.Т. Москва
