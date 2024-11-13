-- dba user granted
CREATE USER Sabirov_DS
IDENTIFIED BY assembly;

GRANT CONNECT, RESOURCE TO Sabirov_DS;

GRANT SELECT ON sh.test_operation, sh.test_uchast TO Sabirov_DS;

-- under user
CREATE TABLE sh.operations AS 
  SELECT ops.*
  FROM sh.test_operation ops
  JOIN sh.test_uchast uch ON uch.inn = ops.inn_pol
  WHERE REGEXP_LIKE(uch.naimen, '[З3][AА][OО]|[з3][аa][кk][рp]ы[тt][оo][eе][\s ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][еe][\s ][oо]бщ[eе]щ[еe][cс][tт][вb][oо]', 1, 1, 'i')
  AND NOT REGEXP_LIKE(ops.bic_pol, '^0445')

UPDATE sh.operations
SET col = val
where ...;

DELETE FROM sh.operations
WHERE ..;

INSERT INTO sh.operations (KOD, INN, NAIMEN, ADR, DATA_REG)
VALUES (1, 1001001001, 'ЗАО Яндекс', 'Г. Москва, ул. Льва Толстого, д. 16', 08-NOV-1997)
  
-- under dba
REVOKE SELECT, ALL ON sh.operations FROM Sabirov_DS;
