SELECT		OrderID as 'Order Number',
			CustomerID as 'Customer Number',
			OrderDate as 'Date Ordered',
			DATEADD(day,40,OrderDate) as '40 Days After Date Ordered',
			DATEDIFF(day, OrderDate, GETDATE()) as 'Number Of Days Difference',
			GETDATE () as 'Current Date and Time'

FROM		tblOrder
WHERE		DATEDIFF(day, OrderDate, GETDATE()) >= 40
GROUP BY	OrderID,
			CustomerID,
			OrderDate
