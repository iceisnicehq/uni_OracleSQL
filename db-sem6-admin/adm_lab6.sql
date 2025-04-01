--1 Написать запрос к системному словарю, который выведет таблицы базы данных, для столбцов которых определены комментарии.

SELECT * --DISTINCT table_name
FROM user_col_comments
WHERE comments IS NOT NULL;

SELECT DISTINCT table_name
FROM user_col_comments
WHERE comments IS NOT NULL;

--2 С помощью запроса к системному словарю сделать скрипт, который позволит ко всем таблицам схемы SH добавить комментарий “это учебная таблица”.

BEGIN
  EXECUTE IMMEDIATE 'COMMENT ON TABLE KC2203_15.PIGS IS ''это swine''';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;

SELECT *
FROM all_tables
WHERE owner = 'KC2203_15';

COMMENT ON TABLE KC2203_15.Hangar IS 'это учебная таблица';

SELECT * FROM all_tab_comments WHERE owner = 'KC2203_15';


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
