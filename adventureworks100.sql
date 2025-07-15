# Mastering SQL with AdventureWorks: A Comprehensive Guide

## **Overview**
This guide provides a structured learning path designed to take you from SQL fundamentals to expert-level proficiency using Microsoft AdventureWorks databases (OLTP, Data Warehouse, and Lightweight). The guide includes theoretical explanations, best practices, real-world applications, practice queries, exercises, and assessments to ensure deep understanding.

---

## **Learning Progression**
The guide follows 10 detailed modules:

### **Module 1: Introduction to SQL and AdventureWorks**
- **Objectives:**
  - Understand SQL basics and database management concepts.
  - Explore relational databases and schemas.
  - Learn to install and use AdventureWorks databases.
  - Differentiate between OLTP, Data Warehouse, and Lightweight databases.
- **Key Concepts:**
  - Structured Query Language (SQL) as a standard for managing relational databases.
  - RDBMS (Relational Database Management Systems) like SQL Server.
  - Overview of database objects (Tables, Views, Indexes, Constraints, Stored Procedures).
  - Installation of AdventureWorks databases and setting up a SQL Server environment.
- **Practice Query:** List all tables in AdventureWorks OLTP.
  ```sql
  SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
  ```

### **Module 2: Understanding the AdventureWorks Schema**
- **Objectives:**
  - Explore the structure and purpose of AdventureWorks database tables.
  - Understand key relationships between tables.
- **Key Concepts:**
  - Primary and foreign keys.
  - Fact and dimension tables in Data Warehouses.
  - Entity-relationship diagrams (ERD).
- **Practice Query:** Retrieve column details for a specific table.
  ```sql
  SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Person';
  ```

---

## **Advanced and Expert SQL Practice Questions (100+ Queries)**
The following questions and their corresponding SQL queries are designed to challenge and build expert-level SQL skills using AdventureWorks OLTP.

### **1-100: Advanced and Expert-Level SQL Queries**

```sql ```

-- 1. Retrieve the top 10 employees with the highest salaries.
SELECT TOP 10 BusinessEntityID, JobTitle, Rate 
FROM HumanResources.EmployeePayHistory 
ORDER BY Rate DESC;

-- 2. Find the total number of orders placed in each year.
SELECT YEAR(OrderDate) AS OrderYear, COUNT(*) AS TotalOrders 
FROM Sales.SalesOrderHeader 
GROUP BY YEAR(OrderDate) 
ORDER BY OrderYear;

-- 3. Retrieve the customers who have placed more than 5 orders.
SELECT CustomerID, COUNT(SalesOrderID) AS OrderCount 
FROM Sales.SalesOrderHeader 
GROUP BY CustomerID 
HAVING COUNT(SalesOrderID) > 5;

-- 4. Find the most popular product (with the highest sales quantity).
SELECT TOP 1 ProductID, SUM(OrderQty) AS TotalSold 
FROM Sales.SalesOrderDetail 
GROUP BY ProductID 
ORDER BY TotalSold DESC;

-- 5. Retrieve the total revenue generated per product category.
SELECT p.ProductCategoryID, pc.Name AS CategoryName, SUM(sod.LineTotal) AS TotalRevenue 
FROM Sales.SalesOrderDetail sod 
JOIN Production.Product p ON sod.ProductID = p.ProductID 
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID 
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID 
GROUP BY p.ProductCategoryID, pc.Name 
ORDER BY TotalRevenue DESC;

-- 6. Retrieve the customers who have never placed an order.
SELECT c.CustomerID, c.PersonID, c.CompanyName 
FROM Sales.Customer c 
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID 
WHERE soh.CustomerID IS NULL;

-- 7. Calculate the average order total per customer.
SELECT CustomerID, AVG(TotalDue) AS AvgOrderValue 
FROM Sales.SalesOrderHeader 
GROUP BY CustomerID;

-- 8. Find employees who have been with the company for more than 10 years.
SELECT BusinessEntityID, JobTitle, HireDate 
FROM HumanResources.Employee 
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 10;

-- 9. List all employees along with their manager’s name.
SELECT e.BusinessEntityID, e.JobTitle, m.BusinessEntityID AS ManagerID, m.JobTitle AS ManagerTitle 
FROM HumanResources.Employee e 
LEFT JOIN HumanResources.Employee m ON e.OrganizationLevel = m.OrganizationLevel - 1;

-- 10. Find the average sales per month over the last 5 years.
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, AVG(TotalDue) AS AvgSales 
FROM Sales.SalesOrderHeader 
WHERE OrderDate >= DATEADD(YEAR, -5, GETDATE()) 
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
ORDER BY OrderYear, OrderMonth;

-- 11-100: Additional queries covering advanced joins, CTEs, stored procedures, indexing strategies, window functions, and performance optimization.

-- 11. Find the most valuable customers based on total purchases.
SELECT CustomerID, SUM(TotalDue) AS TotalSpent 
FROM Sales.SalesOrderHeader 
GROUP BY CustomerID 
ORDER BY TotalSpent DESC;

-- 12. Identify products that have never been sold.
SELECT p.ProductID, p.Name 
FROM Production.Product p 
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID 
WHERE sod.ProductID IS NULL;

-- 13. Create a recursive Common Table Expression (CTE) for employee hierarchy.
WITH EmployeeHierarchy AS (
  SELECT BusinessEntityID, OrganizationLevel, JobTitle
  FROM HumanResources.Employee
  WHERE OrganizationLevel = 1
  UNION ALL
  SELECT e.BusinessEntityID, e.OrganizationLevel, e.JobTitle
  FROM HumanResources.Employee e
  JOIN EmployeeHierarchy eh ON e.OrganizationLevel = eh.OrganizationLevel + 1
)
SELECT * FROM EmployeeHierarchy;

-- 14. Retrieve the top 5 customers by total number of orders.
SELECT TOP 5 CustomerID, COUNT(SalesOrderID) AS OrderCount 
FROM Sales.SalesOrderHeader 
GROUP BY CustomerID 
ORDER BY OrderCount DESC;

-- 15. Retrieve products that have been ordered more than 100 times.
SELECT ProductID, SUM(OrderQty) AS TotalOrdered 
FROM Sales.SalesOrderDetail 
GROUP BY ProductID 
HAVING SUM(OrderQty) > 100;

-- 16-100: More queries on performance tuning, stored procedures, and analytical functions.
```

This is an extended list of advanced queries, covering expert-level concepts, performance tuning, and in-depth SQL applications.



# Advanced SQL Queries for AdventureWorks (16-100)

## Table Operations and Joins

```sql
-- 16. Find products that are in the same category as 'Mountain Bikes'
SELECT p.ProductID, p.Name, pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = (
    SELECT pc2.Name 
    FROM Production.ProductCategory pc2
    JOIN Production.ProductSubcategory ps2 ON pc2.ProductCategoryID = ps2.ProductCategoryID
    JOIN Production.Product p2 ON ps2.ProductSubcategoryID = p2.ProductSubcategoryID
    WHERE p2.Name LIKE '%Mountain Bike%'
    GROUP BY pc2.Name
);

-- 17. Retrieve all orders along with customer information using different join types
SELECT soh.SalesOrderID, c.CustomerID, p.FirstName, p.LastName, soh.OrderDate
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
ORDER BY soh.OrderDate DESC;

-- 18. Find vendors who supply the most number of products
SELECT v.BusinessEntityID, v.Name, COUNT(pv.ProductID) AS ProductCount
FROM Purchasing.Vendor v
JOIN Purchasing.ProductVendor pv ON v.BusinessEntityID = pv.BusinessEntityID
GROUP BY v.BusinessEntityID, v.Name
ORDER BY ProductCount DESC;

-- 19. Find products that have been purchased by the most customers
SELECT p.ProductID, p.Name, COUNT(DISTINCT soh.CustomerID) AS CustomerCount
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.ProductID, p.Name
ORDER BY CustomerCount DESC;

-- 20. Self-join to find employees who have the same job title
SELECT e1.BusinessEntityID, e1.JobTitle, e2.BusinessEntityID AS OtherEmployeeID
FROM HumanResources.Employee e1
JOIN HumanResources.Employee e2 ON e1.JobTitle = e2.JobTitle
WHERE e1.BusinessEntityID < e2.BusinessEntityID;
```

## Aggregations and Window Functions

```sql
-- 21. Calculate running total of sales by month
SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalDue) AS MonthlySales,
    SUM(SUM(TotalDue)) OVER (PARTITION BY YEAR(OrderDate) ORDER BY MONTH(OrderDate)) AS RunningTotal
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- 22. Rank products by sales quantity within each category
SELECT 
    p.ProductID, 
    p.Name, 
    pc.Name AS CategoryName,
    SUM(sod.OrderQty) AS TotalQuantity,
    RANK() OVER (PARTITION BY pc.ProductCategoryID ORDER BY SUM(sod.OrderQty) DESC) AS RankInCategory
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name, pc.Name, pc.ProductCategoryID;

-- 23. Calculate the percentage of total sales each product contributes
WITH ProductSales AS (
    SELECT 
        p.ProductID, 
        p.Name, 
        SUM(sod.LineTotal) AS TotalSales
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    GROUP BY p.ProductID, p.Name
)
SELECT 
    ProductID, 
    Name, 
    TotalSales,
    TotalSales / SUM(TotalSales) OVER () * 100 AS PercentageOfTotal
FROM ProductSales
ORDER BY PercentageOfTotal DESC;

-- 24. Find the difference in sales between consecutive months
SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalDue) AS CurrentMonthSales,
    LAG(SUM(TotalDue), 1, 0) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS PreviousMonthSales,
    SUM(TotalDue) - LAG(SUM(TotalDue), 1, 0) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS MonthlySalesChange
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- 25. Calculate the moving average of sales over a 3-month period
SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalDue) AS MonthlySales,
    AVG(SUM(TotalDue)) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3Month
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;
```

## Common Table Expressions (CTEs) and Subqueries

```sql
-- 26. Use CTE to find customers who have purchased products from all categories
WITH CustomerCategories AS (
    SELECT 
        soh.CustomerID,
        pc.ProductCategoryID,
        COUNT(DISTINCT pc.ProductCategoryID) AS CategoryCount
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY soh.CustomerID, pc.ProductCategoryID
)
SELECT 
    cc.CustomerID,
    COUNT(DISTINCT cc.ProductCategoryID) AS PurchasedCategories,
    (SELECT COUNT(*) FROM Production.ProductCategory) AS TotalCategories
FROM CustomerCategories cc
GROUP BY cc.CustomerID
HAVING COUNT(DISTINCT cc.ProductCategoryID) = (SELECT COUNT(*) FROM Production.ProductCategory);

-- 27. Identify potential cross-selling opportunities using subqueries
SELECT 
    p1.ProductID, 
    p1.Name,
    (
        SELECT STRING_AGG(p2.Name, ', ')
        FROM Production.Product p2
        JOIN Sales.SalesOrderDetail sod2 ON p2.ProductID = sod2.ProductID
        WHERE sod2.SalesOrderID IN (
            SELECT sod1.SalesOrderID 
            FROM Sales.SalesOrderDetail sod1 
            WHERE sod1.ProductID = p1.ProductID
        )
        AND p2.ProductID != p1.ProductID
        GROUP BY p2.ProductID
    ) AS FrequentlyBoughtWith
FROM Production.Product p1
WHERE p1.ProductID IN (
    SELECT TOP 10 ProductID FROM Sales.SalesOrderDetail
    GROUP BY ProductID
    ORDER BY COUNT(*) DESC
);

-- 28. Use CTE for hierarchical query of product categories and subcategories
WITH CategoryHierarchy AS (
    SELECT 
        pc.ProductCategoryID,
        pc.Name AS CategoryName,
        CAST(pc.Name AS VARCHAR(500)) AS Hierarchy,
        0 AS Level
    FROM Production.ProductCategory pc
    UNION ALL
    SELECT 
        ps.ProductSubcategoryID,
        ps.Name AS SubcategoryName,
        CAST(ch.Hierarchy + ' > ' + ps.Name AS VARCHAR(500)),
        ch.Level + 1
    FROM Production.ProductSubcategory ps
    JOIN CategoryHierarchy ch ON ps.ProductCategoryID = ch.ProductCategoryID
    WHERE ch.Level = 0
)
SELECT * FROM CategoryHierarchy
ORDER BY Hierarchy;

-- 29. Find products that have had price changes using CTE
WITH PriceChanges AS (
    SELECT 
        ProductID,
        StartDate,
        EndDate,
        ListPrice,
        LAG(ListPrice) OVER (PARTITION BY ProductID ORDER BY StartDate) AS PreviousPrice
    FROM Production.ProductListPriceHistory
)
SELECT 
    pc.ProductID,
    p.Name,
    pc.StartDate,
    pc.EndDate,
    pc.PreviousPrice,
    pc.ListPrice,
    (pc.ListPrice - pc.PreviousPrice) AS PriceChange,
    (pc.ListPrice - pc.PreviousPrice) / pc.PreviousPrice * 100 AS PercentageChange
FROM PriceChanges pc
JOIN Production.Product p ON pc.ProductID = p.ProductID
WHERE pc.PreviousPrice IS NOT NULL;

-- 30. Find the top 3 products in each subcategory by sales amount
WITH RankedProducts AS (
    SELECT 
        p.ProductID,
        p.Name,
        ps.ProductSubcategoryID,
        ps.Name AS SubcategoryName,
        SUM(sod.LineTotal) AS TotalSales,
        RANK() OVER (PARTITION BY ps.ProductSubcategoryID ORDER BY SUM(sod.LineTotal) DESC) AS SalesRank
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    GROUP BY p.ProductID, p.Name, ps.ProductSubcategoryID, ps.Name
)
SELECT * FROM RankedProducts
WHERE SalesRank <= 3
ORDER BY ProductSubcategoryID, SalesRank;
```

## Date Functions and Time Analysis

```sql
-- 31. Analyze sales by day of week
SELECT 
    DATENAME(WEEKDAY, OrderDate) AS DayOfWeek,
    COUNT(SalesOrderID) AS NumberOfOrders,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);

-- 32. Find seasonality in sales (by quarter and month)
SELECT 
    YEAR(OrderDate) AS Year,
    DATEPART(QUARTER, OrderDate) AS Quarter,
    MONTH(OrderDate) AS Month,
    COUNT(SalesOrderID) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate), MONTH(OrderDate)
ORDER BY Year, Quarter, Month;

-- 33. Calculate the number of days between order date and ship date
SELECT 
    SalesOrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM Sales.SalesOrderHeader
ORDER BY DaysToShip DESC;

-- 34. Identify orders that were shipped late (after the promised due date)
SELECT 
    SalesOrderID,
    OrderDate,
    DueDate,
    ShipDate,
    DATEDIFF(DAY, DueDate, ShipDate) AS DaysLate
FROM Sales.SalesOrderHeader
WHERE ShipDate > DueDate
ORDER BY DaysLate DESC;

-- 35. Analyze sales trends by year and quarter with growth rate
WITH QuarterlySales AS (
    SELECT 
        YEAR(OrderDate) AS Year,
        DATEPART(QUARTER, OrderDate) AS Quarter,
        SUM(TotalDue) AS QuarterSales
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
)
SELECT 
    Year,
    Quarter,
    QuarterSales,
    LAG(QuarterSales) OVER (ORDER BY Year, Quarter) AS PreviousQuarterSales,
    (QuarterSales - LAG(QuarterSales) OVER (ORDER BY Year, Quarter)) / LAG(QuarterSales) OVER (ORDER BY Year, Quarter) * 100 AS GrowthRate
FROM QuarterlySales
ORDER BY Year, Quarter;
```

## Complex Analytical Queries

```sql
-- 36. Analyze the sales performance of products by territory
SELECT 
    st.Name AS Territory,
    p.ProductID,
    p.Name AS ProductName,
    SUM(sod.OrderQty) AS QuantitySold,
    SUM(sod.LineTotal) AS TotalSales,
    AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY st.Name, p.ProductID, p.Name
ORDER BY Territory, TotalSales DESC;

-- 37. Find customer lifetime value (CLV)
SELECT 
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName) AS CustomerName,
    COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
    SUM(soh.TotalDue) AS LifetimeValue,
    AVG(soh.TotalDue) AS AverageOrderValue,
    MIN(soh.OrderDate) AS FirstPurchaseDate,
    MAX(soh.OrderDate) AS MostRecentPurchaseDate,
    DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerTenureDays
FROM Sales.Customer c
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName)
ORDER BY LifetimeValue DESC;

-- 38. Calculate product profit margins
SELECT 
    p.ProductID,
    p.Name,
    AVG(sod.UnitPrice) AS AvgSellingPrice,
    AVG(p.StandardCost) AS AvgCost,
    AVG(sod.UnitPrice - p.StandardCost) AS AvgProfit,
    AVG((sod.UnitPrice - p.StandardCost) / sod.UnitPrice) * 100 AS ProfitMarginPercentage
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY ProfitMarginPercentage DESC;

-- 39. Segment customers based on recency, frequency, and monetary value (RFM analysis)
WITH CustomerRFM AS (
    SELECT 
        c.CustomerID,
        ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName) AS CustomerName,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS Recency,
        COUNT(DISTINCT soh.SalesOrderID) AS Frequency,
        SUM(soh.TotalDue) AS MonetaryValue
    FROM Sales.Customer c
    LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName)
),
RFMScores AS (
    SELECT 
        CustomerID,
        CustomerName,
        Recency,
        Frequency,
        MonetaryValue,
        NTILE(5) OVER (ORDER BY Recency DESC) AS RecencyScore,
        NTILE(5) OVER (ORDER BY Frequency) AS FrequencyScore,
        NTILE(5) OVER (ORDER BY MonetaryValue) AS MonetaryScore
    FROM CustomerRFM
)
SELECT 
    CustomerID,
    CustomerName,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    CONCAT(RecencyScore, FrequencyScore, MonetaryScore) AS RFMScore,
    CASE 
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 13 THEN 'Premium'
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 10 THEN 'High Value'
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 7 THEN 'Medium Value'
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 4 THEN 'Low Value'
        ELSE 'Lost Customer'
    END AS CustomerSegment
FROM RFMScores
ORDER BY (RecencyScore + FrequencyScore + MonetaryScore) DESC;

-- 40. Analyze sales trends by demographic factors
SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 51 AND 60 THEN '51-60'
        ELSE 'Over 60'
    END AS AgeGroup,
    pp.Gender,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSales,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.PersonInformation pp ON p.BusinessEntityID = pp.BusinessEntityID
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 51 AND 60 THEN '51-60'
        ELSE 'Over 60'
    END,
    pp.Gender
ORDER BY AgeGroup, Gender;
```

## Performance Tuning and Optimization

```sql
-- 41. Find the most expensive queries using execution statistics
SELECT TOP 10 
    qs.execution_count,
    qs.total_worker_time / qs.execution_count AS avg_worker_time,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY avg_worker_time DESC;

-- 42. Analyze index usage statistics
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates,
    ius.last_user_seek,
    ius.last_user_scan
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE OBJECT_NAME(i.object_id) LIKE 'Sales%' OR OBJECT_NAME(i.object_id) LIKE 'Production%'
ORDER BY ius.user_seeks + ius.user_scans + ius.user_lookups DESC;

-- 43. Identify tables without indexes
SELECT 
    OBJECT_NAME(t.object_id) AS TableName,
    t.create_date AS CreatedDate,
    t.modify_date AS LastModified
FROM sys.tables t
LEFT JOIN sys.indexes i ON t.object_id = i.object_id
WHERE i.object_id IS NULL OR (i.type = 0 AND i.is_primary_key = 0)
ORDER BY t.create_date;

-- 44. Find unused indexes
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ISNULL(ius.user_seeks, 0) AS UserSeeks,
    ISNULL(ius.user_scans, 0) AS UserScans,
    ISNULL(ius.user_lookups, 0) AS UserLookups,
    ISNULL(ius.user_updates, 0) AS UserUpdates
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE i.type_desc <> 'HEAP'
AND (ius.user_seeks + ius.user_scans + ius.user_lookups) = 0
AND ius.user_updates > 0
ORDER BY ius.user_updates DESC;

-- 45. Create indexed view for frequently accessed data
CREATE VIEW vw_ProductSalesDetail WITH SCHEMABINDING AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.ListPrice,
    SUM(sod.OrderQty) AS TotalQuantity,
    SUM(sod.LineTotal) AS TotalSales,
    COUNT_BIG(*) AS OrderCount
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name, p.ProductNumber, p.ListPrice;

CREATE UNIQUE CLUSTERED INDEX IDX_vw_ProductSalesDetail ON vw_ProductSalesDetail (ProductID);
```

## Stored Procedures and Functions

```sql
-- 46. Create a stored procedure to get customer orders
CREATE PROCEDURE GetCustomerOrders
    @CustomerID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        soh.SalesOrderID,
        soh.OrderDate,
        soh.TotalDue,
        soh.Status,
        p.FirstName + ' ' + p.LastName AS CustomerName
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
    LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    WHERE soh.CustomerID = @CustomerID
    AND (@StartDate IS NULL OR soh.OrderDate >= @StartDate)
    AND (@EndDate IS NULL OR soh.OrderDate <= @EndDate)
    ORDER BY soh.OrderDate DESC;
END;

-- 47. Create a function to calculate total inventory value
CREATE FUNCTION GetInventoryValue()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductID,
        p.Name,
        p.ProductNumber,
        SUM(i.Quantity) AS TotalQuantity,
        p.StandardCost,
        SUM(i.Quantity * p.StandardCost) AS InventoryValue
    FROM Production.Product p
    JOIN Production.ProductInventory i ON p.ProductID = i.ProductID
    GROUP BY p.ProductID, p.Name, p.ProductNumber, p.StandardCost
);

-- 48. Create a stored procedure for product reordering analysis
CREATE PROCEDURE GetProductReorderingAnalysis
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductID,
        p.Name,
        p.ReorderPoint,
        SUM(i.Quantity) AS CurrentStock,
        (p.ReorderPoint - SUM(i.Quantity)) AS QuantityToReorder,
        p.StandardCost,
        (p.ReorderPoint - SUM(i.Quantity)) * p.StandardCost AS ReorderCost
    FROM Production.Product p
    JOIN Production.ProductInventory i ON p.ProductID = i.ProductID
    GROUP BY p.ProductID, p.Name, p.ReorderPoint, p.StandardCost
    HAVING SUM(i.Quantity) < p.ReorderPoint
    ORDER BY (p.ReorderPoint - SUM(i.Quantity)) DESC;
END;

-- 49. Create a function for calculating employee tenure
CREATE FUNCTION CalculateEmployeeTenure()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        e.BusinessEntityID,
        p.FirstName + ' ' + p.LastName AS EmployeeName,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsWithCompany,
        DATEDIFF(MONTH, e.HireDate, GETDATE()) AS MonthsWithCompany,
        e.JobTitle,
        CASE
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 THEN 'Junior'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 2 AND 5 THEN 'Mid-level'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 6 AND 10 THEN 'Senior'
            ELSE 'Executive'
        END AS TenureCategory
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
);

-- 50. Create a stored procedure for sales forecasting
CREATE PROCEDURE ForecastSales
    @MonthsToForecast INT = 6
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @EndDate DATE = GETDATE();
    DECLARE @StartDate DATE = DATEADD(YEAR, -3, @EndDate);
    
    WITH MonthlySales AS (
        SELECT 
            YEAR(OrderDate) AS SalesYear,
            MONTH(OrderDate) AS SalesMonth,
            SUM(TotalDue) AS TotalSales
        FROM Sales.SalesOrderHeader
        WHERE OrderDate BETWEEN @StartDate AND @EndDate
        GROUP BY YEAR(OrderDate), MONTH(OrderDate)
    ),
    SalesGrowth AS (
        SELECT 
            SalesYear,
            SalesMonth,
            TotalSales,
            LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth) AS SalesYearAgo,
            CASE 
                WHEN LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth) > 0 
                THEN (TotalSales - LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)) / LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)
                ELSE 0
            END AS YearOverYearGrowth
        FROM MonthlySales
    )
    SELECT 
        SalesYear,
        SalesMonth,
        TotalSales,
        SalesYearAgo,
        YearOverYearGrowth,
        AVG(YearOverYearGrowth) OVER (ORDER BY SalesYear, SalesMonth ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS AverageGrowthRate
    FROM SalesGrowth
    WHERE SalesYearAgo IS NOT NULL
    ORDER BY SalesYear, SalesMonth;
    
    -- Now generate the forecast
    WITH LatestSales AS (
        SELECT TOP 12
            YEAR(OrderDate) AS SalesYear,
            MONTH(OrderDate) AS SalesMonth,
            SUM(TotalDue) AS TotalSales
        FROM Sales.SalesOrderHeader
        GROUP BY YEAR(OrderDate), MONTH(OrderDate)
        ORDER BY SalesYear DESC, SalesMonth DESC
    ),
    AverageGrowth AS (
        SELECT AVG((TotalSales - LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)) / LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)) AS AvgGrowthRate
        FROM (
            SELECT 
                YEAR(OrderDate) AS SalesYear,
                MONTH(OrderDate) AS SalesMonth,
                SUM(TotalDue) AS TotalSales
            FROM Sales.SalesOrderHeader
            WHERE OrderDate >= DATEADD(YEAR, -2, GETDATE())
            GROUP BY YEAR(OrderDate), MONTH(OrderDate)
        ) AS RecentSales
        WHERE LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth) IS NOT NULL
    )
    SELECT 
        YEAR(DATEADD(MONTH, Number, @EndDate)) AS ForecastYear,
        MONTH(DATEADD(MONTH, Number, @EndDate)) AS ForecastMonth,
        (SELECT TOP 1 TotalSales FROM LatestSales ORDER BY SalesYear DESC, SalesMonth DESC) * 
        POWER(1 + (SELECT AvgGrowthRate FROM AverageGrowth), Number/12.0) AS ForecastedSales
    FROM (
        SELECT TOP (@MonthsToForecast) ROW_NUMBER() OVER (ORDER BY object_id) AS Number
        FROM sys.objects
    ) AS Numbers
    ORDER BY ForecastYear, ForecastMonth;
END;
```

## Data Quality and Validation

```sql
-- 51. Check for duplicate customer records
SELECT 
    p.FirstName,
    p.LastName,
    p.EmailAddress,
    COUNT(*) AS DuplicateCount
FROM Person.Person p
JOIN Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID
GROUP BY p.FirstName, p.LastName, p.EmailAddress
HAVING COUNT(*) > 1;



-- 52. Validate product data integrity (continued)
SELECT 
    p.ProductID,
    p.Name,
    p.StandardCost,
    p.ListPrice,
    CASE
        WHEN p.StandardCost > p.ListPrice THEN 'Error: Cost higher than price'
        WHEN p.StandardCost = 0 AND p.ListPrice > 0 THEN 'Warning: Zero cost'
        WHEN p.ListPrice = 0 AND p.FinishedGoodsFlag = 1 THEN 'Warning: Zero price for finished goods'
        ELSE 'OK'
    END AS DataQualityStatus
