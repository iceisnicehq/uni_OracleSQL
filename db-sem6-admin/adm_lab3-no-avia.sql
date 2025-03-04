CREATE OR REPLACE PACKAGE FlightReservationPackage AS
    -- Объявление функции IsFlightAvailable
    FUNCTION IsFlightAvailable(
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) RETURN NUMBER;

    -- Объявление функции GetPassengerReservations
    FUNCTION GetPassengerReservations(
        p_passenger_id IN tickets.passenger_id%TYPE
    ) RETURN SYS_REFCURSOR;

    -- Объявление процедуры MakeReservation
    PROCEDURE MakeReservation(
        p_passenger_ids IN SYS.ODCINUMBERLIST, -- Список ID пассажиров (от 1 до 10)
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    );
END FlightReservationPackage;


CREATE OR REPLACE PACKAGE BODY FlightReservationPackage AS
    -- Реализация функции IsFlightAvailable
    FUNCTION IsFlightAvailable(
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) RETURN NUMBER IS
        v_total_seats NUMBER;
        v_booked_seats NUMBER;
    BEGIN
        -- Получаем общее количество мест для указанного класса на самолете
        SELECT COUNT(*)
        INTO v_total_seats
        FROM seats s
        JOIN flights f ON s.aircraft_code = f.aircraft_code
        WHERE f.flight_id = p_flight_id
          AND s.fare_conditions = p_fare_conditions;

        -- Получаем количество уже забронированных мест для указанного рейса и класса
        SELECT COUNT(*)
        INTO v_booked_seats
        FROM ticket_flights tf
        JOIN flights f ON tf.flight_id = f.flight_id
        WHERE f.flight_id = p_flight_id
          AND tf.fare_conditions = p_fare_conditions
          AND TRUNC(f.scheduled_departure) = TRUNC(p_flight_date);

        -- Возвращаем количество доступных билетов
        RETURN v_total_seats - v_booked_seats;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RAISE;
    END IsFlightAvailable;

    -- Реализация функции GetPassengerReservations
    FUNCTION GetPassengerReservations(
        p_passenger_id IN tickets.passenger_id%TYPE
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        -- Открываем курсор для возврата информации о бронированиях
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
            WHERE t.passenger_id = p_passenger_id
              AND f.scheduled_departure > SYSDATE; -- Только будущие рейсы

        RETURN v_cursor;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No reservations found for the passenger.');
        WHEN OTHERS THEN
            RAISE;
    END GetPassengerReservations;

    -- Реализация процедуры MakeReservation
    PROCEDURE MakeReservation(
        p_passenger_ids IN SYS.ODCINUMBERLIST, -- Список ID пассажиров
        p_flight_id IN flights.flight_id%TYPE,
        p_fare_conditions IN ticket_flights.fare_conditions%TYPE,
        p_flight_date IN DATE
    ) IS
        v_available_tickets NUMBER;
        v_book_ref bookings.book_ref%TYPE;
        v_ticket_no tickets.ticket_no%TYPE;
        v_passenger_exists NUMBER;
    BEGIN
        -- Проверяем, что все пассажиры существуют в системе
        FOR i IN 1..p_passenger_ids.COUNT LOOP
            SELECT COUNT(*)
            INTO v_passenger_exists
            FROM tickets
            WHERE passenger_id = p_passenger_ids(i);

            IF v_passenger_exists = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Passenger with ID ' || p_passenger_ids(i) || ' does not exist.');
            END IF;
        END LOOP;

        -- Проверяем доступность билетов
        v_available_tickets := IsFlightAvailable(p_flight_id, p_fare_conditions, p_flight_date);

        IF v_available_tickets < p_passenger_ids.COUNT THEN
            RAISE_APPLICATION_ERROR(-20003, 'Not enough tickets available for the selected flight and class.');
        END IF;

        -- Генерируем уникальный номер бронирования
        SELECT 'BR' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || DBMS_RANDOM.STRING('X', 4)
        INTO v_book_ref
        FROM dual;

        -- Добавляем запись в таблицу bookings
        INSERT INTO bookings (book_ref, book_date, total_amount)
        VALUES (v_book_ref, SYSDATE, 0); -- Сумма будет обновлена позже

        -- Добавляем билеты для каждого пассажира
        FOR i IN 1..p_passenger_ids.COUNT LOOP
            -- Генерируем уникальный номер билета
            SELECT 'TK' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || DBMS_RANDOM.STRING('X', 4)
            INTO v_ticket_no
            FROM dual;

            -- Добавляем запись в таблицу tickets
            INSERT INTO tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data)
            SELECT v_ticket_no, v_book_ref, passenger_id, passenger_name, contact_data
            FROM tickets
            WHERE passenger_id = p_passenger_ids(i)
            AND ROWNUM = 1;

            -- Добавляем запись в таблицу ticket_flights
            INSERT INTO ticket_flights (ticket_no, flight_id, fare_conditions, amount)
            VALUES (v_ticket_no, p_flight_id, p_fare_conditions, 0); -- Сумма будет обновлена позже
        END LOOP;

        -- Фиксируем изменения
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            -- Откатываем изменения в случае ошибки
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20004, 'Reservation failed: ' || SQLERRM);
    END MakeReservation;
END FlightReservationPackage;
