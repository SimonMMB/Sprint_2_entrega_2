-- Total sales made to a customer
SELECT c.Name, c.Surname, sd.Id_glasses, g.Brand, g.Price, sd.Quantity, s.Id_sale, s.Total_amount, s.Date_time 
FROM Sale s 
JOIN Customer c ON s.Id_customer = c.Id_customer 
JOIN Sale_detail sd ON s.Id_sale = sd.Id_sale 
JOIN Glasses g ON sd.Id_glasses = g.Id_glasses 
WHERE s.Id_customer = 2;
-- Glasses sold by an employee during a year
SELECT e.Id_employee, e.Name, e.Surname, s.Id_sale, g.Brand, g.Price, s.Date_time
FROM Sale s 
JOIN Employee e ON s.Id_employee = e.Id_employee
JOIN Sale_detail sd ON s.Id_sale = sd.Id_sale
JOIN Glasses g ON sd.Id_glasses = g.Id_glasses
WHERE e.Id_employee = 2 AND YEAR(s.Date_time) = 2025;
-- Suppliers that supplied sold glasses
SELECT DISTINCT su.Id_supplier, su.Name, g.Brand
FROM Sale_detail sd 
JOIN Glasses g ON sd.Id_glasses = g.Id_glasses
JOIN Supplier su ON g.Id_supplier = su.Id_supplier;