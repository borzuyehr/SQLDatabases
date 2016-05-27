CREATE VIEW			vLastCost
AS
SELECT				cost.ItemID,
					MAX(cost.LastCostDate) as LastCostDate
FROM				tblItemCostHistory as cost
GROUP BY			cost.ItemID;
