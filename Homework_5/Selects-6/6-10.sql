SELECT		itemID,
			COUNT (itemID) NumberOfRows,
			SUM (Quantity) QuantitySold,
			MIN (Price)	   MinPrice,
			MAX (Price)	   MaxPrice,
			AVG (Price)	   AveragePrice
FROM		tblOrderLine
GROUP BY	itemID;