FROM Production.Product p
WHERE p.StandardCost > p.ListPrice
   OR (p.StandardCost = 0 AND p.ListPrice > 0)
   OR (p.ListPrice = 0 AND p.FinishedGoodsFlag = 1);

-- 53. Identify orders with inconsistent shipping information
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.ShipDate,
    soh.DueDate,
    CASE
        WHEN soh.ShipDate < soh.OrderDate THEN 'Error: Shipped before ordered'
        WHEN soh.DueDate < soh.OrderDate THEN 'Error: Due date before order date'
        WHEN DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) > 30 THEN 'Warning: Long shipping time'
        ELSE 'OK'
    END AS ShippingStatus
FROM Sales.SalesOrderHeader soh
WHERE soh.ShipDate < soh.OrderDate
   OR soh.DueDate < soh.OrderDate
   OR DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) > 30;

-- 54. Check for missing email addresses for customers
SELECT 
    c.CustomerID,
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    'Missing Email' AS Issue
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID
WHERE e.EmailAddress IS NULL
ORDER BY c.CustomerID;

-- 55. Identify products with inconsistent pricing history
SELECT 
    p.ProductID,
    p.Name,
    plph1.StartDate,
    plph1.EndDate,
    plph1.ListPrice AS OldPrice,
    plph2.ListPrice AS NewPrice,
    (plph2.ListPrice - plph1.ListPrice) / plph1.ListPrice * 100 AS PriceChangePercent
FROM Production.Product p
JOIN Production.ProductListPriceHistory plph1 ON p.ProductID = plph1.ProductID
JOIN Production.ProductListPriceHistory plph2 ON p.ProductID = plph2.ProductID
WHERE plph1.EndDate = plph2.StartDate
AND ABS((plph2.ListPrice - plph1.ListPrice) / plph1.ListPrice * 100) > 50
ORDER BY ABS((plph2.ListPrice - plph1.ListPrice) / plph1.ListPrice * 100) DESC;




-- 56. Customer segmentation by purchase behavior
WITH CustomerPurchases AS (
    SELECT 
        c.CustomerID,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespan
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
)
SELECT 
    CustomerID,
    OrderCount,
    TotalSpend,
    AvgOrderValue,
    DaysSinceLastOrder,
    CustomerLifespan,
    CASE
        WHEN OrderCount >= 10 AND DaysSinceLastOrder <= 90 THEN 'Loyal'
        WHEN OrderCount >= 5 AND DaysSinceLastOrder <= 180 THEN 'Regular'
        WHEN DaysSinceLastOrder <= 90 THEN 'Active'
        WHEN DaysSinceLastOrder BETWEEN 91 AND 365 THEN 'At Risk'
        ELSE 'Churned'
    END AS CustomerSegment
FROM CustomerPurchases
ORDER BY TotalSpend DESC;



-- Completing Query 57 (Product affinity analysis)
    GROUP BY sod1.ProductID, p1.Name, sod2.ProductID, p2.Name
    HAVING COUNT(DISTINCT sod1.SalesOrderID) >= 5
)
SELECT
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    OrdersTogether,
    OrdersTogether / (SELECT COUNT(DISTINCT SalesOrderID) FROM Sales.SalesOrderDetail WHERE ProductID = Product1ID) * 100 AS AffinityPercentage
FROM ProductPairs
ORDER BY OrdersTogether DESC;

-- 58. Customer lifetime value (CLV) calculation
WITH CustomerRevenue AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        SUM(soh.TotalDue) AS MonthlyRevenue
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    CustomerID,
    CustomerName,
    SUM(MonthlyRevenue) AS TotalRevenue,
    COUNT(DISTINCT (OrderYear * 100 + OrderMonth)) AS ActiveMonths,
    SUM(MonthlyRevenue) / COUNT(DISTINCT (OrderYear * 100 + OrderMonth)) AS AvgMonthlyRevenue,
    (SUM(MonthlyRevenue) / COUNT(DISTINCT (OrderYear * 100 + OrderMonth))) * 36 AS ProjectedThreeYearValue
FROM CustomerRevenue
GROUP BY CustomerID, CustomerName
ORDER BY ProjectedThreeYearValue DESC;

-- 59. Product performance analysis with seasonality
SELECT
    p.ProductID,
    p.Name AS ProductName,
    YEAR(soh.OrderDate) AS OrderYear,
    DATEPART(QUARTER, soh.OrderDate) AS OrderQuarter,
    SUM(sod.OrderQty) AS TotalQuantity,
    SUM(sod.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.ProductID, p.Name, YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)
ORDER BY p.ProductID, OrderYear, OrderQuarter;

-- 60. Territory-based sales trend analysis
WITH TerritorySales AS (
    SELECT
        st.TerritoryID,
        st.Name AS TerritoryName,
        st.CountryRegionCode,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        SUM(soh.TotalDue) AS MonthlySales
    FROM Sales.SalesTerritory st
    JOIN Sales.SalesOrderHeader soh ON st.TerritoryID = soh.TerritoryID
    GROUP BY st.TerritoryID, st.Name, st.CountryRegionCode, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    TerritoryID,
    TerritoryName,
    CountryRegionCode,
    OrderYear,
    OrderMonth,
    MonthlySales,
    LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) AS PreviousMonthSales,
    (MonthlySales - LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth)) / 
        NULLIF(LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth), 0) * 100 AS MoMGrowthPercent,
    MonthlySales - LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) AS YoYDifference,
    CASE WHEN LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) IS NOT NULL
         THEN (MonthlySales - LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth)) / 
              LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) * 100
         ELSE NULL
    END AS YoYGrowthPercent
FROM TerritorySales
ORDER BY TerritoryID, OrderYear, OrderMonth;

-- 61. Customer acquisition and retention analysis
WITH CustomerFirstPurchase AS (
    SELECT
        c.CustomerID,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        YEAR(MIN(soh.OrderDate)) AS AcquisitionYear,
        MONTH(MIN(soh.OrderDate)) AS AcquisitionMonth
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
),
CustomerActivity AS (
    SELECT
        c.CustomerID,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS Revenue
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    cfp.AcquisitionYear,
    cfp.AcquisitionMonth,
    COUNT(DISTINCT cfp.CustomerID) AS NewCustomers,
    SUM(CASE WHEN ca.OrderYear = cfp.AcquisitionYear AND ca.OrderMonth = cfp.AcquisitionMonth THEN ca.Revenue ELSE 0 END) AS InitialRevenue,
    COUNT(DISTINCT CASE WHEN ca.OrderYear * 100 + ca.OrderMonth > cfp.AcquisitionYear * 100 + cfp.AcquisitionMonth THEN ca.CustomerID ELSE NULL END) AS RetainedCustomers,
    SUM(CASE WHEN ca.OrderYear * 100 + ca.OrderMonth > cfp.AcquisitionYear * 100 + cfp.AcquisitionMonth THEN ca.Revenue ELSE 0 END) AS RetentionRevenue
FROM CustomerFirstPurchase cfp
LEFT JOIN CustomerActivity ca ON cfp.CustomerID = ca.CustomerID
GROUP BY cfp.AcquisitionYear, cfp.AcquisitionMonth
ORDER BY cfp.AcquisitionYear, cfp.AcquisitionMonth;

-- 62. Sales performance by employee with targets
WITH EmployeeSales AS (
    SELECT
        e.BusinessEntityID AS EmployeeID,
        p.FirstName + ' ' + p.LastName AS EmployeeName,
        e.JobTitle,
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSales
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    JOIN Sales.SalesPerson sp ON e.BusinessEntityID = sp.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
    GROUP BY e.BusinessEntityID, p.FirstName, p.LastName, e.JobTitle, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    EmployeeID,
    EmployeeName,
    JobTitle,
    SalesYear,
    SalesMonth,
    OrderCount,
    TotalSales,
    sp.SalesQuota AS MonthlySalesTarget,
    CASE
        WHEN sp.SalesQuota IS NULL THEN NULL
        ELSE (TotalSales - sp.SalesQuota) / sp.SalesQuota * 100
    END AS TargetAchievementPercent,
    DENSE_RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY TotalSales DESC) AS MonthlyRank
FROM EmployeeSales es
LEFT JOIN Sales.SalesPerson sp ON es.EmployeeID = sp.BusinessEntityID
ORDER BY SalesYear DESC, SalesMonth DESC, TotalSales DESC;

-- 63. Inventory turnover analysis
WITH ProductInventoryMovement AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        p.ListPrice,
        p.StandardCost,
        SUM(sod.OrderQty) AS TotalSold,
        AVG(ph.Quantity) AS AvgInventoryLevel
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
    JOIN Production.ProductInventoryHistory ph ON p.ProductID = ph.ProductID
    WHERE p.FinishedGoodsFlag = 1
    GROUP BY p.ProductID, p.Name, p.ProductNumber, p.ListPrice, p.StandardCost
)
SELECT
    ProductID,
    ProductName,
    ProductNumber,
    ListPrice,
    StandardCost,
    TotalSold,
    AvgInventoryLevel,
    CASE 
        WHEN AvgInventoryLevel = 0 THEN NULL
        ELSE TotalSold / AvgInventoryLevel
    END AS InventoryTurnoverRatio,
    CASE 
        WHEN TotalSold = 0 THEN NULL
        ELSE 365 / (TotalSold / NULLIF(AvgInventoryLevel, 0))
    END AS DaysInInventory,
    (ListPrice - StandardCost) * TotalSold AS GrossProfit
FROM ProductInventoryMovement
ORDER BY InventoryTurnoverRatio DESC;

-- 64. Customer demographic analysis 
SELECT
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    DATEDIFF(YEAR, CASE 
        WHEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date') > '1900-01-01' 
        THEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date')
        ELSE NULL
    END, GETDATE()) AS Age,
    pp.Demographics.value('(/IndividualSurvey/Gender)[1]', 'nvarchar(1)') AS Gender,
    pp.Demographics.value('(/IndividualSurvey/TotalChildren)[1]', 'int') AS TotalChildren,
    pp.Demographics.value('(/IndividualSurvey/NumberChildrenAtHome)[1]', 'int') AS ChildrenAtHome,
    pp.Demographics.value('(/IndividualSurvey/Education)[1]', 'nvarchar(100)') AS Education,
    pp.Demographics.value('(/IndividualSurvey/Occupation)[1]', 'nvarchar(100)') AS Occupation,
    pp.Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]', 'bit') AS HomeOwner,
    pp.Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]', 'int') AS CarsOwned,
    pp.Demographics.value('(/IndividualSurvey/YearlyIncome)[1]', 'nvarchar(100)') AS YearlyIncome,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSpend,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityContact bec ON p.BusinessEntityID = bec.PersonID
JOIN Person.ContactType ct ON bec.ContactTypeID = ct.ContactTypeID
JOIN Person.Person pp ON c.PersonID = pp.BusinessEntityID AND pp.Demographics IS NOT NULL
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY 
    c.CustomerID,
    p.FirstName,
    p.LastName,
    pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date'),
    pp.Demographics.value('(/IndividualSurvey/Gender)[1]', 'nvarchar(1)'),
    pp.Demographics.value('(/IndividualSurvey/TotalChildren)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/NumberChildrenAtHome)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/Education)[1]', 'nvarchar(100)'),
    pp.Demographics.value('(/IndividualSurvey/Occupation)[1]', 'nvarchar(100)'),
    pp.Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]', 'bit'),
    pp.Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/YearlyIncome)[1]', 'nvarchar(100)');

-- 65. Product category performance analysis
SELECT
    pc.ProductCategoryID,
    pc.Name AS CategoryName,
    psc.ProductSubcategoryID,
    psc.Name AS SubcategoryName,
    COUNT(DISTINCT p.ProductID) AS ProductCount,
    SUM(sod.OrderQty) AS TotalQuantitySold,
    SUM(sod.LineTotal) AS TotalRevenue,
    AVG(sod.UnitPrice) AS AvgUnitPrice,
    MIN(sod.UnitPrice) AS MinUnitPrice,
    MAX(sod.UnitPrice) AS MaxUnitPrice,
    SUM(sod.LineTotal) / SUM(sod.OrderQty) AS AvgRevPerUnit,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * p.StandardCost)) AS GrossProfit,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * p.StandardCost)) / SUM(sod.LineTotal) * 100 AS GrossMarginPercent
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory psc ON pc.ProductCategoryID = psc.ProductCategoryID
JOIN Production.Product p ON psc.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY pc.ProductCategoryID, pc.Name, psc.ProductSubcategoryID, psc.Name
ORDER BY TotalRevenue DESC;

-- 66. Sales discounting effect analysis
WITH OrderDiscounts AS (
    SELECT
        soh.SalesOrderID,
        soh.OrderDate,
        soh.CustomerID,
        soh.TerritoryID,
        st.Name AS TerritoryName,
        sod.ProductID,
        p.Name AS ProductName,
        psc.Name AS SubcategoryName,
        pc.Name AS CategoryName,
        sod.UnitPrice,
        sod.UnitPriceDiscount,
        sod.OrderQty,
        sod.UnitPrice * sod.OrderQty AS GrossRevenue,
        sod.UnitPrice * sod.UnitPriceDiscount * sod.OrderQty AS DiscountAmount,
        sod.LineTotal AS NetRevenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    WHERE sod.UnitPriceDiscount > 0
)
SELECT
    ProductID,
    ProductName,
    SubcategoryName,
    CategoryName,
    COUNT(DISTINCT SalesOrderID) AS DiscountedOrderCount,
    SUM(OrderQty) AS TotalQuantity,
    SUM(GrossRevenue) AS GrossRevenue,
    SUM(DiscountAmount) AS TotalDiscountAmount,
    SUM(NetRevenue) AS NetRevenue,
    AVG(UnitPriceDiscount) * 100 AS AvgDiscountPercent,
    SUM(DiscountAmount) / SUM(GrossRevenue) * 100 AS OverallDiscountPercent,
    -- Calculate effect on volume
    (SELECT COUNT(sod2.SalesOrderDetailID) 
     FROM Sales.SalesOrderDetail sod2
     WHERE sod2.ProductID = od.ProductID AND sod2.UnitPriceDiscount > 0) /
    NULLIF((SELECT COUNT(sod3.SalesOrderDetailID)
     FROM Sales.SalesOrderDetail sod3
     WHERE sod3.ProductID = od.ProductID), 0) * 100 AS PercentOrdersDiscounted
FROM OrderDiscounts od
GROUP BY ProductID, ProductName, SubcategoryName, CategoryName
ORDER BY TotalDiscountAmount DESC;

-- 67. Customer RFM (Recency, Frequency, Monetary) analysis
WITH CustomerPurchases AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS Recency,
        COUNT(DISTINCT soh.SalesOrderID) AS Frequency,
        SUM(soh.TotalDue) AS MonetaryValue
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
RFM_Scores AS (
    SELECT
        CustomerID,
        CustomerName,
        Recency,
        Frequency,
        MonetaryValue,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency) AS F_Score,
        NTILE(5) OVER (ORDER BY MonetaryValue) AS M_Score
    FROM CustomerPurchases
)
SELECT
    CustomerID,
    CustomerName,
    Recency,
    Frequency,
    MonetaryValue,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(R_Score, F_Score, M_Score) AS RFM_Score,
    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score >= 3 THEN 'Recent Loyalists'
        WHEN R_Score >= 4 AND M_Score >= 3 THEN 'Promising'
        WHEN F_Score >= 4 AND M_Score >= 4 THEN 'Needs Attention'
        WHEN R_Score >= 3 THEN 'Potential Loyalists'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'At Risk'
        WHEN R_Score = 1 AND F_Score = 1 THEN 'Lost'
        ELSE 'Others'
    END AS Customer_Segment
FROM RFM_Scores
ORDER BY RFM_Score DESC;

-- 68. Sales return analysis
SELECT
    sr.SalesOrderID,
    sr.ReturnDate,
    soh.OrderDate,
    DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) AS DaysUntilReturn,
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    srd.ProductID,
    pr.Name AS ProductName,
    psc.Name AS SubcategoryName,
    pc.Name AS CategoryName,
    srd.ReturnQuantity,
    srd.ReturnReason,
    sr.ReturnTotal,
    CASE
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 30 THEN '0-30 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 60 THEN '31-60 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 90 THEN '61-90 Days'
        ELSE 'Over 90 Days'
    END AS ReturnTimeBucket
FROM Sales.SalesReturn sr
JOIN Sales.SalesReturnDetail srd ON sr.SalesReturnID = srd.SalesReturnID
JOIN Sales.SalesOrderHeader soh ON sr.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Production.Product pr ON srd.ProductID = pr.ProductID
JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
ORDER BY sr.ReturnDate DESC;

-- 69. Customer lifetime value prediction model
WITH CustomerPurchaseHistory AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        MAX(soh.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
        SUM(soh.TotalDue) AS TotalSpend,
        SUM(soh.TotalDue) / COUNT(DISTINCT soh.SalesOrderID) AS AOV,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespan
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
)
SELECT
    CustomerID,
    CustomerName,
    FirstPurchaseDate,
    LastPurchaseDate,
    DATEDIFF(DAY, LastPurchaseDate, GETDATE()) AS DaysSinceLastPurchase,
    TotalOrders,
    TotalSpend,
    AOV,
    CustomerLifespan,
    CASE WHEN CustomerLifespan = 0 THEN 0 ELSE TotalOrders / (CustomerLifespan / 30.0) END AS MonthlyPurchaseRate,
    CASE WHEN CustomerLifespan = 0 THEN 0 ELSE TotalSpend / (CustomerLifespan / 30.0) END AS MonthlySpendRate,
    -- Calculate predicted CLV (36-month prediction)
    CASE 
        WHEN CustomerLifespan = 0 THEN AOV
        ELSE (TotalSpend / (CustomerLifespan / 30.0)) * 36 * 
             EXP(-0.05 * DATEDIFF(DAY, LastPurchaseDate, GETDATE()) / 30.0) -- Apply churn probability
    END AS PredictedCLV_36Month
FROM CustomerPurchaseHistory
ORDER BY PredictedCLV_36Month DESC;

-- 70. Price elasticity analysis
WITH ProductSalesByPrice AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        CAST(sod.UnitPrice AS DECIMAL(10,2)) AS SalePrice,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.OrderQty) AS TotalQuantity,
        SUM(sod.LineTotal) AS TotalRevenue,
        MONTH(soh.OrderDate) AS SalesMonth,
        YEAR(soh.OrderDate) AS SalesYear
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY p.ProductID, p.Name, CAST(sod.UnitPrice AS DECIMAL(10,2)), MONTH(soh.OrderDate), YEAR(soh.OrderDate)
),
PriceTrends AS (
    SELECT
        ProductID,
        ProductName,
        SalesYear,
        SalesMonth,
        SalePrice,
        TotalQuantity,
        LAG(SalePrice) OVER (PARTITION BY ProductID ORDER BY SalesYear, SalesMonth) AS PrevPrice,
        LAG(TotalQuantity) OVER (PARTITION BY ProductID ORDER BY SalesYear, SalesMonth) AS PrevQuantity
    FROM ProductSalesByPrice
)
SELECT
    ProductID,
    ProductName,
    SalesYear,
    SalesMonth,
    SalePrice,
    TotalQuantity,
    PrevPrice,
    PrevQuantity,
    (SalePrice - PrevPrice) / NULLIF(PrevPrice, 0) * 100 AS PriceChangePercent,
    (TotalQuantity - PrevQuantity) / NULLIF(PrevQuantity, 0) * 100 AS QuantityChangePercent,
    -- Calculate price elasticity: % change in quantity / % change in price
    CASE 
        WHEN PrevPrice = 0 OR PrevQuantity = 0 OR SalePrice = PrevPrice THEN NULL
        ELSE ((TotalQuantity - PrevQuantity) / NULLIF(PrevQuantity, 0)) / 
             ((SalePrice - PrevPrice) / NULLIF(PrevPrice, 0))
    END AS PriceElasticity
FROM PriceTrends
WHERE PrevPrice IS NOT NULL AND PrevQuantity IS NOT NULL
  AND PrevPrice <> 0 AND PrevQuantity <> 0
  AND SalePrice <> PrevPrice
ORDER BY ABS(CASE 
        WHEN PrevPrice = 0 OR PrevQuantity = 0 OR SalePrice = PrevPrice THEN NULL
        ELSE ((TotalQuantity - PrevQuantity) / NULLIF(PrevQuantity, 0)) / 
             ((SalePrice - PrevPrice) / NULLIF(PrevPrice, 0))
    END) DESC;

-- 71. Employee performance reporting and benchmarking
WITH SalesByEmployee AS (
    SELECT
        sp.BusinessEntityID AS EmployeeID,
        p.FirstName + ' ' + p.LastName AS EmployeeName,
        e.JobTitle,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        st.TerritoryID,
        st.Name AS Territory,
        st.CountryRegionCode,
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSales,
        sp.SalesQuota,
        SUM(soh.TotalDue) - sp.SalesQuota AS QuotaDifference,
        CASE 
            WHEN sp.SalesQuota > 0 THEN (SUM(soh.TotalDue) / sp.SalesQuota) * 100 
            ELSE NULL 
        END AS QuotaAttainmentPercent
    FROM Sales.SalesPerson sp
    JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
    JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
    GROUP BY 
        sp.BusinessEntityID,
        p.FirstName,
        p.LastName,
        e.JobTitle,
        e.HireDate,
        st.TerritoryID,
        st.Name,
        st.CountryRegionCode,
        YEAR(soh.OrderDate),
        MONTH(soh.OrderDate),
        sp.SalesQuota
)
SELECT
    EmployeeID,
    EmployeeName,
    JobTitle,
    YearsOfService,
    Territory,
    CountryRegionCode,
    SalesYear,
    SalesMonth,
    OrderCount,
    TotalSales,
    SalesQuota,
    QuotaDifference,
    QuotaAttainmentPercent,
    AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS AvgTeamSales,
    TotalSales - AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS DifferenceFromAvg,
    (TotalSales / AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth)) * 100 AS PercentOfAvg,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY TotalSales DESC) AS SalesRank,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY QuotaAttainmentPercent DESC) AS QuotaAttainmentRank
FROM SalesByEmployee
ORDER BY SalesYear DESC, SalesMonth DESC, TotalSales DESC;





-- 72. Forecasting sales using seasonal trends (continuing from your document)
WITH MonthlySales AS (
    SELECT
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        SUM(soh.TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader soh
    GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
),
YearlyTrends AS (
    SELECT
        SalesYear,
        AVG(TotalSales) AS AvgMonthlySales,
        SUM(TotalSales) AS AnnualSales
    FROM MonthlySales
    GROUP BY SalesYear
),
SeasonalFactors AS (
    SELECT
        SalesMonth,
        AVG(TotalSales) / (SELECT AVG(TotalSales) FROM MonthlySales) AS SeasonalIndex
    FROM MonthlySales
    GROUP BY SalesMonth
),
GrowthRate AS (
    SELECT
        (SELECT MAX(AnnualSales) FROM YearlyTrends) / 
        NULLIF((SELECT MIN(AnnualSales) FROM YearlyTrends), 0) AS TotalGrowth,
        POWER(
            (SELECT MAX(AnnualSales) FROM YearlyTrends) / 
            NULLIF((SELECT MIN(AnnualSales) FROM YearlyTrends), 0),
            1.0 / NULLIF((SELECT MAX(SalesYear) - MIN(SalesYear) FROM YearlyTrends), 0)
        ) - 1 AS AnnualGrowthRate
    FROM YearlyTrends
    WHERE SalesYear IN (SELECT MIN(SalesYear) FROM YearlyTrends UNION SELECT MAX(SalesYear) FROM YearlyTrends)
)
SELECT
    m.SalesYear,
    m.SalesMonth,
    m.TotalSales AS ActualSales,
    CASE
        WHEN LEAD(m.SalesYear) OVER (ORDER BY m.SalesYear, m.SalesMonth) IS NULL 
        THEN 
            (SELECT AvgMonthlySales FROM YearlyTrends WHERE SalesYear = MAX(m.SalesYear OVER())) *
            (1 + (SELECT AnnualGrowthRate FROM GrowthRate)) *
            (SELECT SeasonalIndex FROM SeasonalFactors WHERE SalesMonth = m.SalesMonth)
    END AS ForecastedNextPeriod
FROM MonthlySales m
ORDER BY m.SalesYear, m.SalesMonth;

-- 73. Customer segmentation by purchase behavior
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        MAX(soh.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) / 
            NULLIF(COUNT(DISTINCT soh.SalesOrderID) - 1, 0) AS AvgDaysBetweenOrders,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
)
SELECT
    CustomerID,
    CustomerName,
    FirstPurchaseDate,
    LastPurchaseDate,
    OrderCount,
    TotalSpend,
    AvgOrderValue,
    AvgDaysBetweenOrders,
    DaysSinceLastOrder,
    CASE
        WHEN OrderCount > 10 AND TotalSpend > 50000 THEN 'High-Value Regular'
        WHEN OrderCount > 10 AND TotalSpend <= 50000 THEN 'Regular Customer'
        WHEN OrderCount <= 10 AND TotalSpend > 50000 THEN 'High-Value Occasional'
        WHEN OrderCount <= 10 AND TotalSpend <= 50000 THEN 'Standard Customer'
        WHEN OrderCount = 1 THEN 'One-Time Customer'
        ELSE 'Unknown'
    END AS CustomerSegment,
    CASE
        WHEN DaysSinceLastOrder <= 90 THEN 'Active'
        WHEN DaysSinceLastOrder <= 365 THEN 'At Risk'
        ELSE 'Inactive'
    END AS ActivityStatus
FROM CustomerMetrics
ORDER BY TotalSpend DESC;

-- 74. Product bundle analysis
WITH ProductBundles AS (
    SELECT
        sod1.SalesOrderID,
        sod1.ProductID AS Product1ID,
        p1.Name AS Product1Name,
        sod2.ProductID AS Product2ID,
        p2.Name AS Product2Name,
        sod3.ProductID AS Product3ID,
        p3.Name AS Product3Name
    FROM Sales.SalesOrderDetail sod1
    JOIN Sales.SalesOrderDetail sod2 ON sod1.SalesOrderID = sod2.SalesOrderID AND sod1.ProductID < sod2.ProductID
    JOIN Sales.SalesOrderDetail sod3 ON sod2.SalesOrderID = sod3.SalesOrderID AND sod2.ProductID < sod3.ProductID
    JOIN Production.Product p1 ON sod1.ProductID = p1.ProductID
    JOIN Production.Product p2 ON sod2.ProductID = p2.ProductID
    JOIN Production.Product p3 ON sod3.ProductID = p3.ProductID
)
SELECT
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    Product3ID,
    Product3Name,
    COUNT(*) AS BundleFrequency,
    -- Calculate support (percentage of all orders that contain this bundle)
    COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT SalesOrderID) FROM Sales.SalesOrderDetail) AS SupportPercent,
    -- Calculate average order value when this bundle appears
    AVG((SELECT SUM(LineTotal) FROM Sales.SalesOrderDetail WHERE SalesOrderID = pb.SalesOrderID)) AS AvgOrderValue
