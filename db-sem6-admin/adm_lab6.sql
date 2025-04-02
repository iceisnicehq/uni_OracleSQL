--1 Написать запрос к системному словарю, который выведет таблицы базы данных, для столбцов которых определены комментарии.
CREATE TABLE test (
id NUMBER);
SELECT * FROM user_col_comments;

SELECT * --DISTINCT table_name
FROM user_col_comments
WHERE comments IS NOT NULL;


comment on column KC2203_16.clients.tin IS 'is tin';

--------------
SELECT DISTINCT table_name
FROM user_col_comments
WHERE comments IS NOT NULL;
----------------
SELECT *
FROM user_tab_columns;
SELECT *
FROM user_tables;

-- те таблицы у которых все столбцы имеют комментарии
BEGIN
  FOR tab_rec IN (
    SELECT table_name
    FROM user_tables t
    WHERE table_name NOT IN (
      SELECT DISTINCT c.table_name
      FROM user_tab_columns c
      LEFT JOIN user_col_comments cc ON c.table_name = cc.table_name 
                                   AND c.column_name = cc.column_name
      WHERE cc.comments IS NULL
    )
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(tab_rec.table_name);
  END LOOP;
END;





CREATE TABLE test2 (
id NUMBER);

--2 С помощью запроса к системному словарю сделать скрипт, который позволит ко всем таблицам схемы SH добавить комментарий “это учебная таблица”.

BEGIN
  EXECUTE IMMEDIATE 'COMMENT ON TABLE KC2203_16.avtomobil IS ''это avto''';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;

--------------------
BEGIN
  FOR table_rec IN (SELECT table_name FROM all_tables WHERE owner = 'SH') 
  LOOP
    BEGIN
      EXECUTE IMMEDIATE 
        'COMMENT ON TABLE SH.' || table_rec.table_name || ' IS ''это учебная таблица''';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка для таблицы ' || table_rec.table_name || ': ' || SQLERRM);
    END;
  END LOOP;
END;
--------------------
SELECT * FROM all_tab_comments WHERE owner = 'SH';

SELECT * FROM all_tab_comments WHERE owner = 'KC2203_16';

-- if table has comment, then dont add one
SELECT * FROM all_tab_comments WHERE owner = 'KC2203_16'


COMMENT ON TABLE KC2203_16.AVTOMOBIL IS '';
--------------------
BEGIN
  FOR table_rec IN (SELECT table_name, comments FROM all_tab_comments WHERE owner = 'KC2203_16') 
  LOOP
    IF table_rec.comments IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Таблица ' || table_rec.table_name || ' имеет комментарий');
        CONTINUE;
    END IF;
    BEGIN
      EXECUTE IMMEDIATE 
        'COMMENT ON TABLE KC2203_16.' || table_rec.table_name || ' IS ''это таблААА KC2203-16''';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка для таблицы ' || table_rec.table_name || ': ' || SQLERRM);
    END;
  END LOOP;
END;


-- if table has comment, then dont add one
SELECT * FROM all_tab_comments WHERE owner = 'SH'
--------------------
BEGIN
  FOR table_rec IN (SELECT table_name FROM all_tables WHERE owner = 'SH') 
  LOOP
    BEGIN
      EXECUTE IMMEDIATE 
        'COMMENT ON TABLE SH.' || table_rec.table_name || ' IS ''это учебная таблица''';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка для таблицы ' || table_rec.table_name || ': ' || SQLERRM);
    END;
  END LOOP;
END;

----
BEGIN
  FOR table_rec IN (SELECT table_name FROM user_tab_comments) 
  LOOP
    IF table_rec.comments IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(table_rec.table_name || 'уже имеет комментарий' );
        CONTINUE;
    END IF;
    BEGIN
      EXECUTE IMMEDIATE 
        'COMMENT ON TABLE KC2203_16.' || table_rec.table_name || ' IS ''это таблица кс2203_16''';
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка для таблицы ' || table_rec.table_name || ': ' || SQLERRM);
    END;
  END LOOP;
END;
--------------------



