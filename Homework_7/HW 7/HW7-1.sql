SELECT			convert(varchar(10), OrderDate, 101) as 'Date of Order',
				OrderID as 'OrderNumber',
				concat(LastName, ', ', left(FirstName, 1), '.') as 'CustomerName',
				'(' + substring(Phone, 1, 3) + ') ' +
				substring(Phone, 4, 3) + '-' +
				substring(Phone, 7, 4) as 'Phone Number'
FROM			tblOrder 
LEFT OUTER JOIN tblCustomer
ON				tblOrder.CustomerID = tblCustomer.CustomerID
WHERE			OrderDate BETWEEN ( '01/01/' + cast(year(getdate()) as varchar(4))) 
				AND ( '01/31/' + cast(year(getdate()) as varchar(4)))		
ORDER BY		OrderDate desc;
