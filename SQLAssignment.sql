--#######################################################################################
-- Query#1
--#######################################################################################
USE WideWorldImporters
SELECT DISTINCT CustomerName FROM Sales.Customers
SELECT * FROM Sales.Customers
SELECT * FROM Sales.Orders
SELECT * FROM Sales.Invoices
SELECT * FROM Sales.OrderLines
SELECT * FROM Sales.InvoiceLines
--AbsoluteValueDifference = OrdersTotalValue - InvoicesTotalValue
--SELECT CustomerID, CustomerName, TotalNBOrders, TotalNBInvoices, OrdersTotalValue, InvoicesTotalValue, AbsoluteValueDifference
--a) the total number of orders: TotalNBOrders
SELECT COUNT(DISTINCT SO.OrderID) 
FROM Sales.Orders as SO
--b) the number of invoices converted from an order: TotalNBInvoices
SELECT COUNT(DISTINCT SI.InvoiceID) 
FROM Sales.Invoices as SI
--c) the total value of orders: OrdersTotalValue = (PricePerOrder)*(TotalCountofOrders) for Orders
SELECT SUM(SOL.UnitPrice*SOL.Quantity) as OrdersTotalValue
FROM Sales.OrderLines as SOL
--d) the total value of invoices: InvoicesTotalValue = (PricePerOrder)*(TotalCountofOrders) for Invoices
SELECT SUM(SIL.UnitPrice*SIL.Quantity) as InvoicesTotalValue
FROM Sales.InvoiceLines as SIL 
--f) the absolute value of the difference between c - d: AbsoluteValueDifference
--FINAL QUERY
SELECT Query1.CustomerID, Query1.CustomerName, Query1.TotalNBOrders, Query1.TotalNBInvoices, Query1.OrdersTotalValue, Query2.InvoicesTotalValue,
    ABS(Query1.OrdersTotalValue-Query2.InvoicesTotalValue) as AbsoluteValueDifference
FROM(
    SELECT SC.CustomerID, SC.CustomerName, COUNT(DISTINCT SO.OrderID) as TotalNBOrders, COUNT(DISTINCT SI.InvoiceID) as TotalNBInvoices, SUM(SOL.UnitPrice*SOL.Quantity) as OrdersTotalValue
    FROM Sales.Customers as SC, Sales.Orders as SO, Sales.Invoices as SI, Sales.OrderLines as SOL
    WHERE SC.CustomerID=SO.CustomerID AND SO.OrderID=SI.OrderID AND SO.OrderID=SOL.OrderID
    GROUP BY SC.CustomerID, SC.CustomerName) as Query1
LEFT JOIN 
    (SELECT SO.CustomerID, SUM(SIL.UnitPrice*SIL.Quantity) as InvoicesTotalValue
    FROM Sales.Orders as SO, Sales.Invoices as SI, Sales.InvoiceLines as SIL
    WHERE SI.InvoiceID = SIL.InvoiceID AND SO.OrderID=SI.OrderID
    GROUP BY SO.CustomerID) as Query2
ON (Query1.CustomerID=Query2.CustomerID)
ORDER BY AbsoluteValueDifference desc,TotalNBOrders


--#######################################################################################
-- Query#2
--#######################################################################################
USE WideWorldImporters
UPDATE Sales.InvoiceLines SET UnitPrice = UnitPrice +20 WHERE InvoiceLineID IN (
    SELECT MIN(SIL.InvoiceLineID) FROM Sales.InvoiceLines as SIL WHERE SIL.InvoiceID IN (
        SELECT MIN(InvoiceID) FROM Sales.Invoices as SI WHERE SI.CustomerID = '1060')
)
--SELECT * FROM Sales.InvoiceLines WHERE InvoiceLineID = 225394


--#######################################################################################
-- Query#3
--#######################################################################################
USE WideWorldImporters
SELECT * FROM Sales.Customers
SELECT * FROM Sales.CustomerCategories
SELECT * FROM Sales.OrderLines
SELECT * FROM Sales.Invoices
SELECT * FROM Sales.Orders
SELECT Query4.CustomerCategoryName, Query4.CustomerTotalLoss as MaxLoss, Query4.CustomerName, Query4.CustomerID FROM(
    SELECT SCC.CustomerCategoryName, Query3.CustomerTotalLoss, Query3.CustomerName, Query3.CustomerID,
    ROW_NUMBER() over ( partition by SCC.CustomerCategoryName order by Query3.CustomerTotalLoss desc ) as rn 
    FROM Sales.CustomerCategories as SCC 
    JOIN(
        SELECT SC.CustomerCategoryID, SC.CustomerID, SC.CustomerName, Query2.CustomerTotalLoss FROM Sales.Customers as SC
        INNER JOIN(
            SELECT Query1.CustomerID, SUM(SOL.Quantity*SOL.UnitPrice) as CustomerTotalLoss 
            FROM Sales.OrderLines as SOL
            INNER JOIN(
                SELECT SO.OrderID, SO.CustomerID FROM Sales.Orders as SO LEFT JOIN Sales.Invoices as SI ON SI.OrderID=SO.OrderID WHERE SI.OrderID is NULL) as Query1
            ON SOL.OrderID=Query1.OrderID
            GROUP BY Query1.CustomerID) as Query2
        ON SC.CustomerID=Query2.CustomerID) as Query3
    ON SCC.CustomerCategoryID = Query3.CustomerCategoryID) as Query4
    WHERE rn=1
    ORDER BY MaxLoss DESC


--#######################################################################################
-- Query#4
--#######################################################################################
USE SQLPlayground
SELECT * FROM Customer
SELECT * FROM Purchase
SELECT * FROM Product
SELECT * FROM Student

SELECT Customer.CustomerId, Customer.CustomerName
FROM Customer, Purchase, Product
WHERE Purchase.CustomerId=Customer.CustomerId AND Purchase.ProductId=Product.ProductId
GROUP BY (Customer.CustomerId), Customer.CustomerName
HAVING SUM(Purchase.Qty)>50