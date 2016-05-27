UPDATE tblOrder
SET OrderDate = '1/15/2016'
WHERE OrderID = 567123;

UPDATE tblOrder
SET OrderDate = '2/10/2016'
WHERE OrderID = 671100;

UPDATE tblShipLine
SET MethodShipped = LOWER(MethodShipped);

UPDATE tblCustomer
SET State = UPPER(state);

DELETE FROM tblOrder
WHERE OrderID NOT IN 
(SELECT OrderID FROM tblOrderLine);