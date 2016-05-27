CREATE VIEW			vCurrentOrderLineData
AS
SELECT				tblItem.itemID,
					ISNULL(SUM(tblOrderLine.quantity), 0) as TotalQtyOnOrder,
					COUNT (tblOrderLine.orderID) as NumberOfOrders,
					ISNULL (MAX(tblOrderLine.price),0)as MostExpensivePrice,
					ISNULL (MIN(tblOrderLine.price),0) as LeastExpensivePrice,
					ISNULL (AVG(tblOrderLine.price),0) as AveragePrice
FROM				tblOrderLine 
RIGHT OUTER JOIN	tblItem 
ON					tblOrderLine.itemID = tblItem.itemID

GROUP BY			tblItem.ItemID