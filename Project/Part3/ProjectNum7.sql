SELECT			feat.FeatureDescription AS ' ',
				COUNT(rf.FeatureID) as 'Count of Times Feature is Mentioned',
				CAST( (COUNT(rf.FeatureID) * 100 )
					/total.total AS varchar) + '%' 
					AS '% of Grandparent Registrations Mentioned'
FROM			Feature as feat
INNER JOIN		Registration as reg
ON				reg.RelationshipToUser = 'Grandparent'
LEFT OUTER JOIN	RegistrationFeature as rf
ON				feat.FeatureID = rf.FeatureID
				AND rf.RegistrationID = reg.RegistrationID
INNER JOIN		vGrandParentRegistrations as total
ON total IS NOT NULL
GROUP BY		feat.FeatureDescription,
				total.total
ORDER BY		COUNT(rf.FeatureID) DESC;