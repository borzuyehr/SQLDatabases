SELECT			REG.RelationshipToUser		'Relationship To User',
				COUNT (REG.RegistrationID)	'Count of Registrations',
				COUNT (DISTINCT M.ModelDescription)		'Count of Distinct Models',
				'$' + CONVERT(VARCHAR,SUM(REG.Price), 1) AS 'Sum of Price',
				'$' + CONVERT(VARCHAR,AVG(REG.Price), 1) AS 'Average Price' 
FROM			Registration REG
LEFT OUTER JOIN		Toy T
ON				REG.SERIALNUMBER = T.SERIALNUMBER
LEFT OUTER JOIN		Model M
ON				T.MODELNUMBER = M.MODELNUMBER	
GROUP BY		REG.RelationshipToUser
ORDER BY		REG.RelationshipToUser
				