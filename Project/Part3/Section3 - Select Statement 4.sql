SELECT			M.ModelDescription		'Model Number',
				COUNT (REG.RegistrationID)	'Count of Toys Per Model Number Per Registration',
				'$' + CONVERT(VARCHAR,SUM(REG.Price), 1) AS 'Sum of Price',
				'$' + CONVERT(VARCHAR,AVG(REG.Price), 1) AS 'Average Price',
				MIN(REG.DateOfPurchase) 'Earliest Registration Date',
				MAX(REG.DateOfPurchase) 'Earliest Registration Date'
FROM			Registration REG
INNER JOIN		Toy T
ON				REG.SERIALNUMBER = T.SERIALNUMBER
INNER JOIN		Model M
ON				T.MODELNUMBER = M.MODELNUMBER	
GROUP BY		M.ModelDescription	
ORDER BY		M.ModelDescription	