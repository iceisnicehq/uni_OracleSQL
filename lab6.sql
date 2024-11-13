-- dba
CREATE USER Sabirov_DS
IDENTIFIED BY asm123;

GRANT CONNECT, RESOURCE TO Sabirov_DS;

GRANT SELECT ON sh.test_operation, sh.test_uchast TO Sabirov_DS;

-- user
CREATE TABLE sh.operations AS 
    SELECT ops.*
    FROM sh.test_operation ops
    JOIN sh.test_uchast u ON u.inn = ops.inn_pol
    WHERE REGEXP_LIKE(lower(u.naimen), '[з3][аa][oо]|^[з3][аa][кk][рp]ы[тt][оo][eе][ ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][eе][ ]?[oо]бщ[eе]щ[еe][cс][tт][вb][oо]')
    AND NOT REGEXP_LIKE(ops.bic_pol, '^0445')

UPDATE sh.operations
SET summa_dog = 2500000
where kod = 27500;

UPDATE sh.operations
SET summa_dog = 80000
where dog = 041;

DELETE FROM sh.operations
WHERE kod = 506;

INSERT INTO sh.operatuions (KOD, DOG, DAT_DOG, SUMMA_DOG, BIC_PL, KORCH_PL, RASCH, PL, INN_PL, BIC_POL, KORSCH_POL, RASCH_POL, INN_POL, DESCR, DATA_OP, SUMMA_OP, RULE, PRIZ)
VALUES (1000072, 245, TO_DATE('05.02.03', 'DD.MM.YY'), 6300000, '047888773', '30101810000000000311', '40502810600020000007', '7723002556', '047888773', '30101810100000000737', '40702810238090105810', '7717030315', 'ОПЛАТА ЗА ТОВАР', TO_DATE('07.02.09', 'DD.MM.YY'), 6300000.0, NULL, NULL);

-- dba
REVOKE SELECT, ALL ON sh.operations FROM Sabirov_DS;


  
