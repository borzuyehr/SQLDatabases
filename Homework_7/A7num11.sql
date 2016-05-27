SELECT			line.OrderID,
				line.ItemID,
				line.Price,
				line.Quantity,
				ISNULL(SUM(ship.QtyShipped), 0) AS TotalQuantityShipped,
				line.Quantity - ISNULL(SUM(ship.QtyShipped), 0) AS LeftToShip
FROM			tblOrderLine as line
LEFT OUTER JOIN	tblShipLine as ship
ON				line.OrderID = ship.OrderId AND
				line.ItemID = ship.ItemID
GROUP BY		line.OrderID,
				line.ItemID,
				line.Price,
				line.Quantity;