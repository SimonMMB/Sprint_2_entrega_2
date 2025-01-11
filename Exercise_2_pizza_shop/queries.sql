-- Total drinks sold in a city
SELECT SUM(cd.Quantity) AS 'total drinks'
FROM Command_detail cd
JOIN Product pr ON cd.Id_product = pr.Id_product
JOIN Command co ON cd.Id_command = co.Id_command
JOIN Store s ON co.Id_store = s.Id_store
WHERE pr.Type = 'Drink' AND s.City = 'LA';

-- Total commands made by an employee
SELECT COUNT(c.Id_delivering_employee)
FROM Command c 
WHERE c.Id_delivering_employee = 6;