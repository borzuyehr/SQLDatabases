SELECT				ord.OrderID,
					CONVERT(varchar, ord.OrderDate, 101) as DateOrdered,
					(cust.LastName + ', ' + SUBSTRING(cust.FirstName, 1, 1) + '.') as CustomerName,
					item.ItemID,
					item.Description,
					line.Quantity as QuantityOrdered,
					total.TotalShipped,
					SUM(line.Quantity - total.TotalShipped) as QuantityRemaining,
					ShippingStatus =
					CASE
						WHEN total.TotalShipped = 0
						THEN 'Not Shipped'
						WHEN SUM(line.Quantity - total.TotalShipped) = 0
						THEN 'Completely Shipped'
						WHEN SUM(line.Quantity - total.TotalShipped) < 0
						THEN 'Over Shipped'
						WHEN SUM(line.Quantity - total.TotalShipped) > 0
						THEN 'Partially Shipped'
					END
FROM				tblOrder as ord
LEFT OUTER JOIN		tblCustomer as cust
ON					cust.CustomerID = ord.CustomerID
LEFT OUTER JOIN		tblOrderLine as line 
ON					ord.OrderID = line.OrderID
LEFT OUTER JOIN		tblItem as item
ON					item.ItemID = line.ItemID
LEFT OUTER JOIN		tblItemType as itype
ON					itype.TypeID = item.TypeID
LEFT OUTER JOIN		vTotalShipped as total
ON					line.OrderID = total.OrderID
AND					line.ItemID = total.ItemID
INNER JOIN			vOpenOrderLine as oOrd
ON					oOrd.OrderID = ord.OrderID
GROUP BY			ord.OrderID,
					ord.OrderDate,
					cust.LastName,
					cust.FirstName,
					item.ItemID,
					item.Description,
					line.Quantity,
					total.TotalShipped
ORDER BY			ord.OrderDate;
