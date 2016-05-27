SELECT	OrderID,
		ItemID,
		convert(varchar(10), DateShipped, 101) as DateShipped,
		QtyShipped,
		upper(MethodShipped)
FROM tblShipLine
WHERE	DateShipped BETWEEN ( '01/01/' + cast(year(getdate()) as varchar(4))) 
		AND ( '01/31/' + cast(year(getdate()) as varchar(4)));