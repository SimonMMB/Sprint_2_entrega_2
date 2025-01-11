CREATE DATABASE IF NOT EXISTS Optical_shop;

USE Optical_shop;

CREATE TABLE Address (
	Id_address INT AUTO_INCREMENT,
	Street VARCHAR(50) NOT NULL,
	Number VARCHAR(15) NOT NULL,
	Floor VARCHAR(15),
	Door VARCHAR(15),
	City VARCHAR(50) NOT NULL,
	Postal_code VARCHAR(15) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	PRIMARY KEY (Id_address)
);

CREATE TABLE Supplier (
    Id_supplier INT AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL,
    Id_address INT,
    Phone VARCHAR(50) NOT NULL,
    Fax VARCHAR(50),
    NIF VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id_supplier),
    FOREIGN KEY (Id_address) REFERENCES Address(Id_address)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Glasses (
	Id_glasses INT AUTO_INCREMENT,
	Id_supplier INT NOT NULL,
	Brand VARCHAR(50) NOT NULL,
	Graduation_1 FLOAT,
	Graduation_2 FLOAT,
	Mount ENUM('Floating', 'Plastic', 'Metal') NOT NULL,
	Mount_color VARCHAR(50) NOT NULL,
	Color_1 VARCHAR(50),
	Color_2 VARCHAR(50),
	Price FLOAT(15) NOT NULL,
	PRIMARY KEY (Id_glasses),
    FOREIGN KEY (Id_supplier) REFERENCES Supplier(Id_supplier)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Customer (
	Id_customer INT AUTO_INCREMENT,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL,
	Id_address INT,
	Phone VARCHAR(50) NOT NULL,
	Email VARCHAR(50),
	Starting_date DATE DEFAULT CURRENT_DATE,
	Id_referring_customer INT,
	PRIMARY KEY (Id_customer),
    FOREIGN KEY (Id_address) REFERENCES Address(Id_address)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Id_referring_customer) REFERENCES Customer(Id_customer)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE Employee (
	Id_employee INT AUTO_INCREMENT,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL,
	NIF VARCHAR(15) NOT NULL,
	Starting_date DATE DEFAULT CURRENT_DATE,
	PRIMARY KEY (Id_employee)
);

CREATE TABLE Sale (
	Id_sale INT AUTO_INCREMENT,
	Id_employee INT NOT NULL,
	Id_customer INT NOT NULL,
	Total_amount FLOAT,
	Date_time DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (Id_sale),
    FOREIGN KEY (Id_employee) REFERENCES Employee(Id_employee)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (Id_customer) REFERENCES Customer(Id_customer)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Sale_detail (
	Id_sale INT NOT NULL,
	Id_glasses INT NOT NULL,
	Quantity INT NOT NULL,
	Unit_price FLOAT,
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
(2, 2),
(2, 1),
(2, 3);

INSERT INTO Sale_detail(Id_sale, Id_glasses, Quantity)
VALUES
(1, 3, 5),
(1, 2, 2),
(2, 3, 1),
(3, 2, 2),
(3, 3, 4),
(4, 2, 3),
(4, 3, 1),
(5, 3, 3);