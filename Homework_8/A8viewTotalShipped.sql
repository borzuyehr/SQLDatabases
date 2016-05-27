CREATE VIEW			vTotalShipped
AS
SELECT				line.OrderID,
					line.ItemID,
					ISNULL(SUM(ship.QtyShipped), 0) as TotalShipped
FROM				tblShipLine as ship
RIGHT OUTER JOIN	tblOrderLine as line
ON					line.OrderID = ship.OrderID
AND					line.ItemID = ship.ItemID
GROUP BY			line.OrderID,
					line.ItemID;