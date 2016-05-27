SELECT TOP 1 convert(varchar(12), FirstBuyDate, 107) as 'Earliest First Buy Date'
FROM tblCustomer
ORDER BY FirstBuyDate;