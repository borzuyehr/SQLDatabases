SELECT			TOP 1
				M.ModelDescription		'Model Number',
				COUNT (REG.RegistrationID)	'Model Purchased Most Often by GrandParents'
FROM			Registration REG
INNER JOIN		Toy T
ON				REG.SERIALNUMBER = T.SERIALNUMBER
INNER JOIN		Model M
ON				T.MODELNUMBER = M.MODELNUMBER	
WHERE			REG.RelationshipToUser LIKE 'Grandparent'
GROUP BY		M.ModelDescription	
ORDER BY		COUNT (REG.RegistrationID) DESC	