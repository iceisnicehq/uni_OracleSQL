---------------------------------TRASH

CREATE OR REPLACE PACKAGE FlightReservationPackage AS
    -- Function to check flight availability
    FUNCTION IsFlightAvailable(
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) RETURN NUMBER;

    -- Function to get passenger reservations
    FUNCTION GetPassengerReservations(
        p_passenger_id IN tickets.passenger_id%TYPE
    ) RETURN SYS_REFCURSOR;

    -- Procedure to make a reservation
    PROCEDURE MakeReservation(
        p_passenger_ids IN passenger_id_list, -- Используем VARRAY
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    );

    -- Function to calculate total revenue for a flight
    FUNCTION CalculateTotalRevenue(
        p_flight_id IN flights.flight_id%TYPE
    ) RETURN NUMBER;
END FlightReservationPackage;

CREATE OR REPLACE TYPE passenger_id_list AS VARRAY(10) OF VARCHAR(20);
--SELECT * FROM TICKETS;
--DESC TICKETS;
-- File: create_package_body.sql
CREATE OR REPLACE PACKAGE BODY FlightReservationPackage AS
    -- Implement IsFlightAvailable
    FUNCTION IsFlightAvailable(
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) RETURN NUMBER IS
        v_total_seats NUMBER;
        v_booked_seats NUMBER;
    BEGIN
        -- Get total seats for the flight and class
        SELECT COUNT(*)
        INTO v_total_seats
        FROM seats s
        JOIN flights f ON s.aircraft_code = f.aircraft_code
        WHERE f.flight_id = p_flight_id
          AND s.fare_conditions = p_fare_conditions;

        -- Get booked seats for the flight and class
        SELECT COUNT(*)
        INTO v_booked_seats
        FROM ticket_flights tf
        JOIN flights f ON tf.flight_id = f.flight_id
        WHERE f.flight_id = p_flight_id
          AND tf.fare_conditions = p_fare_conditions
          AND TRUNC(f.scheduled_departure) = TRUNC(p_flight_date);

        -- Return available seats
        RETURN v_total_seats - v_booked_seats;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RAISE;
    END IsFlightAvailable;

    -- Implement GetPassengerReservations
    FUNCTION GetPassengerReservations(
        p_passenger_id IN tickets.passenger_id%TYPE
    ) RETURN SYS_REFCURSOR IS
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
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No reservations found for the passenger.');
        WHEN OTHERS THEN
            RAISE;
    END GetPassengerReservations;

   -- Implement MakeReservation
    PROCEDURE MakeReservation(
        p_passenger_ids IN passenger_id_list, -- Используем VARRAY
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
    BEGIN
        -- Validate passengers
        FOR i IN 1..p_passenger_ids.COUNT LOOP
            SELECT COUNT(*)
            INTO v_passenger_exists
            FROM tickets
            WHERE passenger_id = p_passenger_ids(i);

            IF v_passenger_exists = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Passenger ' || p_passenger_ids(i) || ' does not exist.');
            END IF;
        END LOOP;

        -- Check ticket availability
        v_available_tickets := IsFlightAvailable(p_flight_id, p_fare_conditions, p_flight_date);
        IF v_available_tickets < p_passenger_ids.COUNT THEN
            RAISE_APPLICATION_ERROR(-20003, 'Not enough tickets.');
        END IF;

        -- Generate booking reference
        SELECT DBMS_RANDOM.STRING('X', 6) INTO v_book_ref FROM dual;

        -- Generate random total amount
        SELECT TRUNC(DBMS_RANDOM.VALUE(1000, 10000)) INTO v_total_amount FROM dual;

        -- Insert booking
        INSERT INTO bookings (book_ref, book_date, total_amount)
        VALUES (v_book_ref, SYSDATE, v_total_amount);

        -- Generate tickets
        FOR i IN 1..p_passenger_ids.COUNT LOOP
            -- Generate ticket number
            SELECT DBMS_RANDOM.STRING('X', 6) INTO v_ticket_no FROM dual;

            -- Generate random ticket amount
            SELECT TRUNC(DBMS_RANDOM.VALUE(1000, 10000)) INTO v_ticket_amount FROM dual;

            -- Insert ticket
            INSERT INTO tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data)
            SELECT v_ticket_no, v_book_ref, passenger_id, passenger_name, contact_data
            FROM tickets
            WHERE passenger_id = p_passenger_ids(i) AND ROWNUM = 1;

            -- Link ticket to flight
            INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount)
            VALUES (v_ticket_no, p_flight_id, p_fare_conditions, v_ticket_amount);
        END LOOP;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20004, 'Error: ' || SQLERRM);
    END MakeReservation;

    -- Implement CalculateTotalRevenue
    FUNCTION CalculateTotalRevenue(
        p_flight_id IN flights.flight_id%TYPE
    ) RETURN NUMBER IS
        v_total_revenue NUMBER := 0;
    BEGIN
        -- Sum the total revenue for the flight
        SELECT NVL(SUM(b.total_amount), 0)
        INTO v_total_revenue
        FROM ticket_flights tf
        JOIN tickets t ON tf.ticket_no = t.ticket_no
        JOIN bookings b ON t.book_ref = b.book_ref
        WHERE flight_id = p_flight_id;

        RETURN v_total_revenue;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RAISE;
    END CalculateTotalRevenue;
END FlightReservationPackage;

-- FUNC 1 
SELECT FlightReservationPackage.IsFlightAvailable(2055, 'Economy', '16-JUL-17') FROM DUAL

SELECT *
FROM seats s
JOIN flights f ON s.aircraft_code = f.aircraft_code
WHERE f.flight_id = 2055
  AND s.fare_conditions = 'Economy';

SELECT *
FROM ticket_flights tf
JOIN flights f ON tf.flight_id = f.flight_id
JOIN boarding_passes b 
  ON tf.ticket_no = b.ticket_no      -- Ключевое условие!
  AND tf.flight_id = b.flight_id     -- Дополнительная точность
WHERE f.flight_id = 2055
  AND tf.fare_conditions = 'Economy'
  AND TRUNC(f.scheduled_departure) = TO_DATE('16-JUL-17', 'DD-MON-YY');

-- FUNC 2 
SELECT * FROM tickets
SELECT FlightReservationPackage.GetPassengerReservations('6615 976589') FROM DUAL;

-- PROC 3
SELECT * 
FROM ticket_flights tf
JOIN tickets t ON t.ticket_no = tf.ticket_no
JOIN flights f ON tf.flight_id = f.flight_id
WHERE f.flight_id = 30625;

DECLARE
    v_passenger_ids passenger_id_list := passenger_id_list('3952 666242', '9933 118369');
BEGIN
    FlightReservationPackage.MakeReservation(
        v_passenger_ids,
        30625,
        'Economy',
        TO_DATE('16-JUL-17', 'DD-MON-YY')
    );
    DBMS_OUTPUT.PUT_LINE('Reservation successful.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

-- FUNC 4 (additional)
SELECT FlightReservationPackage.CalculateTotalRevenue(2055) FROM DUAL;
