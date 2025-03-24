BEGIN
DBMS_SCHEDULER.ALTER_COSTS_INDEX_JOB (
    job_name         => 'ALTER_COSTS_INDEX_JOB',
    job_type         => 'PLSQL_BLOCK',
    job_action       => 'BEGIN SH.ALTER_TAB_INDX('COSTS'); END;',
    job_class        => 'DBMS_JOB$',
    start_date       => TRUNC(sysdate),
    repeat_interval  => 'FREQ=DAILY; BYMONTH=1,2,3,4; BYDAY=FRI; BYHOUR=0,4,8,12,16,20',
    enabled          => TRUE);
END;