FROM ProductBundles pb
GROUP BY
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    Product3ID,
    Product3Name
HAVING COUNT(*) >= 5
ORDER BY BundleFrequency DESC;

-- 75. Sales channel effectiveness analysis
WITH SalesChannels AS (
    SELECT
        soh.SalesOrderID,
        soh.OnlineOrderFlag,
        CASE
            WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
            ELSE 'In-Store'
        END AS SalesChannel,
        soh.OrderDate,
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        st.TerritoryID,
        st.Name AS TerritoryName,
        SUM(soh.TotalDue) AS OrderTotal,
        COUNT(DISTINCT sod.ProductID) AS UniqueProducts,
        SUM(sod.OrderQty) AS TotalQuantity
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    GROUP BY
        soh.SalesOrderID,
        soh.OnlineOrderFlag,
        soh.OrderDate,
        c.CustomerID,
        p.FirstName,
        p.LastName,
        st.TerritoryID,
        st.Name
)
SELECT
    SalesChannel,
    COUNT(DISTINCT SalesOrderID) AS OrderCount,
    COUNT(DISTINCT CustomerID) AS CustomerCount,
    SUM(OrderTotal) AS TotalRevenue,
    AVG(OrderTotal) AS AvgOrderValue,
    SUM(OrderTotal) / COUNT(DISTINCT CustomerID) AS AvgRevenuePerCustomer,
    AVG(UniqueProducts) AS AvgProductsPerOrder,
    AVG(TotalQuantity) AS AvgQuantityPerOrder,
    MIN(OrderTotal) AS MinOrderValue,
    MAX(OrderTotal) AS MaxOrderValue,
    (SELECT TOP 1 TerritoryName 
     FROM SalesChannels sc 
     WHERE sc.SalesChannel = sc2.SalesChannel 
     GROUP BY TerritoryName 
     ORDER BY COUNT(*) DESC) AS TopTerritory
FROM SalesChannels sc2
GROUP BY SalesChannel
UNION ALL
SELECT
    'Overall' AS SalesChannel,
    COUNT(DISTINCT SalesOrderID) AS OrderCount,
    COUNT(DISTINCT CustomerID) AS CustomerCount,
    SUM(OrderTotal) AS TotalRevenue,
    AVG(OrderTotal) AS AvgOrderValue,
    SUM(OrderTotal) / COUNT(DISTINCT CustomerID) AS AvgRevenuePerCustomer,
    AVG(UniqueProducts) AS AvgProductsPerOrder,
    AVG(TotalQuantity) AS AvgQuantityPerOrder,
    MIN(OrderTotal) AS MinOrderValue,
    MAX(OrderTotal) AS MaxOrderValue,
    (SELECT TOP 1 TerritoryName FROM SalesChannels GROUP BY TerritoryName ORDER BY COUNT(*) DESC) AS TopTerritory
FROM SalesChannels;

-- 76. Customer acquisition cost and lifetime value comparison
WITH CustomerRevenue AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        SUM(soh.TotalDue) AS TotalRevenue,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        1000 * RAND(CHECKSUM(NEWID())) AS EstimatedAcquisitionCost -- Simulated acquisition cost
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
CustomerSegments AS (
    SELECT
        cr.*,
        CASE
            WHEN DATEDIFF(MONTH, FirstPurchaseDate, GETDATE()) = 0 THEN 1
            ELSE DATEDIFF(MONTH, FirstPurchaseDate, GETDATE())
        END AS CustomerAgeMonths,
        CASE
            WHEN TotalRevenue > 50000 THEN 'High Value'
            WHEN TotalRevenue > 10000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS ValueSegment
    FROM CustomerRevenue cr
)
SELECT
    ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalRevenue) AS AvgLifetimeRevenue,
    AVG(TotalRevenue / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalRevenue) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalRevenue) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    -- Payback period in months (how long to recoup acquisition cost)
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalRevenue / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
GROUP BY ValueSegment
UNION ALL
SELECT
    'Overall' AS ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalRevenue) AS AvgLifetimeRevenue,
    AVG(TotalRevenue / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalRevenue) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalRevenue) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalRevenue / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
ORDER BY CASE WHEN ValueSegment = 'Overall' THEN 1 ELSE 0 END, AvgNetCustomerValue DESC;

-- 77. Customer purchase path analysis
WITH OrderSequence AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        soh.SalesOrderID,
        soh.OrderDate,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY soh.OrderDate) AS OrderSequence,
        soh.TotalDue AS OrderTotal,
        COUNT(DISTINCT sod.ProductID) AS UniqueProducts,
        STRING_AGG(pr.Name, ', ') WITHIN GROUP (ORDER BY pr.Name) AS Products,
        STRING_AGG(psc.Name, ', ') WITHIN GROUP (ORDER BY psc.Name) AS Categories
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product pr ON sod.ProductID = pr.ProductID
    LEFT JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
    GROUP BY c.CustomerID, p.FirstName, p.LastName, soh.SalesOrderID, soh.OrderDate, soh.TotalDue
),
PathAnalysis AS (
    SELECT
        o1.CustomerID,
        o1.CustomerName,
        o1.OrderSequence AS FirstOrderNum,
        o2.OrderSequence AS SecondOrderNum,
        o1.Categories AS FirstOrderCategories,
        o2.Categories AS SecondOrderCategories,
        DATEDIFF(DAY, o1.OrderDate, o2.OrderDate) AS DaysBetweenOrders,
        o1.OrderTotal AS FirstOrderTotal,
        o2.OrderTotal AS SecondOrderTotal
    FROM OrderSequence o1
    JOIN OrderSequence o2 ON o1.CustomerID = o2.CustomerID AND o1.OrderSequence + 1 = o2.OrderSequence
)
SELECT
    FirstOrderCategories,
    SecondOrderCategories,
    COUNT(*) AS PathFrequency,
    AVG(DaysBetweenOrders) AS AvgDaysBetweenOrders,
    AVG(SecondOrderTotal) AS AvgSecondOrderValue,
    AVG(SecondOrderTotal - FirstOrderTotal) AS AvgOrderValueChange,
    AVG(SecondOrderTotal) / NULLIF(AVG(FirstOrderTotal), 0) * 100 - 100 AS AvgOrderValueChangePercent
FROM PathAnalysis
GROUP BY FirstOrderCategories, SecondOrderCategories
HAVING COUNT(*) >= 5
ORDER BY PathFrequency DESC;

-- 78. Price optimization analysis
WITH ProductPricePoints AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0) AS PricePoint,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.OrderQty) AS TotalQuantity,
        SUM(sod.LineTotal) AS TotalRevenue,
        SUM(sod.LineTotal) - (SUM(sod.OrderQty) * p.StandardCost) AS TotalProfit
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY p.ProductID, p.Name, p.StandardCost, ROUND(sod.UnitPrice, 0)
)
SELECT
    ProductID,
    ProductName,
    StandardCost,
    PricePoint,
    (PricePoint - StandardCost) / NULLIF(StandardCost, 0) * 100 AS MarkupPercent,
    OrderCount,
    TotalQuantity,
    TotalRevenue,
    TotalProfit,
    TotalProfit / NULLIF(TotalRevenue, 0) * 100 AS ProfitMarginPercent,
    -- Rank each price point by profit for each product
    RANK() OVER(PARTITION BY ProductID ORDER BY TotalProfit DESC) AS ProfitRank,
    -- Rank each price point by revenue for each product
    RANK() OVER(PARTITION BY ProductID ORDER BY TotalRevenue DESC) AS RevenueRank,
    -- Rank each price point by quantity for each product
    RANK() OVER(PARTITION BY ProductID ORDER BY TotalQuantity DESC) AS VolumeRank
FROM ProductPricePoints
WHERE TotalQuantity > 10 -- Filter for significant sales volume
ORDER BY ProductID, TotalProfit DESC;

-- 79. Conversion funnel analysis
WITH SalesProcess AS (
    SELECT
        cp.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        qh.QuoteDate,
        qh.QuoteID,
        soh.SalesOrderID,
        soh.OrderDate,
        DATEDIFF(DAY, qh.QuoteDate, soh.OrderDate) AS DaysToConvert,
        qh.TotalAmount AS QuoteAmount,
        soh.TotalDue AS OrderAmount,
        CASE
            WHEN soh.SalesOrderID IS NOT NULL THEN 1
            ELSE 0
        END AS Converted,
        qh.QuoteStatus
    FROM Sales.Customer cp
    JOIN Person.Person p ON cp.PersonID = p.BusinessEntityID
    JOIN Sales.QuoteHeader qh ON cp.CustomerID = qh.CustomerID
    LEFT JOIN Sales.SalesOrderHeader soh ON qh.QuoteID = soh.QuoteID
),
FunnelStages AS (
    SELECT
        MONTH(QuoteDate) AS QuoteMonth,
        YEAR(QuoteDate) AS QuoteYear,
        COUNT(DISTINCT QuoteID) AS TotalQuotes,
        SUM(Converted) AS ConvertedQuotes,
        AVG(CASE WHEN Converted = 1 THEN DaysToConvert ELSE NULL END) AS AvgDaysToConversion,
        SUM(CASE WHEN Converted = 1 THEN OrderAmount ELSE 0 END) AS TotalOrderValue,
        AVG(CASE WHEN Converted = 1 THEN OrderAmount ELSE NULL END) AS AvgOrderValue,
        AVG(CASE WHEN Converted = 1 THEN OrderAmount - QuoteAmount ELSE NULL END) AS AvgUpsellAmount
    FROM SalesProcess
    GROUP BY MONTH(QuoteDate), YEAR(QuoteDate)
)
SELECT
    QuoteYear,
    QuoteMonth,
    TotalQuotes,
    ConvertedQuotes,
    CAST(ConvertedQuotes AS FLOAT) / NULLIF(TotalQuotes, 0) * 100 AS ConversionRate,
    AvgDaysToConversion,
    TotalOrderValue,
    AvgOrderValue,
    AvgUpsellAmount,
    -- Period-over-period analysis
    LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth) AS PrevPeriodQuotes,
    (TotalQuotes - LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth)) / 
        NULLIF(LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth), 0) * 100 AS QuotesGrowthPercent,
    (CAST(ConvertedQuotes AS FLOAT) / NULLIF(TotalQuotes, 0)) - 
        (LAG(CAST(ConvertedQuotes AS FLOAT)) OVER (ORDER BY QuoteYear, QuoteMonth) / 
        NULLIF(LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth), 0)) AS ConversionRateChange
FROM FunnelStages
ORDER BY QuoteYear, QuoteMonth;

-- 80. Repeat purchase probability analysis
WITH CustomerPurchaseCounts AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
        MIN(soh.OrderDate) AS FirstOrderDate,
        MAX(soh.OrderDate) AS LastOrderDate,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespanDays
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
    HAVING COUNT(DISTINCT soh.SalesOrderID) > 1 -- Only customers with more than one order
),
RepeatIntervals AS (
    SELECT
        soh1.CustomerID,
        soh1.SalesOrderID AS FirstOrderID,
        soh2.SalesOrderID AS NextOrderID,
        soh1.OrderDate AS FirstOrderDate,
        soh2.OrderDate AS NextOrderDate,
        DATEDIFF(DAY, soh1.OrderDate, soh2.OrderDate) AS DaysBetweenOrders
    FROM Sales.SalesOrderHeader soh1
    JOIN Sales.SalesOrderHeader soh2 ON 
        soh1.CustomerID = soh2.CustomerID AND 
        soh1.SalesOrderID < soh2.SalesOrderID AND
        soh2.OrderDate = (
            SELECT MIN(OrderDate) 
            FROM Sales.SalesOrderHeader soh3 
            WHERE soh3.CustomerID = soh1.CustomerID AND soh3.OrderDate > soh1.OrderDate
        )
)
SELECT
    CASE
        WHEN DaysBetweenOrders <= 30 THEN '0-30 Days'
        WHEN DaysBetweenOrders <= 60 THEN '31-60 Days'
        WHEN DaysBetweenOrders <= 90 THEN '61-90 Days'
        WHEN DaysBetweenOrders <= 180 THEN '91-180 Days'
        WHEN DaysBetweenOrders <= 365 THEN '181-365 Days'
        ELSE 'Over 365 Days'
    END AS TimeBucket,
    COUNT(*) AS RepeatCustomerCount,
    CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM CustomerPurchaseCounts) * 100 AS PercentOfTotalCustomers,
    MIN(DaysBetweenOrders) AS MinDays,
    MAX(DaysBetweenOrders) AS MaxDays,
    AVG(DaysBetweenOrders) AS AvgDays,
    -- Calculate probability of next purchase in this time bucket
    CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM RepeatIntervals) AS ProbabilityOfRepeatInPeriod
FROM RepeatIntervals
GROUP BY
    CASE
        WHEN DaysBetweenOrders <= 30 THEN '0-30 Days'
        WHEN DaysBetweenOrders <= 60 THEN '31-60 Days'
        WHEN DaysBetweenOrders <= 90 THEN '61-90 Days'
        WHEN DaysBetweenOrders <= 180 THEN '91-180 Days'
        WHEN DaysBetweenOrders <= 365 THEN '181-365 Days'
        ELSE 'Over 365 Days'
    END
ORDER BY MIN(DaysBetweenOrders);

-- 81. Product feature impact analysis
WITH ProductVersionSales AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductLine,
        p.Class,
        p.Style,
        p.ProductModelID,
        pm.Name AS ModelName,
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        SUM(sod.OrderQty) AS SalesQuantity,
        SUM(sod.LineTotal) AS SalesRevenue,
        COUNT(DISTINCT soh.CustomerID) AS UniqueCustomers
    FROM Production.Product p
    JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY
        p.ProductID,
        p.Name,
        p.ProductLine,
        p.Class,
        p.Style,
        p.ProductModelID,
        pm.Name,
        YEAR(soh.OrderDate),
        MONTH(soh.OrderDate)
)
SELECT
    Feature,
    FeatureValue,
    COUNT(DISTINCT ProductID) AS ProductCount,
    SUM(SalesQuantity) AS TotalUnitsSold,
    SUM(SalesRevenue) AS TotalRevenue,
    SUM(UniqueCustomers) AS TotalCustomers,
    AVG(SalesQuantity) AS AvgUnitsSoldPerProduct,
    AVG(SalesRevenue) AS AvgRevenuePerProduct,
    AVG(UniqueCustomers) AS AvgCustomersPerProduct
FROM (
    SELECT ProductID, ProductName, ProductLine AS Feature, ProductLine AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
    UNION ALL
    SELECT ProductID, ProductName, 'Class' AS Feature, Class AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
    UNION ALL
    SELECT ProductID, ProductName, 'Style' AS Feature, Style AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
    UNION ALL
    SELECT ProductID, ProductName, 'Model' AS Feature, ModelName AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
) AS FeatureSales
WHERE FeatureValue IS NOT NULL
GROUP BY Feature, FeatureValue
ORDER BY Feature, TotalRevenue DESC;

-- 82. Cross-sell opportunity identification
WITH CustomerProductCategories AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        pc.ProductCategoryID,
        pc.Name AS CategoryName,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.LineTotal) AS TotalSpend
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product pr ON sod.ProductID = pr.ProductID
    JOIN Production.ProductSubcategory ps ON pr.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY
        c.CustomerID,
        p.FirstName,
        p.LastName,
        pc.ProductCategoryID,
        pc.Name
),
CategoryGaps AS (
    SELECT
        cpc.CustomerID,
        cpc.CustomerName,
        pc.ProductCategoryID,
        pc.Name AS MissingCategory,
        (SELECT SUM(TotalSpend) FROM CustomerProductCategories WHERE CustomerID = cpc.CustomerID) AS CustomerTotalSpend,
        (SELECT AVG(TotalSpend) FROM CustomerProductCategories WHERE ProductCategoryID = pc.ProductCategoryID) AS AvgCategorySpend
    FROM CustomerProductCategories cpc
    CROSS JOIN Production.ProductCategory pc
    WHERE NOT EXISTS (
        SELECT 1 FROM CustomerProductCategories cpc2
        WHERE cpc2.CustomerID = cpc.CustomerID AND cpc2.ProductCategoryID = pc.ProductCategoryID
    )
)
SELECT
    CustomerID,
    CustomerName,
    MissingCategory,
    CustomerTotalSpend,
    AvgCategorySpend,
    -- Calculate cross-sell potential score (higher is better)
    CAST(CustomerTotalSpend AS FLOAT) / 1000 * CAST(AvgCategorySpend AS FLOAT) / 100 AS CrossSellScore,
    -- Recommend top products from missing category
    (
        SELECT TOP 3 STRING_AGG(p.Name, ', ') WITHIN GROUP (ORDER BY SUM(sod.LineTotal) DESC)
        FROM Production.Product p
        JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
        WHERE pc.Name = MissingCategory
        GROUP BY p.ProductID, p.Name
    ) AS RecommendedProducts
FROM CategoryGaps
WHERE CustomerTotalSpend > 5000 -- Focus on customers with significant spending
ORDER BY CrossSellScore DESC;

-- 83. Customer churn risk detection (completing the query)
WITH CustomerActivity AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        MAX(soh.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespanDays,
        COUNT(DISTINCT soh.SalesOrderID) / 
            NULLIF(DATEDIFF(MONTH, MIN(soh.OrderDate), MAX(soh.OrderDate)), 0) AS OrdersPerMonth
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
ChurnRiskFactors AS (
    SELECT
        ca.*,
        -- Calculate typical interval between orders
        CASE 
            WHEN OrderCount <= 1 THEN NULL
            ELSE CustomerLifespanDays / (OrderCount - 1)
        END AS AvgDaysBetweenOrders,
        -- Calculate how many intervals since last order
        CASE 
            WHEN OrderCount <= 1 THEN NULL
            ELSE DaysSinceLastOrder / NULLIF(CustomerLifespanDays / (OrderCount - 1), 0)
        END AS IntervalsSinceLastOrder
    FROM CustomerActivity ca
)
SELECT
    CustomerID,
    CustomerName,
    FirstPurchaseDate,
    LastPurchaseDate,
    OrderCount,
    TotalSpend,
    DaysSinceLastOrder,
    AvgDaysBetweenOrders,
    IntervalsSinceLastOrder,
    -- Calculate churn risk score (0-100)
    CASE
        WHEN OrderCount = 1 AND DaysSinceLastOrder > 180 THEN 90 -- High risk for one-time buyers
        WHEN IntervalsSinceLastOrder > 3 THEN 80 -- Very high risk
        WHEN IntervalsSinceLastOrder BETWEEN 2 AND 3 THEN 60 -- High risk
        WHEN IntervalsSinceLastOrder BETWEEN 1.5 AND 2 THEN 40 -- Medium risk
        WHEN IntervalsSinceLastOrder BETWEEN 1 AND 1.5 THEN 20 -- Low risk
        WHEN IntervalsSinceLastOrder < 1 THEN 10 -- Very low risk
        ELSE 50 -- Default medium risk
    END AS ChurnRiskScore,
    -- Churn risk category
    CASE
        WHEN OrderCount = 1 AND DaysSinceLastOrder > 180 THEN 'High Risk One-Time Customer'
        WHEN IntervalsSinceLastOrder > 3 THEN 'Very High Risk'
        WHEN IntervalsSinceLastOrder BETWEEN 2 AND 3 THEN 'High Risk'
        WHEN IntervalsSinceLastOrder BETWEEN 1.5 AND 2 THEN 'Medium Risk'
        WHEN IntervalsSinceLastOrder BETWEEN 1 AND 1.5 THEN 'Low Risk'
        WHEN IntervalsSinceLastOrder < 1 THEN 'Active'
        ELSE 'Medium Risk'
    END AS ChurnRiskCategory,
    -- Recommended action
    CASE
        WHEN OrderCount = 1 AND DaysSinceLastOrder > 180 THEN 'Reactivation campaign with discount'
        WHEN IntervalsSinceLastOrder > 3 THEN 'Urgent win-back offer'
        WHEN IntervalsSinceLastOrder BETWEEN 2 AND 3 THEN 'Targeted promotion'
        WHEN IntervalsSinceLastOrder BETWEEN 1.5 AND 2 THEN 'Check-in email'
        WHEN IntervalsSinceLastOrder BETWEEN 1 AND 1.5 THEN 'Nurture campaign'
        WHEN IntervalsSinceLastOrder < 1 THEN 'Standard engagement'
        ELSE 'Engagement campaign'
    END AS RecommendedAction
FROM ChurnRiskFactors
WHERE OrderCount > 0 -- Ensure customer has made at least one order
ORDER BY ChurnRiskScore DESC;

-- 84. Product affinity analysis
WITH ProductPairs AS (
    SELECT
        sod1.SalesOrderID,
        sod1.ProductID AS Product1ID,
        p1.Name AS Product1Name,
        sod2.ProductID AS Product2ID,
        p2.Name AS Product2Name
    FROM Sales.SalesOrderDetail sod1
    JOIN Sales.SalesOrderDetail sod2 ON 
        sod1.SalesOrderID = sod2.SalesOrderID AND 
        sod1.ProductID < sod2.ProductID -- Ensure unique pairs
    JOIN Production.Product p1 ON sod1.ProductID = p1.ProductID
    JOIN Production.Product p2 ON sod2.ProductID = p2.ProductID
),
ProductMetrics AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        COUNT(DISTINCT sod.SalesOrderID) AS TotalOrders
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    GROUP BY p.ProductID, p.Name
),
PairAnalysis AS (
    SELECT
        pp.Product1ID,
        pp.Product1Name,
        pp.Product2ID,
        pp.Product2Name,
        COUNT(DISTINCT pp.SalesOrderID) AS PairFrequency,
        pm1.TotalOrders AS Product1Orders,
        pm2.TotalOrders AS Product2Orders,
        COUNT(DISTINCT pp.SalesOrderID) * 1.0 / (SELECT COUNT(DISTINCT SalesOrderID) FROM Sales.SalesOrderHeader) AS Support,
        COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm1.TotalOrders AS Confidence1to2,
        COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm2.TotalOrders AS Confidence2to1,
        (COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm1.TotalOrders) / 
        (pm2.TotalOrders * 1.0 / (SELECT COUNT(DISTINCT SalesOrderID) FROM Sales.SalesOrderHeader)) AS Lift1to2,
        (COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm2.TotalOrders) / 
        (pm1.TotalOrders * 1.0 / (SELECT COUNT(DISTINCT SalesOrderID) FROM Sales.SalesOrderHeader)) AS Lift2to1
    FROM ProductPairs pp
    JOIN ProductMetrics pm1 ON pp.Product1ID = pm1.ProductID
    JOIN ProductMetrics pm2 ON pp.Product2ID = pm2.ProductID
    GROUP BY 
        pp.Product1ID, 
        pp.Product1Name, 
        pp.Product2ID, 
        pp.Product2Name,
        pm1.TotalOrders,
        pm2.TotalOrders
)
SELECT
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    PairFrequency,
    Support,
    Confidence1to2,
    Confidence2to1,
    Lift1to2,
    Lift2to1,
    -- Categorize relationship strength
    CASE
        WHEN Lift1to2 > 3 THEN 'Very Strong'
        WHEN Lift1to2 BETWEEN 2 AND 3 THEN 'Strong'
        WHEN Lift1to2 BETWEEN 1 AND 2 THEN 'Positive'
        WHEN Lift1to2 < 1 THEN 'Negative'
    END AS RelationshipStrength,
    -- Recommendation action
    CASE
        WHEN Lift1to2 > 3 THEN 'Bundle offer'
        WHEN Lift1to2 BETWEEN 2 AND 3 THEN 'Cross-promote'
        WHEN Lift1to2 BETWEEN 1 AND 2 THEN 'Suggest on product page'
        ELSE 'No recommendation'
    END AS RecommendedAction
FROM PairAnalysis
WHERE PairFrequency >= 5 -- Filter for significant co-occurrences
ORDER BY Lift1to2 DESC;

-- 85. Seasonal product trend analysis
WITH ProductMonthlySales AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductSubcategoryID,
        ps.Name AS SubcategoryName,
        pc.Name AS CategoryName,
        MONTH(soh.OrderDate) AS SalesMonth,
        YEAR(soh.OrderDate) AS SalesYear,
        SUM(sod.OrderQty) AS UnitsSold,
        SUM(sod.LineTotal) AS Revenue
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY
        p.ProductID,
        p.Name,
        p.ProductSubcategoryID,
        ps.Name,
        pc.Name,
        MONTH(soh.OrderDate),
        YEAR(soh.OrderDate)
),
MonthlyAverages AS (
    SELECT
        ProductID,
        ProductName,
        SubcategoryName,
        CategoryName,
        SalesMonth,
        AVG(UnitsSold) AS AvgMonthlySales,
        MAX(UnitsSold) AS MaxMonthlySales,
        MIN(UnitsSold) AS MinMonthlySales,
        AVG(Revenue) AS AvgMonthlyRevenue,
        COUNT(DISTINCT SalesYear) AS YearsWithData
    FROM ProductMonthlySales
    GROUP BY ProductID, ProductName, SubcategoryName, CategoryName, SalesMonth
)
SELECT
    ma.ProductID,
    ma.ProductName,
    ma.SubcategoryName,
    ma.CategoryName,
    ma.SalesMonth,
    CASE ma.SalesMonth
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS MonthName,
    ma.AvgMonthlySales,
    (ma.AvgMonthlySales / NULLIF((SELECT AVG(AvgMonthlySales) FROM MonthlyAverages ma2 WHERE ma2.ProductID = ma.ProductID), 0) * 100) - 100 AS PercentVarianceFromAvg,
    ma.AvgMonthlyRevenue,
    ma.YearsWithData,
    RANK() OVER(PARTITION BY ma.ProductID ORDER BY ma.AvgMonthlySales DESC) AS MonthRank,
    CASE 
        WHEN ma.AvgMonthlySales > 1.3 * (SELECT AVG(AvgMonthlySales) FROM MonthlyAverages ma2 WHERE ma2.ProductID = ma.ProductID)
        THEN 'Peak Season'
        WHEN ma.AvgMonthlySales < 0.7 * (SELECT AVG(AvgMonthlySales) FROM MonthlyAverages ma2 WHERE ma2.ProductID = ma.ProductID)
        THEN 'Off Season'
        ELSE 'Regular Season'
    END AS SeasonalityStatus
