BEGIN
DBMS_SCHEDULER.CREATE_JOB (
    job_name         => 'ALTER_COSTS_INDEX_JOB',
    job_type         => 'PLSQL_BLOCK',
    job_action       => 'BEGIN SH.ALTER_TAB_INDX(''COSTS''); END;',
    job_class        => 'DBMS_JOB$',
    start_date       => TRUNC(sysdate),
    repeat_interval  => 'FREQ=HOURLY; INTERVAL=4; BYMONTH=1,2,3,4; BYDAY=FRI',
    enabled          => TRUE);
END;

BEGIN
DBMS_SCHEDULER.DROP_JOB(    job_name         => 'ALTER_COSTS_INDEX_JOB');
END;

select * from DBA_SCHEDULER_JOBS order by job_name;
-- select * from COSTS;
