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
-- следующая дата запуска 15 июня 2025
DECLARE
    v_next_run_date TIMESTAMP;
BEGIN
DBMS_SCHEDULER.EVALUATE_CALENDAR_STRING (
    'FREQ=HOURLY; INTERVAL=4; BYMONTH=1,2,3,4; BYDAY=FRI',
    TO_DATE('15.06.2025'),
    NULL,
    v_next_run_date
);
    DBMS_OUTPUT.PUT_LINE('Следующая дата выполнения: ' || TO_CHAR(v_next_run_date));
END;
-- интервал по месяцам каждые два месяца
BEGIN
dbms_scheduler.create_schedule('hourly_4_fri', repeat_interval => 'FREQ=HOURLY; INTERVAL=4; BYDAY=FRI');
dbms_scheduler.create_schedule('monthly_2m', repeat_interval => 'FREQ=MONTHLY;INTERVAL=2');
END;

BEGIN
DBMS_SCHEDULER.SET_ATTRIBUTE (
    name             => 'ALTER_COSTS_INDEX_JOB',
    attribute        => 'repeat_interval',
    value            => 'FREQ=MONTHLY; INTERVAL=2; BYDAY=FRI; BYHOUR=0,4,8,12,16,20');
END;

DECLARE
    v_next_run_date TIMESTAMP;
BEGIN
DBMS_SCHEDULER.EVALUATE_CALENDAR_STRING (
    'FREQ=MONTHLY; INTERVAL=2; BYDAY=FRI; BYHOUR=0,4,8,12,16,20',
    TO_DATE('28.06.2025'),
    NULL,
    v_next_run_date
);
    DBMS_OUTPUT.PUT_LINE('Следующая дата выполнения: ' || TO_CHAR(v_next_run_date));
END;

BEGIN
DBMS_SCHEDULER.SET_ATTRIBUTE (
    name             => 'ALTER_COSTS_INDEX_JOB',
    attribute        => 'repeat_interval',
    value            => 'FREQ=HOURLY; INTERVAL=4; BYMONTH=1,2,3,4; BYDAY=FRI');
END;

BEGIN
DBMS_SCHEDULER.SET_ATTRIBUTE (
    name             => 'ALTER_COSTS_INDEX_JOB',
    attribute        => 'job_action',
    value            => ' BEGIN
                            IF MOD(EXTRACT(MONTH FROM SYSDATE), 2) = 0 THEN
                                SH.ALTER_TAB_INDX(''COSTS'');
                            END IF;
                          END;');
END;
--    job_action       => 'BEGIN SH.ALTER_TAB_INDX(''COSTS''); END;',

select * from DBA_SCHEDULER_JOBS order by job_name;
-- select * from COSTS;