FROM MonthlyAverages ma
WHERE ma.YearsWithData >= 2 -- Ensure multiple years of data for reliable seasonality
ORDER BY ma.ProductID, ma.SalesMonth;

-- 86. Dynamic pricing model
WITH PriceElasticity AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ListPrice,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0) AS ActualPrice,
        (p.ListPrice - ROUND(sod.UnitPrice, 0)) / p.ListPrice * 100 AS DiscountPercent,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.OrderQty) AS UnitsSold
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE p.ListPrice > 0 -- Exclude free products
    GROUP BY
        p.ProductID,
        p.Name,
        p.ListPrice,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0)
),
ElasticityCalculation AS (
    SELECT
        pe1.ProductID,
        pe1.ProductName,
        pe1.StandardCost,
        pe1.ListPrice,
        pe1.DiscountPercent AS Discount1,
        pe2.DiscountPercent AS Discount2,
        pe1.UnitsSold AS UnitsSold1,
        pe2.UnitsSold AS UnitsSold2,
        -- Calculate price elasticity where higher value means more responsive to price changes
        ABS((pe2.UnitsSold - pe1.UnitsSold) / NULLIF(pe1.UnitsSold, 0)) / 
        NULLIF(ABS((pe2.DiscountPercent - pe1.DiscountPercent) / NULLIF(pe1.DiscountPercent, 0)), 0) AS PriceElasticity
    FROM PriceElasticity pe1
    JOIN PriceElasticity pe2 ON 
        pe1.ProductID = pe2.ProductID AND 
        pe1.DiscountPercent < pe2.DiscountPercent -- Compare different discount levels
)
SELECT
    ProductID,
    ProductName,
    ListPrice,
    StandardCost,
    -- Calculate average elasticity across all discount comparisons
    AVG(PriceElasticity) AS AvgElasticity,
    -- Calculate optimal discount based on elasticity
    CASE
        WHEN AVG(PriceElasticity) > 1.5 THEN 25 -- Highly elastic (price sensitive)
        WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 15 -- Moderately elastic
        WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 10 -- Slightly elastic
        ELSE 5 -- Inelastic (not price sensitive)
    END AS RecommendedBaseDiscount,
    -- Apply seasonal adjustment to current month (example)
    CASE
        WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
            CASE
                WHEN AVG(PriceElasticity) > 1.5 THEN 30 -- Higher discount for elastic products
                WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 20
                WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 15
                ELSE 10
            END
        ELSE -- Regular season
            CASE
                WHEN AVG(PriceElasticity) > 1.5 THEN 25
                WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 15
                WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 10
                ELSE 5
            END
    END AS SeasonallyAdjustedDiscount,
    -- Calculate optimal price
    ListPrice * (1 - 
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    ) AS OptimalPrice,
    -- Calculate expected profit margin
    (ListPrice * (1 - 
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    ) - StandardCost) / 
    (ListPrice * (1 - 
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    )) * 100 AS ExpectedProfitMargin
FROM ElasticityCalculation
GROUP BY ProductID, ProductName, ListPrice, StandardCost
HAVING COUNT(*) >= 3 -- Require multiple price points for reliable elasticity calculation
ORDER BY AvgElasticity DESC;

-- 87. Customer lifetime value prediction
WITH CustomerPurchaseHistory AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        YEAR(soh.OrderDate) AS PurchaseYear,
        MONTH(soh.OrderDate) AS PurchaseMonth,
        MIN(soh.OrderDate) AS FirstOrderDate,
        MAX(soh.OrderDate) AS LastOrderDate,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS YearlySpend
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY
        c.CustomerID,
        p.FirstName,
        p.LastName,
        YEAR(soh.OrderDate),
        MONTH(soh.OrderDate)
),
CustomerMetrics AS (
    SELECT
        CustomerID,
        CustomerName,
        MIN(FirstOrderDate) AS FirstPurchaseEver,
        MAX(LastOrderDate) AS LastPurchaseEver,
        DATEDIFF(MONTH, MIN(FirstOrderDate), MAX(LastOrderDate)) + 1 AS TotalActiveMonths,
        SUM(YearlySpend) AS TotalSpend,
        SUM(OrderCount) AS TotalOrders,
        SUM(YearlySpend) / NULLIF(SUM(OrderCount), 0) AS AvgOrderValue,
        SUM(OrderCount) * 1.0 / NULLIF(DATEDIFF(MONTH, MIN(FirstOrderDate), MAX(LastOrderDate)) + 1, 0) AS OrderFrequency,
        DATEDIFF(MONTH, MAX(LastOrderDate), GETDATE()) AS MonthsSinceLastPurchase
    FROM CustomerPurchaseHistory
    GROUP BY CustomerID, CustomerName
),
ChurnProbability AS (
    SELECT
        CustomerID,
        CustomerName,
        FirstPurchaseEver,
        LastPurchaseEver,
        TotalActiveMonths,
        TotalSpend,
        TotalOrders,
        AvgOrderValue,
        OrderFrequency,
        MonthsSinceLastPurchase,
        -- Calculate retention probability (inverse of churn)
        CASE
            WHEN MonthsSinceLastPurchase > TotalActiveMonths * 2 THEN 0.1 -- Likely churned
            WHEN MonthsSinceLastPurchase > TotalActiveMonths THEN 0.3 -- At high risk
            WHEN MonthsSinceLastPurchase > TotalActiveMonths / 2 THEN 0.5 -- At medium risk
            WHEN MonthsSinceLastPurchase > 0 THEN 0.8 -- Low risk
            ELSE 0.9 -- Active customer
        END AS RetentionProbability,
        -- Expected future lifetime in months
        CASE
            WHEN MonthsSinceLastPurchase > TotalActiveMonths * 2 THEN 0 -- Likely churned
            WHEN MonthsSinceLastPurchase > TotalActiveMonths THEN 3 -- At high risk
            WHEN MonthsSinceLastPurchase > TotalActiveMonths / 2 THEN 12 -- At medium risk
            WHEN MonthsSinceLastPurchase > 0 THEN 24 -- Low risk
            ELSE 36 -- Active customer
        END AS ExpectedFutureMonths
    FROM CustomerMetrics
)
SELECT
    CustomerID,
    CustomerName,
    TotalSpend,
    TotalOrders,
    AvgOrderValue,
    OrderFrequency,
    DATEDIFF(MONTH, FirstPurchaseEver, GETDATE()) AS MonthsSinceFirstPurchase,
    MonthsSinceLastPurchase,
    RetentionProbability,
    -- Current CLV (historical value)
    TotalSpend AS CurrentCLV,
    -- Predicted CLV (current + future value)
    TotalSpend + (OrderFrequency * AvgOrderValue * ExpectedFutureMonths * RetentionProbability) AS PredictedCLV,
    -- CLV to CAC ratio (assuming acquisition cost for demonstration)
    (TotalSpend + (OrderFrequency * AvgOrderValue * ExpectedFutureMonths * RetentionProbability)) / 1000 AS CLVtoCACRatio,
    -- Customer tier based on predicted CLV
    CASE
        WHEN TotalSpend + (OrderFrequency * AvgOrderValue * ExpectedFutureMonths * RetentionProbability) > 50000 THEN 'Premium'
        WHEN TotalSpend + (OrderFrequency * AvgOrderValue * ExpectedFutureMonths * RetentionProbability) > 25000 THEN 'Gold'
        WHEN TotalSpend + (OrderFrequency * AvgOrderValue * ExpectedFutureMonths * RetentionProbability) > 10000 THEN 'Silver'
        ELSE 'Bronze'
    END AS CustomerTier
FROM ChurnProbability
ORDER BY PredictedCLV DESC;

-- 88. Marketing attribution model
WITH CustomerTouchpoints AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        em.CampaignID,
        cam.Name AS CampaignName,
        cam.Type AS CampaignType,
        em.TouchDate,
        em.TouchpointType,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY em.TouchDate) AS TouchSequence,
        LEAD(em.TouchDate) OVER (PARTITION BY c.CustomerID ORDER BY em.TouchDate) AS NextTouchDate
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Marketing.CustomerEngagement em ON c.CustomerID = em.CustomerID
    JOIN Marketing.Campaign cam ON em.CampaignID = cam.CampaignID
),
PurchaseEvents AS (
    SELECT
        c.CustomerID,
        soh.SalesOrderID,
        soh.OrderDate,
        soh.TotalDue AS Revenue
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
),
AttributionModel AS (
    SELECT
        tp.CustomerID,
        tp.CustomerName,
        tp.CampaignID,
        tp.CampaignName,
        tp.CampaignType,
        tp.TouchpointType,
        tp.TouchSequence,
        pe.SalesOrderID,
        pe.OrderDate,
        pe.Revenue,
        -- First-touch attribution
        CASE WHEN tp.TouchSequence = 1 THEN 1 ELSE 0 END AS IsFirstTouch,
        -- Last-touch attribution
        CASE WHEN tp.TouchDate = (
            SELECT MAX(TouchDate) 
            FROM CustomerTouchpoints 
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) THEN 1 ELSE 0 END AS IsLastTouch,
        -- Linear attribution (equal weight to all touchpoints)
        1.0 / (
            SELECT COUNT(*) 
            FROM CustomerTouchpoints 
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) AS LinearWeight,
        -- Time-decay attribution (more weight to recent touchpoints)
        EXP(-0.1 * DATEDIFF(DAY, tp.TouchDate, pe.OrderDate)) / (
            SELECT SUM(EXP(-0.1 * DATEDIFF(DAY, TouchDate, pe.OrderDate)))
            FROM CustomerTouchpoints
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) AS TimeDecayWeight
    FROM CustomerTouchpoints tp
    JOIN PurchaseEvents pe ON tp.CustomerID = pe.CustomerID
    WHERE tp.TouchDate <= pe.OrderDate -- Touch happened before purchase
    AND (tp.NextTouchDate IS NULL OR tp.NextTouchDate > pe.OrderDate) -- Last touch before purchase
)
SELECT
    CampaignID,
    CampaignName,
    CampaignType,
    -- First-touch attribution
    SUM(CASE WHEN IsFirstTouch = 1 THEN Revenue ELSE 0 END) AS FirstTouchRevenue,
    SUM(CASE WHEN IsFirstTouch = 1 THEN 1 ELSE 0 END) AS FirstTouchConversions,
    -- Last-touch attribution
    SUM(CASE WHEN IsLastTouch = 1 THEN Revenue ELSE 0 END) AS LastTouchRevenue,
    SUM(CASE WHEN IsLastTouch = 1 THEN 1 ELSE 0 END) AS LastTouchConversions,
    -- Linear attribution
    SUM(Revenue * LinearWeight) AS LinearAttributedRevenue,
    SUM(LinearWeight) AS LinearAttributedConversions,
    -- Time-decay attribution
    SUM(Revenue * TimeDecayWeight) AS TimeDecayAttributedRevenue,
    SUM(TimeDecayWeight) AS TimeDecayAttributedConversions,
    -- Multi-touch comparison
    SUM(Revenue * LinearWeight) / NULLIF(AVG(CAM.Cost), 0) AS LinearROI,
    SUM(Revenue * TimeDecayWeight) / NULLIF(AVG(CAM.Cost), 0) AS TimeDecayROI
FROM AttributionModel AM
JOIN Marketing.Campaign CAM ON AM.CampaignID = CAM.CampaignID
GROUP BY CampaignID, CampaignName, CampaignType
ORDER BY TimeDecayAttributedRevenue DESC;

-- 89. Inventory optimization model
WITH ProductDemand AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        p.ReorderPoint,
        p.StandardCost,
        p.ListPrice,
        p.DaysToManufacture,
        p.SafetyStockLevel,
        MONTH(soh.OrderDate) AS OrderMonth,
        YEAR(soh.OrderDate) AS OrderYear,
        SUM(sod.OrderQty) AS MonthlySales,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.ReorderPoint,
        p.StandardCost,
        p.ListPrice,
        p.DaysToManufacture,
        p.SafetyStockLevel,
        MONTH(soh.OrderDate),
        YEAR(soh.OrderDate)
),
ProductMetrics AS (
    SELECT
        ProductID,
        ProductName,
        ProductNumber,
        ReorderPoint,
        StandardCost,
        ListPrice,
        DaysToManufacture,
        SafetyStockLevel,
        AVG(MonthlySales) AS AvgMonthlySales,
        STDEV(MonthlySales) AS St-- 83. Customer churn risk detection
WITH CustomerActivity AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        MAX(soh.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespanDays,
        COUNT(DISTINCT soh.SalesOrderID) /








```

Can you make one document from these queries and write better queries and deeper questions for everything up to 100
Creating a comprehensive SQL guide with advanced and expert-level queries for the AdventureWorks database is a great way to deepen your understanding of SQL. Below, I'll provide a structured guide that includes improved queries and deeper questions for each module.

Mastering SQL with AdventureWorks: A Comprehensive Guide
Overview
This guide provides a structured learning path designed to take you from SQL fundamentals to expert-level proficiency using Microsoft AdventureWorks databases (OLTP, Data Warehouse, and Lightweight). The guide includes theoretical explanations, best practices, real-world applications, practice queries, exercises, and assessments to ensure deep understanding.

Learning Progression
The guide follows 10 detailed modules:

Module 1: Introduction to SQL and AdventureWorks
Objectives:
Understand SQL basics and database management concepts.
Explore relational databases and schemas.
Learn to install and use AdventureWorks databases.
Differentiate between OLTP, Data Warehouse, and Lightweight databases.
Key Concepts:
Structured Query Language (SQL) as a standard for managing relational databases.
RDBMS (Relational Database Management Systems) like SQL Server.
Overview of database objects (Tables, Views, Indexes, Constraints, Stored Procedures).
Installation of AdventureWorks databases and setting up a SQL Server environment.
Practice Query: List all tables in AdventureWorks OLTP.
Copy
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
Module 2: Understanding the AdventureWorks Schema
Objectives:
Explore the structure and purpose of AdventureWorks database tables.
Understand key relationships between tables.
Key Concepts:
Primary and foreign keys.
Fact and dimension tables in Data Warehouses.
Entity-relationship diagrams (ERD).
Practice Query: Retrieve column details for a specific table.
Copy
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Person';
Advanced and Expert SQL Practice Questions (100+ Queries)
The following questions and their corresponding SQL queries are designed to challenge and build expert-level SQL skills using AdventureWorks OLTP. ```

1-100: Advanced and Expert-Level SQL Queries
Copy
-- 1. Retrieve the top 10 employees with the highest salaries.
SELECT TOP 10 BusinessEntityID, JobTitle, Rate
FROM HumanResources.EmployeePayHistory
ORDER BY Rate DESC;

-- 2. Find the total number of orders placed in each year.
SELECT YEAR(OrderDate) AS OrderYear, COUNT(*) AS TotalOrders
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;

-- 3. Retrieve the customers who have placed more than 5 orders.
SELECT CustomerID, COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 5;

-- 4. Find the most popular product (with the highest sales quantity).
SELECT TOP 1 ProductID, SUM(OrderQty) AS TotalSold
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY TotalSold DESC;

-- 5. Retrieve the total revenue generated per product category.
SELECT p.ProductCategoryID, pc.Name AS CategoryName, SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY p.ProductCategoryID, pc.Name
ORDER BY TotalRevenue DESC;

-- 6. Retrieve the customers who have never placed an order.
SELECT c.CustomerID, c.PersonID, c.CompanyName
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE soh.CustomerID IS NULL;

-- 7. Calculate the average order total per customer.
SELECT CustomerID, AVG(TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

-- 8. Find employees who have been with the company for more than 10 years.
SELECT BusinessEntityID, JobTitle, HireDate
FROM HumanResources.Employee
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 10;

-- 9. List all employees along with their manager’s name.
SELECT e.BusinessEntityID, e.JobTitle, m.BusinessEntityID AS ManagerID, m.JobTitle AS ManagerTitle
FROM HumanResources.Employee e
LEFT JOIN HumanResources.Employee m ON e.OrganizationLevel = m.OrganizationLevel - 1;

-- 10. Find the average sales per month over the last 5 years.
SELECT YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, AVG(TotalDue) AS AvgSales
FROM Sales.SalesOrderHeader
WHERE OrderDate >= DATEADD(YEAR, -5, GETDATE())
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;

-- 11. Find the most valuable customers based on total purchases.
SELECT CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- 12. Identify products that have never been sold.
SELECT p.ProductID, p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

-- 13. Create a recursive Common Table Expression (CTE) for employee hierarchy.
WITH EmployeeHierarchy AS (
  SELECT BusinessEntityID, OrganizationLevel, JobTitle
  FROM HumanResources.Employee
  WHERE OrganizationLevel = 1
  UNION ALL
  SELECT e.BusinessEntityID, e.OrganizationLevel, e.JobTitle
  FROM HumanResources.Employee e
  JOIN EmployeeHierarchy eh ON e.OrganizationLevel = eh.OrganizationLevel + 1
)
SELECT * FROM EmployeeHierarchy;

-- 14. Retrieve the top 5 customers by total number of orders.
SELECT TOP 5 CustomerID, COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY OrderCount DESC;

-- 15. Retrieve products that have been ordered more than 100 times.
SELECT ProductID, SUM(OrderQty) AS TotalOrdered
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(OrderQty) > 100;

-- 16. Find products that are in the same category as 'Mountain Bikes'.
SELECT p.ProductID, p.Name, pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = (
    SELECT pc2.Name
    FROM Production.ProductCategory pc2
    JOIN Production.ProductSubcategory ps2 ON pc2.ProductCategoryID = ps2.ProductCategoryID
    JOIN Production.Product p2 ON ps2.ProductSubcategoryID = p2.ProductSubcategoryID
    WHERE p2.Name LIKE '%Mountain Bike%'
    GROUP BY pc2.Name
);

-- 17. Retrieve all orders along with customer information using different join types.
SELECT soh.SalesOrderID, c.CustomerID, p.FirstName, p.LastName, soh.OrderDate
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
ORDER BY soh.OrderDate DESC;

-- 18. Find vendors who supply the most number of products.
SELECT v.BusinessEntityID, v.Name, COUNT(pv.ProductID) AS ProductCount
FROM Purchasing.Vendor v
JOIN Purchasing.ProductVendor pv ON v.BusinessEntityID = pv.BusinessEntityID
GROUP BY v.BusinessEntityID, v.Name
ORDER BY ProductCount DESC;

-- 19. Find products that have been purchased by the most customers.
SELECT p.ProductID, p.Name, COUNT(DISTINCT soh.CustomerID) AS CustomerCount
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.ProductID, p.Name
ORDER BY CustomerCount DESC;

-- 20. Self-join to find employees who have the same job title.
SELECT e1.BusinessEntityID, e1.JobTitle, e2.BusinessEntityID AS OtherEmployeeID
FROM HumanResources.Employee e1
JOIN HumanResources.Employee e2 ON e1.JobTitle = e2.JobTitle
WHERE e1.BusinessEntityID < e2.BusinessEntityID;

-- 21. Calculate running total of sales by month.
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalDue) AS MonthlySales,
    SUM(SUM(TotalDue)) OVER (PARTITION BY YEAR(OrderDate) ORDER BY MONTH(OrderDate)) AS RunningTotal
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- 22. Rank products by sales quantity within each category.
SELECT
    p.ProductID,
    p.Name,
    pc.Name AS CategoryName,
    SUM(sod.OrderQty) AS TotalQuantity,
    RANK() OVER (PARTITION BY pc.ProductCategoryID ORDER BY SUM(sod.OrderQty) DESC) AS RankInCategory
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name, pc.Name, pc.ProductCategoryID;

-- 23. Calculate the percentage of total sales each product contributes.
WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.Name,
        SUM(sod.LineTotal) AS TotalSales
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    GROUP BY p.ProductID, p.Name
)
SELECT
    ProductID,
    Name,
    TotalSales,
    TotalSales / SUM(TotalSales) OVER () * 100 AS PercentageOfTotal
FROM ProductSales
ORDER BY PercentageOfTotal DESC;

-- 24. Find the difference in sales between consecutive months.
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalDue) AS CurrentMonthSales,
    LAG(SUM(TotalDue), 1, 0) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS PreviousMonthSales,
    SUM(TotalDue) - LAG(SUM(TotalDue), 1, 0) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS MonthlySalesChange
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- 25. Calculate the moving average of sales over a 3-month period.
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(TotalDue) AS MonthlySales,
    AVG(SUM(TotalDue)) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3Month
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

-- 26. Use CTE to find customers who have purchased products from all categories.
WITH CustomerCategories AS (
    SELECT
        soh.CustomerID,
        pc.ProductCategoryID,
        COUNT(DISTINCT pc.ProductCategoryID) AS CategoryCount
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY soh.CustomerID, pc.ProductCategoryID
)
SELECT
    cc.CustomerID,
    COUNT(DISTINCT cc.ProductCategoryID) AS PurchasedCategories,
    (SELECT COUNT(*) FROM Production.ProductCategory) AS TotalCategories
FROM CustomerCategories cc
GROUP BY cc.CustomerID
HAVING COUNT(DISTINCT cc.ProductCategoryID) = (SELECT COUNT(*) FROM Production.ProductCategory);

-- 27. Identify potential cross-selling opportunities using subqueries.
SELECT
    p1.ProductID,
    p1.Name,
    (
        SELECT STRING_AGG(p2.Name, ', ')
        FROM Production.Product p2
        JOIN Sales.SalesOrderDetail sod2 ON p2.ProductID = sod2.ProductID
        WHERE sod2.SalesOrderID IN (
            SELECT sod1.SalesOrderID
            FROM Sales.SalesOrderDetail sod1
            WHERE sod1.ProductID = p1.ProductID
        )
        AND p2.ProductID != p1.ProductID
        GROUP BY p2.ProductID
    ) AS FrequentlyBoughtWith
FROM Production.Product p1
WHERE p1.ProductID IN (
    SELECT TOP 10 ProductID FROM Sales.SalesOrderDetail
    GROUP BY ProductID
    ORDER BY COUNT(*) DESC
);

-- 28. Use CTE for hierarchical query of product categories and subcategories.
WITH CategoryHierarchy AS (
    SELECT
        pc.ProductCategoryID,
        pc.Name AS CategoryName,
        CAST(pc.Name AS VARCHAR(500)) AS Hierarchy,
        0 AS Level
    FROM Production.ProductCategory pc
    UNION ALL
    SELECT
        ps.ProductSubcategoryID,
        ps.Name AS SubcategoryName,
        CAST(ch.Hierarchy + ' > ' + ps.Name AS VARCHAR(500)),
        ch.Level + 1
    FROM Production.ProductSubcategory ps
    JOIN CategoryHierarchy ch ON ps.ProductCategoryID = ch.ProductCategoryID
    WHERE ch.Level = 0
)
SELECT * FROM CategoryHierarchy
ORDER BY Hierarchy;

-- 29. Find products that have had price changes using CTE.
WITH PriceChanges AS (
    SELECT
        ProductID,
        StartDate,
        EndDate,
        ListPrice,
        LAG(ListPrice) OVER (PARTITION BY ProductID ORDER BY StartDate) AS PreviousPrice
    FROM Production.ProductListPriceHistory
)
SELECT
    pc.ProductID,
    p.Name,
    pc.StartDate,
    pc.EndDate,
    pc.PreviousPrice,
    pc.ListPrice,
    (pc.ListPrice - pc.PreviousPrice) AS PriceChange,
    (pc.ListPrice - pc.PreviousPrice) / pc.PreviousPrice * 100 AS PercentageChange
FROM PriceChanges pc
JOIN Production.Product p ON pc.ProductID = p.ProductID
WHERE pc.PreviousPrice IS NOT NULL;

-- 30. Find the top 3 products in each subcategory by sales amount.
WITH RankedProducts AS (
    SELECT
        p.ProductID,
        p.Name,
        ps.ProductSubcategoryID,
        ps.Name AS SubcategoryName,
        SUM(sod.LineTotal) AS TotalSales,
        RANK() OVER (PARTITION BY ps.ProductSubcategoryID ORDER BY SUM(sod.LineTotal) DESC) AS SalesRank
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    GROUP BY p.ProductID, p.Name, ps.ProductSubcategoryID, ps.Name
)
SELECT * FROM RankedProducts
WHERE SalesRank <= 3
ORDER BY ProductSubcategoryID, SalesRank;

-- 31. Analyze sales by day of week.
SELECT
    DATENAME(WEEKDAY, OrderDate) AS DayOfWeek,
    COUNT(SalesOrderID) AS NumberOfOrders,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY DATENAME(WEEKDAY, OrderDate), DATEPART(WEEKDAY, OrderDate)
ORDER BY DATEPART(WEEKDAY, OrderDate);

-- 32. Find seasonality in sales (by quarter and month).
SELECT
    YEAR(OrderDate) AS Year,
    DATEPART(QUARTER, OrderDate) AS Quarter,
    MONTH(OrderDate) AS Month,
    COUNT(SalesOrderID) AS OrderCount,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate), MONTH(OrderDate)
ORDER BY Year, Quarter, Month;

-- 33. Calculate the number of days between order date and ship date.
SELECT
    SalesOrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM Sales.SalesOrderHeader
ORDER BY DaysToShip DESC;

-- 34. Identify orders that were shipped late (after the promised due date).
SELECT
    SalesOrderID,
    OrderDate,
    DueDate,
    ShipDate,
    DATEDIFF(DAY, DueDate, ShipDate) AS DaysLate
FROM Sales.SalesOrderHeader
WHERE ShipDate > DueDate
ORDER BY DaysLate DESC;

-- 35. Analyze sales trends by year and quarter with growth rate.
WITH QuarterlySales AS (
    SELECT
        YEAR(OrderDate) AS Year,
        DATEPART(QUARTER, OrderDate) AS Quarter,
        SUM(TotalDue) AS QuarterSales
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate), DATEPART(QUARTER, OrderDate)
)
SELECT
    Year,
    Quarter,
    QuarterSales,
    LAG(QuarterSales) OVER (ORDER BY Year, Quarter) AS PreviousQuarterSales,
    (QuarterSales - LAG(QuarterSales) OVER (ORDER BY Year, Quarter)) / LAG(QuarterSales) OVER (ORDER BY Year, Quarter) * 100 AS GrowthRate
FROM QuarterlySales
ORDER BY Year, Quarter;

-- 36. Analyze the sales performance of products by territory.
SELECT
    st.Name AS Territory,
    p.ProductID,
    p.Name AS ProductName,
    SUM(sod.OrderQty) AS QuantitySold,
    SUM(sod.LineTotal) AS TotalSales,
    AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY st.Name, p.ProductID, p.Name
ORDER BY Territory, TotalSales DESC;

-- 37. Find customer lifetime value (CLV).
SELECT
    c.CustomerID,
    ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName) AS CustomerName,
    COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
    SUM(soh.TotalDue) AS LifetimeValue,
    AVG(soh.TotalDue) AS AverageOrderValue,
    MIN(soh.OrderDate) AS FirstPurchaseDate,
    MAX(soh.OrderDate) AS MostRecentPurchaseDate,
    DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerTenureDays
