SELECT		tblItemLocation.ItemID, 
			tblItem.Description,
			SUM(tblItemLocation.qtyonhand) 'Total Available in Inventory'

FROM		tblItemLocation 
INNER JOIN	tblItem 
ON			tblItemLocation.itemID=tblItem.itemID

GROUP BY	tblItemLocation.itemID,
			tblItem.Description
HAVING		SUM(tblItemLocation.qtyonhand) <18
