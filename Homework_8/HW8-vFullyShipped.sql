CREATE VIEW			vFullyShipped
AS
SELECT				tblOrderLine.orderID,
					CASE
					WHEN SUM(tblOrderLine.quantity - vTotalShipped.TotalShipped)=0
					THEN 'Completely Shipped'
					WHEN SUM(tblOrderLine.quantity - vTotalShipped.TotalShipped)<0
					THEN 'OverShipped'
					end as FullyShipped
					
FROM				tblOrderLine 
				
LEFT OUTER JOIN		vTotalShipped 
ON					tblOrderLine.itemID = vTotalShipped.itemID
AND					tblOrderLine.orderID = vTotalShipped.orderID
GROUP BY			tblOrderLine.OrderID,
					tblOrderLine.ItemID