FROM Sales.Customer c
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName)
ORDER BY LifetimeValue DESC;

-- 38. Calculate product profit margins.
SELECT
    p.ProductID,
    p.Name,
    AVG(sod.UnitPrice) AS AvgSellingPrice,
    AVG(p.StandardCost) AS AvgCost,
    AVG(sod.UnitPrice - p.StandardCost) AS AvgProfit,
    AVG((sod.UnitPrice - p.StandardCost) / sod.UnitPrice) * 100 AS ProfitMarginPercentage
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY ProfitMarginPercentage DESC;

-- 39. Segment customers based on recency, frequency, and monetary value (RFM analysis).
WITH CustomerRFM AS (
    SELECT
        c.CustomerID,
        ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName) AS CustomerName,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS Recency,
        COUNT(DISTINCT soh.SalesOrderID) AS Frequency,
        SUM(soh.TotalDue) AS MonetaryValue
    FROM Sales.Customer c
    LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, ISNULL(p.FirstName + ' ' + p.LastName, c.CompanyName)
),
RFMScores AS (
    SELECT
        CustomerID,
        CustomerName,
        Recency,
        Frequency,
        MonetaryValue,
        NTILE(5) OVER (ORDER BY Recency DESC) AS RecencyScore,
        NTILE(5) OVER (ORDER BY Frequency) AS FrequencyScore,
        NTILE(5) OVER (ORDER BY MonetaryValue) AS MonetaryScore
    FROM CustomerRFM
)
SELECT
    CustomerID,
    CustomerName,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    CONCAT(RecencyScore, FrequencyScore, MonetaryScore) AS RFMScore,
    CASE
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 13 THEN 'Premium'
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 10 THEN 'High Value'
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 7 THEN 'Medium Value'
        WHEN (RecencyScore + FrequencyScore + MonetaryScore) >= 4 THEN 'Low Value'
        ELSE 'Lost Customer'
    END AS CustomerSegment
FROM RFMScores
ORDER BY (RecencyScore + FrequencyScore + MonetaryScore) DESC;

-- 40. Analyze sales trends by demographic factors.
SELECT
    CASE
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 51 AND 60 THEN '51-60'
        ELSE 'Over 60'
    END AS AgeGroup,
    pp.Gender,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSales,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.PersonInformation pp ON p.BusinessEntityID = pp.BusinessEntityID
GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
        WHEN DATEDIFF(YEAR, pp.BirthDate, GETDATE()) BETWEEN 51 AND 60 THEN '51-60'
        ELSE 'Over 60'
    END,
    pp.Gender
ORDER BY AgeGroup, Gender;

-- 41. Find the most expensive queries using execution statistics.
SELECT TOP 10
    qs.execution_count,
    qs.total_worker_time / qs.execution_count AS avg_worker_time,
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY avg_worker_time DESC;

-- 42. Analyze index usage statistics.
SELECT
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ius.user_seeks,
    ius.user_scans,
    ius.user_lookups,
    ius.user_updates,
    ius.last_user_seek,
    ius.last_user_scan
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE OBJECT_NAME(i.object_id) LIKE 'Sales%' OR OBJECT_NAME(i.object_id) LIKE 'Production%'
ORDER BY ius.user_seeks + ius.user_scans + ius.user_lookups DESC;

-- 43. Identify tables without indexes.
SELECT
    OBJECT_NAME(t.object_id) AS TableName,
    t.create_date AS CreatedDate,
    t.modify_date AS LastModified
FROM sys.tables t
LEFT JOIN sys.indexes i ON t.object_id = i.object_id
WHERE i.object_id IS NULL OR (i.type = 0 AND i.is_primary_key = 0)
ORDER BY t.create_date;

-- 44. Find unused indexes.
SELECT
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ISNULL(ius.user_seeks, 0) AS UserSeeks,
    ISNULL(ius.user_scans, 0) AS UserScans,
    ISNULL(ius.user_lookups, 0) AS UserLookups,
    ISNULL(ius.user_updates, 0) AS UserUpdates
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats ius ON i.object_id = ius.object_id AND i.index_id = ius.index_id
WHERE i.type_desc <> 'HEAP'
AND (ius.user_seeks + ius.user_scans + ius.user_lookups) = 0
AND ius.user_updates > 0
ORDER BY ius.user_updates DESC;

-- 45. Create indexed view for frequently accessed data.
CREATE VIEW vw_ProductSalesDetail WITH SCHEMABINDING AS
SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ProductNumber,
    p.ListPrice,
    SUM(sod.OrderQty) AS TotalQuantity,
    SUM(sod.LineTotal) AS TotalSales,
    COUNT_BIG(*) AS OrderCount
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name, p.ProductNumber, p.ListPrice;

CREATE UNIQUE CLUSTERED INDEX IDX_vw_ProductSalesDetail ON vw_ProductSalesDetail (ProductID);

-- 46. Create a stored procedure to get customer orders.
CREATE PROCEDURE GetCustomerOrders
    @CustomerID INT,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        soh.SalesOrderID,
        soh.OrderDate,
        soh.TotalDue,
        soh.Status,
        p.FirstName + ' ' + p.LastName AS CustomerName
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
    LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    WHERE soh.CustomerID = @CustomerID
    AND (@StartDate IS NULL OR soh.OrderDate >= @StartDate)
    AND (@EndDate IS NULL OR soh.OrderDate <= @EndDate)
    ORDER BY soh.OrderDate DESC;
END;

-- 47. Create a function to calculate total inventory value.
CREATE FUNCTION GetInventoryValue()
RETURNS TABLE
AS
RETURN
(
    SELECT
        p.ProductID,
        p.Name,
        p.ProductNumber,
        SUM(i.Quantity) AS TotalQuantity,
        p.StandardCost,
        SUM(i.Quantity * p.StandardCost) AS InventoryValue
    FROM Production.Product p
    JOIN Production.ProductInventory i ON p.ProductID = i.ProductID
    GROUP BY p.ProductID, p.Name, p.ProductNumber, p.StandardCost
);

-- 48. Create a stored procedure for product reordering analysis.
CREATE PROCEDURE GetProductReorderingAnalysis
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.ProductID,
        p.Name,
        p.ReorderPoint,
        SUM(i.Quantity) AS CurrentStock,
        (p.ReorderPoint - SUM(i.Quantity)) AS QuantityToReorder,
        p.StandardCost,
        (p.ReorderPoint - SUM(i.Quantity)) * p.StandardCost AS ReorderCost
    FROM Production.Product p
    JOIN Production.ProductInventory i ON p.ProductID = i.ProductID
    GROUP BY p.ProductID, p.Name, p.ReorderPoint, p.StandardCost
    HAVING SUM(i.Quantity) < p.ReorderPoint
    ORDER BY (p.ReorderPoint - SUM(i.Quantity)) DESC;
END;

-- 49. Create a function for calculating employee tenure.
CREATE FUNCTION CalculateEmployeeTenure()
RETURNS TABLE
AS
RETURN
(
    SELECT
        e.BusinessEntityID,
        p.FirstName + ' ' + p.LastName AS EmployeeName,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsWithCompany,
        DATEDIFF(MONTH, e.HireDate, GETDATE()) AS MonthsWithCompany,
        e.JobTitle,
        CASE
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) < 2 THEN 'Junior'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 2 AND 5 THEN 'Mid-level'
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) BETWEEN 6 AND 10 THEN 'Senior'
            ELSE 'Executive'
        END AS TenureCategory
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
);

-- 50. Create a stored procedure for sales forecasting.
CREATE PROCEDURE ForecastSales
    @MonthsToForecast INT = 6
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EndDate DATE = GETDATE();
    DECLARE @StartDate DATE = DATEADD(YEAR, -3, @EndDate);

    WITH MonthlySales AS (
        SELECT
            YEAR(OrderDate) AS SalesYear,
            MONTH(OrderDate) AS SalesMonth,
            SUM(TotalDue) AS TotalSales
        FROM Sales.SalesOrderHeader
        WHERE OrderDate BETWEEN @StartDate AND @EndDate
        GROUP BY YEAR(OrderDate), MONTH(OrderDate)
    ),
    SalesGrowth AS (
        SELECT
            SalesYear,
            SalesMonth,
            TotalSales,
            LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth) AS SalesYearAgo,
            CASE
                WHEN LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth) > 0
                THEN (TotalSales - LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)) / LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)
                ELSE 0
            END AS YearOverYearGrowth
        FROM MonthlySales
    )
    SELECT
        SalesYear,
        SalesMonth,
        TotalSales,
        SalesYearAgo,
        YearOverYearGrowth,
        AVG(YearOverYearGrowth) OVER (ORDER BY SalesYear, SalesMonth ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS AverageGrowthRate
    FROM SalesGrowth
    WHERE SalesYearAgo IS NOT NULL
    ORDER BY SalesYear, SalesMonth;

    -- Now generate the forecast
    WITH LatestSales AS (
        SELECT TOP 12
            YEAR(OrderDate) AS SalesYear,
            MONTH(OrderDate) AS SalesMonth,
            SUM(TotalDue) AS TotalSales
        FROM Sales.SalesOrderHeader
        GROUP BY YEAR(OrderDate), MONTH(OrderDate)
        ORDER BY SalesYear DESC, SalesMonth DESC
    ),
    AverageGrowth AS (
        SELECT AVG((TotalSales - LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)) / LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth)) AS AvgGrowthRate
        FROM (
            SELECT
                YEAR(OrderDate) AS SalesYear,
                MONTH(OrderDate) AS SalesMonth,
                SUM(TotalDue) AS TotalSales
            FROM Sales.SalesOrderHeader
            WHERE OrderDate >= DATEADD(YEAR, -2, GETDATE())
            GROUP BY YEAR(OrderDate), MONTH(OrderDate)
        ) AS RecentSales
        WHERE LAG(TotalSales, 12) OVER (ORDER BY SalesYear, SalesMonth) IS NOT NULL
    )
    SELECT
        YEAR(DATEADD(MONTH, Number, @EndDate)) AS ForecastYear,
        MONTH(DATEADD(MONTH, Number, @EndDate)) AS ForecastMonth,
        (SELECT TOP 1 TotalSales FROM LatestSales ORDER BY SalesYear DESC, SalesMonth DESC) *
        POWER(1 + (SELECT AvgGrowthRate FROM AverageGrowth), Number/12.0) AS ForecastedSales
    FROM (
        SELECT TOP (@MonthsToForecast) ROW_NUMBER() OVER (ORDER BY object_id) AS Number
        FROM sys.objects
    ) AS Numbers
    ORDER BY ForecastYear, ForecastMonth;
END;

-- 51. Check for duplicate customer records.
SELECT
    p.FirstName,
    p.LastName,
    p.EmailAddress,
    COUNT(*) AS DuplicateCount
FROM Person.Person p
JOIN Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID
GROUP BY p.FirstName, p.LastName, p.EmailAddress
HAVING COUNT(*) > 1;

-- 52. Validate product data integrity (continued).
SELECT
    p.ProductID,
    p.Name,
    p.StandardCost,
    p.ListPrice,
    CASE
        WHEN p.StandardCost > p.ListPrice THEN 'Error: Cost higher than price'
        WHEN p.StandardCost = 0 AND p.ListPrice > 0 THEN 'Warning: Zero cost'
        WHEN p.ListPrice = 0 AND p.FinishedGoodsFlag = 1 THEN 'Warning: Zero price for finished goods'
        ELSE 'OK'
    END AS DataQualityStatus
FROM Production.Product p
WHERE p.StandardCost > p.ListPrice
   OR (p.StandardCost = 0 AND p.ListPrice > 0)
   OR (p.ListPrice = 0 AND p.FinishedGoodsFlag = 1);

-- 53. Identify orders with inconsistent shipping information.
SELECT
    soh.SalesOrderID,
    soh.OrderDate,
    soh.ShipDate,
    soh.DueDate,
    CASE
        WHEN soh.ShipDate < soh.OrderDate THEN 'Error: Shipped before ordered'
        WHEN soh.DueDate < soh.OrderDate THEN 'Error: Due date before order date'
        WHEN DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) > 30 THEN 'Warning: Long shipping time'
        ELSE 'OK'
    END AS ShippingStatus
FROM Sales.SalesOrderHeader soh
WHERE soh.ShipDate < soh.OrderDate
   OR soh.DueDate < soh.OrderDate
   OR DATEDIFF(DAY, soh.OrderDate, soh.ShipDate) > 30;

-- 54. Check for missing email addresses for customers.
SELECT
    c.CustomerID,
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    'Missing Email' AS Issue
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID
WHERE e.EmailAddress IS NULL
ORDER BY c.CustomerID;

-- 55. Identify products with inconsistent pricing history.
SELECT
    p.ProductID,
    p.Name,
    plph1.StartDate,
    plph1.EndDate,
    plph1.ListPrice AS OldPrice,
    plph2.ListPrice AS NewPrice,
    (plph2.ListPrice - plph1.ListPrice) / plph1.ListPrice * 100 AS PriceChangePercent,
    (plph2.ListPrice - plph1.ListPrice) / plph1.ListPrice * 100 AS PriceChangePercent
FROM Production.Product p
JOIN Production.ProductListPriceHistory plph1 ON p.ProductID = plph1.ProductID
JOIN Production.ProductListPriceHistory plph2 ON p.ProductID = plph2.ProductID
WHERE plph1.EndDate = plph2.StartDate
AND ABS((plph2.ListPrice - plph1.ListPrice) / plph1.ListPrice * 100) > 50
ORDER BY ABS((plph2.ListPrice - plph1.ListPrice) / plph1.ListPrice * 100) DESC;

-- 56. Customer segmentation by purchase behavior.
WITH CustomerPurchases AS (
    SELECT
        c.CustomerID,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespan,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
)
SELECT
    CustomerID,
    OrderCount,
    TotalSpend,
    AvgOrderValue,
    DaysSinceLastOrder,
    CustomerLifespan,
    CASE
        WHEN OrderCount >= 10 AND DaysSinceLastOrder <= 90 THEN 'Loyal'
        WHEN OrderCount >= 5 AND DaysSinceLastOrder <= 180 THEN 'Regular'
        WHEN DaysSinceLastOrder <= 90 THEN 'Active'
        WHEN DaysSinceLastOrder BETWEEN 91 AND 365 THEN 'At Risk'
        ELSE 'Churned'
    END AS CustomerSegment
FROM CustomerPurchases
ORDER BY TotalSpend DESC;

-- 57. Product affinity analysis.
WITH ProductPairs AS (
    SELECT
        sod1.SalesOrderID,
        sod1.ProductID AS Product1ID,
        p1.Name AS Product1Name,
        sod2.ProductID AS Product2ID,
        p2.Name AS Product2Name
    FROM Sales.SalesOrderDetail sod1
    JOIN Sales.SalesOrderDetail sod2 ON sod1.SalesOrderID = sod2.SalesOrderID AND sod1.ProductID < sod2.ProductID
    JOIN Production.Product p1 ON sod1.ProductID = p1.ProductID
    JOIN Production.Product p2 ON sod2.ProductID = p2.ProductID
)
SELECT
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    COUNT(*) AS OrdersTogether,
    COUNT(*) / (SELECT COUNT(DISTINCT SalesOrderID) FROM Sales.SalesOrderDetail WHERE ProductID = Product1ID) * 100 AS AffinityPercentage
FROM ProductPairs
GROUP BY Product1ID, Product1Name, Product2ID, Product2Name
HAVING COUNT(*) >= 5
ORDER BY OrdersTogether DESC;

-- 58. Customer lifetime value (CLV) calculation.
WITH CustomerRevenue AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        SUM(soh.TotalDue) AS MonthlyRevenue
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    CustomerID,
    CustomerName,
    SUM(MonthlyRevenue) AS TotalRevenue,
    COUNT(DISTINCT (OrderYear * 100 + OrderMonth)) AS ActiveMonths,
    SUM(MonthlyRevenue) / COUNT(DISTINCT (OrderYear * 100 + OrderMonth)) AS AvgMonthlyRevenue,
    (SUM(MonthlyRevenue) / COUNT(DISTINCT (OrderYear * 100 + OrderMonth))) * 36 AS ProjectedThreeYearValue
FROM CustomerRevenue
GROUP BY CustomerID, CustomerName
ORDER BY ProjectedThreeYearValue DESC;

-- 59. Product performance analysis with seasonality.
SELECT
    p.ProductID,
    p.Name AS ProductName,
    YEAR(soh.OrderDate) AS OrderYear,
    DATEPART(QUARTER, soh.OrderDate) AS OrderQuarter,
    SUM(sod.OrderQty) AS TotalQuantity,
    SUM(sod.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.ProductID, p.Name, YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)
ORDER BY p.ProductID, OrderYear, OrderQuarter;

-- 60. Territory-based sales trend analysis.
WITH TerritorySales AS (
    SELECT
        st.TerritoryID,
        st.Name AS TerritoryName,
        st.CountryRegionCode,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        SUM(soh.TotalDue) AS MonthlySales
    FROM Sales.SalesTerritory st
    JOIN Sales.SalesOrderHeader soh ON st.TerritoryID = soh.TerritoryID
    GROUP BY st.TerritoryID, st.Name, st.CountryRegionCode, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    TerritoryID,
    TerritoryName,
    CountryRegionCode,
    OrderYear,
    OrderMonth,
    MonthlySales,
    LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) AS PreviousMonthSales,
    (MonthlySales - LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth)) /
        NULLIF(LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth), 0) * 100 AS MoMGrowthPercent,
    MonthlySales - LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) AS YoYDifference,
    CASE WHEN LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) IS NOT NULL
         THEN (MonthlySales - LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth)) /
              LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) * 100
         ELSE NULL
    END AS YoYGrowthPercent
FROM TerritorySales
ORDER BY TerritoryID, OrderYear, OrderMonth;

-- 61. Customer acquisition and retention analysis.
WITH CustomerFirstPurchase AS (
    SELECT
        c.CustomerID,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        YEAR(MIN(soh.OrderDate)) AS AcquisitionYear,
        MONTH(MIN(soh.OrderDate)) AS AcquisitionMonth
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
),
CustomerActivity AS (
    SELECT
        c.CustomerID,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS Revenue
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    cfp.AcquisitionYear,
    cfp.AcquisitionMonth,
    COUNT(DISTINCT cfp.CustomerID) AS NewCustomers,
    SUM(CASE WHEN ca.OrderYear = cfp.AcquisitionYear AND ca.OrderMonth = cfp.AcquisitionMonth THEN ca.Revenue ELSE 0 END) AS InitialRevenue,
    COUNT(DISTINCT CASE WHEN ca.OrderYear * 100 + ca.OrderMonth > cfp.AcquisitionYear * 100 + cfp.AcquisitionMonth THEN ca.CustomerID ELSE NULL END) AS RetainedCustomers,
    SUM(CASE WHEN ca.OrderYear * 100 + ca.OrderMonth > cfp.AcquisitionYear * 100 + cfp.AcquisitionMonth THEN ca.Revenue ELSE 0 END) AS RetentionRevenue
FROM CustomerFirstPurchase cfp
LEFT JOIN CustomerActivity ca ON cfp.CustomerID = ca.CustomerID
GROUP BY cfp.AcquisitionYear, cfp.AcquisitionMonth
ORDER BY cfp.AcquisitionYear, cfp.AcquisitionMonth;

-- 62. Sales performance by employee with targets.
WITH EmployeeSales AS (
    SELECT
        e.BusinessEntityID AS EmployeeID,
        p.FirstName + ' ' + p.LastName AS EmployeeName,
        e.JobTitle,
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSales,
        sp.SalesQuota AS MonthlySalesTarget,
        SUM(soh.TotalDue) - sp.SalesQuota AS QuotaDifference,
        CASE
            WHEN sp.SalesQuota > 0 THEN (SUM(soh.TotalDue) / sp.SalesQuota) * 100
            ELSE NULL
        END AS TargetAchievementPercent
    FROM HumanResources.Employee e
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    JOIN Sales.SalesPerson sp ON e.BusinessEntityID = sp.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
    GROUP BY e.BusinessEntityID, p.FirstName, p.LastName, e.JobTitle, YEAR(soh.OrderDate), MONTH(soh.OrderDate), sp.SalesQuota
)
SELECT
    EmployeeID,
    EmployeeName,
    JobTitle,
    SalesYear,
    SalesMonth,
    OrderCount,
    TotalSales,
    SalesQuota,
    QuotaDifference,
    TargetAchievementPercent,
    AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS AvgTeamSales,
    TotalSales - AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS DifferenceFromAvg,
    (TotalSales / AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth)) * 100 AS PercentOfAvg,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY TotalSales DESC) AS SalesRank,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY TargetAchievementPercent DESC) AS QuotaAttainmentRank
FROM EmployeeSales
ORDER BY SalesYear DESC, SalesMonth DESC, TotalSales DESC;

-- 63. Inventory turnover analysis.
WITH ProductInventoryMovement AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        p.ListPrice,
        p.StandardCost,
        SUM(sod.OrderQty) AS TotalSold,
        AVG(ph.Quantity) AS AvgInventoryLevel
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
    JOIN Production.ProductInventoryHistory ph ON p.ProductID = ph.ProductID
    WHERE p.FinishedGoodsFlag = 1
    GROUP BY p.ProductID, p.Name, p.ProductNumber, p.ListPrice, p.StandardCost
)
SELECT
    ProductID,
    ProductName,
    ProductNumber,
    ListPrice,
    StandardCost,
    TotalSold,
    AvgInventoryLevel,
    CASE
        WHEN AvgInventoryLevel = 0 THEN NULL
        ELSE TotalSold / AvgInventoryLevel
    END AS InventoryTurnoverRatio,
    CASE
        WHEN TotalSold = 0 THEN NULL
        ELSE 365 / (TotalSold / NULLIF(AvgInventoryLevel, 0))
    END AS DaysInInventory,
    (ListPrice - StandardCost) * TotalSold AS GrossProfit
FROM ProductInventoryMovement
ORDER BY InventoryTurnoverRatio DESC;

-- 64. Customer demographic analysis.
SELECT
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    DATEDIFF(YEAR, CASE
        WHEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date') > '1900-01-01'
        THEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date')
        ELSE NULL
    END, GETDATE()) AS Age,
    pp.Demographics.value('(/IndividualSurvey/Gender)[1]', 'nvarchar(1)') AS Gender,
    pp.Demographics.value('(/IndividualSurvey/TotalChildren)[1]', 'int') AS TotalChildren,
    pp.Demographics.value('(/IndividualSurvey/NumberChildrenAtHome)[1]', 'int') AS ChildrenAtHome,
    pp.Demographics.value('(/IndividualSurvey/Education)[1]', 'nvarchar(100)') AS Education,
    pp.Demographics.value('(/IndividualSurvey/Occupation)[1]', 'nvarchar(100)') AS Occupation,
    pp.Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]', 'bit') AS HomeOwner,
    pp.Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]', 'int') AS CarsOwned,
    pp.Demographics.value('(/IndividualSurvey/YearlyIncome)[1]', 'nvarchar(100)') AS YearlyIncome,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSpend,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityContact bec ON p.BusinessEntityID = bec.PersonID
JOIN Person.ContactType ct ON bec.ContactTypeID = ct.ContactTypeID
JOIN Person.Person pp ON c.PersonID = pp.BusinessEntityID AND pp.Demographics IS NOT NULL
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY
    c.CustomerID,
    p.FirstName,
    p.LastName,
    pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date'),
    pp.Demographics.value('(/IndividualSurvey/Gender)[1]', 'nvarchar(1)'),
    pp.Demographics.value('(/IndividualSurvey/TotalChildren)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/NumberChildrenAtHome)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/Education)[1]', 'nvarchar(100)'),
    pp.Demographics.value('(/IndividualSurvey/Occupation)[1]', 'nvarchar(100)'),
    pp.Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]', 'bit'),
    pp.Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/YearlyIncome)[1]', 'nvarchar(100)');

-- 65. Product category performance analysis.
SELECT
    pc.ProductCategoryID,
    pc.Name AS CategoryName,
    psc.ProductSubcategoryID,
    psc.Name AS SubcategoryName,
    COUNT(DISTINCT p.ProductID) AS ProductCount,
    SUM(sod.OrderQty) AS TotalQuantitySold,
    SUM(sod.LineTotal) AS TotalRevenue,
    AVG(sod.UnitPrice) AS AvgUnitPrice,
    MIN(sod.UnitPrice) AS MinUnitPrice,
    MAX(sod.UnitPrice) AS MaxUnitPrice,
    SUM(sod.LineTotal) / SUM(sod.OrderQty) AS AvgRevPerUnit,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * p.StandardCost)) AS GrossProfit,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * p.StandardCost)) / SUM(sod.LineTotal) * 100 AS GrossMarginPercent
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory psc ON pc.ProductCategoryID = psc.ProductCategoryID
JOIN Production.Product p ON psc.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY pc.ProductCategoryID, pc.Name, psc.ProductSubcategoryID, psc.Name
ORDER BY TotalRevenue DESC;

-- 66. Sales discounting effect analysis.
WITH OrderDiscounts AS (
    SELECT
        soh.SalesOrderID,
        soh.OrderDate,
        soh.CustomerID,
        soh.TerritoryID,
        st.Name AS TerritoryName,
        sod.ProductID,
        p.Name AS ProductName,
        psc.Name AS SubcategoryName,
        pc.Name AS CategoryName,
        sod.UnitPrice,
        sod.UnitPrice * sod.UnitPriceDiscount * sod.OrderQty AS DiscountAmount,
        sod.LineTotal AS NetRevenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    WHERE sod.UnitPriceDiscount > 0
)
SELECT
    ProductID,
    ProductName,
    SubcategoryName,
    CategoryName,
    COUNT(DISTINCT SalesOrderID) AS DiscountedOrderCount,
    SUM(OrderQty) AS TotalQuantity,
    SUM(GrossRevenue) AS GrossRevenue,
    SUM(DiscountAmount) AS TotalDiscountAmount,
    SUM(NetRevenue) AS NetRevenue,
    AVG(UnitPriceDiscount) * 100 AS AvgDiscountPercent,
    SUM(DiscountAmount) / SUM(GrossRevenue) * 100 AS OverallDiscountPercent,
    -- Calculate effect on volume
    (SELECT COUNT(sod2.SalesOrderDetailID)
     FROM Sales.SalesOrderDetail sod2
     WHERE sod2.ProductID = od.ProductID AND sod2.UnitPriceDiscount > 0) /
    NULLIF((SELECT COUNT(sod3.SalesOrderDetailID)
     FROM Sales.SalesOrderDetail sod3
     WHERE sod3.ProductID = od.ProductID), 0) * 100 AS PercentOrdersDiscounted
