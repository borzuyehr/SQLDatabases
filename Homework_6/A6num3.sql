SELECT	convert(varchar(10), OrderDate, 101) as 'Date of Order',
		OrderID as 'Order Number',
		CustomerID as 'Customer Number',
		CreditCode as 'Credit Code'
FROM tblOrder
WHERE DiscountCode IS NULL
ORDER BY OrderDate;