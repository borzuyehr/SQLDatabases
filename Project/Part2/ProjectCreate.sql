DROP TABLE RegistrationFeature;
DROP TABLE Feature;
DROP TABLE Registration;
DROP TABLE Toy;
DROP TABLE Distributor;
DROP TABLE Model;
DROP TABLE Customer;
DROP TABLE ZipCode;


CREATE TABLE ZipCode(
ZipCode				char(5)		NOT NULL,
City				varchar(20)	NOT NULL,
State				varchar(2)	NOT NULL
CONSTRAINT pkZipCode PRIMARY KEY (ZipCode));

CREATE TABLE Customer(
CustomerID			char(7)			NOT NULL,
LastName			varchar(20)		NOT NULL,
FirstName			varchar(20)		NOT NULL,
Address				varchar(30)		NOT NULL,
ZipCode				char(5)			NOT NULL,
Email				varchar(60),
Phone				char(15)	NOT NULL
CONSTRAINT pkCust PRIMARY KEY (CustomerID),
CONSTRAINT fkZipCode FOREIGN KEY (ZipCode) REFERENCES ZipCode (ZipCode));

CREATE TABLE Model(
ModelNumber			char(10)		NOT NULL,
ModelName			varchar(20)		NOT NULL,
ModelDescription	varchar(60)		NOT NULL,
CONSTRAINT pkModelNumber PRIMARY KEY (ModelNumber));

CREATE TABLE Distributor(
DistributorID		char(7)			NOT NULL,
DistributorName		varchar(20)		NOT NULL,
CONSTRAINT pkDistributorID PRIMARY KEY (DistributorID));

CREATE TABLE Toy(
SerialNumber		char(9)			NOT NULL,
ModelNumber			char(10)		NOT NULL,
DistributorID		char(7),
DateOfReturn		date,
ReturnNotes			varchar(200)
CONSTRAINT pkSerialNumber PRIMARY KEY (SerialNumber),
CONSTRAINT fkModelNumber FOREIGN KEY (ModelNumber) REFERENCES Model (ModelNumber),
CONSTRAINT fkDistributorID FOREIGN KEY (DistributorID) REFERENCES Distributor (DistributorID));

CREATE TABLE Registration(
CustomerID			char(7)			NOT NULL,
SerialNumber		char(9)			NOT NULL,
DateOfPurchase		date			NOT NULL,
Price				money			NOT NULL CHECK (Price > 0),
WhereFirstLearn		varchar(30)		NOT NULL CHECK ( WhereFirstLearn = 'Advertisement in print' OR
												WhereFirstLearn = 'Advertisement on the web' OR
												WhereFirstLearn = 'Advertisement on TV' OR
												WhereFirstLearn = 'Friend’s recommendation' OR
												WhereFirstLearn = 'In-store display' OR
												WhereFirstLearn = 'Catalog' OR
												WhereFirstLearn = 'Other' ),
RelationshipToUser	varchar(15)		NOT NULL CHECK ( RelationshipToUser = 'Parent' OR
												RelationshipToUser = 'Grandparent' OR
												RelationshipToUser = 'Aunt/Uncle' OR
												RelationshipToUser = 'Friend' OR
												RelationshipToUser = 'Other Relative' OR
												RelationshipToUser = 'Other' ),
UserAge				int				NOT NULL CHECK (UserAge > 0),
UserGender			varchar(1)		NOT NULL CHECK (UserGender = 'F' OR UserGender = 'M'),
FutureBuy			varchar(10)		NOT NULL CHECK (FutureBuy = 'Yes' OR
												FutureBuy = 'No' OR
												FutureBuy = 'Don''t know')
CONSTRAINT pkCustSerial PRIMARY KEY (CustomerID, SerialNumber),
CONSTRAINT fkCustomerID	FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
CONSTRAINT fkSerialNumber FOREIGN KEY (SerialNumber) REFERENCES Toy (SerialNumber));

CREATE TABLE Feature(
FeatureID			char(5)			NOT NULL,
FeatureDescription	varchar(30)		NOT NULL,
CONSTRAINT pkFeatureID PRIMARY KEY (FeatureID));

CREATE TABLE RegistrationFeature(
CustomerID			char(7)			NOT NULL,
SerialNumber		char(9)			NOT NULL,
FeatureID			char(5)			NOT NULL,
CONSTRAINT	pkCustSerialFeat PRIMARY KEY (CustomerID, SerialNumber, FeatureID),
CONSTRAINT	fkCustSerial FOREIGN KEY (CustomerID, SerialNumber) REFERENCES Registration (CustomerID, SerialNumber),
CONSTRAINT	fkFeatureID FOREIGN KEY (FeatureID) REFERENCES Feature (FeatureID));