FROM OrderDiscounts od
GROUP BY ProductID, ProductName, SubcategoryName, CategoryName
ORDER BY TotalDiscountAmount DESC;

-- 67. Customer RFM (Recency, Frequency, Monetary) analysis.
WITH CustomerPurchases AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS Recency,
        COUNT(DISTINCT soh.SalesOrderID) AS Frequency,
        SUM(soh.TotalDue) AS MonetaryValue
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
RFM_Scores AS (
    SELECT
        CustomerID,
        CustomerName,
        Recency,
        Frequency,
        MonetaryValue,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency) AS F_Score,
        NTILE(5) OVER (ORDER BY MonetaryValue) AS M_Score
    FROM CustomerPurchases
)
SELECT
    CustomerID,
    CustomerName,
    Recency,
    Frequency,
    MonetaryValue,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(R_Score, F_Score, M_Score) AS RFM_Score,
    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score >= 3 THEN 'Recent Loyalists'
        WHEN R_Score >= 4 AND M_Score >= 3 THEN 'Promising'
        WHEN F_Score >= 4 AND M_Score >= 4 THEN 'Needs Attention'
        WHEN R_Score >= 3 THEN 'Potential Loyalists'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'At Risk'
        WHEN R_Score = 1 AND F_Score = 1 THEN 'Lost'
        ELSE 'Others'
    END AS Customer_Segment
FROM RFM_Scores
ORDER BY RFM_Score DESC;

-- 68. Sales return analysis.
SELECT
    sr.SalesOrderID,
    sr.ReturnDate,
    soh.OrderDate,
    DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) AS DaysUntilReturn,
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    srd.ProductID,
    pr.Name AS ProductName,
    psc.Name AS SubcategoryName,
    pc.Name AS CategoryName,
    srd.ReturnQuantity,
    srd.ReturnReason,
    sr.ReturnTotal,
    CASE
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 30 THEN '0-30 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 60 THEN '31-60 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 90 THEN '61-90 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 180 THEN '91-180 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 365 THEN '181-365 Days'
        ELSE 'Over 365 Days'
    END AS ReturnTimeBucket
FROM Sales.SalesReturn sr
JOIN Sales.SalesReturnDetail srd ON sr.SalesReturnID = srd.SalesReturnID
JOIN Sales.SalesOrderHeader soh ON sr.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Production.Product pr ON srd.ProductID = pr.ProductID
JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
ORDER BY sr.ReturnDate DESC;

-- 69. Customer lifetime value prediction model.
WITH CustomerPurchaseHistory AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        SUM(soh.TotalDue) AS TotalSpend,
        COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespanDays
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
CustomerSegments AS (
    SELECT
        cr.*,
        CASE
            WHEN DATEDIFF(MONTH, FirstPurchaseDate, GETDATE()) = 0 THEN 1
            ELSE DATEDIFF(MONTH, FirstPurchaseDate, GETDATE())
        END AS CustomerAgeMonths,
        CASE
            WHEN TotalSpend > 50000 THEN 'High Value'
            WHEN TotalSpend > 10000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS ValueSegment
    FROM CustomerPurchaseHistory cr
)
SELECT
    ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalSpend) AS AvgLifetimeRevenue,
    AVG(TotalSpend / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalSpend) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalSpend) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    -- Payback period in months (how long to recoup acquisition cost)
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalSpend / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
GROUP BY ValueSegment
UNION ALL
SELECT
    'Overall' AS ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalSpend) AS AvgLifetimeRevenue,
    AVG(TotalSpend / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalSpend) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalSpend) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalSpend / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
ORDER BY CASE WHEN ValueSegment = 'Overall' THEN 1 ELSE 0 END, AvgNetCustomerValue DESC;

-- 70. Price elasticity analysis.
WITH PriceElasticity AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ListPrice,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0) AS ActualPrice,
        (p.ListPrice - ROUND(sod.UnitPrice, 0)) / p.ListPrice * 100 AS DiscountPercent,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.OrderQty) AS UnitsSold
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE p.ListPrice > 0 -- Exclude free products
    GROUP BY
        p.ProductID,
        p.Name,
        p.ListPrice,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0)
),
ElasticityCalculation AS (
    SELECT
        pe1.ProductID,
        pe1.ProductName,
        pe1.StandardCost,
        pe1.ListPrice,
        pe1.DiscountPercent AS Discount1,
        pe2.DiscountPercent AS Discount2,
        pe1.UnitsSold AS UnitsSold1,
        pe2.UnitsSold AS UnitsSold2,
        -- Calculate price elasticity where higher value means more responsive to price changes
        ABS((pe2.UnitsSold - pe1.UnitsSold) / NULLIF(pe1.UnitsSold, 0)) /
        NULLIF(ABS((pe2.DiscountPercent - pe1.DiscountPercent) / NULLIF(pe1.DiscountPercent, 0)), 0) AS PriceElasticity
    FROM PriceElasticity pe1
    JOIN PriceElasticity pe2 ON
        pe1.ProductID = pe2.ProductID AND
        pe1.DiscountPercent < pe2.DiscountPercent -- Compare different discount levels
)
SELECT
    ProductID,
    ProductName,
    ListPrice,
    StandardCost,
    -- Calculate average elasticity across all discount comparisons
    AVG(PriceElasticity) AS AvgElasticity,
    -- Calculate optimal discount based on elasticity
    CASE
        WHEN AVG(PriceElasticity) > 1.5 THEN 25 -- Highly elastic (price sensitive)
        WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 15 -- Moderately elastic
        WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 10 -- Slightly elastic
        ELSE 5 -- Inelastic (not price sensitive)
    END AS RecommendedBaseDiscount,
    -- Apply seasonal adjustment to current month (example)
    CASE
        WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
            CASE
                WHEN AVG(PriceElasticity) > 1.5 THEN 30 -- Higher discount for elastic products
                WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 20
                WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 15
                ELSE 10
            END
        ELSE -- Regular season
            CASE
                WHEN AVG(PriceElasticity) > 1.5 THEN 25
                WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 15
                WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 10
                ELSE 5
            END
    END AS SeasonallyAdjustedDiscount,
    -- Calculate optimal price
    ListPrice * (1 -
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    ) AS OptimalPrice,
    -- Calculate expected profit margin
    (ListPrice * (1 -
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    ) - StandardCost) /
    (ListPrice * (1 -
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    )) * 100 AS ExpectedProfitMargin
FROM ElasticityCalculation
GROUP BY ProductID, ProductName, ListPrice, StandardCost
HAVING COUNT(*) >= 3 -- Require multiple price points for reliable elasticity calculation
ORDER BY AvgElasticity DESC;

-- 71. Employee performance reporting and benchmarking.
WITH SalesByEmployee AS (
    SELECT
        sp.BusinessEntityID AS EmployeeID,
        p.FirstName + ' ' + p.LastName AS EmployeeName,
        e.JobTitle,
        e.HireDate,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
        st.TerritoryID,
        st.Name AS Territory,
        st.CountryRegionCode,
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSales,
        sp.SalesQuota,
        SUM(soh.TotalDue) - sp.SalesQuota AS QuotaDifference,
        CASE
            WHEN sp.SalesQuota > 0 THEN (SUM(soh.TotalDue) / sp.SalesQuota) * 100
            ELSE NULL
        END AS QuotaAttainmentPercent
    FROM Sales.SalesPerson sp
    JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
    JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
    GROUP BY
        sp.BusinessEntityID,
        p.FirstName,
        p.LastName,
        e.JobTitle,
        e.HireDate,
        st.TerritoryID,
        st.Name,
        st.CountryRegionCode,
        YEAR(soh.OrderDate),
        MONTH(soh.OrderDate),
        sp.SalesQuota
)
SELECT
    EmployeeID,
    EmployeeName,
    JobTitle,
    YearsOfService,
    Territory,
    CountryRegionCode,
    SalesYear,
    SalesMonth,
    OrderCount,
    TotalSales,
    SalesQuota,
    QuotaDifference,
    QuotaAttainmentPercent,
    AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS AvgTeamSales,
    TotalSales - AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS DifferenceFromAvg,
    (TotalSales / AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth)) * 100 AS PercentOfAvg,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY TotalSales DESC) AS SalesRank,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY QuotaAttainmentPercent DESC) AS QuotaAttainmentRank
FROM SalesByEmployee
ORDER BY SalesYear DESC, SalesMonth DESC, TotalSales DESC;

-- 72. Forecasting sales using seasonal trends (continuing from your document).
WITH MonthlySales AS (
    SELECT
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        SUM(soh.TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader soh
    GROUP BY YEAR(soh.OrderDate), MONTH(soh.OrderDate)
),
YearlyTrends AS (
    SELECT
        SalesYear,
        AVG(TotalSales) AS AvgMonthlySales,
        SUM(TotalSales) AS AnnualSales
    FROM MonthlySales
    GROUP BY SalesYear
),
SeasonalFactors AS (
    SELECT
        SalesMonth,
        AVG(TotalSales) / (SELECT AVG(TotalSales) FROM MonthlySales) AS SeasonalIndex
    FROM MonthlySales
    GROUP BY SalesMonth
),
GrowthRate AS (
    SELECT
        (SELECT MAX(AnnualSales) FROM YearlyTrends) /
        NULLIF((SELECT MIN(AnnualSales) FROM YearlyTrends), 0) AS TotalGrowth,
        POWER(
            (SELECT MAX(AnnualSales) FROM YearlyTrends) /
            NULLIF((SELECT MIN(AnnualSales) FROM YearlyTrends), 0),
            1.0 / NULLIF((SELECT MAX(SalesYear) - MIN(SalesYear) FROM YearlyTrends), 0)
        ) - 1 AS AnnualGrowthRate
    FROM YearlyTrends
    WHERE SalesYear IN (SELECT MIN(SalesYear) FROM YearlyTrends UNION SELECT MAX(SalesYear) FROM YearlyTrends)
)
SELECT
    m.SalesYear,
    m.SalesMonth,
    m.TotalSales AS ActualSales,
    CASE
        WHEN LEAD(m.SalesYear) OVER (ORDER BY m.SalesYear, m.SalesMonth) IS NULL
        THEN
            (SELECT AvgMonthlySales FROM YearlyTrends WHERE SalesYear = MAX(m.SalesYear OVER())) *
            (1 + (SELECT AnnualGrowthRate FROM GrowthRate)) *
            (SELECT SeasonalIndex FROM SeasonalFactors WHERE SalesMonth = m.SalesMonth)
    END AS ForecastedNextPeriod
FROM MonthlySales m
ORDER BY m.SalesYear, m.SalesMonth;

-- 73. Customer segmentation by purchase behavior.
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        MAX(soh.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) /
            NULLIF(COUNT(DISTINCT soh.SalesOrderID) - 1, 0) AS AvgDaysBetweenOrders,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
)
SELECT
    CustomerID,
    CustomerName,
    FirstPurchaseDate,
    LastPurchaseDate,
    OrderCount,
    TotalSpend,
    AvgOrderValue,
    AvgDaysBetweenOrders,
    DaysSinceLastOrder,
    CASE
        WHEN OrderCount > 10 AND TotalSpend > 50000 THEN 'High-Value Regular'
        WHEN OrderCount > 10 AND TotalSpend <= 50000 THEN 'Regular Customer'
        WHEN OrderCount <= 10 AND TotalSpend > 50000 THEN 'High-Value Occasional'
        WHEN OrderCount <= 10 AND TotalSpend <= 50000 THEN 'Standard Customer'
        WHEN OrderCount = 1 THEN 'One-Time Customer'
        ELSE 'Unknown'
    END AS CustomerSegment,
    CASE
        WHEN DaysSinceLastOrder <= 90 THEN 'Active'
        WHEN DaysSinceLastOrder <= 365 THEN 'At Risk'
        ELSE 'Inactive'
    END AS ActivityStatus
FROM CustomerMetrics
ORDER BY TotalSpend DESC;

-- 74. Product bundle analysis.
WITH ProductBundles AS (
    SELECT
        sod1.SalesOrderID,
        sod1.ProductID AS Product1ID,
        p1.Name AS Product1Name,
        sod2.ProductID AS Product2ID,
        p2.Name AS Product2Name,
        sod3.ProductID AS Product3ID,
        p3.Name AS Product3Name
    FROM Sales.SalesOrderDetail sod1
    JOIN Sales.SalesOrderDetail sod2 ON sod1.SalesOrderID = sod2.SalesOrderID AND sod1.ProductID < sod2.ProductID
    JOIN Sales.SalesOrderDetail sod3 ON sod2.SalesOrderID = sod3.SalesOrderID AND sod2.ProductID < sod3.ProductID
    JOIN Production.Product p1 ON sod1.ProductID = p1.ProductID
    JOIN Production.Product p2 ON sod2.ProductID = p2.ProductID
    JOIN Production.Product p3 ON sod3.ProductID = p3.ProductID
)
SELECT
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    Product3ID,
    Product3Name,
    COUNT(*) AS BundleFrequency,
    -- Calculate support (percentage of all orders that contain this bundle)
    COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT SalesOrderID) FROM Sales.SalesOrderDetail) AS SupportPercent,
    -- Calculate average order value when this bundle appears
    AVG((SELECT SUM(LineTotal) FROM Sales.SalesOrderDetail WHERE SalesOrderID = pb.SalesOrderID)) AS AvgOrderValue
FROM ProductBundles pb
GROUP BY
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    Product3ID,
    Product3Name
HAVING COUNT(*) >= 5 -- Filter for significant co-occurrences
ORDER BY BundleFrequency DESC;

-- 75. Sales channel effectiveness analysis.
WITH SalesChannels AS (
    SELECT
        soh.SalesOrderID,
        soh.OnlineOrderFlag,
        CASE
            WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
            ELSE 'In-Store'
        END AS SalesChannel,
        soh.OrderDate,
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        st.TerritoryID,
        st.Name AS TerritoryName,
        SUM(soh.TotalDue) AS OrderTotal,
        COUNT(DISTINCT sod.ProductID) AS UniqueProducts,
        SUM(sod.OrderQty) AS TotalQuantity
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    GROUP BY
        soh.SalesOrderID,
        soh.OnlineOrderFlag,
        soh.OrderDate,
        c.CustomerID,
        p.FirstName,
        p.LastName,
        st.TerritoryID,
        st.Name
)
SELECT
    SalesChannel,
    COUNT(DISTINCT SalesOrderID) AS OrderCount,
    COUNT(DISTINCT CustomerID) AS CustomerCount,
    SUM(OrderTotal) AS TotalRevenue,
    AVG(OrderTotal) AS AvgOrderValue,
    SUM(OrderTotal) / COUNT(DISTINCT CustomerID) AS AvgRevenuePerCustomer,
    AVG(UniqueProducts) AS AvgProductsPerOrder,
    AVG(TotalQuantity) AS AvgQuantityPerOrder,
    MIN(OrderTotal) AS MinOrderValue,
    MAX(OrderTotal) AS MaxOrderValue,
    (SELECT TOP 1 TerritoryName
     FROM SalesChannels sc
     WHERE sc.SalesChannel = sc2.SalesChannel
     GROUP BY TerritoryName
     ORDER BY COUNT(*) DESC) AS TopTerritory
FROM SalesChannels sc2
GROUP BY SalesChannel
UNION ALL
SELECT
    'Overall' AS SalesChannel,
    COUNT(DISTINCT SalesOrderID) AS OrderCount,
    COUNT(DISTINCT CustomerID) AS CustomerCount,
    SUM(OrderTotal) AS TotalRevenue,
    AVG(OrderTotal) AS AvgOrderValue,
    SUM(OrderTotal) / COUNT(DISTINCT CustomerID) AS AvgRevenuePerCustomer,
    AVG(UniqueProducts) AS AvgProductsPerOrder,
    AVG(TotalQuantity) AS AvgQuantityPerOrder,
    MIN(OrderTotal) AS MinOrderValue,
    MAX(OrderTotal) AS MaxOrderValue,
    (SELECT TOP 1 TerritoryName FROM SalesChannels GROUP BY TerritoryName ORDER BY COUNT(*) DESC) AS TopTerritory
FROM SalesChannels;

-- 76. Customer acquisition cost and lifetime value comparison.
WITH CustomerRevenue AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        SUM(soh.TotalDue) AS TotalRevenue,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        1000 * RAND(CHECKSUM(NEWID())) AS EstimatedAcquisitionCost -- Simulated acquisition cost
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
CustomerSegments AS (
    SELECT
        cr.*,
        CASE
            WHEN DATEDIFF(MONTH, FirstPurchaseDate, GETDATE()) = 0 THEN 1
            ELSE DATEDIFF(MONTH, FirstPurchaseDate, GETDATE())
        END AS CustomerAgeMonths,
        CASE
            WHEN TotalRevenue > 50000 THEN 'High Value'
            WHEN TotalRevenue > 10000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS ValueSegment
    FROM CustomerRevenue cr
)
SELECT
    ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalRevenue) AS AvgLifetimeRevenue,
    AVG(TotalRevenue / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalRevenue) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalRevenue) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    -- Payback period in months (how long to recoup acquisition cost)
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalRevenue / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
GROUP BY ValueSegment
UNION ALL
SELECT
    'Overall' AS ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalRevenue) AS AvgLifetimeRevenue,
    AVG(TotalRevenue / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalRevenue) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalRevenue) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalRevenue / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
ORDER BY CASE WHEN ValueSegment = 'Overall' THEN 1 ELSE 0 END, AvgNetCustomerValue DESC;

-- 77. Customer purchase path analysis.
WITH OrderSequence AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        soh.SalesOrderID,
        soh.OrderDate,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY soh.OrderDate) AS OrderSequence,
        soh.TotalDue AS OrderTotal,
        COUNT(DISTINCT sod.ProductID) AS UniqueProducts,
        STRING_AGG(pr.Name, ', ') WITHIN GROUP (ORDER BY pr.Name) AS Products,
        STRING_AGG(psc.Name, ', ') WITHIN GROUP (ORDER BY psc.Name) AS Categories
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product pr ON sod.ProductID = pr.ProductID
    LEFT JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
    GROUP BY
        c.CustomerID,
        p.FirstName,
        p.LastName,
        soh.SalesOrderID,
        soh.OrderDate,
        soh.TotalDue
),
PathAnalysis AS (
    SELECT
        o1.CustomerID,
        o1.CustomerName,
        o1.OrderSequence AS FirstOrderNum,
        o2.OrderSequence AS SecondOrderNum,
        o1.Categories AS FirstOrderCategories,
        o2.Categories AS SecondOrderCategories,
        DATEDIFF(DAY, o1.OrderDate, o2.OrderDate) AS DaysBetweenOrders,
        o1.OrderTotal AS FirstOrderTotal,
        o2.OrderTotal AS SecondOrderTotal
    FROM OrderSequence o1
    JOIN OrderSequence o2 ON o1.CustomerID = o2.CustomerID AND o1.OrderSequence + 1 = o2.OrderSequence
)
SELECT
    FirstOrderCategories,
    SecondOrderCategories,
    COUNT(*) AS PathFrequency,
    AVG(DaysBetweenOrders) AS AvgDaysBetweenOrders,
    AVG(SecondOrderTotal) AS AvgSecondOrderValue,
    AVG(SecondOrderTotal - FirstOrderTotal) AS AvgOrderValueChange,
    AVG(SecondOrderTotal) / NULLIF(AVG(FirstOrderTotal), 0) * 100 - 100 AS AvgOrderValueChangePercent
FROM PathAnalysis
GROUP BY FirstOrderCategories, SecondOrderCategories
HAVING COUNT(*) >= 5
ORDER BY PathFrequency DESC;

-- 78. Price optimization analysis.
WITH ProductPricePoints AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0) AS PricePoint,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.OrderQty) AS TotalQuantity,
        SUM(sod.LineTotal) AS TotalRevenue,
        SUM(sod.LineTotal) - (SUM(sod.OrderQty) * p.StandardCost) AS TotalProfit
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY p.ProductID, p.Name, p.StandardCost, ROUND(sod.UnitPrice, 0)
)
SELECT
    ProductID,
    ProductName,
    StandardCost,
    PricePoint,
    (PricePoint - StandardCost) / NULLIF(StandardCost, 0) * 100 AS MarkupPercent,
    OrderCount,
    TotalQuantity,
    TotalRevenue,
    TotalProfit,
    TotalProfit / NULLIF(TotalRevenue, 0) * 100 AS ProfitMarginPercent,
    -- Rank each price point by profit for each product
    RANK() OVER(PARTITION BY ProductID ORDER BY TotalProfit DESC) AS ProfitRank,
    -- Rank each price point by revenue for each product
    RANK() OVER(PARTITION BY ProductID ORDER BY TotalRevenue DESC) AS RevenueRank,
    -- Rank each price point by quantity for each product
    RANK() OVER(PARTITION BY ProductID ORDER BY TotalQuantity DESC) AS VolumeRank
FROM ProductPricePoints
WHERE TotalQuantity > 10 -- Filter for significant sales volume
ORDER BY AvgElasticity DESC;

-- 79. Conversion funnel analysis.
WITH SalesProcess AS (
    SELECT
        cp.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        qh.QuoteDate,
        qh.QuoteID,
        soh.SalesOrderID,
        soh.OrderDate,
        DATEDIFF(DAY, qh.QuoteDate, soh.OrderDate) AS DaysToConvert,
        qh.TotalAmount AS QuoteAmount,
        soh.TotalDue AS OrderAmount,
        CASE
            WHEN soh.SalesOrderID IS NOT NULL THEN 1
            ELSE 0
        END AS Converted,
        qh.QuoteStatus
    FROM Sales.Customer cp
    JOIN Person.Person p ON cp.PersonID = p.BusinessEntityID
    JOIN Sales.QuoteHeader qh ON cp.CustomerID = qh.CustomerID
    LEFT JOIN Sales.SalesOrderHeader soh ON qh.QuoteID = soh.QuoteID
),
FunnelStages AS (
    SELECT
        MONTH(QuoteDate) AS QuoteMonth,
        YEAR(QuoteDate) AS QuoteYear,
        COUNT(DISTINCT QuoteID) AS TotalQuotes,
        SUM(Converted) AS ConvertedQuotes,
        AVG(CASE WHEN Converted = 1 THEN DaysToConvert ELSE NULL END) AS AvgDaysToConversion,
        SUM(CASE WHEN Converted = 1 THEN OrderAmount ELSE 0 END) AS TotalOrderValue,
        AVG(CASE WHEN Converted = 1 THEN OrderAmount ELSE NULL END) AS AvgOrderValue,
        AVG(CASE WHEN Converted = 1 THEN OrderAmount - QuoteAmount ELSE NULL END) AS AvgUpsellAmount
    FROM SalesProcess
    GROUP BY MONTH(QuoteDate), YEAR(QuoteDate)
)
SELECT
    QuoteYear,
    QuoteMonth,
    TotalQuotes,
    ConvertedQuotes,
    CAST(ConvertedQuotes AS FLOAT) / NULLIF(TotalQuotes, 0) * 100 AS ConversionRate,
    AvgDaysToConversion,
    TotalOrderValue,
    AvgOrderValue,
    AvgUpsellAmount,
    -- Period-over-period analysis
    LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth) AS PrevPeriodQuotes,
    (TotalQuotes - LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth)) /
        NULLIF(LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth), 0) * 100 AS QuotesGrowthPercent,
    (CAST(ConvertedQuotes AS FLOAT) / NULLIF(TotalQuotes, 0)) -
        (LAG(CAST(ConvertedQuotes AS FLOAT)) OVER (ORDER BY QuoteYear, QuoteMonth) /
        NULLIF(LAG(TotalQuotes) OVER (ORDER BY QuoteYear, QuoteMonth), 0)) AS ConversionRateChange
FROM FunnelStages
ORDER BY QuoteYear, QuoteMonth;

-- 80. Repeat purchase probability analysis.
WITH CustomerPurchaseCounts AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespan
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
    HAVING COUNT(DISTINCT soh.SalesOrderID) > 1 -- Only customers with more than one order
),
RepeatIntervals AS (
    SELECT
        soh1.CustomerID,
        soh1.SalesOrderID AS FirstOrderID,
        soh2.SalesOrderID AS NextOrderID,
        soh1.OrderDate AS FirstOrderDate,
        soh2.OrderDate AS NextOrderDate,
        DATEDIFF(DAY, soh1.OrderDate, soh2.OrderDate) AS DaysBetweenOrders
    FROM Sales.SalesOrderHeader soh1
    JOIN Sales.SalesOrderHeader soh2 ON
        soh1.CustomerID = soh2.CustomerID AND
        soh1.SalesOrderID < soh2.SalesOrderID AND
        soh2.OrderDate = (
            SELECT MIN(OrderDate)
            FROM Sales.SalesOrderHeader soh3
            WHERE soh3.CustomerID = soh1.CustomerID AND soh3.OrderDate > soh1.OrderDate
        )
)
SELECT
    CASE
        WHEN DaysBetweenOrders <= 30 THEN '0-30 Days'
        WHEN DaysBetweenOrders <= 60 THEN '31-60 Days'
        WHEN DaysBetweenOrders <= 90 THEN '61-90 Days'
        WHEN DaysBetweenOrders <= 180 THEN '91-180 Days'
        WHEN DaysBetweenOrders <= 365 THEN '181-365 Days'
        ELSE 'Over 365 Days'
    END AS TimeBucket,
    COUNT(*) AS RepeatCustomerCount,
    CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM CustomerPurchaseCounts) * 100 AS PercentOfTotalCustomers,
    MIN(DaysBetweenOrders) AS MinDays,
    MAX(DaysBetweenOrders) AS MaxDays,
    AVG(DaysBetweenOrders) AS AvgDays,
    -- Calculate probability of next purchase in this time bucket
    CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM RepeatIntervals) AS ProbabilityOfRepeatInPeriod
FROM RepeatIntervals
GROUP BY
    CASE
        WHEN DaysBetweenOrders <= 30 THEN '0-30 Days'
        WHEN DaysBetweenOrders <= 60 THEN '31-60 Days'
        WHEN DaysBetweenOrders <= 90 THEN '61-90 Days'
        WHEN DaysBetweenOrders <= 180 THEN '91-180 Days'
        WHEN DaysBetweenOrders <= 365 THEN '181-365 Days'
        ELSE 'Over 365 Days'
    END
ORDER BY MIN(DaysBetweenOrders);

