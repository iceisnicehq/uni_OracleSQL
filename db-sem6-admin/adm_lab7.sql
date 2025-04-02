SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


EXPLAIN PLAN FOR -- 1369 select
    SELECT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t
    JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
    JOIN flights f ON f.flight_id=tf.flight_id
    WHERE t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no

CREATE MATERIALIZED VIEW mv_ticket_flight_info
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
START WITH SYSDATE
NEXT SYSDATE + 7
AS
    SELECT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t
    JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
    JOIN flights f ON f.flight_id=tf.flight_id
    WHERE t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no;

DROP MATERIALIZED VIEW mv_ticket_flight_info;

EXPLAIN PLAN FOR -- 3
    SELECT * FROM mv_ticket_flight_info;

BEGIN
    DBMS_MVIEW.REFRESH('mv_ticket_flight_info');
END;

CREATE INDEX idx_tickets_ticket_no ON tickets(ticket_no);
CREATE INDEX idx_ticket_flights_ticket_no ON ticket_flights(ticket_no);
CREATE INDEX idx_ticket_flights_flight_id ON ticket_flights(flight_id);
CREATE INDEX idx_flights_flight_id ON flights(flight_id);
CREATE INDEX idx_tickets_passenger_id ON tickets(passenger_id);

EXPLAIN PLAN FOR -- 1368 select NO ORDER BY
    SELECT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t
    JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
    JOIN flights f ON f.flight_id=tf.flight_id
    WHERE t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    --ORDER BY t.ticket_no
    
EXPLAIN PLAN FOR -- 35858 select NO WHERE CLAUSE
    SELECT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t
    JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
    JOIN flights f ON f.flight_id=tf.flight_id
    --WHERE t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no
    
EXPLAIN PLAN FOR -- 1370 DISTINCT
    SELECT DISTINCT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t
    JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
    JOIN flights f ON f.flight_id=tf.flight_id
    WHERE t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no
    
EXPLAIN PLAN FOR -- 65142 DISTINCT + NO WHERE
    SELECT DISTINCT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t
    JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
    JOIN flights f ON f.flight_id=tf.flight_id
    -- WHERE t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no

EXPLAIN PLAN FOR -- 35858 DISTINCT + NO WHERE + NO ORDER
    SELECT DISTINCT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t
    JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
    JOIN flights f ON f.flight_id=tf.flight_id
    -- WHERE t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    --ORDER BY t.ticket_no
    
EXPLAIN PLAN FOR -- 1369 NO JOIN
    SELECT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, 
           tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t, ticket_flights tf, flights f
    WHERE t.ticket_no = tf.ticket_no
      AND tf.flight_id = f.flight_id
      AND t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no;

EXPLAIN PLAN FOR -- 1370 DISTINT + NO JOIN
    SELECT DISTINCT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, 
           tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t, ticket_flights tf, flights f
    WHERE t.ticket_no = tf.ticket_no
      AND tf.flight_id = f.flight_id
      AND t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no;

EXPLAIN PLAN FOR -- 18T NO WHERE + NO JOIN
    SELECT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, 
           tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t, ticket_flights tf, flights f
--    WHERE t.ticket_no = tf.ticket_no
--      AND tf.flight_id = f.flight_id
--      AND t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
    ORDER BY t.ticket_no;
    
EXPLAIN PLAN FOR -- 16T NO WHERE + NO JOIN + NO ORDER
    SELECT t.ticket_no, t.book_ref, t.passenger_name, t.contact_data, 
           tf.fare_conditions, f.departure_airport, f.arrival_airport, tf.amount
    FROM tickets t, ticket_flights tf, flights f
--    WHERE t.ticket_no = tf.ticket_no
--      AND tf.flight_id = f.flight_id
--      AND t.passenger_id IN ('1576 926666', '6209 127371', '7140 936574')
-- ORDER BY t.ticket_no;
