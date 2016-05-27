SELECT			TOP 1
				REG.RelationshipToUser		'Relationship To User',
				COUNT (REG.RegistrationID)	'Count of Registrations',
				COUNT (DISTINCT M.ModelDescription)		'Count of Distinct Models',
				'$' + CONVERT(VARCHAR,SUM(REG.Price), 1) AS 'Sum of Price',
				'$' + CONVERT(VARCHAR,AVG(REG.Price), 1) AS 'Average Price' 
FROM			Registration REG
INNER JOIN		Toy T
ON				REG.SERIALNUMBER = T.SERIALNUMBER
INNER JOIN		Model M
ON				T.MODELNUMBER = M.MODELNUMBER	
GROUP BY		REG.RelationshipToUser
ORDER BY		COUNT (REG.RegistrationID) DESC;