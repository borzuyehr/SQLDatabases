SELECT	OrderID as OrderNumber,
		ItemID as ItemNumber,
		Quantity as QuantityOrdered,
		Price as PricePaid,
		(Quantity * Price) as ExtendedPrice,
		CASE 
			WHEN (Quantity * Price) < 1000
			THEN NULL
			WHEN 1500 > (Quantity * Price) and (Quantity * Price) > 1000 
			THEN 'Medium Order'
			WHEN 2000 > (Quantity * Price) and (Quantity * Price) > 1500
			THEN 'Large Order - Monitor'
			WHEN 5000 > (Quantity * Price) and (Quantity * Price) > 2000
			THEN 'Very Large Order – Watch Dates'
			WHEN 5000 < (Quantity * Price)
			THEN '***Closely Watch the Status***'
			END OrderStatusMessage
FROM tblOrderLine
WHERE Quantity * Price > 800;