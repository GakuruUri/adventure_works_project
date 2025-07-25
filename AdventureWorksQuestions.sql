/*
List all tables in AdventureWorks OLTP
*/


SELECT	TABLE_NAME
FROM	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_TYPE = 'BASE TABLE';


/*
Retrieve column detals for a  specific table
*/

SELECT	COLUMN_NAME, DATA_TYPE
FROM	INFORMATION_SCHEMA.COLUMNS
WHERE	TABLE_NAME = 'HumanResources.Employee'


/*
### **Module 1: Introduction to SQL and AdventureWorks**
*/

-- 1. **Retrieve the top 10 employees with the highest salaries.**
   -- This query identifies the top-earning employees based on their salary rates.

SELECT	TOP 10
		BusinessEntityID,
		Rate
FROM	HumanResources.EmployeePayHistory
ORDER	BY	Rate DESC



-- 2. **Find the total number of orders placed in each year.**
   -- This query calculates the total number of orders for each year, helping to analyze order trends over time.

   SELECT	YEAR(OrderDate)	AS	OrderYear,
			COUNT(*)	AS	TotalOrders
   FROM	Sales.SalesOrderHeader
   GROUP	BY	YEAR(OrderDate)
   ORDER	BY	OrderYear;


-- 3. **Retrieve the customers who have placed more than 5 orders.**
   -- This query identifies loyal customers who have made multiple purchases, which can be useful for targeted marketing campaigns.

SELECT	CustomerID,
		COUNT(SalesOrderID) AS OrderCount
FROM	Sales.SalesOrderHeader
GROUP	BY	CustomerID
HAVING	COUNT(SalesOrderID) > 5;



-- 4. **Find the most popular product (with the highest sales quantity).**
   -- This query determines the product with the highest sales volume, indicating high demand.

SELECT	TOP	1	ProductID,
		SUM(OrderQty) AS TotalSold
FROM	Sales.SalesOrderDetail
GROUP	BY	ProductID
ORDER	BY	TotalSold DESC;



-- 5. **Retrieve the total revenue generated per product category.**
   -- This query calculates the total revenue for each product category, helping to understand which categories are performing best.

SELECT	p.ProductCategoryID, 
		pc.Name AS CategoryName, 
		SUM(sod.LineTotal) As TotalRevenue
FROM	Sales.SalesOrderDetail sod
	JOIN	Production.Product p ON sod.ProductID = p.ProductID
	JOIN	Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
	JOIN	Production.ProductCategory pc ON ps.ProductCategoryID = ps.ProductCategoryID
GROUP	BY	p.ProductCategoryID, pc.Name
ORDER	BY	TotalRevenue DESC


SELECT	psc.ProductCategoryID, -- Corrected: Use ProductCategoryID from ProductSubcategory
		pc.Name AS	CategoryName,
		SUM(sod.LineTotal) AS TotalRevenue
FROM	Sales.SalesOrderDetail	sod
	JOIN	Production.Product p ON sod.ProductID = p.ProductID
	JOIN	Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID  -- Corrected alias to psc
	JOIN	Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID  -- Corrected alias to psc
GROUP	BY	psc.ProductCategoryID,
			pc.Name  -- Corrected: Group by the correct column
ORDER	BY	TotalRevenue	DESC

/*
SELECT Clause:

psc.ProductCategoryID: Selects the ProductCategoryID from the ProductSubcategory table.
pc.Name AS CategoryName: Selects the name of the product category from the ProductCategory table and aliases it as CategoryName.
SUM(sod.LineTotal) AS TotalRevenue: Calculates the total revenue by summing up the LineTotal from the SalesOrderDetail table and aliases it as TotalRevenue.
FROM Clause:

Sales.SalesOrderDetail sod: Specifies the SalesOrderDetail table from the Sales schema and aliases it as sod.
JOIN Clauses:

JOIN Production.Product p ON sod.ProductID = p.ProductID: Joins the SalesOrderDetail table with the Product table on the ProductID field.
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID: Joins the Product table with the ProductSubcategory table on the ProductSubcategoryID field.
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID: Joins the ProductSubcategory table with the ProductCategory table on the ProductCategoryID field.
GROUP BY Clause:

psc.ProductCategoryID, pc.Name: Groups the results by ProductCategoryID and the name of the product category to aggregate the total revenue for each category.
ORDER BY Clause:

TotalRevenue DESC: Orders the results in descending order based on the TotalRevenue, showing the categories with the highest revenue first.
Explanation:
The query calculates the total revenue for each product category by summing the LineTotal from the SalesOrderDetail table.
It joins multiple tables to associate each sale with its respective product category.
The results are grouped by ProductCategoryID and CategoryName to aggregate the revenue for each category.
Finally, the results are ordered by TotalRevenue in descending order to show the highest revenue-generating categories first.
*/


