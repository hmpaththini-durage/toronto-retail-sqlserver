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

WITH Base AS(
	SELECT 
		CustomerID,
		DATEDIFF(day, MAX(OrderDate), GETDATE()) AS Recency,
		COUNT(OrderID) AS Frequency,
		SUM(Total) AS Monetary
	FROM Orders 
	WHERE OrderStatus = 'Completed' 
	GROUP BY CustomerID
),
Scored AS(
	SELECT 
        CustomerID,
        NTILE(5) OVER (ORDER BY Recency ASC) AS R_Score,   -- recent orders score higher
        NTILE(5) OVER (ORDER BY Frequency DESC) AS F_Score, -- frequent buyers score higher
        NTILE(5) OVER (ORDER BY Monetary DESC) AS M_Score   -- higher spenders score higher
    FROM Base
)
SELECT *,
       CAST(R_Score AS VARCHAR(1)) 
       + CAST(F_Score AS VARCHAR(1)) 
       + CAST(M_Score AS VARCHAR(1)) AS RFM_Code
FROM Scored
ORDER BY RFM_Code DESC;

--Campaign Lift Analysis
-- Shows revenue and orders driven by each online marketing campaign to evaluate ROI.

WITH OnlineOrders AS(
	SELECT * 
	FROM Orders
	WHERE Channel = 'Online' 
		and OrderStatus = 'Completed'
)
SELECT 
	c.CampaignID, 
	c.name AS CampaignName,
	SUM(o.Total) AS AttributedRevenue,
    COUNT(o.OrderID) AS AttributedOrders,
    MIN(c.StartDate) AS StartDate,
    MAX(c.EndDate) AS EndDate
FROM Campaigns c
LEFT JOIN OnlineOrders o 
	ON c.CampaignID = o.CampaignID
GROUP BY c.CampaignID, c.Name
ORDER BY AttributedRevenue DESC;

-- Year-over-Year (YoY) Growth Analysis
-- Compare revenue trends for Online vs Store sales channels.
-- Calculate monthly revenue and measure growth over time.
-- Use LAG() to get the previous month’s revenue and compute % growth.

WITH MonthlyRevenue AS(
	SELECT 
		FORMAT(OrderDate, 'yyyy-MM') AS Month, 
		Channel, SUM(Total) As Revenue 
	FROM Orders 
	WHERE OrderStatus = 'Completed' 
	GROUP BY FORMAT(OrderDate, 'yyyy-MM'), Channel
)
SELECT 
    Month,
    Channel,
    Revenue,
    LAG(Revenue) OVER (PARTITION BY Channel ORDER BY Month) AS PrevMonthRevenue,
    ROUND(
        (CAST(Revenue AS FLOAT) - LAG(Revenue) OVER (PARTITION BY Channel ORDER BY Month))
        / NULLIF(LAG(Revenue) OVER (PARTITION BY Channel ORDER BY Month),0) * 100, 2
    ) AS MoM_Growth_Percent
FROM MonthlyRevenue
ORDER BY Month, Channel;