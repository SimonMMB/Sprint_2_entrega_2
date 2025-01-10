CREATE DATABASE IF NOT EXISTS Optical_shop;

USE Optical_shop;

CREATE TABLE Address (
	Id_address int AUTO_INCREMENT,
	Street varchar(50) NOT NULL,
	Number varchar(15) NOT NULL,
	Floor varchar(15),
	Door varchar(15),
	City varchar(50) NOT NULL,
	Postal_code varchar(15) NOT NULL,
	Country varchar(50) NOT NULL,
	PRIMARY KEY (Id_address)
);

CREATE TABLE Supplier (
    Id_supplier int AUTO_INCREMENT,
    Name varchar(50) NOT NULL,
    Id_address int,
    Phone varchar(50) NOT NULL,
    Fax varchar(50),
    NIF varchar(50) NOT NULL,
    PRIMARY KEY (Id_supplier),
    FOREIGN KEY (Id_address) REFERENCES Address(Id_address)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Glasses (
	Id_glasses int AUTO_INCREMENT,
	Id_supplier int NOT NULL,
	Brand varchar(50) NOT NULL,
	Graduation_1 float,
	Graduation_2 float,
	Mount ENUM('Floating', 'Plastic', 'Metal') NOT NULL,
	Mount_color varchar(50) NOT NULL,
	Color_1 varchar(50),
	Color_2 varchar(50),
	Price float(15) NOT NULL,
	PRIMARY KEY (Id_glasses),
    FOREIGN KEY (Id_supplier) REFERENCES Supplier(Id_supplier)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Customer (
	Id_customer int AUTO_INCREMENT,
	Name varchar(50) NOT NULL,
	Surname varchar(50) NOT NULL,
	Id_address int,
	Phone varchar(50) NOT NULL,
	Email varchar(50),
	Starting_date date DEFAULT CURRENT_DATE,
	Id_referring_customer int,
	PRIMARY KEY (Id_customer),
    FOREIGN KEY (Id_address) REFERENCES Address(Id_address)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Id_referring_customer) REFERENCES Customer(Id_customer)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE Employee (
	Id_employee int AUTO_INCREMENT,
	Name varchar(50) NOT NULL,
	Surname varchar(50) NOT NULL,
	NIF varchar(15) NOT NULL,
	Starting_date date DEFAULT CURRENT_DATE,
	PRIMARY KEY (Id_employee)
);

CREATE TABLE Sale (
	Id_sale int AUTO_INCREMENT,
	Id_employee int NOT NULL,
	Id_customer int NOT NULL,
	Total_amount float,
	Date_time datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (Id_sale),
    FOREIGN KEY (Id_employee) REFERENCES Employee(Id_employee)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Id_customer) REFERENCES Customer(Id_customer)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Sale_detail (
	Id_sale int NOT NULL,
	Id_glasses int NOT NULL,
	Quantity int NOT NULL,
	Unit_price float,
	PRIMARY KEY (Id_sale, Id_glasses),
    FOREIGN KEY (Id_glasses) REFERENCES Glasses(Id_glasses)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DELIMITER $$

CREATE TRIGGER set_unit_price
BEFORE INSERT ON Sale_detail
FOR EACH ROW
BEGIN
    DECLARE price FLOAT;
    SELECT Price INTO price
    FROM Glasses
    WHERE Id_glasses = NEW.Id_glasses;
    SET NEW.Unit_price = price;
END$$

CREATE TRIGGER set_total_amount
AFTER INSERT ON Sale_detail
FOR EACH ROW
BEGIN
    DECLARE totalAmount FLOAT;
    SELECT SUM(Quantity * Unit_price) INTO totalAmount
    FROM Sale_detail
    WHERE Id_sale = NEW.Id_sale;
    UPDATE Sale
    SET Total_amount = totalAmount
    WHERE Id_sale = NEW.Id_sale;
END$$

DELIMITER ;

INSERT INTO Address(Street, Number, City, Postal_code, Country)
VALUES
('Carrer de Provenza', '69', 'Barcelona', '08029', 'Spain'),
('Via Apia', '109', 'Rome', '2000F', 'Italy'),
('Rue de la mort', '66', 'Paris', 'PA2345', 'France');

INSERT INTO Supplier(Name, Id_address, Phone, NIF)
VALUES
('Ferreti', 1, '111111111', '11111111A'),
('Constantini', 2, '222222222', '22222222B'),
('Rayban', 3, '333333333', '33333333C');

INSERT INTO Glasses(Id_supplier, Brand, Mount, Mount_color, Price)
VALUES
(1, 'Versace', 'Floating', 'Black', 199),
(2, 'Prada', 'Plastic', 'Carey', 308.75),
(3, 'Rayban', 'Metal', 'Grey', 279.99);

INSERT INTO Customer(Name, Surname, Phone)
VALUES
('Marta', 'Carranza', '444444444'),
('Carlos', 'Fernandez', '555555555'),
('Ana', 'Acosta', '666666666');

INSERT INTO Employee(Name, Surname, NIF)
VALUES
('Paola', 'Cesped', '44444444D'),
('David', 'Aguilar', '55555555E'),
('Ariel', 'Romaneti', '66666666F');

INSERT INTO Sale(Id_employee, Id_customer)
VALUES
(1, 3),
(3, 2),
(2, 2);

INSERT INTO Sale_detail(Id_sale, Id_glasses, Quantity)
VALUES
(1, 3, 5),
(1, 1, 2),
(2, 3, 1),
(3, 2, 2),
(3, 1, 4);