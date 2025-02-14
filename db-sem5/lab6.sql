-- dba
CREATE USER Sabirov_DS
IDENTIFIED BY asm123;

GRANT CREATE SESSION, CREATE TABLE TO Sabirov_DS;

GRANT SELECT, UPDATE, DELETE ON sh.test_operation, sh.test_uchast TO Sabirov_DS;

-- user
CREATE TABLE sh.operations AS 
    SELECT ops.*
    FROM sh.test_operation ops
    JOIN sh.test_uchast u ON u.inn = ops.inn_pol
    WHERE REGEXP_LIKE(lower(u.naimen), '[з3][аa][oо]|^[з3][аa][кk][рp]ы[тt][оo][eе][ ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][eе][ ]?[oо]бщ[eе]щ[еe][cс][tт][вb][oо]')
    AND NOT REGEXP_LIKE(ops.bic_pol, '^0445')
    
-------
WITH bic_pol_only AS (
    SELECT DISTINCT ops.bic_pol 
    FROM sh.test_operation ops
    JOIN sh.test_uchast u ON u.inn = ops.inn_pol
    WHERE REGEXP_LIKE(lower(u.naimen), '[з3][аa][oо]|^[з3][аa][кk][рp]ы[тt][оo][eе][ ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][eе][ ]?[oо]бщ[eе]щ[еe][cс][tт][вb][oо]')
      AND NOT REGEXP_LIKE(ops.bic_pol, '^0445')
)
SELECT op.bic_pol AS бик_пол, COUNT(*) AS число_операций
FROM sh.test_operation op
WHERE op.bic_pol IN (SELECT bic_pol FROM bic_pol_only)
   OR op.bic_pl  IN (SELECT bic_pol FROM bic_pol_only)
GROUP BY op.bic_pol
HAVING op.bic_pol NOT LIKE '0445%';
--------
-- количество операций у каждого получателя 
-- бик + число операций
SELECT op.bic_pol as бик_пол, COUNT(*) AS число_операций(пол+пл)
    FROM sh.test_operation op
    WHERE op.bic_pol IN (
    SELECT DISTINCT ops.bic_pol AS БИК_получателя
    FROM sh.test_operation ops
    JOIN sh.test_uchast u ON u.inn = ops.inn_pol
    WHERE REGEXP_LIKE(lower(u.naimen), '[з3][аa][oо]|^[з3][аa][кk][рp]ы[тt][оo][eе][ ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][eе][ ]?[oо]бщ[eе]щ[еe][cс][tт][вb][oо]')
        AND NOT REGEXP_LIKE(ops.bic_pol, '^0445')
    )
    GROUP BY op.bic_pol;
    
SELECT 
    op.bic_pol AS бик_пол, 
    COUNT(*) AS число_операций
FROM 
    sh.test_operation op
WHERE 
    op.bic_pol IN (
        SELECT DISTINCT ops.bic_pol 
        FROM sh.test_operation ops
        JOIN sh.test_uchast u ON u.inn = ops.inn_pol
        WHERE REGEXP_LIKE(lower(u.naimen), '[з3][аa][oо]|^[з3][аa][кk][рp]ы[тt][оo][eе][ ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][eе][ ]?[oо]бщ[eе]щ[еe][cс][tт][вb][oо]')
          AND NOT REGEXP_LIKE(ops.bic_pol, '^0445')
    )
    OR op.bic_pl IN (
        SELECT DISTINCT ops.bic_pol 
        FROM sh.test_operation ops
        JOIN sh.test_uchast u ON u.inn = ops.inn_pol
        WHERE REGEXP_LIKE(lower(u.naimen), '[з3][аa][oо]|^[з3][аa][кk][рp]ы[тt][оo][eе][ ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][eе][ ]?[oо]бщ[eе]щ[еe][cс][tт][вb][oо]')
          AND NOT REGEXP_LIKE(ops.bic_pol, '^0445')
    )
GROUP BY 
    op.bic_pol;
-- вот у нас есть получатели
-- есть плательщики
-- посчитать число 
SELECT ops.bic_pl AS БИК_плательщика, COUNT(*) AS число_операций
FROM sh.test_operation ops
JOIN sh.test_uchast u ON u.inn = ops.inn_pl
WHERE REGEXP_LIKE(lower(u.naimen), '[з3][аa][oо]|^[з3][аa][кk][рp]ы[тt][оo][eе][ ]?[aа][kк]ци[oо][hн][eе][pр][hн][oо][eе][ ]?[oо]бщ[eе]щ[еe][cс][tт][вb][oо]')
    AND NOT REGEXP_LIKE(ops.bic_pl, '^0445')
GROUP BY ops.bic_pl;

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


  
