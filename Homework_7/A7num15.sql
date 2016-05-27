SELECT			cust.LastName + ', ' + cust.FirstName CustomerName,
				line.OrderID,
				line.ItemID,
				item.Description
FROM			tblOrderLine AS line
LEFT OUTER JOIN	tblItem AS item
ON				line.itemID = item.itemID
LEFT OUTER JOIN tblOrder AS ord
ON				line.OrderID = ord.OrderID
LEFT OUTER JOIN tblCustomer AS cust
ON				ord.CustomerID = cust.CustomerID
LEFT OUTER JOIN	tblShipLine AS ship
ON				line.OrderID = ship.OrderID AND
				line.ItemID = ship.ItemID
WHERE			ship.MethodShipped = 'FedEx'			
				