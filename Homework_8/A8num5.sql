SELECT TOP 1		cust.LastName + ', ' + cust.FirstName as CustomerName,
					ord.OrderID,
					CONVERT(varchar, ord.OrderDate, 107) as DateOrdered,
					item.ItemID,
					item.Description,
					line.Price,
					cost.LastCost as MostCurrentCost,
					CONVERT(varchar, lcost.LastCostDate, 101) as LastCostDate,
					SUM(line.Price - cost.LastCost) as DifferenceBetweenPriceandCost
FROM				tblOrder as ord
LEFT OUTER JOIN		tblCustomer as cust
ON					cust.CustomerID = ord.CustomerID
LEFT OUTER JOIN		tblOrderLine as line 
ON					ord.OrderID = line.OrderID
LEFT OUTER JOIN		tblItem as item
ON					item.ItemID = line.ItemID
LEFT OUTER JOIN		tblItemType as itype
ON					itype.TypeID = item.TypeID
LEFT OUTER JOIN		vLastCost as lcost
ON					line.ItemID = lcost.ItemID
LEFT OUTER JOIN		tblItemCostHistory as cost
ON					lcost.LastCostDate = cost.LastCostDate
AND					lcost.ItemID = cost.ItemID
WHERE				item.Description = 'Tiny Epic Galaxies'
GROUP BY			cust.LastName,
					cust.FirstName,
					ord.OrderID,
					ord.OrderDate,
					item.ItemID,
					item.Description,
					line.Price,
					cost.LastCost,
					lcost.LastCostDate
ORDER BY			line.Price;
