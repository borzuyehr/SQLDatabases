CREATE VIEW			vOpenOrderLine
AS
SELECT				total.OrderID,
					total.ItemID,
					line.Quantity,
					total.TotalShipped
FROM				vTotalShipped as total
LEFT OUTER JOIN		tblOrderLine as line
ON					total.OrderID = line.OrderID
AND					total.ItemID = line.ItemID
WHERE				line.Quantity > total.TotalShipped