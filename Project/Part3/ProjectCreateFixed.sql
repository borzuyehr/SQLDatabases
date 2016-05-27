DROP TABLE RegistrationFeature;
DROP TABLE Feature;
DROP TABLE Registration;
DROP TABLE Toy;
DROP TABLE Distributor;
DROP TABLE Model;
DROP TABLE Customer;



CREATE TABLE Customer(
CustomerID			char(7)			NOT NULL,
CustomerName		varchar(20)		NOT NULL,
Email				varchar(60),
Phone				char(15)	NOT NULL
CONSTRAINT pkCust PRIMARY KEY (CustomerID));

CREATE TABLE Model(
ModelNumber			char(11)		NOT NULL,
ModelDescription	varchar(60)		NOT NULL,
CONSTRAINT pkModelNumber PRIMARY KEY (ModelNumber));

CREATE TABLE Distributor(
DistributorID		char(7)			NOT NULL,
DistributorName		varchar(40)		NOT NULL,
CONSTRAINT pkDistributorID PRIMARY KEY (DistributorID));

CREATE TABLE Toy(
SerialNumber		char(13)		NOT NULL,
ModelNumber			char(11)		NOT NULL
CONSTRAINT pkSerialNumber PRIMARY KEY (SerialNumber),
CONSTRAINT fkModelNumber FOREIGN KEY (ModelNumber) REFERENCES Model (ModelNumber));

CREATE TABLE Registration(
RegistrationID		char(8)			NOT NULL,
CustomerID			char(7)		NOT NULL,
SerialNumber		char(13)			NOT NULL,
DateOfPurchase		date			NOT NULL,
Price				money			NOT NULL CHECK (Price > 0),
WhereFirstLearn		varchar(30)		NOT NULL,
RelationshipToUser	varchar(15)		NOT NULL,
UserAge				int				NOT NULL CHECK (UserAge > 0),
UserGender			varchar(1)		NOT NULL CHECK (UserGender = 'F' OR UserGender = 'M'),
FutureBuy			varchar(10)		NOT NULL,
DistributorID		char(7)
CONSTRAINT pkRegistrationID PRIMARY KEY (RegistrationID),
CONSTRAINT fkCustomerID	FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),
CONSTRAINT fkSerialNumber FOREIGN KEY (SerialNumber) REFERENCES Toy (SerialNumber),
CONSTRAINT fkDistributorID FOREIGN KEY (DistributorID) REFERENCES Distributor (DistributorID));

CREATE TABLE Feature(
FeatureID			char(5)			NOT NULL,
FeatureDescription	varchar(40)		NOT NULL,
CONSTRAINT pkFeatureID PRIMARY KEY (FeatureID));

CREATE TABLE RegistrationFeature(
RegFeatureID		char(5)			NOT NULL,
FeatureID			char(5)			NOT NULL,
RegistrationID		char(8)			NOT NULL,
CONSTRAINT	pkRegFeatureID PRIMARY KEY (RegFeatureID),
CONSTRAINT	fkRegistrationID FOREIGN KEY (RegistrationID) REFERENCES Registration (RegistrationID),
CONSTRAINT	fkFeatureID FOREIGN KEY (FeatureID) REFERENCES Feature (FeatureID));