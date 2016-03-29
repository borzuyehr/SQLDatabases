CREATE TABLE tblCustomer 
(CustomerID			char(5) NOT NULL,
 LastName			varchar(30) NOT NULL,
 FirstName			varchar(20),
 CustomerAddress    varchar(30) NOT NULL,
 City				varchar(20) NOT NULL,
 CustomerState      char(2) NOT NULL,
 Zip				varchar(12) NOT NULL,
 Country			varchar(15),
 FirstBuyDate       datetime,
 Email				varchar(60),
 Phone				char(15) NOT NULL,
 CONSTRAINT pkCustomer PRIMARY KEY(CustomerID));


 CREATE TABLE tblOrder 
(OrderID         char(6)NOT NULL,
 OrderDate       datetime NOT NULL,
 DiscountCode    char(2) CHECK (DiscountCode IN ('02', '03', '04', '06', '08', '10', 'A1', 'B3')),
 CreditCode      char(3) NOT NULL,
 ShipName        varchar(30),
 ShipAddress     varchar(30),
 ShipZip         varchar(12),
 ShipCountry     varchar(30),
 ShipPhone       char(15),
 CustomerID      char(5) NOT NULL,
 CONSTRAINT pkOrder PRIMARY KEY(OrderID),
 CONSTRAINT fkCustomerID
 FOREIGN KEY (CustomerID) REFERENCES tblCustomer (CustomerID));

 ALTER TABLE tblOrder
 ADD PrimaryOrderID char(6)
 ALTER TABLE tblOrder
 ADD FOREIGN KEY (PrimaryOrderID) REFERENCES tblOrder (OrderID)

CREATE TABLE tblItemType
(TypeID					int NOT NULL,
CategoryDescripition	varchar(50),
CONSTRAINT pkTypeID PRIMARY KEY (TypeID));



CREATE TABLE tblItem
(ItemID				char(6) NOT NULL,
 Description		varchar(300) ,
 ListPrice			money check(ListPrice>5) NOT NULL,
 TypeID				int NOT NULL,
 CONSTRAINT pkItem PRIMARY KEY (ItemID),
 CONSTRAINT fkType 
 FOREIGN KEY (TypeID) REFERENCES tblItemType (TypeID));


CREATE TABLE tblItemLocation
(ItemID			char(6) NOT NULL,
 LocationID		char(2) NOT NULL,
 QtyOnHand		int,
 CONSTRAINT pkItemLocation PRIMARY KEY (ItemID, LocationID),
 CONSTRAINT fkItem 
 FOREIGN KEY (ItemID) REFERENCES tblItem (ItemID));


CREATE TABLE tblItemCostHistory
(ItemID				char(6) NOT NULL,
 LastCostDate		datetime NOT NULL,
 LastCost			money NOT NULL,
 CONSTRAINT pkItemCostHistory PRIMARY KEY (ItemID, LastCostDate),
 CONSTRAINT fkItemCostHistory 
 FOREIGN KEY (ItemID) REFERENCES tblItem (ItemID));


CREATE TABLE tblOrderLine
(OrderId		char(6) NOT NULL,
 ItemID			char(6) NOT NULL,
 Quantity		int CHECK(Quantity > 0) NOT NULL,
 Price			money CHECK(Price > 0) NOT NULL,
 CONSTRAINT pkOrderLine PRIMARY KEY (OrderID, ItemID),
 CONSTRAINT fkOrderID 
 FOREIGN KEY (OrderID) REFERENCES tblOrder (OrderID), 
 CONSTRAINT fkItemID 
 FOREIGN KEY (ItemID) REFERENCES tblItem (ItemID));


CREATE TABLE tblReview
(ReviewID		int NOT NULL IDENTITY(1,1), 
 ReviewDate		datetime,
 Rating			int CHECK(Rating >= 0 AND Rating <= 5),
 ReviewText		varchar(500),
 OrderID		char(6) NOT NULL,
 ItemID			char(6) NOT NULL,
 CONSTRAINT pkReview PRIMARY KEY (ReviewID),
 CONSTRAINT fkReviewOrderItem 
 FOREIGN KEY (OrderID, ItemID) REFERENCES tblOrderLine (OrderID, ItemID));


 CREATE TABLE tblShipLine
(DateShipped datetime NOT NULL,
 OrderID char(6) NOT NULL,
 ItemID char(6) NOT NULL,
 LocationID char(2) NOT NULL,
 QtyShipped int NOT NULL,
 MethodShiped varchar(30) NOT NULL,
 CONSTRAINT pkShipLine PRIMARY KEY (Dateshipped, OrderID, ItemID, LocationID),
 CONSTRAINT fkShipOrderItem 
 FOREIGN KEY (OrderID, ItemID) REFERENCES TblOrderLine (OrderID, ItemID),
 CONSTRAINT fkShipItemLocation 
 FOREIGN KEY (ItemID, LocationID) REFERENCES tblItemLocation (ItemID, LocationID));





