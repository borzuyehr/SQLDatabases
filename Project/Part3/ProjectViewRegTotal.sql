CREATE VIEW vTotalRegistrations
AS
SELECT COUNT(RegistrationID) as Total
FROM Registration;