CREATE DATABASE IF NOT EXISTS roadwise_rental;
USE roadwise_rental;

DROP TABLE IF EXISTS Maintenance;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS VehicleType;
DROP TABLE IF EXISTS User;

CREATE TABLE User (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(160) NOT NULL UNIQUE,
  phone VARCHAR(30),
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE VehicleType (
  vehicle_type_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(60) NOT NULL UNIQUE,
  description VARCHAR(255),
  icon VARCHAR(10) NOT NULL DEFAULT 'CAR'
);

CREATE TABLE Vehicle (
  vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
  vehicle_type_id INT NOT NULL,
  make VARCHAR(60) NOT NULL,
  model VARCHAR(80) NOT NULL,
  year SMALLINT NOT NULL,
  registration_number VARCHAR(30) NOT NULL UNIQUE,
  color VARCHAR(30),
  seats TINYINT NOT NULL DEFAULT 5,
  price_per_day DECIMAL(10, 2) NOT NULL,
  status ENUM('available', 'maintenance', 'retired') NOT NULL DEFAULT 'available',
  image_url VARCHAR(500),
  FOREIGN KEY (vehicle_type_id) REFERENCES VehicleType(vehicle_type_id)
);

CREATE TABLE Booking (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  pickup_location VARCHAR(160) NOT NULL,
  total_cost DECIMAL(10, 2) NOT NULL,
  status ENUM('reserved', 'active', 'completed', 'cancelled') NOT NULL DEFAULT 'reserved',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES User(user_id),
  FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
  CHECK (end_date >= start_date)
);

CREATE TABLE Payment (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  booking_id INT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  payment_method ENUM('card', 'cash', 'transfer') NOT NULL DEFAULT 'card',
  status ENUM('pending', 'paid', 'refunded') NOT NULL DEFAULT 'pending',
  paid_at TIMESTAMP NULL,
  FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE TABLE Maintenance (
  maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
  vehicle_id INT NOT NULL,
  service_type VARCHAR(120) NOT NULL,
  notes TEXT,
  scheduled_date DATE NOT NULL,
  completed_date DATE NULL,
  cost DECIMAL(10, 2) DEFAULT 0,
  status ENUM('scheduled', 'in_progress', 'completed') NOT NULL DEFAULT 'scheduled',
  FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

INSERT INTO User (full_name, email, phone, password_hash, role) VALUES
('Alex Morgan', 'alex@roadwise.local', '+1 555 0134', 'scrypt$3480756c3c8d3b6b6acdd26f3ea67dd1$e2ff493f35fc27580ed2a381e06ea34e8194059a3c3a1f02ca367daaa1776c3857900914e646b9b8895561ed09a50527b355f9cf36f0d2034664afd31ff68c08', 'customer'),
('Roadwise Admin', 'admin@roadwise.local', '+1 555 0100', 'scrypt$058c3cca15d832f3f679245e294028bf$9c948191d881b89049a8c0612395fefa0ea2b2ff8331323d2b400e06d5bf197487f5314b90e97cc1c259d5414259bd83dee1e4aa428721a50d3007cbcec44a5f', 'admin');

INSERT INTO VehicleType (name, description, icon) VALUES
('City', 'Compact rides for everyday movement', 'CITY'),
('SUV', 'Confident space for longer journeys', 'SUV'),
('Electric', 'Quiet, efficient and future-facing', 'EV'),
('Luxury', 'Elevated comfort for special trips', 'LUX');

INSERT INTO Vehicle (vehicle_type_id, make, model, year, registration_number, color, seats, price_per_day, image_url) VALUES
(1, 'Toyota', 'Yaris', 2023, 'RW-101-CY', 'Pearl white', 5, 39.00, 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&w=900&q=85'),
(2, 'Volvo', 'XC60', 2024, 'RW-204-SV', 'Moss green', 5, 82.00, 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=900&q=85'),
(3, 'Tesla', 'Model 3', 2024, 'RW-309-EV', 'Midnight black', 5, 76.00, 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?auto=format&fit=crop&w=900&q=85'),
(4, 'Mercedes-Benz', 'E-Class', 2023, 'RW-412-LX', 'Graphite', 5, 128.00, 'https://images.unsplash.com/photo-1563720223185-11003d516935?auto=format&fit=crop&w=900&q=85'),
(2, 'Jeep', 'Wrangler', 2022, 'RW-507-SV', 'Sand', 5, 94.00, 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=900&q=85'),
(1, 'Honda', 'Civic', 2023, 'RW-618-CY', 'Ocean blue', 5, 48.00, 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?auto=format&fit=crop&w=900&q=85');

INSERT INTO Booking (user_id, vehicle_id, start_date, end_date, pickup_location, total_cost, status) VALUES
(1, 3, DATE_SUB(CURDATE(), INTERVAL 8 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Downtown Station', 228.00, 'completed'),
(1, 2, DATE_ADD(CURDATE(), INTERVAL 12 DAY), DATE_ADD(CURDATE(), INTERVAL 15 DAY), 'Airport Terminal 1', 328.00, 'reserved');

INSERT INTO Payment (booking_id, amount, payment_method, status, paid_at) VALUES
(1, 228.00, 'card', 'paid', DATE_SUB(NOW(), INTERVAL 8 DAY)),
(2, 328.00, 'card', 'paid', NOW());

INSERT INTO Maintenance (vehicle_id, service_type, notes, scheduled_date, status) VALUES
(5, 'Tire rotation', 'Replace rear tires if tread is below 4mm.', DATE_ADD(CURDATE(), INTERVAL 4 DAY), 'scheduled');
