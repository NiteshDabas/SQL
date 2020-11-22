# SQL<br/>


## SQL Queries<br/>

### Query 1.<br/>
Using the database WideWorldImporters, write a SQL query which reports the consistency between orders and their attached invoices. The resultset should report for each (CustomerID, CustomerName)<br/>
 a. the total number of orders: TotalNBOrders<br/>
 b. the number of invoices converted from an order: TotalNBInvoices<br/>
 c. the total value of orders: OrdersTotalValue<br/>
 d. the total value of invoices: InvoicesTotalValue<br/>
 f. the absolute value of the difference between c - d: AbsoluteValueDifference<br/>
 
 The resultset must be sorted by highest values of AbsoluteValueDifference, then by smallest to highest values of TotalNBOrders and CustomerName is that order.<br/>
 Please note that all values in a & b must be identical by definition of the query, as we are observing orders converted into invoices. We are looking for potential differences between c & d.<br/>
 
 ### Query 2.<br/>
 For the CustomerId = 1060 (CustomerName = 'Anand Mudaliyar'), Identify the first InvoiceLine of his first Invoice, where "first" means the lowest respective IDs, and write an update query increasing the UnitPrice of this InvoiceLine by 20.<br/>
 
 ### Query 3.<br/>
 In the database WideWorldImporters, write a SQL query which reports the highest loss of money from orders not being converted into invoices, by customer category. The name and id of the customer who generated this highest loss must also be identified. The resultset is ordered by highest loss.<br/>
 
 ### Query 4.<br/>
 In the database SQLPlayground, write a SQL query selecting all the customers' data who have purchased all the products AND have bought more than 50 products in total (sum of all purchases).<br/>


