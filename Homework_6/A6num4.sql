SELECT	OrderID as 'OrderNumber',
		ItemID as 'ItemNumber',
		Quantity as 'QuantityOrdered',
		Price as 'PricePaid',
		Quantity * Price as 'ExtendedPrice'
FROM tblOrderLine
WHERE itemId = 'A34665';