CREATE OR REPLACE TYPE passenger_id_list AS VARRAY(10) OF VARCHAR(20);

CREATE OR REPLACE PACKAGE FlightReservationPackage AS
    FUNCTION IsFlightAvailable(
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) RETURN NUMBER;

    FUNCTION GetPassengerReservations(
        p_passenger_id IN tickets.passenger_id%TYPE
    ) RETURN SYS_REFCURSOR;

    PROCEDURE MakeReservation(
        p_passenger_ids IN passenger_id_list, 
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    );

    FUNCTION CalculateTotalRevenue(
        p_flight_id IN flights.flight_id%TYPE
    ) RETURN NUMBER;
END FlightReservationPackage;

CREATE OR REPLACE PACKAGE BODY FlightReservationPackage AS
    FUNCTION IsFlightAvailable(
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) RETURN NUMBER 
        IS
            v_total_seats NUMBER;
            v_booked_seats NUMBER;
        BEGIN
        SELECT COUNT(*)
            INTO v_total_seats
            FROM seats s
            JOIN flights f ON s.aircraft_code = f.aircraft_code
            WHERE f.flight_id = p_flight_id
                AND s.fare_conditions = p_fare_conditions;

        SELECT COUNT(*)
            INTO v_booked_seats
            FROM ticket_flights tf
            JOIN flights f ON tf.flight_id = f.flight_id
            WHERE f.flight_id = p_flight_id
                AND tf.fare_conditions = p_fare_conditions
                AND TRUNC(f.scheduled_departure) = TRUNC(p_flight_date);
        RETURN v_total_seats - v_booked_seats;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 0;
        WHEN OTHERS THEN RAISE;
    END IsFlightAvailable;

    FUNCTION GetPassengerReservations(
        p_passenger_id IN tickets.passenger_id%TYPE
    ) RETURN 
    SYS_REFCURSOR 
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT 
                t.ticket_no,
                t.book_ref,
                t.passenger_name,
                tf.flight_id,
                tf.fare_conditions,
                f.scheduled_departure,
                f.scheduled_arrival,
                f.departure_airport,
                f.arrival_airport,
                f.status
            FROM tickets t
                JOIN ticket_flights tf ON t.ticket_no = tf.ticket_no
                JOIN flights f ON tf.flight_id = f.flight_id
            WHERE t.passenger_id = p_passenger_id;
        RETURN v_cursor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20001, 'У этого пассажира нет бронирований.');
        WHEN OTHERS THEN RAISE;
    END GetPassengerReservations;
    
    
    PROCEDURE MakeReservation(
        p_passenger_ids IN passenger_id_list,
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) IS
        v_available_tickets NUMBER;
        v_book_ref bookings.book_ref%TYPE;
        v_ticket_no tickets.ticket_no%TYPE;
        v_passenger_exists NUMBER;
        v_total_amount bookings.total_amount%TYPE;
        v_ticket_amount ticket_flights.amount%TYPE;
        v_passenger_name tickets.passenger_name%TYPE;
        v_contact_data tickets.contact_data%TYPE;
    BEGIN
        FOR i IN 1..p_passenger_ids.COUNT LOOP
            SELECT COUNT(*)
            INTO v_passenger_exists
            FROM tickets
            WHERE passenger_id = p_passenger_ids(i);

            IF v_passenger_exists = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Пассажир ' || p_passenger_ids(i) || ' не существует.');
            END IF;
        END LOOP;
        v_available_tickets := IsFlightAvailable(p_flight_id, p_fare_conditions, p_flight_date);
        IF v_available_tickets < p_passenger_ids.COUNT THEN
            RAISE_APPLICATION_ERROR(-20003, 'Билетов меньше, чем пассажиров.');
        END IF;
        SELECT DBMS_RANDOM.STRING('X', 6) INTO v_book_ref FROM dual;
        SELECT TRUNC(DBMS_RANDOM.VALUE(1000, 10000)) INTO v_total_amount FROM dual;
        INSERT INTO bookings (book_ref, book_date, total_amount)
        VALUES (v_book_ref, SYSDATE, v_total_amount);
        FOR i IN 1..p_passenger_ids.COUNT LOOP
            SELECT DBMS_RANDOM.STRING('X', 6) INTO v_ticket_no FROM dual;
            SELECT TRUNC(DBMS_RANDOM.VALUE(1000, 10000)) INTO v_ticket_amount FROM dual;
            SELECT passenger_name, contact_data
            INTO v_passenger_name, v_contact_data
            FROM tickets
            WHERE passenger_id = p_passenger_ids(i) AND ROWNUM = 1;
            INSERT INTO tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data)
            VALUES (v_ticket_no, v_book_ref, p_passenger_ids(i), v_passenger_name, v_contact_data);
            INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount)
            VALUES (v_ticket_no, p_flight_id, p_fare_conditions, v_ticket_amount);
            DBMS_OUTPUT.PUT_LINE('Добавлено бронирование ' || v_book_ref || 'и билет ' || v_ticket_no);
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN RAISE;
    END MakeReservation;
    
    FUNCTION CalculateTotalRevenue(
        p_flight_id IN flights.flight_id%TYPE
    ) RETURN NUMBER 
    IS
        v_total_revenue NUMBER := 0;
    BEGIN
        SELECT SUM(b.total_amount)
            INTO v_total_revenue
            FROM ticket_flights tf
                JOIN tickets t ON tf.ticket_no = t.ticket_no
                JOIN bookings b ON t.book_ref = b.book_ref
            WHERE flight_id = p_flight_id;
        RETURN v_total_revenue;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN 0;
        WHEN OTHERS THEN RAISE;
    END CalculateTotalRevenue;
END FlightReservationPackage;

SELECT SYSDATE FROM DUAL;

-- 1
SELECT FlightReservationPackage.IsFlightAvailable(2055, 'Economy', '16.07.17') FROM DUAL

SELECT *
FROM seats s
JOIN flights f ON s.aircraft_code = f.aircraft_code
WHERE f.flight_id = 2055
  AND s.fare_conditions = 'Economy';

SELECT *
FROM ticket_flights tf
JOIN flights f ON tf.flight_id = f.flight_id
JOIN boarding_passes b 
  ON tf.ticket_no = b.ticket_no        AND tf.flight_id = b.flight_id     WHERE f.flight_id = 2055
  AND tf.fare_conditions = 'Economy'
  AND TRUNC(f.scheduled_departure) = TO_DATE('16.07.17', 'DD.MM.YY');

-- 2
SELECT * FROM tickets
SELECT FlightReservationPackage.GetPassengerReservations('6615 976589') FROM DUAL;

-- 3 
SELECT * 
FROM ticket_flights tf
JOIN tickets t ON t.ticket_no = tf.ticket_no
JOIN flights f ON tf.flight_id = f.flight_id
WHERE f.flight_id = 30625;

DECLARE
    v_passenger_ids passenger_id_list := passenger_id_list('6615 976589', '2290 450397');
BEGIN
    FlightReservationPackage.MakeReservation(
        v_passenger_ids,
        30625,
        'Economy',
        TO_DATE('16.07.17', 'DD.MM.YY')
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
SELECT * FROM tickets WHERE ticket_no = 'SHK989';
--4
SELECT FlightReservationPackage.CalculateTotalRevenue(2055) FROM DUAL;
