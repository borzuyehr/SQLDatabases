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
					END PhoneNumber,
				tblOrderLine.ItemID as 'ItemID',
				tblItem.Description as 'Description',
				tblItemType.CategoryDescripition as 'CategoryDescription',
				tblOrderLine.Quantity as 'Quantity',
				tblOrderLine.Price as 'Price',
				tblOrderLine.Price * tblOrderLine.Quantity as 'ExtendedPrice'
FROM			tblOrder 
LEFT OUTER JOIN tblCustomer
ON				tblOrder.CustomerID = tblCustomer.CustomerID
LEFT OUTER JOIN tblOrderLine
ON				tblOrder.OrderID = tblOrderLine.OrderID
LEFT OUTER JOIN tblItem
ON				tblOrderLine.ItemID = tblItem.ItemID
LEFT OUTER JOIN tblItemType
ON				tblItem.TypeID = tblItemType.TypeID
WHERE			OrderDate BETWEEN ( '01/01/' + cast(year(getdate()) as varchar(4))) 
				AND ( '01/31/' + cast(year(getdate()) as varchar(4))) 
 		
ORDER BY		OrderDate desc;