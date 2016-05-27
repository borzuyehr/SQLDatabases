SELECT			feat.FeatureDescription AS ' ',
				COUNT(rf.FeatureID) as 'Count of Times Feature is Mentioned',
				CAST( (COUNT(rf.FeatureID) * 100 )
					/total.total AS varchar) + '%' 
					AS '% of registrations mentioned'
FROM			Registration as reg
RIGHT OUTER JOIN	RegistrationFeature as rf
ON rf.RegistrationID = reg.RegistrationID
RIGHT OUTER JOIN Feature as feat
ON rf.FeatureID = feat.FeatureID
INNER JOIN		vTotalRegistrations as total
ON total IS NOT NULL
GROUP BY		feat.FeatureDescription,
				total.total
ORDER BY		COUNT(rf.FeatureID) DESC;