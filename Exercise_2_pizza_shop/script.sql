CREATE DATABASE IF NOT EXISTS Pizza_shop;

USE Pizza_shop;

CREATE TABLE Store (
	Id_store INT AUTO_INCREMENT,
	Address VARCHAR(50) NOT NULL,
	PC VARCHAR(15) NOT NULL,
	City VARCHAR(50) NOT NULL,
	Province VARCHAR(50),
	PRIMARY KEY (Id_store)
);

CREATE TABLE Category (
	Id_category INT AUTO_INCREMENT,
	Name VARCHAR(50) NOT NULL,
	PRIMARY KEY (Id_category)
);

CREATE TABLE Product (
	Id_product INT AUTO_INCREMENT,
	Type ENUM('Pizza', 'Burguer', 'Drink') NOT NULL,
	Id_category INT,
	Name VARCHAR(50) NOT NULL,
	Description VARCHAR(50),
	Photo BLOB,
	Price FLOAT NOT NULL,
	PRIMARY KEY (Id_product),
    FOREIGN KEY (Id_category) REFERENCES Category(Id_category)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Employee (
	Id_employee INT AUTO_INCREMENT,
	Id_store INT NOT NULL,
	Kitchen_or_delivery ENUM('Kitchen', 'Delivery') NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL,
	NIF VARCHAR(15) NOT NULL,
	Phone VARCHAR(15),
	PRIMARY KEY (Id_employee),
    FOREIGN KEY (Id_store) REFERENCES Store(Id_store)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Customer (
	Id_customer INT AUTO_INCREMENT,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	PC VARCHAR(15) NOT NULL,
	City VARCHAR(50) NOT NULL,
	Province VARCHAR(50),
	Phone VARCHAR(15) NOT NULL,
	PRIMARY KEY (Id_customer)
);

CREATE TABLE Command (
	Id_command INT AUTO_INCREMENT,
	Id_store INT NOT NULL,
	Id_customer INT NOT NULL,
	Command_datetime DATETIME DEFAULT CURRENT_TIMESTAMP,
	Total_amount FLOAT,
	Delivery_or_pickup ENUM('Delivery', 'Pick_up') NOT NULL,
	Id_delivering_employee INT,
	Delivery_datetime DATETIME,
	PRIMARY KEY (Id_command),
    FOREIGN KEY (Id_customer) REFERENCES Customer(Id_customer)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Id_store) REFERENCES Store(Id_store)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Id_delivering_employee) REFERENCES Employee(Id_employee)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Command_detail (
	Id_command INT NOT NULL,
	Id_product INT NOT NULL,
	Quantity INT NOT NULL,
	Unit_price FLOAT NOT NULL,
	Amount FLOAT NOT NULL,
	PRIMARY KEY (Id_command, Id_product),
    FOREIGN KEY (Id_command) REFERENCES Command(Id_command)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Id_product) REFERENCES Product(Id_product)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO Store(Address, PC, City)
VALUES
('Great breakfast 9012', '2000', 'LA'),
('Supercooltrip 701', '1998', 'Malibu'),
('Fast Scooter 451', '1996', 'Santa Monica');

INSERT INTO Category(Name)
VALUES
('Italian pizza'),
('Greek pizza'),
('Argentinian pizza');

INSERT INTO Product(Type, Id_category, Name, Price)
VALUES
('Pizza', 1, 'Capricciosa', 15.99),
('Pizza', 2, 'Partenon', 18.99),
('Pizza', 3, 'Buenos Aires', 20.99),
('Burguer', NULL, 'Cheesse burguer', 9.99),
('Burguer', NULL, 'Vegan burguer', 11.99),
('Drink', NULL, 'Coca-Cola', 1.99),
('Drink', NULL, 'Fanta', 1.99),
('Drink', NULL, 'Sprite', 1.99),
('Drink', NULL, 'Heineken', 2.99);

INSERT INTO Employee(Id_store, Kitchen_or_delivery, Name, Surname, NIF)
VALUES
(1, 'Kitchen', 'Tom', 'Hanks', '123456789A'),  
(1, 'Delivery', 'Will', 'Smith', '987654321B'), 
(2, 'Kitchen', 'Leonardo', 'DiCaprio', '456789123C'), 
(2, 'Delivery', 'Brad', 'Pitt', '789123456D'),  
(3, 'Kitchen', 'Johnny', 'Depp', '234567890E'), 
(3, 'Delivery', 'Scarlett', 'Johansson', '345678901F'),
(1, 'Kitchen', 'Hugh', 'Hefner', '555-HH'), 
(2, 'Delivery', 'Carmen', 'Electra', '555-CE'),
(3, 'Kitchen', 'Gina', 'Davis', '555-GD');

INSERT INTO Customer(Name, Surname, Address, PC, City, Phone)
VALUES
('David', 'Copperfield', 'Beverly Hills 90210', '2000', 'LA', '555555'),
('Mitch', 'Buckanon', 'Beach Street 245', '2000', 'LA', '6666666'),
('Martillo', 'Hammer', 'Rockdeluxe 698', '2000', 'LA', '777777'),
('Pamlea', 'Anderson', 'Sunshine Avenue 2345', '1998', 'Malibu', '677788'),
('Ana Nicole', 'Smith', 'Sand and sea court 142', '1998', 'Malibu', '999999'),
('Dona', 'D Erico', 'Ocean Drive 45', '1996', 'Santa Monica', '98734167');

INSERT INTO Command(Id_store, Id_customer, Total_amount, Delivery_or_pickup, Id_delivering_employee, Delivery_datetime)
VALUES
(1, 1, 32.96, 'Delivery', 2, '2025-01-10 13:15:00'),
(2, 4, 50.96, 'Pick_up', NULL, NULL),
(3, 6, 25.97, 'Delivery', 6, '2025-01-10 15:30:00'),
(1, 2, 39.96, 'Pick_up', NULL, NULL),
(3, 5, 29.97, 'Delivery', 4, '2025-01-11 11:00:00');

INSERT INTO Command_detail(Id_command, Id_product, Quantity, Unit_price, Amount)
VALUES
(1, 1, 2, 15.99, 31.98),
(1, 6, 1, 1.99, 1.99),
(2, 2, 2, 18.99, 37.98),
(2, 8, 2, 2.99, 5.98),
(2, 9, 1, 1.99, 1.99),
(3, 3, 1, 20.99, 20.99),
(3, 7, 1, 2.99, 2.99),
(3, 6, 1, 1.99, 1.99),
(4, 4, 1, 9.99, 9.99),
(4, 5, 2, 11.99, 23.98),
(4, 6, 2, 1.99, 3.98),
(5, 3, 1, 20.99, 20.99),
(5, 9, 1, 1.99, 1.99),
(5, 8, 2, 2.99, 5.98);