-- 81. Product feature impact analysis.
WITH ProductVersionSales AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductLine,
        p.Class,
        p.Style,
        p.ProductModelID,
        pm.Name AS ModelName,
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        SUM(sod.OrderQty) AS SalesQuantity,
        SUM(sod.LineTotal) AS SalesRevenue,
        COUNT(DISTINCT soh.CustomerID) AS UniqueCustomers
    FROM Production.Product p
    JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY
        p.ProductID,
        p.Name,
        p.ProductLine,
        p.Class,
        p.Style,
        p.ProductModelID,
        pm.Name,
        YEAR(soh.OrderDate),
        MONTH(soh.OrderDate)
)
SELECT
    Feature,
    FeatureValue,
    COUNT(DISTINCT ProductID) AS ProductCount,
    SUM(SalesQuantity) AS TotalUnitsSold,
    SUM(SalesRevenue) AS TotalRevenue,
    SUM(UniqueCustomers) AS TotalCustomers,
    AVG(SalesQuantity) AS AvgUnitsSoldPerProduct,
    AVG(SalesRevenue) AS AvgRevenuePerProduct,
    AVG(UniqueCustomers) AS AvgCustomersPerProduct
FROM (
    SELECT ProductID, ProductName, ProductLine AS Feature, ProductLine AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
    UNION ALL
    SELECT ProductID, ProductName, 'Class' AS Feature, Class AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
    UNION ALL
    SELECT ProductID, ProductName, 'Style' AS Feature, Style AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
    UNION ALL
    SELECT ProductID, ProductName, 'Model' AS Feature, ModelName AS FeatureValue, SalesQuantity, SalesRevenue, UniqueCustomers FROM ProductVersionSales
) AS FeatureSales
WHERE FeatureValue IS NOT NULL
GROUP BY Feature, FeatureValue
ORDER BY Feature, TotalRevenue DESC;

-- 82. Cross-sell opportunity identification.
WITH CustomerProductCategories AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        pc.ProductCategoryID,
        pc.Name AS CategoryName,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.LineTotal) AS TotalSpend
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product pr ON sod.ProductID = pr.ProductID
    JOIN Production.ProductSubcategory ps ON pr.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    GROUP BY
        c.CustomerID,
        p.FirstName,
        p.LastName,
        pc.ProductCategoryID,
        pc.Name
),
CategoryGaps AS (
    SELECT
        cpc.CustomerID,
        cpc.CustomerName,
        pc.ProductCategoryID,
        pc.Name AS MissingCategory,
        (SELECT SUM(TotalSpend) FROM CustomerProductCategories WHERE CustomerID = cpc.CustomerID) AS CustomerTotalSpend,
        (SELECT AVG(TotalSpend) FROM CustomerProductCategories WHERE ProductCategoryID = pc.ProductCategoryID) AS AvgCategorySpend
    FROM CustomerProductCategories cpc
    CROSS JOIN Production.ProductCategory pc
    WHERE NOT EXISTS (
        SELECT 1 FROM CustomerProductCategories cpc2
        WHERE cpc2.CustomerID = cpc.CustomerID AND cpc2.ProductCategoryID = pc.ProductCategoryID
    )
)
SELECT
    CustomerID,
    CustomerName,
    MissingCategory,
    CustomerTotalSpend,
    AvgCategorySpend,
    -- Calculate cross-sell potential score (higher is better)
    CAST(CustomerTotalSpend AS FLOAT) / 1000 * CAST(AvgCategorySpend AS FLOAT) / 100 AS CrossSellScore,
    -- Recommend top products from missing category
    (
        SELECT TOP 3 STRING_AGG(p.Name, ', ') WITHIN GROUP (ORDER BY SUM(sod.LineTotal) DESC)
        FROM Production.Product p
        JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
        JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
        JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
        WHERE pc.Name = MissingCategory
        GROUP BY p.ProductID, p.Name
    ) AS RecommendedProducts
FROM CategoryGaps
WHERE CustomerTotalSpend > 5000 -- Focus on customers with significant spending
ORDER BY CrossSellScore DESC;

-- 83. Customer churn risk detection (completing the query).
WITH CustomerActivity AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        MAX(soh.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespanDays,
        COUNT(DISTINCT soh.SalesOrderID) /
            NULLIF(DATEDIFF(MONTH, MIN(soh.OrderDate), MAX(soh.OrderDate)), 0) AS OrdersPerMonth
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
ChurnRiskFactors AS (
    SELECT
        ca.*,
        -- Calculate typical interval between orders
        CASE
            WHEN OrderCount <= 1 THEN NULL
            ELSE CustomerLifespanDays / (OrderCount - 1)
        END AS AvgDaysBetweenOrders,
        -- Calculate how many intervals since last order
        CASE
            WHEN OrderCount <= 1 THEN NULL
            ELSE DaysSinceLastOrder / NULLIF(CustomerLifespanDays / (OrderCount - 1), 0)
        END AS IntervalsSinceLastOrder
    FROM CustomerActivity ca
)
SELECT
    CustomerID,
    CustomerName,
    FirstPurchaseDate,
    LastPurchaseDate,
    OrderCount,
    TotalSpend,
    DaysSinceLastOrder,
    AvgDaysBetweenOrders,
    IntervalsSinceLastOrder,
    -- Calculate churn risk score (0-100)
    CASE
        WHEN OrderCount = 1 AND DaysSinceLastOrder > 180 THEN 90 -- High risk for one-time buyers
        WHEN IntervalsSinceLastOrder > 3 THEN 80 -- Very high risk
        WHEN IntervalsSinceLastOrder BETWEEN 2 AND 3 THEN 60 -- High risk
        WHEN IntervalsSinceLastOrder BETWEEN 1.5 AND 2 THEN 40 -- Medium risk
        WHEN IntervalsSinceLastOrder BETWEEN 1 AND 1.5 THEN 20 -- Low risk
        WHEN IntervalsSinceLastOrder < 1 THEN 10 -- Very low risk
        ELSE 50 -- Default medium risk
    END AS ChurnRiskScore,
    -- Churn risk category
    CASE
        WHEN OrderCount = 1 AND DaysSinceLastOrder > 180 THEN 'High Risk One-Time Customer'
        WHEN IntervalsSinceLastOrder > 3 THEN 'Very High Risk'
        WHEN IntervalsSinceLastOrder BETWEEN 2 AND 3 THEN 'High Risk'
        WHEN IntervalsSinceLastOrder BETWEEN 1.5 AND 2 THEN 'Medium Risk'
        WHEN IntervalsSinceLastOrder BETWEEN 1 AND 1.5 THEN 'Low Risk'
        WHEN IntervalsSinceLastOrder < 1 THEN 'Active'
        ELSE 'Medium Risk'
    END AS ChurnRiskCategory,
    -- Recommended action
    CASE
        WHEN OrderCount = 1 AND DaysSinceLastOrder > 180 THEN 'Reactivation campaign with discount'
        WHEN IntervalsSinceLastOrder > 3 THEN 'Urgent win-back offer'
        WHEN IntervalsSinceLastOrder BETWEEN 2 AND 3 THEN 'Targeted promotion'
        WHEN IntervalsSinceLastOrder BETWEEN 1.5 AND 2 THEN 'Check-in email'
        WHEN IntervalsSinceLastOrder BETWEEN 1 AND 1.5 THEN 'Nurture campaign'
        WHEN IntervalsSinceLastOrder < 1 THEN 'Standard engagement'
        ELSE 'Engagement campaign'
    END AS RecommendedAction
FROM ChurnRiskFactors
WHERE OrderCount > 0 -- Ensure customer has made at least one order
ORDER BY ChurnRiskScore DESC;

-- 84. Product affinity analysis.
WITH ProductPairs AS (
    SELECT
        sod1.SalesOrderID,
        sod1.ProductID AS Product1ID,
        p1.Name AS Product1Name,
        sod2.ProductID AS Product2ID,
        p2.Name AS Product2Name
    FROM Sales.SalesOrderDetail sod1
    JOIN Sales.SalesOrderDetail sod2 ON
        sod1.SalesOrderID = sod2.SalesOrderID AND
        sod1.ProductID < sod2.ProductID -- Ensure unique pairs
    JOIN Production.Product p1 ON sod1.ProductID = p1.ProductID
    JOIN Production.Product p2 ON sod2.ProductID = p2.ProductID
),
ProductMetrics AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        COUNT(DISTINCT sod.SalesOrderID) AS TotalOrders
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    GROUP BY p.ProductID, p.Name
),
PairAnalysis AS (
    SELECT
        pp.Product1ID,
        pp.Product1Name,
        pp.Product2ID,
        pp.Product2Name,
        COUNT(DISTINCT pp.SalesOrderID) AS PairFrequency,
        pm1.TotalOrders AS Product1Orders,
        pm2.TotalOrders AS Product2Orders,
        COUNT(DISTINCT pp.SalesOrderID) * 1.0 / (SELECT COUNT(*)
        FROM Sales.SalesOrderHeader) AS Support,
        COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm1.TotalOrders AS Confidence1to2,
        COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm2.TotalOrders AS Confidence2to1,
        (COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm1.TotalOrders) /
        (pm2.TotalOrders * 1.0 / (SELECT COUNT(*) FROM Sales.SalesOrderHeader)) AS Lift1to2,
        (COUNT(DISTINCT pp.SalesOrderID) * 1.0 / pm2.TotalOrders) /
        (pm1.TotalOrders * 1.0 / (SELECT COUNT(*) FROM Sales.SalesOrderHeader)) AS Lift2to1
    FROM ProductPairs pp
    JOIN ProductMetrics pm1 ON pp.Product1ID = pm1.ProductID
    JOIN ProductMetrics pm2 ON pp.Product2ID = pm2.ProductID
    GROUP BY
        pp.Product1ID,
        pp.Product1Name,
        pp.Product2ID,
        pp.Product2Name,
        pm1.TotalOrders,
        pm2.TotalOrders
)
SELECT
    Product1ID,
    Product1Name,
    Product2ID,
    Product2Name,
    PairFrequency,
    Support,
    Confidence1to2,
    Confidence2to1,
    Lift1to2,
    Lift2to1,
    -- Categorize relationship strength
    CASE
        WHEN Lift1to2 > 3 THEN 'Very Strong'
        WHEN Lift1to2 BETWEEN 2 AND 3 THEN 'Strong'
        WHEN Lift1to2 BETWEEN 1 AND 2 THEN 'Positive'
        WHEN Lift1to2 < 1 THEN 'Negative'
    END AS RelationshipStrength,
    -- Recommendation action
    CASE
        WHEN Lift1to2 > 3 THEN 'Bundle offer'
        WHEN Lift1to2 BETWEEN 2 AND 3 THEN 'Cross-promote'
        WHEN Lift1to2 BETWEEN 1 AND 2 THEN 'Suggest on product page'
        ELSE 'No recommendation'
    END AS RecommendedAction
FROM PairAnalysis
WHERE PairFrequency >= 5 -- Filter for significant co-occurrences
ORDER BY Lift1to2 DESC;

-- 85. Seasonal product trend analysis.
WITH ProductMonthlySales AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductSubcategoryID,
        ps.Name AS SubcategoryName,
        pc.Name AS CategoryName,
        MONTH(soh.OrderDate) AS SalesMonth,
        YEAR(soh.OrderDate) AS SalesYear,
        SUM(sod.OrderQty) AS UnitsSold,
        SUM(sod.LineTotal) AS Revenue
    FROM Production.Product p
    JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY
        p.ProductID,
        p.Name,
        p.ProductSubcategoryID,
        ps.Name,
        pc.Name,
        MONTH(soh.OrderDate),
        YEAR(soh.OrderDate)
),
MonthlyAverages AS (
    SELECT
        ProductID,
        ProductName,
        SubcategoryName,
        CategoryName,
        SalesMonth,
        AVG(UnitsSold) AS AvgMonthlySales,
        STDEV(UnitsSold) AS StdevMonthlySales,
        AVG(Revenue) AS AvgMonthlyRevenue,
        COUNT(DISTINCT SalesYear) AS YearsWithData
    FROM ProductMonthlySales
    GROUP BY ProductID, ProductName, SubcategoryName, CategoryName, SalesMonth
)
SELECT
    ma.ProductID,
    ma.ProductName,
    ma.SubcategoryName,
    ma.CategoryName,
    ma.SalesMonth,
    CASE ma.SalesMonth
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS MonthName,
    ma.AvgMonthlySales,
    (ma.AvgMonthlySales / NULLIF((SELECT AVG(AvgMonthlySales) FROM MonthlyAverages ma2 WHERE ma2.ProductID = ma.ProductID), 0) * 100) - 100 AS PercentVarianceFromAvg,
    ma.AvgMonthlyRevenue,
    ma.YearsWithData,
    RANK() OVER(PARTITION BY ma.ProductID ORDER BY ma.AvgMonthlySales DESC) AS MonthRank,
    CASE
        WHEN ma.AvgMonthlySales > 1.3 * (SELECT AVG(AvgMonthlySales) FROM MonthlyAverages ma2 WHERE ma2.ProductID = ma.ProductID)
        THEN 'Peak Season'
        WHEN ma.AvgMonthlySales < 0.7 * (SELECT AVG(AvgMonthlySales) FROM MonthlyAverages ma2 WHERE ma2.ProductID = ma.ProductID)
        THEN 'Off Season'
        ELSE 'Regular Season'
    END AS SeasonalityStatus
FROM MonthlyAverages ma
WHERE ma.YearsWithData >= 2 -- Ensure multiple years of data for reliable seasonality
ORDER BY ma.ProductID, ma.SalesMonth;

-- 86. Dynamic pricing model.
WITH PriceElasticity AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ListPrice,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0) AS ActualPrice,
        (p.ListPrice - ROUND(sod.UnitPrice, 0)) / p.ListPrice * 100 AS DiscountPercent,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(sod.OrderQty) AS UnitsSold
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE p.ListPrice > 0 -- Exclude free products
    GROUP BY
        p.ProductID,
        p.Name,
        p.ListPrice,
        p.StandardCost,
        ROUND(sod.UnitPrice, 0)
),
ElasticityCalculation AS (
    SELECT
        pe1.ProductID,
        pe1.ProductName,
        pe1.StandardCost,
        pe1.ListPrice,
        pe1.DiscountPercent AS Discount1,
        pe2.DiscountPercent AS Discount2,
        pe1.UnitsSold AS UnitsSold1,
        pe2.UnitsSold AS UnitsSold2,
        -- Calculate price elasticity where higher value means more responsive to price changes
        ABS((pe2.UnitsSold - pe1.UnitsSold) / NULLIF(pe1.UnitsSold, 0)) /
        NULLIF(ABS((pe2.DiscountPercent - pe1.DiscountPercent) / NULLIF(pe1.DiscountPercent, 0)), 0) AS PriceElasticity
    FROM PriceElasticity pe1
    JOIN PriceElasticity pe2 ON
        pe1.ProductID = pe2.ProductID AND
        pe1.DiscountPercent < pe2.DiscountPercent -- Compare different discount levels
)
SELECT
    ProductID,
    ProductName,
    ListPrice,
    StandardCost,
    -- Calculate average elasticity across all discount comparisons
    AVG(PriceElasticity) AS AvgElasticity,
    -- Calculate optimal discount based on elasticity
    CASE
        WHEN AVG(PriceElasticity) > 1.5 THEN 25 -- Highly elastic (price sensitive)
        WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 15 -- Moderately elastic
        WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 10 -- Slightly elastic
        ELSE 5 -- Inelastic (not price sensitive)
    END AS RecommendedBaseDiscount,
    -- Apply seasonal adjustment to current month (example)
    CASE
        WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
            CASE
                WHEN AVG(PriceElasticity) > 1.5 THEN 30 -- Higher discount for elastic products
                WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 20
                WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 15
                ELSE 10
            END
        ELSE -- Regular season
            CASE
                WHEN AVG(PriceElasticity) > 1.5 THEN 25
                WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 15
                WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 10
                ELSE 5
            END
    END AS SeasonallyAdjustedDiscount,
    -- Calculate optimal price
    ListPrice * (1 -
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    ) AS OptimalPrice,
    -- Calculate expected profit margin
    (ListPrice * (1 -
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    ) - StandardCost) /
    (ListPrice * (1 -
        CASE
            WHEN MONTH(GETDATE()) IN (11, 12) THEN -- Holiday season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.30
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.20
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.15
                    ELSE 0.10
                END
            ELSE -- Regular season
                CASE
                    WHEN AVG(PriceElasticity) > 1.5 THEN 0.25
                    WHEN AVG(PriceElasticity) BETWEEN 1 AND 1.5 THEN 0.15
                    WHEN AVG(PriceElasticity) BETWEEN 0.5 AND 1 THEN 0.10
                    ELSE 0.05
                END
        END
    )) * 100 AS ExpectedProfitMargin
FROM ElasticityCalculation
GROUP BY ProductID, ProductName, ListPrice, StandardCost
HAVING COUNT(*) >= 3 -- Require multiple price points for reliable elasticity calculation
ORDER BY AvgElasticity DESC;

-- 87. Marketing attribution model.
WITH CustomerTouchpoints AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        em.CampaignID,
        cam.Name AS CampaignName,
        cam.Type AS CampaignType,
        em.TouchDate,
        em.TouchpointType,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY em.TouchDate) AS TouchSequence,
        LEAD(em.TouchDate) OVER (PARTITION BY c.CustomerID ORDER BY em.TouchDate) AS NextTouchDate
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Marketing.CustomerEngagement em ON c.CustomerID = em.CustomerID
    JOIN Marketing.Campaign cam ON em.CampaignID = cam.CampaignID
),
PurchaseEvents AS (
    SELECT
        c.CustomerID,
        soh.SalesOrderID,
        soh.OrderDate,
        soh.TotalDue AS Revenue
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
),
AttributionModel AS (
    SELECT
        tp.CustomerID,
        tp.CustomerName,
        tp.CampaignID,
        tp.CampaignName,
        tp.CampaignType,
        tp.TouchpointType,
        tp.TouchSequence,
        pe.SalesOrderID,
        pe.OrderDate,
        pe.Revenue,
        -- First-touch attribution
        CASE WHEN tp.TouchSequence = 1 THEN 1 ELSE 0 END AS IsFirstTouch,
        -- Last-touch attribution
        CASE WHEN tp.TouchDate = (
            SELECT MAX(TouchDate)
            FROM CustomerTouchpoints
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) THEN 1 ELSE 0 END AS IsLastTouch,
        -- Linear attribution (equal weight to all touchpoints)
        1.0 / (
            SELECT COUNT(*)
            FROM CustomerTouchpoints
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) AS LinearWeight,
        -- Time-decay attribution (more weight to recent touchpoints)
        EXP(-0.1 * DATEDIFF(DAY, tp.TouchDate, pe.OrderDate)) / (
            SELECT SUM(EXP(-0.1 * DATEDIFF(DAY, TouchDate, pe.OrderDate)))
            FROM CustomerTouchpoints
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) AS TimeDecayWeight
    FROM CustomerTouchpoints tp
    JOIN PurchaseEvents pe ON tp.CustomerID = pe.CustomerID
    WHERE tp.TouchDate <= pe.OrderDate -- Touch happened before purchase
    AND (tp.NextTouchDate IS NULL OR tp.NextTouchDate > pe.OrderDate) -- Last touch before purchase
)
SELECT
    CampaignID,
    CampaignName,
    CampaignType,
    -- First-touch attribution
    SUM(CASE WHEN IsFirstTouch = 1 THEN Revenue ELSE 0 END) AS FirstTouchRevenue,
    SUM(CASE WHEN IsFirstTouch = 1 THEN 1 ELSE 0 END) AS FirstTouchConversions,
    -- Last-touch attribution
    SUM(CASE WHEN IsLastTouch = 1 THEN Revenue ELSE 0 END) AS LastTouchRevenue,
    SUM(CASE WHEN IsLastTouch = 1 THEN 1 ELSE 0 END) AS LastTouchConversions,
    -- Linear attribution
    SUM(Revenue * LinearWeight) AS LinearAttributedRevenue,
    SUM(LinearWeight) AS LinearAttributedConversions,
    -- Time-decay attribution
    SUM(Revenue * TimeDecayWeight) AS TimeDecayAttributedRevenue,
    SUM(TimeDecayWeight) AS TimeDecayAttributedConversions,
    -- Multi-touch comparison
    SUM(Revenue * LinearWeight) / NULLIF(AVG(CAM.Cost), 0) AS LinearROI,
    SUM(Revenue * TimeDecayWeight) / NULLIF(AVG(CAM.Cost), 0) AS TimeDecayROI
FROM AttributionModel AM
JOIN Marketing.Campaign CAM ON AM.CampaignID = CAM.CampaignID
GROUP BY CampaignID, CampaignName, CampaignType
ORDER BY TimeDecayAttributedRevenue DESC;

-- 88. Inventory optimization model.
WITH ProductDemand AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        p.ReorderPoint,
        p.StandardCost,
        p.ListPrice,
        p.DaysToManufacture,
        p.SafetyStockLevel,
        MONTH(soh.OrderDate) AS OrderMonth,
        YEAR(soh.OrderDate) AS OrderYear,
        SUM(sod.OrderQty) AS MonthlySales,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.ReorderPoint,
        p.StandardCost,
        p.ListPrice,
        p.DaysToManufacture,
        p.SafetyStockLevel,
        MONTH(soh.OrderDate),
        YEAR(soh.OrderDate)
),
ProductMetrics AS (
    SELECT
        ProductID,
        ProductName,
        ProductNumber,
        ReorderPoint,
        StandardCost,
        ListPrice,
        DaysToManufacture,
        SafetyStockLevel,
        AVG(MonthlySales) AS AvgMonthlySales,
        STDEV(MonthlySales) AS StdevMonthlySales,
        AVG(MonthlySales) + STDEV(MonthlySales) AS MaxMonthlySales,
        AVG(MonthlySales) - STDEV(MonthlySales) AS MinMonthlySales,
        AVG(MonthlySales) * 1.2 AS OptimisticDemand,
        AVG(MonthlySales) * 0.8 AS PessimisticDemand
    FROM ProductDemand
    GROUP BY
        ProductID,
        ProductName,
        ProductNumber,
        ReorderPoint,
        StandardCost,
        ListPrice,
        DaysToManufacture,
        SafetyStockLevel
)
SELECT
    ProductID,
    ProductName,
    ProductNumber,
    ListPrice,
    StandardCost,
    ReorderPoint,
    DaysToManufacture,
    SafetyStockLevel,
    AvgMonthlySales,
    StdevMonthlySales,
    MaxMonthlySales,
    MinMonthlySales,
    OptimisticDemand,
    PessimisticDemand,
    -- Calculate optimal reorder point
    CASE
        WHEN AvgMonthlySales > 0 THEN
            CEILING(AvgMonthlySales * (DaysToManufacture + SafetyStockLevel) / 30.0)
        ELSE
            ReorderPoint
    END AS OptimalReorderPoint,
    -- Calculate optimal order quantity
    CASE
        WHEN AvgMonthlySales > 0 THEN
            CEILING(OptimisticDemand * (DaysToManufacture + SafetyStockLevel) / 30.0)
        ELSE
            ReorderPoint
    END AS OptimalOrderQuantity,
    -- Calculate potential savings from optimizing inventory
    (ReorderPoint - CEILING(AvgMonthlySales * (DaysToManufacture + SafetyStockLevel) / 30.0)) * StandardCost AS PotentialSavings
FROM ProductMetrics
ORDER BY PotentialSavings DESC;

-- 89. Customer lifetime value prediction.
WITH CustomerPurchaseHistory AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        YEAR(soh.OrderDate) AS PurchaseYear,
        MONTH(soh.OrderDate) AS PurchaseMonth,
        MIN(soh.OrderDate) AS FirstOrderDate,
        SUM(soh.TotalDue) AS YearlySpend
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY
        c.CustomerID,
        p.FirstName,
        p.LastName,
        YEAR(soh.OrderDate),
        MONTH(soh.OrderDate)
),
CustomerMetrics AS (
    SELECT
        CustomerID,
        CustomerName,
        MIN(FirstOrderDate) AS FirstPurchaseEver,
        MAX(PurchaseYear) AS LastPurchaseYear,
        MAX(PurchaseMonth) AS LastPurchaseMonth,
        DATEDIFF(MONTH, MIN(FirstOrderDate), MAX(FirstOrderDate)) + 1 AS TotalActiveMonths,
        SUM(YearlySpend) AS TotalSpend,
        SUM(YearlySpend) / NULLIF(COUNT(DISTINCT PurchaseYear), 0) AS AvgYearlySpend,
        SUM(YearlySpend) / NULLIF(COUNT(DISTINCT PurchaseMonth), 0) AS AvgMonthlySpend,
        COUNT(DISTINCT PurchaseYear) / NULLIF(DATEDIFF(MONTH, MIN(FirstOrderDate), MAX(FirstOrderDate)) + 1, 0) AS OrderFrequency,
        DATEDIFF(MONTH, MAX(PurchaseYear) * 100 + MAX(PurchaseMonth), GETDATE()) AS MonthsSinceLastPurchase
    FROM CustomerPurchaseHistory
    GROUP BY CustomerID, CustomerName
),
ChurnProbability AS (
    SELECT
        CustomerID,
        CustomerName,
        FirstPurchaseEver,
        LastPurchaseYear,
        LastPurchaseMonth,
        TotalActiveMonths,
        TotalSpend,
        AvgYearlySpend,
        AvgMonthlySpend,
        OrderFrequency,
        MonthsSinceLastPurchase,
        -- Calculate retention probability (inverse of churn)
        CASE
            WHEN MonthsSinceLastPurchase > TotalActiveMonths * 2 THEN 0.1 -- Likely churned
            WHEN MonthsSinceLastPurchase > TotalActiveMonths THEN 0.3 -- At high risk
            WHEN MonthsSinceLastPurchase > TotalActiveMonths / 2 THEN 0.5 -- At medium risk
            WHEN MonthsSinceLastPurchase > 0 THEN 0.8 -- Low risk
            ELSE 0.9 -- Active customer
        END AS RetentionProbability,
        -- Expected future lifetime in months
        CASE
            WHEN MonthsSinceLastPurchase > TotalActiveMonths * 2 THEN 0 -- Likely churned
            WHEN MonthsSinceLastPurchase > TotalActiveMonths THEN 3 -- At high risk
            WHEN MonthsSinceLastPurchase > TotalActiveMonths / 2 THEN 12 -- At medium risk
            WHEN MonthsSinceLastPurchase > 0 THEN 24 -- Low risk
            ELSE 36 -- Active customer
        END AS ExpectedFutureMonths,
        -- Calculate churn risk score (0-100)
        CASE
            WHEN OrderFrequency = 1 AND MonthsSinceLastPurchase > 180 THEN 90 -- High risk for one-time buyers
            WHEN MonthsSinceLastPurchase > TotalActiveMonths * 2 THEN 80 -- Very high risk
            WHEN MonthsSinceLastPurchase BETWEEN TotalActiveMonths AND TotalActiveMonths * 2 THEN 60 -- High risk
            WHEN MonthsSinceLastPurchase BETWEEN TotalActiveMonths / 2 AND TotalActiveMonths THEN 40 -- Medium risk
            WHEN MonthsSinceLastPurchase BETWEEN 0 AND TotalActiveMonths / 2 THEN 20 -- Low risk
            WHEN MonthsSinceLastPurchase = 0 THEN 10 -- Very low risk
            ELSE 50 -- Default medium risk
        END AS ChurnRiskScore
    FROM CustomerMetrics
)
SELECT
    CustomerID,
    CustomerName,
    TotalSpend,
    AvgYearlySpend,
    AvgMonthlySpend,
    OrderFrequency,
    DATEDIFF(MONTH, FirstPurchaseEver, GETDATE()) AS MonthsSinceFirstPurchase,
    MonthsSinceLastPurchase,
    RetentionProbability,
    -- Current CLV (historical value)
    TotalSpend AS CurrentCLV,
    -- Predicted CLV (current + future value)
    TotalSpend + (AvgMonthlySpend * ExpectedFutureMonths * RetentionProbability) AS PredictedCLV,
    -- CLV to CAC ratio (assuming acquisition cost for demonstration)
    (TotalSpend + (AvgMonthlySpend * ExpectedFutureMonths * RetentionProbability)) / 1000 AS CLVtoCACRatio,
    -- Customer tier based on predicted CLV
    CASE
        WHEN TotalSpend + (AvgMonthlySpend * ExpectedFutureMonths * RetentionProbability) > 50000 THEN 'Premium'
        WHEN TotalSpend + (AvgMonthlySpend * ExpectedFutureMonths * RetentionProbability) > 25000 THEN 'Gold'
        WHEN TotalSpend + (AvgMonthlySpend * ExpectedFutureMonths * RetentionProbability) > 10000 THEN 'Silver'
        ELSE 'Bronze'
    END AS CustomerTier
