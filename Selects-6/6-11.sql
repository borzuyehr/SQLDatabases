SELECT *,
		CONVERT(VARCHAR(50),(MaxPrice-MinPrice) / ((MaxPrice+MinPrice)/2)*100)+'%' Diff
FROM (
	SELECT		itemID,
			COUNT (itemID) NumberOfRows,
			SUM (Quantity) QuantitySold,
			MIN (Price)	 as  MinPrice,
			MAX (Price)	 as  MaxPrice,
			AVG (Price)	   AveragePrice

FROM		tblOrderLine
GROUP BY	itemID) sub
 
WHERE MinPrice*1.5 < MaxPrice 

