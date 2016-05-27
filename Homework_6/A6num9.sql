SELECT ROUND(AVG(Price), 2) as 'Average Selling Price'
FROM tblOrderLine
WHERE itemID = 'A34665';