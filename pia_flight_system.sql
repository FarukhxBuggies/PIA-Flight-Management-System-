CREATE DATABASE IF NOT EXISTS pia_flight_system;

USE pia_flight_system;

CREATE TABLE IF NOT EXISTS Flights (
    flight_number VARCHAR(10) PRIMARY KEY,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    source VARCHAR(100),
    destination VARCHAR(100),
    capacity INT
);

CREATE TABLE IF NOT EXISTS Passengers (
    passport_number VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Bookings (
    booking_reference VARCHAR(20) PRIMARY KEY,
    passport_number VARCHAR(20),
    flight_number VARCHAR(10),
    seat_class VARCHAR(20),
    FOREIGN KEY (passport_number) REFERENCES Passengers(passport_number),
    FOREIGN KEY (flight_number) REFERENCES Flights(flight_number)
);

INSERT INTO Flights (flight_number, departure_time, arrival_time, source, destination, capacity)
VALUES ('PK-001', '2025-12-10 10:00:00', '2025-12-10 14:00:00', 'Karachi', 'Lahore', 180);

INSERT INTO Passengers (passport_number, name, email, phone)
VALUES ('A123456789', 'John Doe', 'john.doe@example.com', '1234567890');
