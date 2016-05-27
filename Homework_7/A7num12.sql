SELECT			line.OrderID,
				cust.LastName + ', ' + cust.FirstName,
				line.ItemID,
				line.Price,
				line.Quantity,
				ISNULL(SUM(ship.QtyShipped), 0) AS TotalQuantityShipped,
				line.Quantity - ISNULL(SUM(ship.QtyShipped), 0) AS LeftToShip
FROM			tblOrderLine AS line
LEFT OUTER JOIN	tblShipLine AS ship
ON				line.OrderID = ship.OrderId AND
				line.ItemID = ship.ItemID
LEFT OUTER JOIN tblOrder AS ord
ON				line.OrderID = ord.OrderID
LEFT OUTER JOIN tblCustomer AS cust
ON				ord.CustomerID = cust.CustomerID
GROUP BY		line.OrderID,
				cust.LastName,
				cust.FirstName,
				line.ItemID,
				line.Price,
				line.Quantity;