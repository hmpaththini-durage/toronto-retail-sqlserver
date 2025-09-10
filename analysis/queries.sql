--List all customers along with the total number of orders they have placed..

WITH NumberOfOrders AS (
    SELECT CustomerID, COUNT(OrderID) AS TotalOrders
    FROM Orders
    GROUP BY CustomerID
)
SELECT c.CustomerID, c.FirstName, c.LastName, o.TotalOrders
FROM Customers c
JOIN NumberOfOrders o ON c.CustomerID = o.CustomerID;

--List the total revenue per customer, considering only completed orders, and order the results from highest to lowest revenue.

WITH Revenue AS (
    SELECT CustomerID, SUM(Total) AS Revenue
    FROM Orders
    WHERE OrderStatus = 'completed'
    GROUP BY CustomerID
)
SELECT c.CustomerID, c.FirstName, c.LastName, r.Revenue
FROM Customers c
JOIN Revenue r ON c.CustomerID = r.CustomerID
ORDER BY r.Revenue DESC;

--List monthly revenue for the last 6 months, grouped by month, considering only completed orders.

SELECT
    DATEADD(month, DATEDIFF(month, 0, OrderDate), 0) AS MonthStart,
    ROUND(SUM(Total), 2) AS Revenue
FROM Orders
WHERE OrderStatus = 'Completed'
  AND OrderDate >= DATEADD(month, -6, GETDATE())
GROUP BY DATEADD(month, DATEDIFF(month, 0, OrderDate), 0)
ORDER BY MonthStart;

--Find the top 5 products by revenue in the last 90 days, showing product name, revenue, and units sold.

WITH RecentOrders AS (
	SELECT oi.ProductID, 
	SUM(oi.UnitPrice * oi.Quantity) AS Revenue, 
	SUM(oi.Quantity) AS unitssold  
	FROM OrderItems oi
	JOIN Orders o ON oi.OrderID = o.OrderID
	WHERE o.OrderStatus = 'Completed'
	AND o.OrderDate >= DATEADD(day, -90, GETDATE())
	GROUP BY oi.ProductID 
)
SELECT TOP 5 p.ProductID,p.ProductName, r.Revenue , r.unitssold
FROM Products p
JOIN RecentOrders r ON p.ProductID = r.ProductID ORDER BY r.Revenue DESC;

--Create a simple RFM score for each customer, considering Recency (days since last order), 
--Frequency (number of completed orders), and Monetary (total spent). Score each metric from 1–5.




