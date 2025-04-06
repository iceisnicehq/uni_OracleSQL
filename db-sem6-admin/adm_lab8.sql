-- ВСЕ ЗАДАНИЯ ВЫПОЛНЯЮТСЯ В SQLPlus, ЕСЛИ ЯВНО НЕ УКАЗАНО ОБРАТНОЕ
-- 1.     Зайдите в SQLPlus под пользователем SYS в PDB
-- 2.     Выведите информацию о файлах табличных пространств для PDB
-- 3.     Создайте новый файл в табличном пространстве  USERS с именем USER03.dbf с начальным размером 760Мб без возможности авторасширения.
-- 4.     Вывести SQL текст, выполняемый всеми активными сессиями.
-- 5.     Зайти в SQLPlus под SYS в СDB.
-- 6.     Создайте пользователя С##USER1.
-- 7.     Создать роль my_common.
-- 8.     Дать роли  my_common  права на создание сессии.
-- 9.     Дать пользователю C##USER1 роль my_common.
-- 10.    Зайдите в SQLDeveloper под пользователем C##USER1.
  
-- 1. 
sqlplus sys@XEPDB1 as sysdba

-- 2. 
SELECT file_name, tablespace_name, bytes/1024/1024 "SIZE_MB" FROM dba_data_files;

-- Посмотри где находятся файлы .dbf? У тебя на компе как в примере
-- 3. 
ALTER TABLESPACE USERS 
  ADD DATAFILE '/opt/oracle/oradata/ORCLCDB/ORCLPDB1/USER03.dbf' 
  SIZE 760M AUTOEXTEND OFF;

-- 4. 
SELECT s.sid, s.serial#, q.sql_text 
  FROM v$session s 
  JOIN v$sql q ON s.sql_id = q.sql_id 
  WHERE s.status = 'ACTIVE';

-- 5. Я делал так sqlplus sys/password@localhost:1521/XEPDB1 as sysdba
sqlplus sys as sysdba
Password: ???
  
-- 6.
CREATE USER C##USER1 IDENTIFIED BY password;

-- 7.
CREATE ROLE C##my_common CONTAINER = ALL;

-- 8.
GRANT CREATE SESSION TO C##my_common CONTAINER = ALL;

-- 9.
GRANT C##my_common TO C##USER1 CONTAINER = ALL;

-- 10.
Username: USER1
Password: password
Hostname: ???
Port: ???
Service name: XEPDB1