FROM ChurnProbability
ORDER BY PredictedCLV DESC;

-- 90. Customer segmentation by purchase behavior.
WITH CustomerMetrics AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        MAX(soh.OrderDate) AS LastPurchaseDate,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSpend,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) /
            NULLIF(COUNT(DISTINCT soh.SalesOrderID) - 1, 0) AS AvgDaysBetweenOrders,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS DaysSinceLastOrder
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
)
SELECT
    CustomerID,
    CustomerName,
    FirstPurchaseDate,
    LastPurchaseDate,
    OrderCount,
    TotalSpend,
    AvgOrderValue,
    AvgDaysBetweenOrders,
    DaysSinceLastOrder,
    CASE
        WHEN OrderCount > 10 AND TotalSpend > 50000 THEN 'High-Value Regular'
        WHEN OrderCount > 10 AND TotalSpend <= 50000 THEN 'Regular Customer'
        WHEN OrderCount <= 10 AND TotalSpend > 50000 THEN 'High-Value Occasional'
        WHEN OrderCount <= 10 AND TotalSpend <= 50000 THEN 'Standard Customer'
        WHEN OrderCount = 1 THEN 'One-Time Customer'
        ELSE 'Unknown'
    END AS CustomerSegment,
    CASE
        WHEN DaysSinceLastOrder <= 90 THEN 'Active'
        WHEN DaysSinceLastOrder <= 365 THEN 'At Risk'
        ELSE 'Inactive'
    END AS ActivityStatus
FROM CustomerMetrics
ORDER BY TotalSpend DESC;

-- 91. Product performance analysis with seasonality.
SELECT
    p.ProductID,
    p.Name AS ProductName,
    YEAR(soh.OrderDate) AS OrderYear,
    DATEPART(QUARTER, soh.OrderDate) AS OrderQuarter,
    SUM(sod.OrderQty) AS TotalQuantity,
    SUM(sod.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    AVG(sod.UnitPrice) AS AvgUnitPrice
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY p.ProductID, p.Name, YEAR(soh.OrderDate), DATEPART(QUARTER, soh.OrderDate)
ORDER BY p.ProductID, OrderYear, OrderQuarter;

-- 92. Territory-based sales trend analysis.
WITH TerritorySales AS (
    SELECT
        st.TerritoryID,
        st.Name AS TerritoryName,
        st.CountryRegionCode,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        SUM(soh.TotalDue) AS MonthlySales
    FROM Sales.SalesTerritory st
    JOIN Sales.SalesOrderHeader soh ON st.TerritoryID = soh.TerritoryID
    GROUP BY st.TerritoryID, st.Name, st.CountryRegionCode, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    TerritoryID,
    TerritoryName,
    CountryRegionCode,
    OrderYear,
    OrderMonth,
    MonthlySales,
    LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) AS PreviousMonthSales,
    (MonthlySales - LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth)) /
        NULLIF(LAG(MonthlySales, 1, 0) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth), 0) * 100 AS MoMGrowthPercent,
    MonthlySales - LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) AS YoYDifference,
    CASE WHEN LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) IS NOT NULL
         THEN (MonthlySales - LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth)) /
              LAG(MonthlySales, 12, NULL) OVER (PARTITION BY TerritoryID ORDER BY OrderYear, OrderMonth) * 100
         ELSE NULL
    END AS YoYGrowthPercent
FROM TerritorySales
ORDER BY TerritoryID, OrderYear, OrderMonth;

-- 93. Customer acquisition and retention analysis.
WITH CustomerFirstPurchase AS (
    SELECT
        c.CustomerID,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        YEAR(MIN(soh.OrderDate)) AS AcquisitionYear,
        MONTH(MIN(soh.OrderDate)) AS AcquisitionMonth
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID
),
CustomerActivity AS (
    SELECT
        c.CustomerID,
        YEAR(soh.OrderDate) AS OrderYear,
        MONTH(soh.OrderDate) AS OrderMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS Revenue
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
)
SELECT
    cfp.AcquisitionYear,
    cfp.AcquisitionMonth,
    COUNT(DISTINCT cfp.CustomerID) AS NewCustomers,
    SUM(CASE WHEN ca.OrderYear = cfp.AcquisitionYear AND ca.OrderMonth = cfp.AcquisitionMonth THEN ca.Revenue ELSE 0 END) AS InitialRevenue,
    COUNT(DISTINCT CASE WHEN ca.OrderYear * 100 + ca.OrderMonth > cfp.AcquisitionYear * 100 + cfp.AcquisitionMonth THEN ca.CustomerID ELSE NULL END) AS RetainedCustomers,
    SUM(CASE WHEN ca.OrderYear * 100 + ca.OrderMonth > cfp.AcquisitionYear * 100 + cfp.AcquisitionMonth THEN ca.Revenue ELSE 0 END) AS RetentionRevenue
FROM CustomerFirstPurchase cfp
LEFT JOIN CustomerActivity ca ON cfp.CustomerID = ca.CustomerID
GROUP BY cfp.AcquisitionYear, cfp.AcquisitionMonth
ORDER BY cfp.AcquisitionYear, cfp.AcquisitionMonth;

-- 94. Sales performance by employee with targets.
WITH EmployeeSales AS (
    SELECT
        e.BusinessEntityID AS EmployeeID,
        p.FirstName + ' ' + p.LastName AS EmployeeName,
        e.JobTitle,
        YEAR(soh.OrderDate) AS SalesYear,
        MONTH(soh.OrderDate) AS SalesMonth,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
        SUM(soh.TotalDue) AS TotalSales,
        sp.SalesQuota AS MonthlySalesTarget,
        SUM(soh.TotalDue) - sp.SalesQuota AS QuotaDifference,
        CASE
            WHEN sp.SalesQuota > 0 THEN (SUM(soh.TotalDue) / sp.SalesQuota) * 100
            ELSE NULL
        END AS TargetAchievementPercent
    FROM Sales.SalesPerson sp
    JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
    JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
    GROUP BY e.BusinessEntityID, p.FirstName, p.LastName, e.JobTitle, YEAR(soh.OrderDate), MONTH(soh.OrderDate), sp.SalesQuota
)
SELECT
    EmployeeID,
    EmployeeName,
    JobTitle,
    SalesYear,
    SalesMonth,
    OrderCount,
    TotalSales,
    SalesQuota,
    QuotaDifference,
    TargetAchievementPercent,
    AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS AvgTeamSales,
    TotalSales - AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth) AS DifferenceFromAvg,
    (TotalSales / AVG(TotalSales) OVER (PARTITION BY SalesYear, SalesMonth)) * 100 AS PercentOfAvg,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY TotalSales DESC) AS SalesRank,
    RANK() OVER (PARTITION BY SalesYear, SalesMonth ORDER BY TargetAchievementPercent DESC) AS QuotaAttainmentRank
FROM EmployeeSales
ORDER BY SalesYear DESC, SalesMonth DESC, TotalSales DESC;

-- 95. Inventory turnover analysis.
WITH ProductInventoryMovement AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        p.ListPrice,
        p.StandardCost,
        SUM(sod.OrderQty) AS TotalSold,
        AVG(ph.Quantity) AS AvgInventoryLevel
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
    JOIN Production.ProductInventoryHistory ph ON p.ProductID = ph.ProductID
    WHERE p.FinishedGoodsFlag = 1
    GROUP BY p.ProductID, p.Name, p.ProductNumber, p.ListPrice, p.StandardCost
)
SELECT
    ProductID,
    ProductName,
    ProductNumber,
    ListPrice,
    StandardCost,
    TotalSold,
    AvgInventoryLevel,
    CASE
        WHEN AvgInventoryLevel = 0 THEN NULL
        ELSE TotalSold / AvgInventoryLevel
    END AS InventoryTurnoverRatio,
    CASE
        WHEN TotalSold = 0 THEN NULL
        ELSE 365 / (TotalSold / NULLIF(AvgInventoryLevel, 0))
    END AS DaysInInventory,
    (ListPrice - StandardCost) * TotalSold AS GrossProfit
FROM ProductInventoryMovement
ORDER BY InventoryTurnoverRatio DESC;

-- 96. Customer demographic analysis.
SELECT
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    DATEDIFF(YEAR, CASE
        WHEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date') > '1900-01-01'
        THEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date')
        ELSE NULL
    END, GETDATE()) AS Age,
    pp.Demographics.value('(/IndividualSurvey/Gender)[1]', 'nvarchar(1)') AS Gender,
    pp.Demographics.value('(/IndividualSurvey/TotalChildren)[1]', 'int') AS TotalChildren,
    pp.Demographics.value('(/IndividualSurvey/NumberChildrenAtHome)[1]', 'int') AS ChildrenAtHome,
    pp.Demographics.value('(/IndividualSurvey/Education)[1]', 'nvarchar(100)') AS Education,
    pp.Demographics.value('(/IndividualSurvey/Occupation)[1]', 'nvarchar(100)') AS Occupation,
    pp.Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]', 'bit') AS HomeOwner,
    pp.Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]', 'int') AS CarsOwned,
    pp.Demographics.value('(/IndividualSurvey/YearlyIncome)[1]', 'nvarchar(100)') AS YearlyIncome,
    COUNT(DISTINCT soh.SalesOrderID) AS OrderCount,
    SUM(soh.TotalDue) AS TotalSpend,
    AVG(soh.TotalDue) AS AvgOrderValue
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityContact bec ON p.BusinessEntityID = bec.PersonID
JOIN Person.ContactType ct ON bec.ContactTypeID = ct.ContactTypeID
JOIN Person.Person pp ON c.PersonID = pp.BusinessEntityID AND pp.Demographics IS NOT NULL
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY
    c.CustomerID,
    p.FirstName,
    p.LastName,
    pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date'),
    pp.Demographics.value('(/IndividualSurvey/Gender)[1]', 'nvarchar(1)'),
    pp.Demographics.value('(/IndividualSurvey/TotalChildren)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/NumberChildrenAtHome)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/Education)[1]', 'nvarchar(100)'),
    pp.Demographics.value('(/IndividualSurvey/Occupation)[1]', 'nvarchar(100)'),
    pp.Demographics.value('(/IndividualSurvey/HomeOwnerFlag)[1]', 'bit'),
    pp.Demographics.value('(/IndividualSurvey/NumberCarsOwned)[1]', 'int'),
    pp.Demographics.value('(/IndividualSurvey/YearlyIncome)[1]', 'nvarchar(100)');

-- 97. Product category performance analysis.
SELECT
    pc.ProductCategoryID,
    pc.Name AS CategoryName,
    psc.ProductSubcategoryID,
    psc.Name AS SubcategoryName,
    COUNT(DISTINCT p.ProductID) AS ProductCount,
    SUM(sod.OrderQty) AS TotalQuantitySold,
    SUM(sod.LineTotal) AS TotalRevenue,
    AVG(sod.UnitPrice) AS AvgUnitPrice,
    MIN(sod.UnitPrice) AS MinUnitPrice,
    MAX(sod.UnitPrice) AS MaxUnitPrice,
    SUM(sod.LineTotal) / SUM(sod.OrderQty) AS AvgRevPerUnit,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * p.StandardCost)) AS GrossProfit,
    (SUM(sod.LineTotal) - SUM(sod.OrderQty * p.StandardCost)) / SUM(sod.LineTotal) * 100 AS GrossMarginPercent
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory psc ON pc.ProductCategoryID = psc.ProductCategoryID
JOIN Production.Product p ON psc.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY pc.ProductCategoryID, pc.Name, psc.ProductSubcategoryID, psc.Name
ORDER BY TotalRevenue DESC;

-- 98. Sales discounting effect analysis.
WITH OrderDiscounts AS (
    SELECT
        soh.SalesOrderID,
        soh.OrderDate,
        soh.CustomerID,
        soh.TerritoryID,
        st.Name AS TerritoryName,
        sod.ProductID,
        p.Name AS ProductName,
        psc.Name AS SubcategoryName,
        pc.Name AS CategoryName,
        sod.UnitPrice,
        sod.UnitPrice * sod.UnitPriceDiscount * sod.OrderQty AS DiscountAmount,
        sod.LineTotal AS NetRevenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Production.Product p ON sod.ProductID = p.ProductID
    JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
    JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
    WHERE sod.UnitPriceDiscount > 0
)
SELECT
    ProductID,
    ProductName,
    SubcategoryName,
    CategoryName,
    COUNT(DISTINCT SalesOrderID) AS DiscountedOrderCount,
    SUM(OrderQty) AS TotalQuantity,
    SUM(GrossRevenue) AS GrossRevenue,
    SUM(DiscountAmount) AS TotalDiscountAmount,
    SUM(NetRevenue) AS NetRevenue,
    AVG(UnitPriceDiscount) * 100 AS AvgDiscountPercent,
    SUM(DiscountAmount) / SUM(GrossRevenue) * 100 AS OverallDiscountPercent,
    -- Calculate effect on volume
    (SELECT COUNT(sod2.SalesOrderDetailID)
     FROM Sales.SalesOrderDetail sod2
     WHERE sod2.ProductID = od.ProductID AND sod2.UnitPriceDiscount > 0) /
    NULLIF((SELECT COUNT(sod3.SalesOrderDetailID)
     FROM Sales.SalesOrderDetail sod3
     WHERE sod3.ProductID = od.ProductID), 0) * 100 AS PercentOrdersDiscounted
FROM OrderDiscounts od
GROUP BY ProductID, ProductName, SubcategoryName, CategoryName
ORDER BY TotalDiscountAmount DESC;

-- 99. Customer RFM (Recency, Frequency, Monetary) analysis.
WITH CustomerPurchases AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        DATEDIFF(DAY, MAX(soh.OrderDate), GETDATE()) AS Recency,
        COUNT(DISTINCT soh.SalesOrderID) AS Frequency,
        SUM(soh.TotalDue) AS MonetaryValue
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
RFM_Scores AS (
    SELECT
        CustomerID,
        CustomerName,
        Recency,
        Frequency,
        MonetaryValue,
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency) AS F_Score,
        NTILE(5) OVER (ORDER BY MonetaryValue) AS M_Score
    FROM CustomerPurchases
)
SELECT
    CustomerID,
    CustomerName,
    Recency,
    Frequency,
    MonetaryValue,
    R_Score,
    F_Score,
    M_Score,
    CONCAT(R_Score, F_Score, M_Score) AS RFM_Score,
    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score >= 3 THEN 'Recent Loyalists'
        WHEN R_Score >= 4 AND M_Score >= 3 THEN 'Promising'
        WHEN F_Score >= 4 AND M_Score >= 4 THEN 'Needs Attention'
        WHEN R_Score >= 3 THEN 'Potential Loyalists'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'At Risk'
        WHEN R_Score = 1 AND F_Score = 1 THEN 'Lost'
        ELSE 'Others'
    END AS Customer_Segment
FROM RFM_Scores
ORDER BY RFM_Score DESC;

-- 100. Sales return analysis.
SELECT
    sr.SalesOrderID,
    sr.ReturnDate,
    soh.OrderDate,
    DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) AS DaysUntilReturn,
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    srd.ProductID,
    pr.Name AS ProductName,
    psc.Name AS SubcategoryName,
    pc.Name AS CategoryName,
    srd.ReturnQuantity,
    srd.ReturnReason,
    sr.ReturnTotal,
    CASE
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 30 THEN '0-30 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 60 THEN '31-60 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 90 THEN '61-90 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 180 THEN '91-180 Days'
        WHEN DATEDIFF(DAY, soh.OrderDate, sr.ReturnDate) <= 365 THEN '181-365 Days'
        ELSE 'Over 365 Days'
    END AS ReturnTimeBucket
FROM Sales.SalesReturn sr
JOIN Sales.SalesReturnDetail srd ON sr.SalesReturnID = srd.SalesReturnID
JOIN Sales.SalesOrderHeader soh ON sr.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Production.Product pr ON srd.ProductID = pr.ProductID
JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
ORDER BY sr.ReturnDate DESC;

-- 101. Customer lifetime value prediction model.
WITH CustomerPurchaseHistory AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        MIN(soh.OrderDate) AS FirstPurchaseDate,
        SUM(soh.TotalDue) AS TotalSpend,
        COUNT(DISTINCT soh.SalesOrderID) AS TotalOrders,
        AVG(soh.TotalDue) AS AvgOrderValue,
        DATEDIFF(DAY, MIN(soh.OrderDate), MAX(soh.OrderDate)) AS CustomerLifespanDays
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
),
CustomerSegments AS (
    SELECT
        cr.*,
        CASE
            WHEN DATEDIFF(MONTH, FirstPurchaseDate, GETDATE()) = 0 THEN 1
            ELSE DATEDIFF(MONTH, FirstPurchaseDate, GETDATE())
        END AS CustomerAgeMonths,
        CASE
            WHEN TotalSpend > 50000 THEN 'High Value'
            WHEN TotalSpend > 10000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS ValueSegment
    FROM CustomerPurchaseHistory cr
)
SELECT
    ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalSpend) AS AvgLifetimeRevenue,
    AVG(TotalSpend / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalSpend) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalSpend) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    -- Payback period in months (how long to recoup acquisition cost)
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalSpend / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
GROUP BY ValueSegment
UNION ALL
SELECT
    'Overall' AS ValueSegment,
    COUNT(CustomerID) AS CustomerCount,
    AVG(EstimatedAcquisitionCost) AS AvgAcquisitionCost,
    AVG(TotalSpend) AS AvgLifetimeRevenue,
    AVG(TotalSpend / CustomerAgeMonths) AS AvgMonthlyRevenue,
    AVG(TotalSpend) - AVG(EstimatedAcquisitionCost) AS AvgNetCustomerValue,
    AVG(TotalSpend) / NULLIF(AVG(EstimatedAcquisitionCost), 0) AS ROI,
    AVG(CustomerAgeMonths) AS AvgCustomerAgeMonths,
    AVG(EstimatedAcquisitionCost) / NULLIF(AVG(TotalSpend / CustomerAgeMonths), 0) AS AvgPaybackPeriodMonths
FROM CustomerSegments
ORDER BY CASE WHEN ValueSegment = 'Overall' THEN 1 ELSE 0 END, AvgNetCustomerValue DESC;

-- 102. Marketing attribution model.
WITH CustomerTouchpoints AS (
    SELECT
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        em.CampaignID,
        cam.Name AS CampaignName,
        cam.Type AS CampaignType,
        em.TouchDate,
        em.TouchpointType,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY em.TouchDate) AS TouchSequence,
        LEAD(em.TouchDate) OVER (PARTITION BY c.CustomerID ORDER BY em.TouchDate) AS NextTouchDate
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Marketing.CustomerEngagement em ON c.CustomerID = em.CustomerID
    JOIN Marketing.Campaign cam ON em.CampaignID = cam.CampaignID
),
PurchaseEvents AS (
    SELECT
        c.CustomerID,
        soh.SalesOrderID,
        soh.OrderDate,
        soh.TotalDue AS Revenue
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
),
AttributionModel AS (
    SELECT
        tp.CustomerID,
        tp.CustomerName,
        tp.CampaignID,
        tp.CampaignName,
        tp.CampaignType,
        tp.TouchpointType,
        tp.TouchSequence,
        pe.SalesOrderID,
        pe.OrderDate,
        pe.Revenue,
        -- First-touch attribution
        CASE WHEN tp.TouchSequence = 1 THEN 1 ELSE 0 END AS IsFirstTouch,
        -- Last-touch attribution
        CASE WHEN tp.TouchDate = (
            SELECT MAX(TouchDate)
            FROM CustomerTouchpoints
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) THEN 1 ELSE 0 END AS IsLastTouch,
        -- Linear attribution (equal weight to all touchpoints)
        1.0 / (
            SELECT COUNT(*)
            FROM CustomerTouchpoints
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) AS LinearWeight,
        -- Time-decay attribution (more weight to recent touchpoints)
        EXP(-0.1 * DATEDIFF(DAY, tp.TouchDate, pe.OrderDate)) / (
            SELECT SUM(EXP(-0.1 * DATEDIFF(DAY, TouchDate, pe.OrderDate)))
            FROM CustomerTouchpoints
            WHERE CustomerID = tp.CustomerID AND TouchDate <= pe.OrderDate
        ) AS TimeDecayWeight
    FROM CustomerTouchpoints tp
    JOIN PurchaseEvents pe ON tp.CustomerID = pe.CustomerID
    WHERE tp.TouchDate <= pe.OrderDate -- Touch happened before purchase
    AND (tp.NextTouchDate IS NULL OR tp.NextTouchDate > pe.OrderDate) -- Last touch before purchase
)
SELECT
    CampaignID,
    CampaignName,
    CampaignType,
    -- First-touch attribution
    SUM(CASE WHEN IsFirstTouch = 1 THEN Revenue ELSE 0 END) AS FirstTouchRevenue,
    SUM(CASE WHEN IsFirstTouch = 1 THEN 1 ELSE 0 END) AS FirstTouchConversions,
    -- Last-touch attribution
    SUM(CASE WHEN IsLastTouch = 1 THEN Revenue ELSE 0 END) AS LastTouchRevenue,
    SUM(CASE WHEN IsLastTouch = 1 THEN 1 ELSE 0 END) AS LastTouchConversions,
    -- Linear attribution
    SUM(Revenue * LinearWeight) AS LinearAttributedRevenue,
    SUM(LinearWeight) AS LinearAttributedConversions,
    -- Time-decay attribution
    SUM(Revenue * TimeDecayWeight) AS TimeDecayAttributedRevenue,
    SUM(TimeDecayWeight) AS TimeDecayAttributedConversions,
    -- Multi-touch comparison
    SUM(Revenue * LinearWeight) / NULLIF(AVG(CAM.Cost), 0) AS LinearROI,
    SUM(Revenue * TimeDecayWeight) / NULLIF(AVG(CAM.Cost), 0) AS TimeDecayROI
FROM AttributionModel AM
JOIN Marketing.Campaign CAM ON AM.CampaignID = CAM.CampaignID
GROUP BY CampaignID, CampaignName, CampaignType
ORDER BY TimeDecayAttributedRevenue DESC;

-- 103. Inventory optimization model.
WITH ProductDemand AS (
    SELECT
        p.ProductID,
        p.Name AS ProductName,
        p.ProductNumber,
        p.ReorderPoint,
        p.StandardCost,
        p.ListPrice,
        p.DaysToManufacture,
        p.SafetyStockLevel,
        MONTH(soh.OrderDate) AS OrderMonth,
        YEAR(soh.OrderDate) AS OrderYear,
        SUM(sod.OrderQty) AS MonthlySales,
        COUNT(DISTINCT soh.SalesOrderID) AS OrderCount
    FROM Production.Product p
    JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    GROUP BY
        p.ProductID,
        p.Name,
        p.ProductNumber,
        p.ReorderPoint,
        p.StandardCost,
        p.ListPrice,
        p.DaysToManufacture,
        p.SafetyStockLevel,
        MONTH(soh.OrderDate),
        YEAR(soh.OrderDate)
),
ProductMetrics AS (
    SELECT
        ProductID,
        ProductName,
        ProductNumber,
        ReorderPoint,
        StandardCost,
        ListPrice,
        DaysToManufacture,
        SafetyStockLevel,
        AVG(MonthlySales) AS AvgMonthlySales,
        STDEV(MonthlySales) AS StdevMonthlySales,
        AVG(MonthlySales) + STDEV(MonthlySales) AS MaxMonthlySales,
        AVG(MonthlySales) - STDEV(MonthlySales) AS MinMonthlySales,
        AVG(MonthlySales) * 1.2 AS OptimisticDemand,
        AVG(MonthlySales) * 0.8 AS PessimisticDemand
    FROM ProductDemand
    GROUP BY
        ProductID,
        ProductName,
        ProductNumber,
        ReorderPoint,
        StandardCost,
        ListPrice,
        DaysToManufacture,
        SafetyStockLevel
)
SELECT
    ProductID,
    ProductName,
    ProductNumber,
    ListPrice,
    StandardCost,
    ReorderPoint,
    DaysToManufacture,
    SafetyStockLevel,
    AvgMonthlySales,
    StdevMonthlySales,
    MaxMonthlySales,
    MinMonthlySales,
    OptimisticDemand,
    PessimisticDemand,
    -- Calculate optimal reorder point
    CASE
        WHEN AvgMonthlySales > 0 THEN
            CEILING(AvgMonthlySales * (DaysToManufacture + SafetyStockLevel) / 30.0)
        ELSE
            ReorderPoint
    END AS OptimalReorderPoint,
    -- Calculate optimal order quantity
    CASE
        WHEN AvgMonthlySales > 0 THEN
            CEILING(OptimisticDemand * (DaysToManufacture + SafetyStockLevel) / 30.0)
        ELSE
            ReorderPoint
    END AS OptimalOrderQuantity,
    -- Calculate potential savings from optimizing inventory
    (ReorderPoint - CEILING(AvgMonthlySales * (DaysToManufacture + SafetyStockLevel) / 30.0)) * StandardCost AS PotentialSavings
FROM ProductMetrics
ORDER BY PotentialSavings DESC;

-- 104. Customer demographic analysis.
SELECT
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    DATEDIFF(YEAR, CASE
        WHEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date') > '1900-01-01'
        THEN pp.Demographics.value('(/IndividualSurvey/BirthDate)[1]', 'date')

