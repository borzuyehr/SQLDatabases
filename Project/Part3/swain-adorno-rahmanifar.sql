
------------------------------------------
-- IS 475/675 Final Project SQL Statements
-- Team 6:
-- Ryan Swain
-- Eric Adorno
-- Peter Rahmanifar
--
--
------------------------------------------

-- Question 1

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
ORDER BY		1;

-- Question 2

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
ORDER BY		REG.RelationshipToUser;

-- Question 3

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

-- Question 4

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
ORDER BY		M.ModelDescription;

-- Question 5

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
ORDER BY		COUNT (REG.RegistrationID) DESC;

-- Question 6

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

--Question 7

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

--Question 8

SELECT			TOP 3
				feat.FeatureDescription AS ' ',
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


-------------------------------------
-- Graduate Component
-- Ryan Swain
-------------------------------------

-------------------------------------
-- Function 1: Sanitize String
-------------------------------------

IF OBJECT_ID( 'fnSanitizeString', N'FN') IS NOT NULL
	DROP FUNCTION fnSanitizeString;
GO
CREATE FUNCTION fnSanitizeString (@String varchar(200))
RETURNS varchar(200)
BEGIN
	DECLARE @retString varchar(200)
	SET @retString = REPLACE( @string, ')', '')
	SET @retString = REPLACE( @retString, '''', '�')
	SET @retString = REPLACE( @retString, ';', ',')
	RETURN @retString
END;
GO
DECLARE @return varchar(200);
EXECUTE @return = fnSanitizeString 'Robert''); DROP TABLE Students';
PRINT @return;


-------------------------------------
-- Function 2: Validate Question
-------------------------------------

IF OBJECT_ID( 'fnValidQuestions', N'FN') IS NOT NULL
	DROP FUNCTION fnValidQuestions;
GO
CREATE FUNCTION fnValidQuestions(@Question varchar(20), @Answer varchar(40))
RETURNS BIT
BEGIN
	DECLARE @Return BIT = 0
	IF (@Question = 'WhereFirstLearn')
		BEGIN
			IF (@Answer = 'Advertisement in print' OR
				@Answer = 'Advertisement on the web' OR
				@Answer = 'Advertisement on TV' OR
				@Answer = 'Friend''s recommendation' OR
				@Answer = 'In-store display' OR
				@Answer = 'Catalog' OR
				@Answer = 'Other')
				BEGIN
					SET @Return = 1
				END
		END
	IF (@Question = 'RelationshipToUser')
		BEGIN
			IF (@Answer = 'Parent' OR
				@Answer = 'Grandparent' OR
				@Answer = 'Aunt/Uncle' OR
				@Answer = 'Friend' OR
				@Answer = 'Other Relative' OR
				@Answer = 'Other')
				BEGIN
					SET @Return = 1
				END
		END
	IF (@Question = 'FutureBuy')
		BEGIN
			IF (@Answer = 'Yes' OR
				@Answer = 'No' OR
				@Answer = 'Don''t know')
				BEGIN
					SET @Return = 1
				END
		END
	RETURN @Return
END;

GO
DECLARE @return varchar(40);
EXECUTE @return = fnValidQuestions @Question = 'FutureBuy', @Answer = 'Don''t Know';
PRINT @return;


-------------------------------------
-- Stored Procedure 1 & 2: Validate Registration DateOfPurchase
-------------------------------------



IF OBJECT_ID( 'ValidateRegistration', 'P') IS NOT NULL
	DROP PROCEDURE ValidateRegistration;
GO
IF OBJECT_ID( 'AddRegistration', 'P') IS NOT NULL
	DROP PROCEDURE AddRegistration;
GO

-- Adds Validated Registration Information to Registration,
-- Toy, Customer, and RegistrationFeature tables.
CREATE PROCEDURE AddRegistration
	@SaniName varchar(20),
	@SaniEmail varchar(60),
	@SaniPhone char(15),
	@ModelNumber char(12),
	@SerialNumber char(14),
	@DateOfPurchase date,
	@Price money,
	@WhereFirstLearn varchar(30),
	@RelationshipToUser varchar(15),
	@UserAge int,
	@UserGender	varchar(1),
	@FutureBuy varchar(10),
	@DistributorName varchar(40),
	@Feature1 bit,
	@Feature2 bit,
	@Feature3 bit,
	@Feature4 bit,
	@Feature5 bit,
	@Feature6 bit,
	@Feature7 bit,
	@Feature8 bit,
	@Feature9 bit,
	@Feature10 bit,
	@Feature11 bit
AS
	DECLARE @CustomerID int,
		@RegistrationID int,
		@DistributorID char(7)

	-- Add row to Customer Table First
	INSERT INTO MCustomer VALUES (
		@SaniName,
		@SaniEmail,
		@SaniPhone
	)

	-- Add row to Toy Table
	INSERT INTO MToy VALUES (
		@SerialNumber,
		@ModelNumber
	)

	-- Cursor to get newly created CustomerID
	DECLARE CustCursor CURSOR FOR
			SELECT CustomerID
			FROM MCustomer
			WHERE CustomerName = @SaniName AND
					Email = @SaniEmail AND
					Phone = @SaniPhone;

	OPEN CustCursor
	FETCH NEXT FROM CustCursor INTO @CustomerID;

	-- Cursor to get DistributorID with Distributor Name
	DECLARE DisCursor CURSOR FOR
		SELECT DistributorID
		FROM MDistributor
		WHERE DistributorName = @DistributorName;

	OPEN DisCursor
	FETCH NEXT FROM DisCursor INTO @DistributorID;

	-- Add row to Registration Table
	INSERT INTO MRegistration VALUES (
					@CustomerID,
					@SerialNumber,
					@DateOfPurchase,
					@Price,
					@WhereFirstLearn,
					@RelationshipToUser,
					@UserAge,
					@UserGender,
					@FutureBuy,
					@DistributorID
				)

	-- Cursor to get RegistrationID
	DECLARE regCursor CURSOR FOR
		SELECT TOP 1 RegistrationID
		FROM MRegistration
		ORDER BY RegistrationID DESC;

	OPEN regCursor
	FETCH NEXT FROM regCursor INTO @RegistrationID;

	--If feature is selected (1), then insert row.
	IF @Feature1 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M201', @RegistrationID )
		END
	IF @Feature2 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M202', @RegistrationID )
		END
	IF @Feature3 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M203', @RegistrationID )
		END
	IF @Feature4 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M204', @RegistrationID )
		END
	IF @Feature5 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M205', @RegistrationID )
		END
	IF @Feature6 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M206', @RegistrationID )
		END
	IF @Feature7 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M207', @RegistrationID )
		END
	IF @Feature8 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M208', @RegistrationID )
		END
	IF @Feature9 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M209', @RegistrationID )
		END
	IF @Feature10 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M210', @RegistrationID )
		END
	IF @Feature11 = 1
		BEGIN
			INSERT INTO MRegistrationFeature VALUES ( 'M211', @RegistrationID )
		END

	-- Close those cursors
	CLOSE regCursor;
	DEALLOCATE regCursor;
	CLOSE CustCursor;
	DEALLOCATE CustCursor;
	CLOSE DisCursor;
	DEALLOCATE DisCursor;
; --End AddRegistration

GO

CREATE PROCEDURE ValidateRegistration
	@CName varchar(20),
	@CEmail varchar(60),
	@Phone char(15),
	@ModelNumber char(12),
	@SerialNumber char(14),
	@DateOfPurchase date,
	@Price money,
	@WhereFirstLearn varchar(30),
	@RelationshipToUser varchar(15),
	@UserAge int,
	@UserGender	varchar(1),
	@FutureBuy varchar(10),
	@DistributorName varchar(40),
	@Feature1 bit,
	@Feature2 bit,
	@Feature3 bit,
	@Feature4 bit,
	@Feature5 bit,
	@Feature6 bit,
	@Feature7 bit,
	@Feature8 bit,
	@Feature9 bit,
	@Feature10 bit,
	@Feature11 bit
AS
	DECLARE @Tester bit
	DECLARE @SaniName varchar(20)
	DECLARE @SaniEmail varchar(60)
	DECLARE @SaniPhone char(15)

	-- Use Valid Question function to see if Answers are valid (1) or else invalid (0) stop function and print error code.
	EXECUTE @Tester = fnValidQuestions @Question = 'WhereFirstLearn', @Answer = @WhereFirstLearn;
	IF ( @Tester  = 0 )
		BEGIN
			PRINT 'Invalid Response for Question 1.'
			RETURN
		END
	EXECUTE @Tester = fnValidQuestions @Question = 'RelationshipToUser', @Answer = @RelationshipToUser;
	IF ( @Tester  = 0 )
		BEGIN
			PRINT 'Invalid Response for Question 3.'
			RETURN
		END
	EXECUTE @Tester = fnValidQuestions @Question = 'FutureBuy', @Answer = @FutureBuy;
	IF ( @Tester  = 0 )
		BEGIN
			PRINT 'Invalid Response for Question 4.'
			RETURN
		END

	-- Use fnSanitizeString function to remove SQL injection characters.
	EXECUTE @SaniName = fnSanitizeString @CName
	EXECUTE @SaniEmail = fnSanitizeString @CEmail
	EXECUTE @SaniPhone = fnSanitizeString @Phone

	-- If validation succeeds, call AddRegistration Stored Procedure.
	EXECUTE AddRegistration
		@SaniName,
		@SaniEmail,
		@SaniPhone,
		@ModelNumber,
		@SerialNumber,
		@DateOfPurchase,
		@Price,
		@WhereFirstLearn,
		@RelationshipToUser,
		@UserAge,
		@UserGender,
		@FutureBuy,
		@DistributorName,
		@Feature1,
		@Feature2,
		@Feature3,
		@Feature4,
		@Feature5,
		@Feature6,
		@Feature7,
		@Feature8,
		@Feature9,
		@Feature10,
		@Feature11
;
GO

-- Test validation and insert proceedures.
EXECUTE ValidateRegistration
			@CName = 'Swanson, Bert',
			@CEmail = 'bswanson@gmail.com',
			@Phone = '714-232-1111',
			@ModelNumber = 'MJCSUV5',
			@SerialNumber = 'M16170921-6988',
			@DateOfPurchase = '2016-05-08',
			@Price = '928.00',
			@WhereFirstLearn = 'Advertisement on TV',
			@RelationshipToUser = 'Aunt/Uncle',
			@UserAge = '3',
			@UserGender	= 'F',
			@FutureBuy = 'Don''t know',
			@DistributorName = 'Toys "R" Us Inc.',
			@Feature1 = 1,
			@Feature2 = 0,
			@Feature3 = 1,
			@Feature4 = 1,
			@Feature5 = 1,
			@Feature6 = 0,
			@Feature7 = 0,
			@Feature8 = 0,
			@Feature9 = 0,
			@Feature10 = 0,
			@Feature11 = 0;




-------------------------------------
-- Stored Procedure 3: Remove Duplicates to Historical Tables
-------------------------------------

IF OBJECT_ID( 'RemoveDupes', 'P') IS NOT NULL
	DROP PROCEDURE RemoveDupes;
GO

-- Tests Registrations for duplicates.
-- If found, older duplicates are moved to history tables.
CREATE PROCEDURE RemoveDupes
AS
DECLARE @RegistrationID int,
		@CustomerID int,
		@SerialNumber char(14),
		@DateOfPurchase	date,
		@Price money,
		@WhereFirstLearn varchar(30),
		@RelationshipToUser varchar(15),
		@UserAge int,
		@UserGender varchar(1),
		@FutureBuy varchar(10),
		@DistributorID char(7),
		@RegFeatureID int,
		@FeatureID char(5),
		@NewRegID int,
		@RegCounter int = 0,
		@RFCounter int = 0


--Start Cursor to find duplicate entries
DECLARE regCursor CURSOR FOR
		SELECT	SerialNumber
		FROM MRegistration
		GROUP BY SerialNumber
		HAVING COUNT(*) > 1;

OPEN regCursor
FETCH NEXT FROM regCursor INTO @SerialNumber

--Start cursor while loop
WHILE @@FETCH_STATUS = 0
	BEGIN

		-- Start cursor to get all columns in registration table
		-- Where duplicates are found except for the most recent
		DECLARE entryCursor CURSOR FOR
			SELECT	*
			FROM MRegistration
			WHERE SerialNumber = @SerialNumber AND
				RegistrationID < (SELECT MAX(RegistrationID)
									FROM MRegistration
									WHERE SerialNumber = @SerialNumber);

		OPEN entryCursor
		FETCH NEXT FROM entryCursor INTO
			@RegistrationID,
			@CustomerID,
			@SerialNumber,
			@DateOfPurchase,
			@Price,
			@WhereFirstLearn,
			@RelationshipToUser,
			@UserAge,
			@UserGender,
			@FutureBuy,
			@DistributorID

		--Begin while loop for each registration row
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @RegCounter = @RegCounter + 1

				-- Insert row into RegistrationHistory table
				INSERT INTO MRegistrationHistory VALUES (
					@CustomerID,
					@SerialNumber,
					@DateOfPurchase,
					@Price,
					@WhereFirstLearn,
					@RelationshipToUser,
					@UserAge,
					@UserGender,
					@FutureBuy,
					@DistributorID );

				-- Get new RegistrationID from RegistrationHistory table
				DECLARE newRegCursor CURSOR FOR
					SELECT TOP 1 RegistrationID
					FROM MRegistrationHistory
					ORDER BY RegistrationID DESC

				OPEN newRegCursor
				FETCH NEXT FROM newRegCursor INTO @NewRegID

				-- Find all attached RegistrationFeature rows
				DECLARE rfCursor SCROLL CURSOR FOR
					SELECT FeatureID
					FROM MRegistrationFeature
					WHERE RegistrationID = @RegistrationID

				OPEN rfCursor

				FETCH NEXT FROM rfCursor INTO @FeatureID

				-- For each RegistrationFeature row, Insert into RegistrationFeatureHistory table
				-- Using newly created RegistrationHistory row's RegistrationID
				WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @RFCounter = @RFCounter + 1

						INSERT INTO MRegistrationFeatureHistory VALUES (
							@FeatureID,
							@NewRegID
						)

						FETCH NEXT FROM rfCursor INTO @FeatureID
					END -- End RegistrationFeature Loop

				--Remove old RegistrationFeature row
				DELETE FROM MRegistrationFeature
				WHERE @RegistrationID = RegistrationID

				--Remove old Registration row
				DELETE FROM MRegistration
				WHERE RegistrationID = @RegistrationID


				--Get next registration row
				FETCH NEXT FROM entryCursor INTO
					@RegistrationID,
					@CustomerID,
					@SerialNumber,
					@DateOfPurchase,
					@Price,
					@WhereFirstLearn,
					@RelationshipToUser,
					@UserAge,
					@UserGender,
					@FutureBuy,
					@DistributorID

				--Close Registration Feature Cursor
				CLOSE rfCursor
				DEALLOCATE rfCursor

				--Close New Registration Cursor
				CLOSE newRegCursor
				DEALLOCATE newRegCursor
			END -- End Registration Loop

		-- Close Registration Cursor
		CLOSE entryCursor
		DEALLOCATE entryCursor;

		--Get Next Serial Number
		FETCH NEXT FROM regCursor INTO @SerialNumber
	END --End Serial Number Loop

--Close Duplicate Serial Number Cursor
CLOSE regCursor
DEALLOCATE regCursor;

-- Print update totals
PRINT CAST(@RegCounter AS varchar(4) ) + ' registration(s) and ' +
			CAST(@RFCounter AS varchar(4)) +
			' attached feature(s) moved to the history tables.'

GO
EXECUTE RemoveDupes;



-------------------------------------
-- CREATE Statements
-------------------------------------


DROP TABLE MRegistrationFeatureHistory;
DROP TABLE MRegistrationHistory;
DROP TABLE MRegistrationFeature;
DROP TABLE MFeature;
DROP TABLE MRegistration;
DROP TABLE MToy;
DROP TABLE MDistributor;
DROP TABLE MModel;
DROP TABLE MCustomer;


CREATE TABLE MCustomer(
CustomerID			int				NOT NULL	IDENTITY( 921, 1),
CustomerName		varchar(20)		NOT NULL,
Email				varchar(60),
Phone				char(15)		NOT NULL
CONSTRAINT pkMCust PRIMARY KEY (CustomerID));

CREATE TABLE MModel(
ModelNumber			char(12)		NOT NULL,
ModelDescription	varchar(60)		NOT NULL,
CONSTRAINT pkMModelNumber PRIMARY KEY (ModelNumber));

CREATE TABLE MDistributor(
DistributorID		char(7)				NOT NULL,
DistributorName		varchar(40)		NOT NULL,
CONSTRAINT pkMDistributorID PRIMARY KEY (DistributorID));

CREATE TABLE MToy(
SerialNumber		char(14)		NOT NULL,
ModelNumber			char(12)		NOT NULL
CONSTRAINT pkMSerialNumber PRIMARY KEY (SerialNumber),
CONSTRAINT fkMModelNumber FOREIGN KEY (ModelNumber) REFERENCES MModel (ModelNumber));

CREATE TABLE MRegistration(
RegistrationID		INT				NOT NULL IDENTITY( 20062178, 1),
CustomerID			INT				NOT NULL,
SerialNumber		char(14)		NOT NULL,
DateOfPurchase		date			NOT NULL,
Price				money			NOT NULL CHECK (Price > 0),
WhereFirstLearn		varchar(30)		NOT NULL,
RelationshipToUser	varchar(15)		NOT NULL,
UserAge				int				NOT NULL CHECK (UserAge > 0),
UserGender			varchar(1)		NOT NULL CHECK (UserGender = 'F' OR UserGender = 'M'),
FutureBuy			varchar(10)		NOT NULL,
DistributorID		char(7)
CONSTRAINT pkMRegistrationID PRIMARY KEY (RegistrationID),
CONSTRAINT fkMCustomerID	FOREIGN KEY (CustomerID) REFERENCES MCustomer (CustomerID),
CONSTRAINT fkMSerialNumber FOREIGN KEY (SerialNumber) REFERENCES MToy (SerialNumber),
CONSTRAINT fkMDistributorID FOREIGN KEY (DistributorID) REFERENCES MDistributor (DistributorID));

CREATE TABLE MFeature(
FeatureID			char(5)			NOT NULL,
FeatureDescription	varchar(40)		NOT NULL,
CONSTRAINT pkMFeatureID PRIMARY KEY (FeatureID));

CREATE TABLE MRegistrationFeature(
RegFeatureID		INT			NOT NULL 	IDENTITY( 193102, 1),
FeatureID			char(5)		NOT NULL,
RegistrationID		INT			NOT NULL,
CONSTRAINT	pkMRegFeatureID PRIMARY KEY (RegFeatureID),
CONSTRAINT	fkMRegistrationID FOREIGN KEY (RegistrationID) REFERENCES MRegistration (RegistrationID),
CONSTRAINT	fkMFeatureID FOREIGN KEY (FeatureID) REFERENCES MFeature (FeatureID));

CREATE TABLE MRegistrationHistory(
RegistrationID		int				NOT NULL IDENTITY (20062110, 1),
CustomerID			int				NOT NULL,
SerialNumber		char(14)		NOT NULL,
DateOfPurchase		date			NOT NULL,
Price				money			NOT NULL CHECK (Price > 0),
WhereFirstLearn		varchar(30)		NOT NULL,
RelationshipToUser	varchar(15)		NOT NULL,
UserAge				int				NOT NULL CHECK (UserAge > 0),
UserGender			varchar(1)		NOT NULL CHECK (UserGender = 'F' OR UserGender = 'M'),
FutureBuy			varchar(10)		NOT NULL,
DistributorID		char(7)
CONSTRAINT pkMRegistrationHistID PRIMARY KEY (RegistrationID),
CONSTRAINT fkMCustomerHistID	FOREIGN KEY (CustomerID) REFERENCES MCustomer (CustomerID),
CONSTRAINT fkMSerialNumberHist FOREIGN KEY (SerialNumber) REFERENCES MToy (SerialNumber),
CONSTRAINT fkMDistributorHistID FOREIGN KEY (DistributorID) REFERENCES MDistributor (DistributorID));

CREATE TABLE MRegistrationFeatureHistory(
RegFeatureID		int			NOT NULL	IDENTITY (293010, 1),
FeatureID			char(5)		NOT NULL,
RegistrationID		int			NOT NULL,
CONSTRAINT	pkMRegFeatureHistID PRIMARY KEY (RegFeatureID),
CONSTRAINT	fkMRegistrationHistID FOREIGN KEY (RegistrationID) REFERENCES MRegistrationHistory (RegistrationID),
CONSTRAINT	fkMFeatureHistID FOREIGN KEY (FeatureID) REFERENCES MFeature (FeatureID));




-------------------------------------
-- Populate Statements
-------------------------------------





/* MCustomer Table*/
SET IDENTITY_INSERT MCustomer ON;
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('912','Baird, Conan','mollis@in.ca','(421) 486-3684');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('911','Oliver, Emily','aliquet.Phasellus.fermentum@quis.org','(455) 377-0247');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('919','Hoffman, Molly','mi.Aliquam@elitpretium.co.uk','(846) 455-7199');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('920','Lynn, Lee','neque.pellentesque@dolorQuisquetincidunt.co.uk','(780) 546-4628');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('918','Cardenas, Jordan','consectetuer.cursus.et@eget.org','(622) 912-5078');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('917','French, Donna','lacus@lorem.co.uk','(632) 134-9107');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('916','Lester, Forrest','eu.eros.Nam@hymenaeos.ca','(780) 256-5011');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('915','Phelps, Tamekah','molestie@luctusCurabituregestas.net','(770) 446-1118');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('914','Reynolds, Octavius','elit@mauris.ca','(447) 603-4833');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('921','Casey, Jade','ligula@Nulla.co.uk','(136) 348-5242');
INSERT INTO MCustomer (CustomerID, CustomerName, Email, Phone) VALUES ('913','Vasquez, Adele','non@ornareliberoat.ca','(450) 562-8528');
SET IDENTITY_INSERT MCustomer OFF;


/*MModel Table*/
INSERT INTO MModel VALUES ('MJCSUV5', 'Jeep Cherokee SUV');
INSERT INTO MModel VALUES ('MJCSUV8', 'Jeep Cherokee SUV Limited');
INSERT INTO MModel VALUES ('MFFS488', 'Ferrari 488 GTB');
INSERT INTO MModel VALUES ('MTT4x45', 'Toyota Tacoma 4x4 5th release');
INSERT INTO MModel VALUES ('MCSUV76', '1976 Chevy SUV');
INSERT INTO MModel VALUES ('MBMWM5', 'BMW M5');
INSERT INTO MModel VALUES ('MTRAIN06', 'Bullet Train 6');
INSERT INTO MModel VALUES ('MTESLA-S', 'Tesla MModel S');
INSERT INTO MModel VALUES ('MTESLA-3', 'Tesla MModel 3');
INSERT INTO MModel VALUES ('MSHELBY500-7', 'Ford Mustang Shelby GT500');

/*MDistributor Table*/
INSERT INTO MDistributor VALUES ('M500','Fringilla Toys Limited');
INSERT INTO MDistributor VALUES ('M501','Donec Toy Institute');
INSERT INTO MDistributor VALUES ('M502','Vitae Erat Toys Ltd');
INSERT INTO MDistributor VALUES ('M503','Aenean Egestas Hendrerit Toys Limited');
INSERT INTO MDistributor VALUES ('M504','Id Toys Ltd');
INSERT INTO MDistributor VALUES ('M505','Arcu Et Pede Toys And Associates');
INSERT INTO MDistributor VALUES ('M506','Lobortis Toy Industries');
INSERT INTO MDistributor VALUES ('M507','Mus Donec Toy Consulting');
INSERT INTO MDistributor VALUES ('M508','Eleifend Toy Corp.');
INSERT INTO MDistributor VALUES ('M509','Hendrerit Donec Toy Company');
INSERT INTO MDistributor VALUES ('M510','Orci Toy Institute');
INSERT INTO MDistributor VALUES ('M511','Non Arcu Vivamus Toy Industries');
INSERT INTO MDistributor VALUES ('M512','Sed Malesuada Toy Foundation');
INSERT INTO MDistributor VALUES ('M513','Donec Toys Incorporated');
INSERT INTO MDistributor VALUES ('M514','Lacinia Mattis Toys Inc.');
INSERT INTO MDistributor VALUES ('M515','Eros Toy Foundation');
INSERT INTO MDistributor VALUES ('M516','Nunc Toy Corporation');
INSERT INTO MDistributor VALUES ('M517','Arcu Toy Corp.');
INSERT INTO MDistributor VALUES ('M518','Nullam Toy LLP');
INSERT INTO MDistributor VALUES ('M519','Vulputate Toy Foundation');
INSERT INTO MDistributor VALUES ('M520','Sed Dui Toy Ltd');
INSERT INTO MDistributor VALUES ('M521','Ac Toy Foundation');
INSERT INTO MDistributor VALUES ('M522','Lacus Toy Associates');
INSERT INTO MDistributor VALUES ('M523','Proin Toys Inc.');
INSERT INTO MDistributor VALUES ('M524','Claremont Toy World');
INSERT INTO MDistributor VALUES ('M525','Toys "R" Us Inc.');

/*Toy Table*/
INSERT INTO MToy VALUES('M16071108-8336','MJCSUV5');
INSERT INTO MToy VALUES('M16710601-2524','MJCSUV8');
INSERT INTO MToy VALUES('M16980103-2310','MFFS488');
INSERT INTO MToy VALUES('M16031001-7322','MTT4x45');
INSERT INTO MToy VALUES('M16860922-9284','MCSUV76');
INSERT INTO MToy VALUES('M16021105-9779','MBMWM5');
INSERT INTO MToy VALUES('M16030210-0821','MTRAIN06');
INSERT INTO MToy VALUES('M16170710-3444','MTESLA-S');
INSERT INTO MToy VALUES('M16270501-9814','MTESLA-3');
INSERT INTO MToy VALUES('M16810402-6250','MSHELBY500-7');
INSERT INTO MToy VALUES('M16531123-1426','MJCSUV5');
INSERT INTO MToy VALUES('M16271114-8987','MJCSUV8');
INSERT INTO MToy VALUES('M16240419-8737','MFFS488');
INSERT INTO MToy VALUES('M16790605-6903','MTT4x45');
INSERT INTO MToy VALUES('M16420618-3560','MCSUV76');
INSERT INTO MToy VALUES('M16101030-8474','MBMWM5');
INSERT INTO MToy VALUES('M16530829-0252','MTRAIN06');
INSERT INTO MToy VALUES('M16620930-7203','MTESLA-S');
INSERT INTO MToy VALUES('M16880504-0949','MTESLA-3');
INSERT INTO MToy VALUES('M16021109-0477','MSHELBY500-7');
INSERT INTO MToy VALUES('M16040313-2087','MJCSUV5');
INSERT INTO MToy VALUES('M16851017-0114','MJCSUV8');
INSERT INTO MToy VALUES('M16430109-5537','MFFS488');
INSERT INTO MToy VALUES('M16720221-2341','MTT4x45');
INSERT INTO MToy VALUES('M16811225-1940','MCSUV76');
INSERT INTO MToy VALUES('M16631204-5963','MBMWM5');
INSERT INTO MToy VALUES('M16670720-9877','MTRAIN06');
INSERT INTO MToy VALUES('M16530322-3407','MTESLA-S');
INSERT INTO MToy VALUES('M16311120-8348','MTESLA-3');
INSERT INTO MToy VALUES('M16010902-3507','MSHELBY500-7');
INSERT INTO MToy VALUES('M16260906-5475','MJCSUV5');
INSERT INTO MToy VALUES('M16900610-9525','MJCSUV8');
INSERT INTO MToy VALUES('M16380709-5017','MFFS488');
INSERT INTO MToy VALUES('M16050921-6966','MTT4x45');


/*Registration Table*/
SET IDENTITY_INSERT MRegistration ON;
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062110','911','M16071108-8336','2015-11-25','412.81','Advertisement in print','Parent','7','M','No','M501');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062111','911','M16710601-2524','2015-11-30','872.75','Advertisement in print','Parent','13','F','No','M515');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062112','912','M16710601-2524','2015-11-17','788.68','Advertisement in print','Parent','7','M','Don''t Know','M512');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062113','912','M16710601-2524','2016-01-04','618.8','Advertisement on the web','Parent','14','M','Yes','M520');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062114','913','M16980103-2310','2016-01-30','705.51','Advertisement on the web','Parent','9','M','Yes','M525');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062115','913','M16980103-2310','2015-12-20','843.75','Advertisement on the web','Parent','10','F','Don''t Know','M519');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062116','918','M16031001-7322','2016-01-26','733.62','Advertisement on the web','Grandparent','5','F','Yes','M515');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062117','918','M16860922-9284','2016-01-25','927.71','Advertisement on the web','Grandparent','12','M','No','M505');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062118','915','M16021105-9779','2015-12-05','324.89','Advertisement on the web','Grandparent','5','M','No','M521');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062119','915','M16030210-0821','2015-12-30','878.14','Advertisement on TV','Grandparent','11','F','Don''t Know','M503');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062120','916','M16030210-0821','2015-12-07','753.15','Advertisement on TV','Aunt/Uncle','11','M','Yes','M502');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062121','916','M16170710-3444','2016-01-26','771.04','Advertisement on TV','Aunt/Uncle','7','M','Yes','M525');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062122','913','M16270501-9814','2015-12-25','595.54','Advertisement on TV','Other Relative','6','M','Don''t Know','M524');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062123','913','M16810402-6250','2016-01-16','334.44','Advertisement on TV','Other Relative','7','F','Yes','M501');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062124','918','M16531123-1426','2015-11-23','676.57','Advertisement on TV','Other','15','F','No','M510');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062125','918','M16271114-8987','2015-11-03','486.6','Friend�s recommendation','Other','9','M','No','M518');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062126','919','M16240419-8737','2015-11-04','332.15','Friend�s recommendation','Parent','10','M','Don''t Know','M520');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062127','919','M16790605-6903','2015-11-13','902.34','Friend�s recommendation','Parent','7','F','Yes','M514');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062128','920','M16790605-6903','2016-01-23','307.44','In-store display','Parent','8','M','Yes','M521');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062129','920','M16420618-3560','2016-01-25','611.55','In-store display','Parent','15','M','Don''t Know','M517');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062130','920','M16101030-8474','2015-12-27','391.48','In-store display','Parent','8','M','Yes','M507');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062131','920','M16530829-0252','2015-12-21','530.18','Catalog','Parent','5','F','No','M525');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062132','920','M16530829-0252','2016-01-28','733.41','Catalog','Grandparent','8','F','No','M519');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062133','920','M16620930-7203','2016-01-17','433.94','Catalog','Grandparent','10','M','Don''t Know','M505');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062134','911','M16880504-0949','2016-01-15','420.74','Other','Grandparent','13','M','Yes','M506');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062135','911','M16021109-0477','2015-11-14','644.17','Other','Grandparent','7','F','Yes','M501');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062136','912','M16040313-2087','2015-12-23','551.74','Other','Aunt/Uncle','13','M','Don''t Know','M505');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062137','912','M16040313-2087','2015-12-03','633.77','Advertisement in print','Aunt/Uncle','15','M','Yes','M507');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062138','913','M16851017-0114','2015-11-23','566.74','Advertisement in print','Other Relative','13','M','No','M523');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062139','913','M16430109-5537','2015-12-13','380.71','Advertisement in print','Other Relative','5','F','No','M502');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062140','918','M16311120-8348','2015-11-14','868.04','Advertisement on the web','Other','15','F','Don''t Know','M519');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062141','918','M16010902-3507','2015-11-03','636.69','Advertisement on the web','Other','5','M','Yes','M501');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062142','915','M16260906-5475','2015-11-23','566.19','Advertisement on the web','Parent','10','M','Yes','M509');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062143','915','M16900610-9525','2016-01-06','702.88','Advertisement on the web','Parent','8','F','Don''t Know','M520');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062144','916','M16380709-5017','2016-01-22','802.47','Advertisement on the web','Parent','14','M','Yes','M522');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062145','916','M16050921-6966','2016-01-07','562.26','Advertisement on the web','Parent','5','M','No','M509');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062146','913','M16071108-8336','2015-12-06','980.13','Advertisement on TV','Parent','9','M','No','M518');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062147','913','M16710601-2524','2015-12-24','388.46','Advertisement on TV','Parent','14','F','Don''t Know','M523');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062148','918','M16710601-2524','2015-11-21','904.56','Advertisement on TV','Grandparent','5','F','Yes','M521');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062149','918','M16710601-2524','2015-11-20','566.57','Advertisement on TV','Grandparent','14','M','Yes','M516');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062150','919','M16980103-2310','2015-12-21','416.78','Advertisement on TV','Grandparent','6','M','Don''t Know','M523');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062151','919','M16980103-2310','2015-12-26','983.05','Advertisement on TV','Grandparent','15','F','Yes','M511');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062152','920','M16031001-7322','2015-12-20','658.55','Friend�s recommendation','Aunt/Uncle','5','M','No','M509');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062153','920','M16860922-9284','2015-11-13','657.9','Friend�s recommendation','Aunt/Uncle','13','M','No','M520');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062154','920','M16021105-9779','2015-11-09','764.71','Friend�s recommendation','Other Relative','15','M','Don''t Know','M507');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062155','920','M16030210-0821','2015-11-11','533.24','In-store display','Other Relative','13','F','Yes','M502');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062156','920','M16030210-0821','2015-11-30','428.68','In-store display','Other','8','F','Yes','M509');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062157','920','M16170710-3444','2016-01-13','677.23','In-store display','Other','11','M','Don''t Know','M521');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062158','911','M16270501-9814','2015-11-06','538.17','Catalog','Parent','13','M','Yes','M525');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062159','911','M16810402-6250','2016-01-29','523.37','Catalog','Parent','14','F','No','M503');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062160','912','M16531123-1426','2016-01-04','386.12','Catalog','Parent','11','M','No','M517');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062161','912','M16271114-8987','2015-11-04','750.88','Other','Parent','5','M','Don''t Know','M522');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062162','913','M16240419-8737','2015-12-10','997.45','Other','Parent','5','M','Yes','M502');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062163','913','M16790605-6903','2015-11-08','308.66','Other','Parent','11','F','Yes','M507');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062164','918','M16790605-6903','2016-01-21','683.16','Advertisement in print','Grandparent','10','F','Don''t Know','M518');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062165','918','M16420618-3560','2016-01-17','390.78','Advertisement in print','Grandparent','9','M','Yes','M521');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062166','915','M16101030-8474','2016-01-04','673.12','Advertisement in print','Grandparent','7','M','No','M508');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062167','915','M16530829-0252','2016-01-11','983.22','Advertisement on the web','Grandparent','9','F','No','M525');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062168','916','M16530829-0252','2016-01-23','804.55','Advertisement on the web','Aunt/Uncle','9','M','Don''t Know','M515');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062169','916','M16620930-7203','2016-01-24','840.9','Advertisement on the web','Aunt/Uncle','8','M','Yes','M502');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062170','913','M16880504-0949','2016-01-13','775.21','Advertisement on the web','Other Relative','15','M','Yes','M519');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062171','913','M16021109-0477','2015-12-17','313.85','Advertisement on the web','Other Relative','10','F','Don''t Know','M504');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062172','918','M16040313-2087','2015-11-24','390.87','Advertisement on the web','Other','6','F','Yes','M503');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062173','918','M16040313-2087','2015-11-14','770.57','Advertisement on TV','Other','6','M','No','M508');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062174','919','M16851017-0114','2016-01-01','810.36','Advertisement on TV','Parent','9','M','No','M515');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062175','919','M16430109-5537','2015-11-27','376.06','Advertisement on TV','Parent','11','F','Don''t Know','M509');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062176','920','M16311120-8348','2015-12-07','901.77','Advertisement on TV','Parent','10','M','Yes','M504');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062177','920','M16010902-3507','2015-11-20','674.08','Advertisement on TV','Parent','13','M','Yes','M514');
INSERT INTO MRegistration (RegistrationID, CustomerID, SerialNumber, DateOfPurchase, Price, WhereFirstLearn, RelationshipToUser, UserAge, UserGender, FutureBuy, DistributorID) VALUES('20062178','920','M16260906-5475','2015-11-17','716.24','Advertisement on TV','Parent','12','M','Don''t Know','M507');
SET IDENTITY_INSERT MRegistration OFF;

/* Feature Table */
INSERT INTO MFeature VALUES( 'M201', 'Type of MToy (car, jeep, etc.)');
INSERT INTO MFeature VALUES( 'M202', 'Size');
INSERT INTO MFeature VALUES( 'M203', 'Color');
INSERT INTO MFeature VALUES( 'M204', 'Speed');
INSERT INTO MFeature VALUES( 'M205', 'Quality of design');
INSERT INTO MFeature VALUES( 'M206', 'Level of replication from original');
INSERT INTO MFeature VALUES( 'M207', 'Safety MFeatures');
INSERT INTO MFeature VALUES( 'M208', 'Cost');
INSERT INTO MFeature VALUES( 'M209', 'Sound MFeatures');
INSERT INTO MFeature VALUES( 'M210', 'Other');
INSERT INTO MFeature VALUES( 'M211', 'Laser turrets');

/* RegistrationFeature Table */
SET IDENTITY_INSERT MRegistrationFeature ON;
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193010', 'M210','20062110')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193011', 'M204','20062111')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193012', 'M201','20062112')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193013', 'M209','20062112')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193014', 'M202','20062113')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193015', 'M201','20062114')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193016', 'M202','20062114')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193017', 'M208','20062114')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193018', 'M206','20062115')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193019', 'M210','20062115')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193020', 'M205','20062116')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193021', 'M201','20062117')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193022', 'M210','20062117')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193023', 'M208','20062118')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193024', 'M206','20062119')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193025', 'M205','20062120')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193026', 'M204','20062121')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193027', 'M207','20062122')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193028', 'M207','20062123')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193029', 'M203','20062124')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193030', 'M202','20062125')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193031', 'M202','20062126')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193032', 'M207','20062126')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193033', 'M208','20062126')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193034', 'M201','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193035', 'M202','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193036', 'M203','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193037', 'M204','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193038', 'M205','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193039', 'M206','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193040', 'M207','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193041', 'M208','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193042', 'M209','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193043', 'M210','20062127')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193044', 'M206','20062128')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193045', 'M205','20062129')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193046', 'M210','20062135')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193047', 'M210','20062136')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193048', 'M201','20062137')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193049', 'M207','20062138')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193050', 'M210','20062139')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193051', 'M205','20062139')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193052', 'M209','20062139')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193053', 'M201','20062140')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193054', 'M202','20062140')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193055', 'M205','20062140')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193056', 'M201','20062141')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193057', 'M202','20062141')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193058', 'M206','20062141')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193059', 'M204','20062142')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193060', 'M201','20062142')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193061', 'M207','20062143')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193062', 'M204','20062144')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193063', 'M208','20062145')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193064', 'M207','20062146')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193065', 'M203','20062147')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193066', 'M201','20062148')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193067', 'M206','20062149')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193068', 'M205','20062150')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193069', 'M201','20062151')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193070', 'M209','20062152')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193071', 'M203','20062153')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193072', 'M210','20062154')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193073', 'M208','20062155')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193074', 'M208','20062156')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193075', 'M207','20062157')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193076', 'M205','20062158')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193077', 'M210','20062159')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193078', 'M210','20062160')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193079', 'M201','20062161')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193080', 'M201','20062162')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193081', 'M205','20062163')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193082', 'M207','20062163')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193083', 'M202','20062164')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193084', 'M210','20062164')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193085', 'M203','20062165')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193086', 'M201','20062166')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193087', 'M209','20062167')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193088', 'M205','20062168')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193089', 'M201','20062169')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193090', 'M206','20062170')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193091', 'M208','20062171')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193092', 'M204','20062172')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193093', 'M201','20062172')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193094', 'M204','20062173')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193095', 'M201','20062174')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193096', 'M202','20062174')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193097', 'M209','20062174')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193098', 'M201','20062175')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193099', 'M203','20062176')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193100', 'M204','20062177')
INSERT INTO MRegistrationFeature (RegFeatureID, FeatureID, RegistrationID) VALUES ('193101', 'M208','20062178')
SET IDENTITY_INSERT MRegistrationFeature OFF;
