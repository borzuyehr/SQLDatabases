SELECT			ITEM.ItemID  'ItemID',
				ITEM.Description  'Description',
				TIT.categoryDescription 'CategoryDescription',
				VCOLD.TotalQtyOnOrder,
				VCOLD.NumberOfOrders,
				VCOLD.MostExpensivePrice,
				VCOLD.LeastExpensivePrice,
				VCOLD.AveragePrice,
				(Select ISNULL (MAX(LastCost),0)
				 From tblItemCostHistory ICH3
				 Where ICH3.ItemID = ITEM.ItemID) "MostExpensiveCost",
				(Select ISNULL (MIN(LastCost),0)
				 From tblItemCostHistory ICH3
				 Where ICH3.ItemID = ITEM.ItemID) "LeastExpensiveCost",
				(Select ISNULL (AVG(LastCost),0)
				 From tblItemCostHistory ICH3
				 Where ICH3.ItemID = ITEM.ItemID) "AverageCost",
				ISNULL(CONVERT(VARCHAR, ICH.LastCostDate, 107), 'No Previous Purchase') 'Last Cost Date',
				ISNULL(CONVERT(VARCHAR, ICH.lastcost, 107), 0) 'Most Current Cost'	 

FROM			tblItem ITEM
LEFT OUTER JOIN	tblItemCostHistory ICH
ON			ITEM.ItemID = ICH.ItemID
LEFT OUTER JOIN tblItemType  TIT
ON				ITEM.typeid = TIT.typeid
LEFT OUTER JOIN vCurrentOrderLineData VCOLD
ON				ITEM.itemID = VCOLD.itemID

WHERE			ICH.LastCostDate = 
				(Select MAX(LastCostDate)
				 From tblItemCostHistory ICH4
				 Where ICH4.ItemID = ITEM.ItemID)
				 OR ICH.LastCostDate IS NULL		
ORDER BY		ItemID ASC, 
			LastCostDate DESC
