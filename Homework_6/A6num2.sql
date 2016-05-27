SELECT	concat(LastName, ', ', left(FirstName, 1), '.') as 'CustomerName', 
		'(' + substring(Phone, 1, 3) + ') ' +
		substring(Phone, 4, 3) + '-' +
		substring(Phone, 7, 4) as 'Phone Number',
		upper(City) as 'City',
		upper(State) as 'State',
		convert(varchar(12), FirstBuyDate, 107) as 'FirstBuyDate'
FROM tblCustomer
WHERE State = 'NV'
ORDER BY CustomerName;