SELECT			convert(varchar(10), tblOrder.OrderDate, 101) as 'Date of Order',
				concat(tblCustomer.LastName, ', ', left(tblCustomer.FirstName, 1), '.') as 'CustomerName',
				tblOrder.OrderID as 'OrderNumber',
				CASE
					WHEN tblOrder.ShipAddress is not NULL
					THEN tblOrder.ShipAddress
					WHEN tblOrder.ShipAddress is NULL
					THEN tblCustomer.CustomerAddress
					END	 ShipAddress,
				CASE
					WHEN tblOrder.ShipZip is not NULL
					THEN tblOrder.ShipZip
					WHEN tblOrder.ShipZip is NULL
					THEN tblCustomer.Zip
					END	 ShipCode,
				CASE
					WHEN tblOrder.ShipCountry is not NULL
					THEN tblOrder.Shipcountry
					WHEN (tblOrder.ShipCountry is NULL)
					THEN 'Unknown'
					END ShipCountry,

				CASE
					WHEN tblOrder.ShipCountry is NULL
					THEN
					'(' + substring(tblCustomer.Phone, 1, 3) + ') ' +
					substring(tblCustomer.Phone, 4, 3) + '-' +
					substring(tblCustomer.Phone, 7, 4) 
					WHEN tblOrder.ShipCountry = 'USA'
					THEN
					'(' + substring(tblOrder.ShipPhone, 1, 3) + ') ' +
					substring(tblOrder.ShipPhone, 4, 3) + '-' +
					substring(tblOrder.ShipPhone, 7, 4) 
					WHEN tblOrder.ShipCountry is not NULL
					THEN tblOrder.ShipPhone
					END PhoneNumber
FROM			tblOrder 
LEFT OUTER JOIN tblCustomer
ON				tblOrder.CustomerID = tblCustomer.CustomerID
WHERE			OrderDate BETWEEN ( '01/01/' + cast(year(getdate()) as varchar(4))) 
				AND ( '01/31/' + cast(year(getdate()) as varchar(4))) 		
ORDER BY		OrderDate desc;