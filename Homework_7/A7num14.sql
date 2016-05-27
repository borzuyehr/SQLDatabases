SELECT			line.OrderID,
				cust.LastName + ', ' + cust.FirstName,
				line.ItemID,
				item.Description,
				type.CategoryDescription,
				item.ListPrice,
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
LEFT OUTER JOIN	tblItem AS item
ON				line.ItemID = item.ItemID
LEFT OUTER JOIN	tblItemType AS type
ON				item.TypeID = type.TypeID
GROUP BY		line.OrderID,
				cust.LastName,
				cust.FirstName,
				line.ItemID,
				item.Description,
				type.CategoryDescription,
				item.ListPrice,
				line.Price,
				line.Quantity
HAVING			line.Quantity - ISNULL(SUM(ship.QtyShipped), 0) < 0		