-- 6. **Retrieve the customers who have never placed an order.**
   -- This query identifies customers who have not made any purchases, which can be useful for re-engagement campaigns.



SELECT	c.CustomerID, c.PersonID, soh.TerritoryID
FROM	Sales.Customer c
	LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE	soh.CustomerID IS NULL



/*







7. **Calculate the average order total per customer.**
   - This query calculates the average value of orders placed by each customer, providing insights into customer spending habits.

8. **Find employees who have been with the company for more than 10 years.**
   - This query identifies long-tenured employees, which can be useful for recognizing loyalty and experience within the company.

9. **List all employees along with their managerís name.**
   - This query provides a hierarchical view of the organization by listing employees and their respective managers.

10. **Find the average sales per month over the last 5 years.**
    - This query calculates the average monthly sales over the past five years, helping to analyze sales trends over time.

### **Module 2: Understanding the AdventureWorks Schema**
11. **Retrieve column details for a specific table.**
    - This query retrieves metadata about the columns in a specified table, such as data types and names.

### **Advanced and Expert SQL Practice Questions (1-100)**
12. **Identify products that have never been sold.**
    - This query identifies products that have not been sold, which can be useful for inventory management and promotional strategies.

13. **Create a recursive Common Table Expression (CTE) for employee hierarchy.**
    - This query creates a hierarchical view of the employee structure, showing reporting lines within the organization.

14. **Retrieve the top 5 customers by total number of orders.**
    - This query identifies the top customers based on the number of orders they have placed, highlighting frequent buyers.

15. **Retrieve products that have been ordered more than 100 times.**
    - This query identifies popular products that have been ordered frequently, indicating high demand.

16. **Find products that are in the same category as 'Mountain Bikes'.**
    - This query identifies products that belong to the same category as 'Mountain Bikes', which can be useful for cross-selling strategies.

17. **Retrieve all orders along with customer information using different join types.**
    - This query retrieves order details along with corresponding customer information, using different join types to include or exclude certain data.

18. **Find vendors who supply the most number of products.**
    - This query identifies vendors who supply the highest number of products, which can be useful for supplier management and negotiations.

19. **Find products that have been purchased by the most customers.**
    - This query identifies products that have been purchased by the largest number of unique customers, indicating broad appeal.

20. **Self-join to find employees who have the same job title.**
    - This query identifies employees who share the same job title, which can be useful for analyzing roles and responsibilities within the organization.

21. **Calculate running total of sales by month.**
    - This query calculates the cumulative sales total for each month, providing insights into sales trends over time.

22. **Rank products by sales quantity within each category.**
    - This query ranks products within their respective categories based on sales quantity, highlighting top-selling items.

23. **Calculate the percentage of total sales each product contributes.**
    - This query calculates the contribution of each product to the total sales, providing insights into product performance.

24. **Find the difference in sales between consecutive months.**
    - This query calculates the difference in sales between consecutive months, helping to identify trends and seasonality in sales data.

25. **Calculate the moving average of sales over a 3-month period.**
    - This query calculates the moving average of sales over a 3-month period, smoothing out short-term fluctuations and highlighting longer-term trends.

26. **Use CTE to find customers who have purchased products from all categories.**
    - This query identifies customers who have made purchases across all product categories, indicating diverse buying behavior.

27. **Identify potential cross-selling opportunities using subqueries.**
    - This query identifies products that are frequently purchased together, providing insights into potential cross-selling opportunities.

28. **Use CTE for hierarchical query of product categories and subcategories.**
    - This query creates a hierarchical view of product categories and subcategories, showing the structure of the product catalog.

29. **Find products that have had price changes using CTE.**
    - This query identifies products that have experienced price changes, which can be useful for pricing strategy analysis.

30. **Find the top 3 products in each subcategory by sales amount.**
    - This query identifies the top-selling products within each subcategory, highlighting high-performing items.

31. **Analyze sales by day of week.**
    - This query analyzes sales data by day of the week, providing insights into weekly sales patterns.

32. **Find seasonality in sales (by quarter and month).**
    - This query analyzes sales data by quarter and month, identifying seasonal trends and patterns.

33. **Calculate the number of days between order date and ship date.**
    - This query calculates the number of days between the order date and the ship date, helping to analyze order fulfillment times.

34. **Identify orders that were shipped late (after the promised due date).**
    - This query identifies orders that were shipped after the promised due date, highlighting potential issues in order fulfillment.

35. **Analyze sales trends by year and quarter with growth rate.**
    - This query analyzes sales trends by year and quarter, calculating the growth rate to identify trends over time.

36. **Analyze the sales performance of products by territory.**
    - This query analyzes the sales performance of products by territory, providing insights into regional sales patterns.

37. **Find customer lifetime value (CLV).**
    - This query calculates the lifetime value of customers, providing insights into customer profitability and loyalty.

38. **Calculate product profit margins.**
    - This query calculates the profit margins for products, providing insights into product profitability.

39. **Segment customers based on recency, frequency, and monetary value (RFM analysis).**
    - This query segments customers based on their purchasing behavior, providing insights into customer value and loyalty.

40. **Analyze sales trends by demographic factors.**
    - This query analyzes sales trends by demographic factors, providing insights into customer segments and purchasing behavior.

41. **Find the most expensive queries using execution statistics.**
    - This query identifies the most resource-intensive queries, helping to optimize database performance.

42. **Analyze index usage statistics.**
    - This query analyzes index usage statistics, providing insights into index performance and optimization opportunities.

43. **Identify tables without indexes.**
    - This query identifies tables that do not have indexes, highlighting potential performance issues.

44. **Find unused indexes.**
    - This query identifies unused indexes, providing insights into potential performance optimizations.

45. **Create indexed view for frequently accessed data.**
    - This query creates an indexed view to improve the performance of frequently accessed data.

46. **Create a stored procedure to get customer orders.**
    - This query creates a stored procedure to retrieve customer orders, providing a reusable way to access order data.

47. **Create a function to calculate total inventory value.**
    - This query creates a function to calculate the total value of inventory, providing insights into inventory management.

48. **Create a stored procedure for product reordering analysis.**
    - This query creates a stored procedure to analyze product reordering needs, providing insights into inventory management.

49. **Create a function for calculating employee tenure.**
    - This query creates a function to calculate employee tenure, providing insights into employee loyalty and experience.

50. **Create a stored procedure for sales forecasting.**
    - This query creates a stored procedure to forecast sales, providing insights into future sales trends and growth opportunities.

51. **Check for duplicate customer records.**
    - This query identifies duplicate customer records, highlighting potential data quality issues.

52. **Validate product data integrity (continued).**
    - This query validates product data integrity, providing insights into potential data quality issues.

53. **Identify orders with inconsistent shipping information.**
    - This query identifies orders with inconsistent shipping information, highlighting potential issues in order fulfillment.

54. **Check for missing email addresses for customers.**
    - This query identifies customers with missing email addresses, highlighting potential data quality issues.

55. **Identify products with inconsistent pricing history.**
    - This query identifies products with inconsistent pricing history, highlighting potential pricing strategy issues.

56. **Customer segmentation by purchase behavior.**
    - This query segments customers based on their purchasing behavior, providing insights into customer value and loyalty.

57. **Product affinity analysis.**
    - This query analyzes product affinity, identifying products that are frequently purchased together.

58. **Customer lifetime value (CLV) calculation.**
    - This query calculates the lifetime value of customers, providing insights into customer profitability and loyalty.

59. **Product performance analysis with seasonality.**
    - This query analyzes product performance with seasonality, providing insights into seasonal sales trends.

60. **Territory-based sales trend analysis.**
    - This query analyzes sales trends by territory, providing insights into regional sales patterns.

61. **Customer acquisition and retention analysis.**
    - This query analyzes customer acquisition and retention, providing insights into customer loyalty and acquisition strategies.

62. **Sales performance by employee with targets.**
    - This query analyzes sales performance by employee, comparing actual sales to targets.

63. **Inventory turnover analysis.**
    - This query analyzes inventory turnover, providing insights into inventory management and performance.

64. **Customer demographic analysis.**
    - This query analyzes customer demographics, providing insights into customer segments and purchasing behavior.

65. **Product category performance analysis.**
    - This query analyzes product category performance, providing insights into category sales and profitability.

66. **Sales discounting effect analysis.**
    - This query analyzes the effect of sales discounting, providing insights into pricing strategies and promotions.

67. **Customer RFM (Recency, Frequency, Monetary) analysis.**
    - This query segments customers based on their purchasing behavior, providing insights into customer value and loyalty.

68. **Sales return analysis.**
    - This query analyzes sales returns, providing insights into return rates and customer satisfaction.

69. **Customer acquisition cost and lifetime value comparison.**
    - This query compares customer acquisition costs to lifetime value, providing insights into customer profitability and acquisition strategies.

70. **Price elasticity analysis.**
    - This query analyzes price elasticity, providing insights into pricing strategies and customer sensitivity to price changes.

71. **Employee performance reporting and benchmarking.**
    - This query analyzes employee performance, providing insights into employee productivity and benchmarking.

72. **Forecasting sales using seasonal trends (continued).**
    - This query forecasts sales using seasonal trends, providing insights into future sales trends and growth opportunities.

73. **Customer segmentation by purchase behavior.**
    - This query segments customers based on their purchasing behavior, providing insights into customer value and loyalty.

74. **Product bundle analysis.**
    - This query analyzes product bundles, identifying products that are frequently purchased together.

75. **Sales channel effectiveness analysis.**
    - This query analyzes the effectiveness of different sales channels, providing insights into channel performance and optimization opportunities.

76. **Customer acquisition cost and lifetime value comparison.**
    - This query compares customer acquisition costs to lifetime value, providing insights into customer profitability and acquisition strategies.

77. **Customer purchase path analysis.**
    - This query analyzes customer purchase paths, providing insights into purchasing behavior and optimization opportunities.

78. **Price optimization analysis.**
    - This query analyzes price optimization, providing insights into pricing strategies and customer sensitivity to price changes.

79. **Conversion funnel analysis.**
    - This query analyzes the conversion funnel, providing insights into sales pipeline performance and optimization opportunities.

80. **Repeat purchase probability analysis.**
    - This query analyzes repeat purchase probability, providing insights into customer loyalty and retention strategies.

81. **Product feature impact analysis.**
    - This query analyzes the impact of product features on sales, providing insights into product design and feature optimization.

82. **Cross-sell opportunity identification.**
    - This query identifies cross-sell opportunities, providing insights into potential revenue growth and customer satisfaction.

83. **Customer churn risk detection (continued).**
    - This query identifies customers at risk of churn, providing insights into customer retention strategies.

84. **Product affinity analysis.**
    - This query analyzes product affinity, identifying products that are frequently purchased together.

85. **Seasonal product trend analysis.**
    - This query analyzes seasonal product trends, providing insights into seasonal sales patterns and optimization opportunities.

86. **Dynamic pricing model.**
    - This query creates a dynamic pricing model, providing insights into pricing strategies and customer sensitivity to price changes.

87. **Customer lifetime value prediction.**
    - This query predicts customer lifetime value, providing insights into customer profitability and loyalty.

88. **Marketing attribution model.**
    - This query analyzes marketing attribution, providing insights into the effectiveness of marketing campaigns and channels.

89. **Inventory optimization model.**
    - This query analyzes inventory optimization, providing insights into inventory management and performance.

90. **Customer demographic analysis.**
    - This query analyzes customer demographics, providing insights into customer segments and purchasing behavior.

91. **Product category performance analysis.**
    - This query analyzes product category performance, providing insights into category sales and profitability.

92. **Sales discounting effect analysis.**
    - This query analyzes the effect of sales discounting, providing insights into pricing strategies and promotions.

93. **Customer RFM (Recency, Frequency, Monetary) analysis.**
    - This query segments customers based on their purchasing behavior, providing insights into customer value and loyalty.

94. **Sales return analysis.**
    - This query analyzes sales returns, providing insights into return rates and customer satisfaction.

95. **Customer acquisition cost and lifetime value comparison.**
    - This query compares customer acquisition costs to lifetime value, providing insights into customer profitability and acquisition strategies.

96. **Price optimization analysis.**
    - This query analyzes price optimization, providing insights into pricing strategies and customer sensitivity to price changes.

97. **Conversion funnel analysis.**
    - This query analyzes the conversion funnel, providing insights into sales pipeline performance and optimization opportunities.

98. **Repeat purchase probability analysis.**
    - This query analyzes repeat purchase probability, providing insights into customer loyalty and retention strategies.

99. **Product feature impact analysis.**
    - This query analyzes the impact of product features on sales, providing insights into product design and feature optimization.

100. **Cross-sell opportunity identification.**
    - This query identifies cross-sell opportunities, providing insights into potential revenue growth and customer satisfaction.

*/