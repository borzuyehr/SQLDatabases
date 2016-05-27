CREATE VIEW vGrandParentRegistrations
AS
SELECT COUNT(RegistrationID) as Total
FROM Registration
WHERE RelationshipToUser = 'Grandparent';