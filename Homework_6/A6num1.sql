SELECT	concat(FirstName, ' ', LastName ) as 'CustomerName', 
		Phone as 'CustomerPhone',
		City,
		State,
		FirstBuyDate 
FROM tblCustomer
WHERE State = 'NV';