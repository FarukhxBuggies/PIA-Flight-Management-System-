# PIA-Flight-Management-System-
A Python-based flight management system for PIA with MySQL integration for managing flights, bookings, passengers, and ticket generation.
import mysql.connector
import logging
from abc import ABC, abstractmethod
from datetime import datetime

logging.basicConfig(filename='flight_system.log', level=logging.INFO, format='%(asctime)s - %(message)s')

class Database:
    def __init__(self):
        self.connection = mysql.connector.connect(
            host="localhost",
            user="your_username",
            password="your_password",
            database="pia_flight_system"
        )
        self.cursor = self.connection.cursor()

    def fetch_flights(self):
        self.cursor.execute("SELECT * FROM Flights")
        return self.cursor.fetchall()

    def fetch_passengers(self):
        self.cursor.execute("SELECT * FROM Passengers")
        return self.cursor.fetchall()

    def fetch_bookings(self):
        self.cursor.execute("SELECT * FROM Bookings")
        return self.cursor.fetchall()

    def insert_flight(self, flight):
        self.cursor.execute('''
            INSERT INTO Flights (flight_number, departure_time, arrival_time, source, destination, capacity)
            VALUES (%s, %s, %s, %s, %s, %s)
        ''', (flight.flight_number, flight.departure_time, flight.arrival_time, flight.source, flight.destination, flight.capacity))
        self.connection.commit()

    def insert_passenger(self, passenger):
        self.cursor.execute('''
            INSERT INTO Passengers (passport_number, name, email, phone)
            VALUES (%s, %s, %s, %s)
        ''', (passenger.passport_number, passenger.name, passenger.email, passenger.phone))
        self.connection.commit()

    def insert_booking(self, booking):
        self.cursor.execute('''
            INSERT INTO Bookings (booking_reference, passport_number, flight_number, seat_class)
            VALUES (%s, %s, %s, %s)
        ''', (booking.booking_reference, booking.passenger.passport_number, booking.flight.flight_number, booking.seat_class))
        self.connection.commit()

    def close(self):
        self.connection.close()


class Flight:
    def __init__(self, flight_number, departure_time, arrival_time, source, destination, capacity):
        self.flight_number = flight_number
        self.departure_time = departure_time
        self.arrival_time = arrival_time
        self.source = source
        self.destination = destination
        self.capacity = capacity
        self.passengers = []

    def add_passenger(self, passenger):
        if len(self.passengers) < self.capacity:
            self.passengers.append(passenger)
            logging.info(f"Passenger {passenger.name} added to flight {self.flight_number}")
        else:
            logging.warning(f"Flight {self.flight_number} is full, cannot add {passenger.name}")
            print("No seats available!")

    def display_flight_info(self):
        print(f"Flight {self.flight_number}: {self.source} -> {self.destination}, "
              f"Departure: {self.departure_time}, Arrival: {self.arrival_time}, "
              f"Seats available: {self.capacity - len(self.passengers)}")


class Passenger:
    def __init__(self, name, passport_number, email, phone):
        self.name = name
        self.passport_number = passport_number
        self.email = email
        self.phone = phone

    def book_flight(self, flight, seat_class):
        flight.add_passenger(self)
        print(f"Booking successful for {self.name} on flight {flight.flight_number}")
        return StandardBooking(self, flight, seat_class)


class Booking(ABC):
    @abstractmethod
    def view_booking(self):
        pass


class StandardBooking(Booking):
    def __init__(self, passenger, flight, seat_class):
        self.booking_reference = f"STD-{passenger.passport_number[:3]}-{flight.flight_number[:3]}"
        self.passenger = passenger
        self.flight = flight
        self.seat_class = seat_class

    def view_booking(self):
        print(f"Booking Reference: {self.booking_reference}, Passenger: {self.passenger.name}, "
              f"Flight: {self.flight.flight_number}, Seat Class: {self.seat_class}")


class Crew:
    def __init__(self, crew_id, name, role, schedule):
        self.crew_id = crew_id
        self.name = name
        self.role = role
        self.schedule = schedule

    def assign_to_flight(self, flight):
        logging.info(f"{self.name} assigned to flight {flight.flight_number} as {self.role}")
        print(f"{self.name} assigned to flight {flight.flight_number} as {self.role}")


class Ticket:
    def __init__(self, booking, price):
        self.ticket_id = f"T-{booking.booking_reference[:6]}"
        self.booking = booking
        self.price = price

    def generate_ticket(self):
        print(f"Ticket ID: {self.ticket_id}, Flight: {self.booking.flight.flight_number}, "
              f"Passenger: {self.booking.passenger.name}, Price: {self.price}")
        logging.info(f"Ticket generated for {self.booking.passenger.name} for flight {self.booking.flight.flight_number}")


def main():
    db = Database()

    flights_data = db.fetch_flights()
    passengers_data = db.fetch_passengers()

    flight1 = Flight(flights_data[0][0], flights_data[0][1], flights_data[0][2], flights_data[0][3], flights_data[0][4], flights_data[0][5])
    passenger1 = Passenger(passengers_data[0][1], passengers_data[0][0], passengers_data[0][2], passengers_data[0][3])

    booking1 = passenger1.book_flight(flight1, "Economy")
    db.insert_booking(booking1)

    ticket1 = Ticket(booking1, 5000)
    ticket1.generate_ticket()

    db.close()


if __name__ == "__main__":
    main()

