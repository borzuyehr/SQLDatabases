SELECT		distinct		ord.OrderID,
					ISNULL(CONVERT(VARCHAR, ord.OrderDate, 107),'no date') 'OrderDate',
					ord.customerid,
					cust.LastName + ', ' + SUBSTRING(cust.FirstName, 1, 1) + '.' as CustomerName,
					ord.primaryOrderID,
					ISNULL(CONVERT(VARCHAR, ord.OrderDate, 107),'no date') 'OrderDate',
					 min (ISNULL(CONVERT(VARCHAR, tblShipLine.DateShipped, 107),'no date')) as FirstDateShipped,
					 max (ISNULL(CONVERT(VARCHAR, tblShipLine.DateShipped, 107),'no date')) as LastDateShipped
						
FROM				tblOrder as ord
inner JOIN		tblCustomer as cust
ON					cust.CustomerID = ord.CustomerID
inner JOIN		tblOrderLine
ON					ord.orderID = tblOrderLine.orderID
inner JOIN		tblShipLine
ON					tblOrderLine.itemID = tblShipLine.itemID
and					tblOrderLine.orderID = tblShipLine.orderID
inner JOIN			vTotalShipped total
ON					ord.orderID = total.orderID
GROUP BY			ord.OrderID,
					ord.OrderDate,
					cust.LastName,
					cust.FirstName,
					ord.customerid,
					ord.primaryOrderID,
					ord.OrderDate
HAVING				SUM(tblOrderLine.Quantity - total.TotalShipped) < 0
or					SUM(tblOrderLine.Quantity - total.TotalShipped) = 0
