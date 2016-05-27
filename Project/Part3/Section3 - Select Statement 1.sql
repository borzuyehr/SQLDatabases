SELECT			REG.SerialNumber,
				M.ModelNumber,
				M.ModelDescription,
				CUST.CustomerName,
				CONVERT(VARCHAR,REG.DateOfPurchase, 107) AS 'PurchaseDate',
				'$' + CONVERT(VARCHAR,REG.Price, 1) AS 'Price',
				DIST.DistributorName,
				REG.RelationshipToUser 
FROM			Registration REG
INNER JOIN		Toy T
ON				REG.SERIALNUMBER = T.SERIALNUMBER
INNER JOIN		Model M
ON				T.MODELNUMBER = M.MODELNUMBER	
INNER JOIN		Customer Cust
ON				REG.CUSTOMERID = CUST.CUSTOMERID
INNER JOIN		Distributor DIST
ON				REG.DISTRIBUTORID = DIST.DISTRIBUTORID
ORDER BY		1


