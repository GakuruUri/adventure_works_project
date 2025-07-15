
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'

-- Chat GPT

-- Below is a comprehensive guide that rewords each question into a clearer, more detailed task. Each task includes an in?depth explanation and a set of guidelines to help you craft your SQL queries against the AdventureWorks OLTP database. You can use these guidelines as a blueprint when writing your own queries.

-- ---

-- ## **Basic Data Retrieval and Aggregation Tasks**


/*
1. **Identify the Top 10 Highest?Paid Employees**  
/ Retrieve the top 10 employees with the highest salaries.
   - **Rewritten Task:**  
     Develop a query to extract the top 10 employees who receive the 
     highest salaries from the employee salary data.
   - **Detailed Explanation:**  
     This task involves identifying the employees with the highest 
     compensation. 
     You need to locate the table(s) that store salary information 
     (for example, a salary history or pay details table) and 
    join with the employee table if you need additional details (like name or job title).  
   - **Query Guidelines:**  
     - Determine which table(s) contain salary information (e.g., *EmployeePayHistory*).  
     - Join with the employee master table to retrieve additional details if necessary.  
     - Use an ORDER BY clause on the salary column in descending order.  
     - Limit the result to 10 records using TOP or LIMIT based on your SQL dialect.
*/

SELECT  TOP 10 heh.BusinessEntityID, --Limit the result to 10 records using TOP or LIMIT based on your SQL dialect
        heh.Rate,
        hre.JobTitle
FROM  HumanResources.EmployeePayHistory heh --Determine which table(s) contain salary information (e.g., *EmployeePayHistory*).  
LEFT JOIN HumanResources.Employee hre --Join with the employee master table to retrieve additional details if necessary
  ON heh.BusinessEntityID = hre.BusinessEntityID
ORDER BY  Rate DESC --Use an ORDER BY clause on the salary column in descending order. 


/*
2. **Compute the Total Number of Orders Placed Each Year**  
  Find the total number of orders placed in each year.
   - **Rewritten Task:**  
     Create a query that calculates the yearly count of orders, 
     allowing you to track order volume trends over time.
   - **Detailed Explanation:**  
     This analysis helps in understanding the business growth 
     and seasonal patterns by aggregating 
	 orders by the year they were placed.  
   - **Query Guidelines:**  
     - Identify the orders table (e.g., *SalesOrderHeader*) 
     and the column that holds the order date.  
     - Use a GROUP BY clause to group orders by the year extracted from the order date.  
     - Use an aggregate function (COUNT) to get the total orders for each year.
*/
SELECT  YEAR(OrderDate) AS OrderYear, --Identify the orders table (e.g., *SalesOrderHeader*) 
        COUNT(*) AS TotalOrders
FROM  Sales.SalesOrderHeader --and the column that holds the order date. 
GROUP BY YEAR(OrderDate) -- Use a GROUP BY clause to group orders by the year extracted from the order date.
ORDER BY OrderYear -- Use an aggregate function (COUNT) to get the total orders for each year.


/*
3. **Find Loyal Customers with More Than 5 Orders**  
   - **Rewritten Task:**  
     Write a query to retrieve customers who have placed more than five orders, 
     highlighting the most engaged customers.
   - **Detailed Explanation:**  
     By finding customers with multiple orders, you can target them for loyalty 
     rewards or special marketing campaigns.  
   - **Query Guidelines:**  
     - Identify the customer and order tables.  
     - Join these tables if necessary.  
     - Group the data by customer ID and count the number of orders per customer.  
     - Use a HAVING clause to filter customers where the count exceeds five.
*/

SELECT  CustomerID,
        COUNT(SalesOrderID) AS OrderCount -- count the number of orders per customer. 
FROM  Sales.SalesOrderHeader -- Identify the customer and order tables.  
GROUP BY CustomerID  --Group the data by customer ID
HAVING  COUNT(SalesOrderID) > 5; --Use a HAVING clause to filter customers where the count exceeds five.


/*
4. **Determine the Most Popular Product by Sales Quantity**  
   - **Rewritten Task:**  
     Develop a query to find the product that has been sold in the highest quantity, 
     indicating its popularity.
   - **Detailed Explanation:**  
     This task measures product demand by summing the sales quantity across all transactions.  
   - **Query Guidelines:**  
     - Locate the sales detail table that records product quantities sold 
     (e.g., *SalesOrderDetail*).  
     - GROUP BY product ID and sum the quantity sold.  
     - Order the results in descending order by the total quantity and limit to the top result.
*/

SELECT  TOP 3 ProductID,
        SUM(OrderQty) AS TotalSold
FROM  Sales.SalesOrderDetail -- Locate the sales detail table that records product quantities sold (e.g., *SalesOrderDetail*).
GROUP BY  ProductID -- GROUP BY product ID and sum the quantity sold. 
ORDER BY TotalSold -- Order the results in descending order by the total quantity and limit to the top result.


/*
5. **Calculate Revenue Per Product Category**  
   - **Rewritten Task:**  
     Write a query to calculate the total revenue generated by each product category, 
     providing insight into category performance.
   - **Detailed Explanation:**  
     This analysis helps in understanding which product categories drive 
     revenue and can influence inventory and marketing decisions.  
   - **Query Guidelines:**  
     - Identify the tables containing sales and product category details 
     (e.g., *SalesOrderDetail*, *Product*, *ProductCategory*).  
     - Use JOINs to combine sales data with category information.  
     - Multiply quantity by price (or use an existing revenue column) and sum the 
      revenue per category.  
     - Group by product category.
*/
SELECT  pc.ProductCategoryID,
        pc.Name AS CategoryName,
        SUM(sod.LineTotal) AS TotalRevenue
FROM  Sales.SalesOrderDetail sod
LEFT JOIN  Production.Product p
    ON sod.ProductID = p.ProductID
LEFT JOIN  Production.ProductSubcategory ps
    ON  p.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN  Production.ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.ProductCategoryID, pc.Name
ORDER BY TotalRevenue DESC;


/*
6. **Identify Customers Without Any Orders**  
   - **Rewritten Task:**  
     Create a query to list customers who have never placed an order.
   - **Detailed Explanation:**  
     This task is useful for identifying inactive or new customers for re-engagement campaigns.  
   - **Query Guidelines:**  
     - Identify the customer table and the orders table.  
     - Use an outer join or a NOT EXISTS subquery to find customers that do not have 
     matching orders in the orders table.

*/





/*


7. **Compute the Average Order Total for Each Customer**  
   - **Rewritten Task:**  
     Develop a query that calculates the average order value per customer, giving insights into customer spending patterns.
   - **Detailed Explanation:**  
     This measure of customer spending helps in understanding purchasing behavior and segmenting customers by value.  
   - **Query Guidelines:**  
     - Identify the order totals from the orders table.  
     - Group by customer ID and use AVG() to compute the average order total for each customer.

8. **Find Employees with Over 10 Years of Service**  
   - **Rewritten Task:**  
     Write a query to identify employees who have been with the company for more than 10 years.
   - **Detailed Explanation:**  
     Recognizing long-tenured employees can support internal award programs and understand retention trends.  
   - **Query Guidelines:**  
     - Identify the employee table with hire date information.  
     - Calculate the difference between the current date and the hire date.  
     - Filter for employees whose tenure exceeds 10 years.

9. **List Employees with Their Manager�s Name**  
   - **Rewritten Task:**  
     Create a query that shows each employee along with the name of their direct manager.
   - **Detailed Explanation:**  
     This hierarchical view helps understand the reporting structure within the organization.  
   - **Query Guidelines:**  
     - Use the employee table where a manager or supervisor ID is stored.  
     - Perform a self-join on the employee table to link each employee to their manager�s record.  
     - Select the employee name and the manager name in your result.

10. **Calculate the Average Monthly Sales for the Past 5 Years**  
    - **Rewritten Task:**  
      Develop a query to compute the average sales per month over the last 5 years to analyze ongoing sales trends.
    - **Detailed Explanation:**  
      This task helps in identifying long-term trends by smoothing out fluctuations across months over multiple years.  
    - **Query Guidelines:**  
      - Identify the sales table and the column for order date and sales amount.  
      - Filter data to include only the last 5 years.  
      - Group by month (and possibly year) and calculate the monthly totals, then compute the average over these months.

---

## **Exploring Schema Metadata**

11. **Retrieve Metadata for a Specific Table**  
    - **Rewritten Task:**  
      Write a query to extract detailed column information (names, data types, etc.) from a specific table in the database.
    - **Detailed Explanation:**  
      Understanding the table schema is essential for building correct queries and ensuring data integrity.  
    - **Query Guidelines:**  
      - Use system catalog views or information schema views (e.g., *INFORMATION_SCHEMA.COLUMNS*) to retrieve column details.  
      - Filter the results by the table name you are interested in.

---

## **Advanced and Expert SQL Practice Tasks**

12. **List Products That Have Never Been Sold**  
    - **Rewritten Task:**  
      Develop a query to identify products in your inventory that have no associated sales records.
    - **Detailed Explanation:**  
      This can help in inventory management by highlighting products that may need promotions or discontinuation.  
    - **Query Guidelines:**  
      - Identify the product table and the sales details table.  
      - Use a LEFT JOIN or NOT EXISTS clause to filter products with no matching sales records.

13. **Construct an Employee Hierarchy Using a Recursive CTE**  
    - **Rewritten Task:**  
      Create a recursive Common Table Expression (CTE) to build a full reporting hierarchy of employees.
    - **Detailed Explanation:**  
      Recursive CTEs are useful for traversing hierarchical or tree-structured data such as an organizational chart.  
    - **Query Guidelines:**  
      - Start with the top-level manager(s) as the anchor query.  
      - Recursively join the employee table to add subordinates.  
      - Ensure the recursion terminates properly to avoid infinite loops.

14. **Determine the Top 5 Customers by Order Count**  
    - **Rewritten Task:**  
      Write a query to rank and retrieve the five customers who have placed the highest number of orders.
    - **Detailed Explanation:**  
      This analysis helps identify customers who frequently engage with your business.  
    - **Query Guidelines:**  
      - Group orders by customer ID and count the orders.  
      - Order the result in descending order by the count and limit the output to the top 5.

15. **Retrieve Products Ordered Over 100 Times**  
    - **Rewritten Task:**  
      Develop a query that finds products which have been ordered more than 100 times.
    - **Detailed Explanation:**  
      Identifying high-demand products can inform inventory decisions and marketing strategies.  
    - **Query Guidelines:**  
      - Aggregate order data from the sales details table grouped by product ID.  
      - Filter using a HAVING clause where the summed quantity is greater than 100.

16. **Find Products in the Same Category as 'Mountain Bikes'**  
    - **Rewritten Task:**  
      Write a query to list all products that belong to the same category as the 'Mountain Bikes' product.
    - **Detailed Explanation:**  
      This can be useful for cross-selling by recommending similar products to customers.  
    - **Query Guidelines:**  
      - Identify the product category of 'Mountain Bikes'.  
      - Use JOINs to match products with their category and filter for the matching category.

17. **Join Orders with Customer Information Using Various Join Types**  
    - **Rewritten Task:**  
      Create queries that combine order data with customer details using different types of joins (INNER, LEFT, RIGHT, etc.) to see how they affect the result set.
    - **Detailed Explanation:**  
      Exploring different join types will help you understand how to include or exclude records based on the existence of related data.
    - **Query Guidelines:**  
      - Identify the orders table and the customer table.  
      - Write separate queries for each join type to observe the differences in the returned dataset.

18. **Identify Vendors Supplying the Largest Number of Products**  
    - **Rewritten Task:**  
      Write a query to determine which vendors supply the most products to your inventory.
    - **Detailed Explanation:**  
      This helps in supplier management and negotiating better terms by knowing which vendors are the primary sources of products.
    - **Query Guidelines:**  
      - Identify tables containing vendor information and product details.  
      - Group the products by vendor and count the number of products each supplies.  
      - Order the result in descending order by product count.

19. **Discover Products Purchased by the Most Unique Customers**  
    - **Rewritten Task:**  
      Create a query to identify the products that have been bought by the highest number of distinct customers.
    - **Detailed Explanation:**  
      This indicates products with broad appeal and can help in understanding customer preferences.
    - **Query Guidelines:**  
      - Use the sales details table and customer data.  
      - Group by product and use COUNT(DISTINCT customerID) to find unique customer counts.  
      - Order the results to highlight the most popular products by customer diversity.

20. **Find Employees Sharing the Same Job Title Using a Self-Join**  
    - **Rewritten Task:**  
      Develop a query that finds pairs or groups of employees who hold the same job title by joining the employee table with itself.
    - **Detailed Explanation:**  
      This can help analyze role distributions and verify whether multiple employees perform similar functions.
    - **Query Guidelines:**  
      - Self-join the employee table on the job title column.  
      - Exclude self-matches if necessary and select distinct job titles along with employee details.

21. **Compute the Running Total of Monthly Sales**  
    - **Rewritten Task:**  
      Write a query to calculate a cumulative sum of sales totals by month.
    - **Detailed Explanation:**  
      A running total can help visualize sales growth and monitor progress over a period.
    - **Query Guidelines:**  
      - Use window functions (like SUM() OVER (ORDER BY month)) to compute cumulative totals.  
      - Ensure that data is ordered correctly (by month or date).

22. **Rank Products Within Each Category by Sales Quantity**  
    - **Rewritten Task:**  
      Develop a query that assigns a rank to products based on the quantity sold within each product category.
    - **Detailed Explanation:**  
      Ranking products within categories helps highlight top performers and may inform category-specific strategies.
    - **Query Guidelines:**  
      - Use window functions such as RANK() or DENSE_RANK() partitioned by category.  
      - Order by the sales quantity in descending order.

23. **Determine Each Product�s Contribution to Total Sales (Percentage)**  
    - **Rewritten Task:**  
      Create a query that calculates what percentage of the overall sales each product represents.
    - **Detailed Explanation:**  
      This analysis aids in understanding the relative performance of each product.
    - **Query Guidelines:**  
      - Sum sales per product and calculate the total sales.  
      - Use a subquery or window function to compute each product�s percentage contribution.

24. **Compute Month-over-Month Sales Differences**  
    - **Rewritten Task:**  
      Write a query to determine the difference in sales between each consecutive month.
    - **Detailed Explanation:**  
      Analyzing the difference between months helps identify trends, seasonal patterns, or sudden changes.
    - **Query Guidelines:**  
      - Use window functions like LAG() to compare the sales amount of the current month with the previous month.  
      - Calculate the difference and format the output for clarity.

25. **Calculate a 3-Month Moving Average for Sales**  
    - **Rewritten Task:**  
      Develop a query to compute a moving average of sales over a 3-month window to smooth out fluctuations.
    - **Detailed Explanation:**  
      A moving average helps in identifying longer-term trends by minimizing short-term volatility.
    - **Query Guidelines:**  
      - Use window functions (e.g., AVG() OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)).  
      - Ensure proper ordering and partitioning if needed.

26. **Find Customers Who Purchased Products from Every Category Using a CTE**  
    - **Rewritten Task:**  
      Write a query using a Common Table Expression (CTE) to list customers who have made purchases in all available product categories.
    - **Detailed Explanation:**  
      This query identifies diverse buyers whose purchasing patterns span the entire product line.
    - **Query Guidelines:**  
      - Use a CTE to first determine all product categories.  
      - Join or compare customer purchase records against the complete list of categories, filtering for those matching all.

27. **Identify Cross-Selling Opportunities with Subqueries**  
    - **Rewritten Task:**  
      Create a query that uses subqueries to identify products that are frequently purchased together.
    - **Detailed Explanation:**  
      Discovering product affinities can lead to effective cross-selling strategies and improved customer recommendations.
    - **Query Guidelines:**  
      - Analyze order details to determine co-occurrence of products in the same order.  
      - Use subqueries to compare order lists and identify frequent pairings.

28. **Generate a Hierarchical View of Product Categories and Subcategories Using a CTE**  
    - **Rewritten Task:**  
      Write a recursive CTE to build a tree structure showing product categories and their respective subcategories.
    - **Detailed Explanation:**  
      This approach clarifies the product catalog structure and aids in categorization analysis.
    - **Query Guidelines:**  
      - Identify parent-child relationships in the category table.  
      - Construct an anchor query for the top-level categories and a recursive part for subcategories.

29. **Detect Products with a History of Price Changes Using a CTE**  
    - **Rewritten Task:**  
      Create a query that uses a CTE to list products that have experienced changes in pricing over time.
    - **Detailed Explanation:**  
      Tracking price changes can reveal pricing strategy trends and inform future adjustments.
    - **Query Guidelines:**  
      - Identify historical price records from the product pricing history table.  
      - Use a CTE to compare previous and current prices, filtering for products with differences.

30. **Identify the Top 3 Products in Each Subcategory by Sales Amount**  
    - **Rewritten Task:**  
      Write a query to rank products within each subcategory and extract the top three based on sales revenue.
    - **Detailed Explanation:**  
      This analysis helps pinpoint high-performing products at a more granular subcategory level.
    - **Query Guidelines:**  
      - Use window functions like RANK() partitioned by subcategory.  
      - Filter to return only the top three per subcategory.

31. **Analyze Sales by Day of the Week**  
    - **Rewritten Task:**  
      Develop a query to aggregate sales data by day of the week, highlighting daily performance patterns.
    - **Detailed Explanation:**  
      Understanding daily sales trends can inform staffing, promotions, and operational planning.
    - **Query Guidelines:**  
      - Extract the day of the week from the order date.  
      - GROUP BY this extracted value and sum the sales for each day.

32. **Identify Seasonal Trends in Sales by Quarter and Month**  
    - **Rewritten Task:**  
      Write a query to analyze sales data by both quarter and month to detect seasonal variations.
    - **Detailed Explanation:**  
      This analysis helps in planning for seasonal demand and adjusting strategies accordingly.
    - **Query Guidelines:**  
      - Extract quarter and month from the order date.  
      - Group the data accordingly and compare sales totals across different time frames.

33. **Calculate the Delivery Time for Each Order**  
    - **Rewritten Task:**  
      Develop a query that computes the number of days between the order date and the ship date.
    - **Detailed Explanation:**  
      This metric is critical for evaluating order fulfillment efficiency.
    - **Query Guidelines:**  
      - Use date functions to subtract the order date from the ship date.  
      - Present the result as a new column representing the delivery duration.

34. **Identify Orders Shipped After the Promised Due Date**  
    - **Rewritten Task:**  
      Write a query to flag orders where the ship date exceeds the promised delivery date.
    - **Detailed Explanation:**  
      Highlighting late shipments can help in addressing fulfillment issues and improving service.
    - **Query Guidelines:**  
      - Compare the ship date with the due date in your orders table.  
      - Filter for records where the ship date is later than the due date.

35. **Analyze Yearly and Quarterly Sales Growth Rates**  
    - **Rewritten Task:**  
      Create a query that calculates sales growth rates by comparing sales data from consecutive years and quarters.
    - **Detailed Explanation:**  
      This helps in tracking business performance trends and forecasting future growth.
    - **Query Guidelines:**  
      - Group sales data by year and quarter.  
      - Compute the growth rate by comparing the current period�s sales with the previous period.

36. **Examine Sales Performance by Territory**  
    - **Rewritten Task:**  
      Write a query to analyze product sales across different geographic territories.
    - **Detailed Explanation:**  
      Regional analysis can reveal market trends and areas needing targeted strategies.
    - **Query Guidelines:**  
      - Join sales data with territory information (which might come from customer or sales tables).  
      - Aggregate sales by territory.

37. **Calculate Customer Lifetime Value (CLV)**  
    - **Rewritten Task:**  
      Develop a query to compute the lifetime value of each customer based on their historical purchases.
    - **Detailed Explanation:**  
      CLV is a critical metric for understanding customer profitability and guiding retention strategies.
    - **Query Guidelines:**  
      - Sum all orders per customer over time.  
      - Consider additional factors such as profit margins if available.

38. **Determine Product Profit Margins**  
    - **Rewritten Task:**  
      Write a query to calculate the profit margin for each product.
    - **Detailed Explanation:**  
      This helps in assessing product profitability and informing pricing strategies.
    - **Query Guidelines:**  
      - Use revenue and cost data from the product and sales tables.  
      - Compute margin as (Sales Price - Cost) divided by Sales Price.

39. **Segment Customers Based on Recency, Frequency, and Monetary Value (RFM Analysis)**  
    - **Rewritten Task:**  
      Create a query that segments customers by evaluating how recently and frequently they buy, and how much they spend.
    - **Detailed Explanation:**  
      RFM segmentation helps identify high-value customers and tailor marketing strategies accordingly.
    - **Query Guidelines:**  
      - Calculate the recency, frequency, and total spend for each customer.  
      - Use CASE statements or additional subqueries to group customers into segments.

40. **Analyze Sales Trends by Demographic Factors**  
    - **Rewritten Task:**  
      Write a query to compare sales data across various customer demographic groups.
    - **Detailed Explanation:**  
      This analysis aids in understanding market segments and targeting promotions more effectively.
    - **Query Guidelines:**  
      - Join customer demographic data with sales records.  
      - Group and aggregate sales by relevant demographic attributes.

41. **Identify the Most Resource-Intensive Queries Using Execution Statistics**  
    - **Rewritten Task:**  
      Develop a query that reveals the queries consuming the most system resources based on execution statistics.
    - **Detailed Explanation:**  
      This is crucial for database performance tuning and identifying areas for optimization.
    - **Query Guidelines:**  
      - Query system views or DMVs that capture query execution statistics.  
      - Order the results based on metrics such as CPU time or execution duration.

42. **Examine Index Usage Statistics**  
    - **Rewritten Task:**  
      Create a query to review how frequently indexes are used, which can help in performance tuning.
    - **Detailed Explanation:**  
      Analyzing index usage helps determine whether existing indexes are effective or if new indexes are needed.
    - **Query Guidelines:**  
      - Query system catalog views that report index statistics.  
      - Focus on usage counts and performance metrics.

43. **Identify Tables Lacking Indexes**  
    - **Rewritten Task:**  
      Write a query to list tables that do not have any indexes, indicating potential performance issues.
    - **Detailed Explanation:**  
      Tables without indexes can lead to slower query performance, especially on large datasets.
    - **Query Guidelines:**  
      - Query system metadata to find tables without associated index entries.

44. **Find Unused Indexes**  
    - **Rewritten Task:**  
      Develop a query to detect indexes that are rarely or never used.
    - **Detailed Explanation:**  
      Unused indexes can be removed to optimize storage and performance.
    - **Query Guidelines:**  
      - Use system DMV reports that include index usage statistics.  
      - Filter for indexes with little to no usage over a defined period.

45. **Create an Indexed View for Frequently Accessed Data**  
    - **Rewritten Task:**  
      Write a query to create an indexed view that pre-aggregates or pre-joins data frequently accessed by users.
    - **Detailed Explanation:**  
      Indexed views can speed up query performance by storing computed results.  
    - **Query Guidelines:**  
      - Define the view with a SELECT statement that aggregates or joins data.  
      - Create a unique clustered index on the view to materialize it.

46. **Develop a Stored Procedure to Retrieve Customer Orders**  
    - **Rewritten Task:**  
      Create a stored procedure that accepts customer parameters and returns their order details.
    - **Detailed Explanation:**  
      Stored procedures encapsulate logic for reusability and can improve security and performance.
    - **Query Guidelines:**  
      - Define input parameters (e.g., customer ID).  
      - Write the SELECT query to retrieve order details and include error handling as needed.

47. **Build a Function to Calculate Total Inventory Value**  
    - **Rewritten Task:**  
      Write a scalar function that computes the total inventory value by multiplying quantities by their unit costs.
    - **Detailed Explanation:**  
      This function helps in assessing the overall value of inventory holdings.
    - **Query Guidelines:**  
      - Accept necessary parameters if needed, or reference inventory tables directly.  
      - Return the computed total using appropriate arithmetic operations.

48. **Create a Stored Procedure for Product Reordering Analysis**  
    - **Rewritten Task:**  
      Develop a stored procedure that analyzes product sales and inventory levels to suggest when reordering is required.
    - **Detailed Explanation:**  
      This helps ensure inventory levels are optimized, preventing stockouts.
    - **Query Guidelines:**  
      - Include logic that compares current inventory levels against historical sales or reorder thresholds.  
      - Return products that require reordering based on defined criteria.

49. **Develop a Function to Calculate Employee Tenure**  
    - **Rewritten Task:**  
      Create a scalar function that computes the length of service (tenure) for an employee using their hire date.
    - **Detailed Explanation:**  
      Employee tenure insights can support HR analyses and recognition programs.
    - **Query Guidelines:**  
      - Accept an employee�s hire date as input.  
      - Return the tenure by calculating the difference from the current date.

50. **Construct a Stored Procedure for Sales Forecasting**  
    - **Rewritten Task:**  
      Write a stored procedure that processes historical sales data to forecast future sales trends.
    - **Detailed Explanation:**  
      Sales forecasting can inform budgeting and strategy by predicting future revenue.
    - **Query Guidelines:**  
      - Use historical sales data aggregated over time periods.  
      - Incorporate statistical functions or simple trend analysis logic.

---

## **Data Quality, Integrity, and Complex Analysis Tasks**

51. **Detect Duplicate Customer Records**  
    - **Rewritten Task:**  
      Create a query that identifies customer records with duplicate key identifiers, indicating potential data quality issues.
    - **Detailed Explanation:**  
      Finding duplicates helps maintain clean and accurate customer data.
    - **Query Guidelines:**  
      - Group customer records by a unique identifier (or combination) and count occurrences.  
      - Filter groups where the count is greater than one.

52. **Validate Product Data Integrity**  
    - **Rewritten Task:**  
      Write a query that checks for anomalies or inconsistencies in product data (e.g., missing values, invalid types).
    - **Detailed Explanation:**  
      Ensuring product data integrity is essential for reliable reporting and decision-making.
    - **Query Guidelines:**  
      - Check for nulls or out-of-range values in critical columns.  
      - Use conditional expressions to flag anomalies.

53. **Identify Orders with Inconsistent Shipping Information**  
    - **Rewritten Task:**  
      Develop a query to detect orders where shipping information is incomplete or inconsistent.
    - **Detailed Explanation:**  
      This helps highlight potential issues in logistics or data entry errors.
    - **Query Guidelines:**  
      - Compare shipping details (like ship date, address) for inconsistencies.  
      - Use conditional checks and filtering to isolate problematic records.

54. **Find Customers Missing Email Addresses**  
    - **Rewritten Task:**  
      Write a query to list customers whose records lack an email address.
    - **Detailed Explanation:**  
      Identifying missing contact information is crucial for customer communications.
    - **Query Guidelines:**  
      - Filter the customer table for rows with NULL or empty email fields.

55. **Detect Products with Inconsistent Pricing History**  
    - **Rewritten Task:**  
      Create a query that identifies products with irregularities in their pricing history, indicating potential errors or strategy changes.
    - **Detailed Explanation:**  
      Analyzing pricing consistency can support competitive pricing analysis.
    - **Query Guidelines:**  
      - Compare historical price data using joins or window functions to highlight anomalies.

56. **Segment Customers by Purchase Behavior**  
    - **Rewritten Task:**  
      Write a query that groups customers based on patterns in their purchasing behavior.
    - **Detailed Explanation:**  
      Customer segmentation aids targeted marketing by identifying distinct behavior patterns.
    - **Query Guidelines:**  
      - Use aggregate functions to summarize purchase frequency, value, and recency.  
      - Apply CASE statements or clustering logic for segmentation.

57. **Conduct a Product Affinity Analysis**  
    - **Rewritten Task:**  
      Develop a query that analyzes which products are frequently purchased together.
    - **Detailed Explanation:**  
      Understanding product affinity can reveal cross-selling opportunities.
    - **Query Guidelines:**  
      - Analyze order line items to detect product co-occurrences.  
      - Use subqueries or self-joins to aggregate and count pairs of products.

58. **Recalculate Customer Lifetime Value (CLV)**  
    - **Rewritten Task:**  
      Write a query that recalculates each customer�s lifetime value based on their cumulative purchase history.
    - **Detailed Explanation:**  
      CLV is critical for prioritizing high-value customers and tailoring engagement strategies.
    - **Query Guidelines:**  
      - Sum total customer spending from the orders table.  
      - Optionally, factor in profit margins for a more refined analysis.

59. **Perform Product Performance Analysis with Seasonality**  
    - **Rewritten Task:**  
      Develop a query to analyze how product sales vary with the seasons.
    - **Detailed Explanation:**  
      Identifying seasonal effects on product sales can inform inventory and marketing strategies.
    - **Query Guidelines:**  
      - Aggregate sales data by season or month.  
      - Compare results across different seasons to highlight trends.

60. **Analyze Sales Trends by Territory**  
    - **Rewritten Task:**  
      Write a query to examine how sales figures differ across various geographic regions.
    - **Detailed Explanation:**  
      This regional analysis supports market segmentation and targeted strategies.
    - **Query Guidelines:**  
      - Join sales data with territory or regional information.  
      - Group and aggregate sales by territory.

61. **Examine Customer Acquisition and Retention Metrics**  
    - **Rewritten Task:**  
      Create a query that analyzes both the acquisition of new customers and the retention of existing ones.
    - **Detailed Explanation:**  
      This dual analysis provides insights into overall customer lifecycle health.
    - **Query Guidelines:**  
      - Use historical order data to identify new versus repeat customers.  
      - Calculate metrics such as acquisition rate and retention rate.

62. **Compare Employee Sales Performance Against Targets**  
    - **Rewritten Task:**  
      Write a query that evaluates each employee�s sales performance relative to their set targets.
    - **Detailed Explanation:**  
      This helps in assessing individual performance and identifying top performers.
    - **Query Guidelines:**  
      - Join employee sales data with target values.  
      - Calculate differences or percentages to measure performance.

63. **Conduct an Inventory Turnover Analysis**  
    - **Rewritten Task:**  
      Develop a query to calculate the rate at which inventory is sold and replaced over a period.
    - **Detailed Explanation:**  
      High turnover indicates efficient inventory management, while low turnover may signal overstocking.
    - **Query Guidelines:**  
      - Use sales and inventory data to compute turnover ratios.  
      - Consider time-based grouping to analyze trends.

64. **Perform a Detailed Customer Demographic Analysis**  
    - **Rewritten Task:**  
      Write a query that examines customer demographics (e.g., age, region) and correlates them with purchasing behavior.
    - **Detailed Explanation:**  
      This analysis helps in tailoring marketing efforts to specific customer segments.
    - **Query Guidelines:**  
      - Join customer demographic tables with order data.  
      - Group and aggregate sales by demographic attributes.

65. **Assess Product Category Performance**  
    - **Rewritten Task:**  
      Create a query to analyze and compare the performance (sales and profitability) of different product categories.
    - **Detailed Explanation:**  
      Understanding category performance aids in inventory and promotional decisions.
    - **Query Guidelines:**  
      - Join product and sales tables to aggregate performance metrics per category.  
      - Use SUM and AVG functions to evaluate revenue and profitability.

66. **Evaluate the Impact of Sales Discounts on Revenue**  
    - **Rewritten Task:**  
      Write a query to analyze how discounting strategies affect overall sales revenue.
    - **Detailed Explanation:**  
      This query helps determine if discounts are driving higher volume or eroding margins.
    - **Query Guidelines:**  
      - Compare sales amounts with and without discounts.  
      - Use calculations to derive percentage differences and analyze trends.

67. **Revisit Customer RFM Analysis for Segmentation**  
    - **Rewritten Task:**  
      Develop a query that segments customers using Recency, Frequency, and Monetary metrics.
    - **Detailed Explanation:**  
      RFM analysis is a repeatable strategy to identify the most valuable customer segments.
    - **Query Guidelines:**  
      - Calculate recency, frequency, and monetary values as in Task 39.  
      - Apply segmentation logic to classify customers accordingly.

68. **Analyze Sales Returns and Their Impact**  
    - **Rewritten Task:**  
      Write a query to quantify and analyze sales returns, including the return rate and associated revenue loss.
    - **Detailed Explanation:**  
      Understanding return patterns can help improve product quality and customer satisfaction.
    - **Query Guidelines:**  
      - Identify returns from sales or return transaction tables.  
      - Aggregate data to calculate return rates and revenue impact.

69. **Compare Customer Acquisition Costs to Lifetime Value**  
    - **Rewritten Task:**  
      Develop a query that compares how much is spent on acquiring a customer versus the revenue they generate over time.
    - **Detailed Explanation:**  
      This comparison informs marketing budget allocation and customer profitability analysis.
    - **Query Guidelines:**  
      - Use customer acquisition cost data (if available) along with lifetime purchase data.  
      - Calculate ratios or differences to assess profitability.

70. **Perform a Price Elasticity Analysis**  
    - **Rewritten Task:**  
      Write a query to evaluate how changes in product pricing affect demand.
    - **Detailed Explanation:**  
      This analysis helps determine the sensitivity of customers to price changes.
    - **Query Guidelines:**  
      - Compare sales data before and after price changes.  
      - Use percentage change calculations to derive elasticity metrics.

71. **Report and Benchmark Employee Performance**  
    - **Rewritten Task:**  
      Create a query to generate a detailed report of employee performance, comparing actual sales against benchmarks.
    - **Detailed Explanation:**  
      Such reports support performance reviews and internal benchmarking.
    - **Query Guidelines:**  
      - Aggregate sales data by employee.  
      - Join with target/benchmark information to calculate variances.

72. **Forecast Sales Using Seasonal Trends**  
    - **Rewritten Task:**  
      Develop a query that uses historical seasonal patterns to predict future sales.
    - **Detailed Explanation:**  
      Seasonal forecasting can inform inventory and staffing decisions.
    - **Query Guidelines:**  
      - Aggregate historical sales data by season.  
      - Use trend analysis functions or statistical models if available.

73. **Segment Customers by Purchase Behavior (Alternate Approach)**  
    - **Rewritten Task:**  
      Write an alternative query for customer segmentation based on their purchasing patterns, reinforcing insights from Task 56.
    - **Detailed Explanation:**  
      Multiple segmentation approaches may yield additional insights.
    - **Query Guidelines:**  
      - Experiment with different grouping strategies or thresholds in your segmentation logic.

74. **Analyze Product Bundle Performance**  
    - **Rewritten Task:**  
      Create a query to examine which product bundles (grouped items) perform best in terms of sales.
    - **Detailed Explanation:**  
      Bundled products can drive higher revenue and customer satisfaction if optimized.
    - **Query Guidelines:**  
      - Identify orders that include bundled products.  
      - Aggregate sales data to compare performance across different bundles.

75. **Assess Sales Channel Effectiveness**  
    - **Rewritten Task:**  
      Write a query to analyze and compare the effectiveness of various sales channels (e.g., online, in-store).
    - **Detailed Explanation:**  
      This analysis reveals which channels drive the most revenue and could influence future channel strategy.
    - **Query Guidelines:**  
      - Join sales data with channel information.  
      - Group and sum revenue by each channel.

76. **Revisit the Comparison of Customer Acquisition Cost and Lifetime Value**  
    - **Rewritten Task:**  
      Write an alternative query that re-evaluates customer acquisition cost versus lifetime value for improved clarity.
    - **Detailed Explanation:**  
      A refined analysis may provide deeper insights into customer profitability.
    - **Query Guidelines:**  
      - Use similar methods as in Task 69 but consider adding more granularity or segmentation.

77. **Analyze the Customer Purchase Path**  
    - **Rewritten Task:**  
      Develop a query that traces the sequence of actions or transactions leading to a purchase.
    - **Detailed Explanation:**  
      Understanding the customer journey helps optimize the sales funnel.
    - **Query Guidelines:**  
      - Use time-ordered data from customer interactions or transaction logs.  
      - Identify common paths or drop-off points.

78. **Perform Price Optimization Analysis**  
    - **Rewritten Task:**  
      Write a query to explore different pricing strategies and their impact on sales performance.
    - **Detailed Explanation:**  
      The goal is to identify an optimal price point that maximizes revenue while staying competitive.
    - **Query Guidelines:**  
      - Compare sales volumes at different price points.  
      - Use statistical aggregation to determine the most effective pricing ranges.

79. **Conduct a Conversion Funnel Analysis**  
    - **Rewritten Task:**  
      Create a query that breaks down the sales funnel stages, from customer visits to completed purchases, and calculates conversion rates at each stage.
    - **Detailed Explanation:**  
      This analysis pinpoints where potential customers drop out, guiding optimization efforts.
    - **Query Guidelines:**  
      - Use event or transaction logs that capture funnel steps.  
      - Calculate conversion percentages between stages.

80. **Analyze Repeat Purchase Probability**  
    - **Rewritten Task:**  
      Write a query to estimate the likelihood that a customer will make a repeat purchase.
    - **Detailed Explanation:**  
      This metric is key for understanding customer loyalty and planning retention strategies.
    - **Query Guidelines:**  
      - Analyze historical order data to determine repeat purchase rates.  
      - Use ratios or probability calculations based on customer frequency.

81. **Assess the Impact of Product Features on Sales**  
    - **Rewritten Task:**  
      Develop a query to analyze how different product features correlate with sales performance.
    - **Detailed Explanation:**  
      Insights here can guide product development and marketing strategies.
    - **Query Guidelines:**  
      - Join product attribute tables with sales data.  
      - Use correlation or grouping techniques to compare performance across feature variations.

82. **Identify Cross-Sell Opportunities**  
    - **Rewritten Task:**  
      Create a query that identifies products that could be marketed together to boost sales.
    - **Detailed Explanation:**  
      Cross-selling analysis can uncover combinations that increase average order value.
    - **Query Guidelines:**  
      - Analyze order data for frequent co-purchase patterns.  
      - Use subqueries or association rules to identify product pairs or groups.

83. **Detect Customers at Risk of Churn**  
    - **Rewritten Task:**  
      Write a query to identify customers who show signs of decreasing engagement or purchasing frequency.
    - **Detailed Explanation:**  
      Early detection of churn risk allows for timely intervention and retention strategies.
    - **Query Guidelines:**  
      - Analyze recency and frequency metrics from order data.  
      - Use thresholds to flag customers with reduced activity.

84. **Revisit Product Affinity Analysis**  
    - **Rewritten Task:**  
      Develop an alternative query to identify products that are frequently purchased together, reinforcing Task 57.
    - **Detailed Explanation:**  
      Multiple approaches may reveal different insights into product affinities.
    - **Query Guidelines:**  
      - Use a variation in join or grouping strategies to cross-validate previous findings.

85. **Analyze Seasonal Trends for Specific Product Categories**  
    - **Rewritten Task:**  
      Write a query to determine how sales of specific product categories vary seasonally.
    - **Detailed Explanation:**  
      This helps in forecasting and inventory management by category.
    - **Query Guidelines:**  
      - Filter and group sales data by product category and season/month.  
      - Compare seasonal totals to identify patterns.

86. **Develop a Dynamic Pricing Model**  
    - **Rewritten Task:**  
      Create a query (or set of queries) to build a model that adjusts product prices based on factors like demand, inventory, and seasonality.
    - **Detailed Explanation:**  
      Dynamic pricing models help optimize revenue by adapting to market conditions in real time.
    - **Query Guidelines:**  
      - Gather historical sales, inventory, and pricing data.  
      - Use statistical functions or incorporate external factors to simulate pricing adjustments.

87. **Predict Customer Lifetime Value**  
    - **Rewritten Task:**  
      Write a query to forecast the future lifetime value of customers based on their past purchasing behavior.
    - **Detailed Explanation:**  
      Predictive CLV helps prioritize high-value customers and adjust marketing strategies.
    - **Query Guidelines:**  
      - Use historical order data along with trend analysis.  
      - Incorporate growth trends or regression analysis as part of the prediction.

88. **Analyze the Marketing Attribution Model**  
    - **Rewritten Task:**  
      Develop a query to evaluate which marketing channels contribute most effectively to customer conversions.
    - **Detailed Explanation:**  
      Attribution analysis reveals how different marketing efforts drive sales.
    - **Query Guidelines:**  
      - Combine marketing campaign data with sales conversion data.  
      - Compare conversion rates and revenue generated per channel.

89. **Develop an Inventory Optimization Model**  
    - **Rewritten Task:**  
      Write a query to analyze current inventory levels, sales trends, and reorder patterns to optimize inventory.
    - **Detailed Explanation:**  
      This analysis helps in reducing overstock or stockouts by aligning inventory with demand.
    - **Query Guidelines:**  
      - Aggregate sales and inventory data over time.  
      - Use calculations to identify optimal reorder points and quantities.

90. **Revisit Customer Demographic Analysis**  
    - **Rewritten Task:**  
      Create a query that re-examines customer demographics and their purchase patterns, possibly with additional segmentation.
    - **Detailed Explanation:**  
      A refreshed demographic analysis might provide new insights into emerging customer segments.
    - **Query Guidelines:**  
      - Use similar joins as in Task 64, but consider additional demographic fields or finer segmentation.

91. **Reassess Product Category Performance Analysis**  
    - **Rewritten Task:**  
      Write a query to revisit the performance of product categories, including additional performance metrics if needed.
    - **Detailed Explanation:**  
      This analysis confirms or refines previous insights on category performance.
    - **Query Guidelines:**  
      - Use aggregate functions on sales and profit data by category.  
      - Compare with previous results to identify trends.

92. **Evaluate the Effects of Sales Discounting Again**  
    - **Rewritten Task:**  
      Develop an alternate query to assess the impact of discounts on sales revenue and profitability.
    - **Detailed Explanation:**  
      Re-examining discount effects might reveal different insights when segmented by product or time period.
    - **Query Guidelines:**  
      - Use a similar approach as in Task 66 with potential segmentation.

93. **Reperform Customer RFM Analysis for a Refined Segmentation**  
    - **Rewritten Task:**  
      Write another version of the RFM analysis query to segment customers, possibly using different thresholds.
    - **Detailed Explanation:**  
      A refined segmentation can help better target specific customer groups.
    - **Query Guidelines:**  
      - Reuse the logic from Tasks 39 and 67 with adjustments to grouping criteria.

94. **Conduct Another Round of Sales Return Analysis**  
    - **Rewritten Task:**  
      Create a query that further examines sales returns, focusing on different time frames or product groups.
    - **Detailed Explanation:**  
      This can help identify if return rates vary by season or product type.
    - **Query Guidelines:**  
      - Use additional grouping or filtering beyond Task 68 to drill down into the data.

95. **Revisit the Comparison Between Customer Acquisition Cost and Lifetime Value**  
    - **Rewritten Task:**  
      Write a further refined query to compare acquisition costs against lifetime value for deeper insights.
    - **Detailed Explanation:**  
      Iterating on this analysis can help validate previous findings or highlight new trends.
    - **Query Guidelines:**  
      - Use additional segmentation or more detailed cost data if available.

96. **Conduct Another Price Optimization Analysis**  
    - **Rewritten Task:**  
      Develop an alternate query for evaluating optimal pricing strategies, considering new variables if possible.
    - **Detailed Explanation:**  
      This may involve incorporating external market factors to refine your pricing model.
    - **Query Guidelines:**  
      - Extend the approach from Task 78 with additional variables or time segments.

97. **Perform a Detailed Conversion Funnel Analysis Again**  
    - **Rewritten Task:**  
      Write another query to dissect the conversion funnel with more granularity.
    - **Detailed Explanation:**  
      A detailed breakdown can pinpoint the precise stages where conversion rates drop.
    - **Query Guidelines:**  
      - Use detailed logs and multiple aggregation layers to analyze each funnel stage.

98. **Reevaluate Repeat Purchase Probability**  
    - **Rewritten Task:**  
      Develop an alternate query to assess the probability of repeat purchases, refining the model from earlier.
    - **Detailed Explanation:**  
      Additional segmentation may reveal nuances in customer loyalty.
    - **Query Guidelines:**  
      - Build on Task 80�s methodology, adding segmentation by customer type or region.

99. **Assess How Product Features Impact Sales Again**  
    - **Rewritten Task:**  
      Write a query to further analyze the correlation between various product features and their sales performance.
    - **Detailed Explanation:**  
      This deeper analysis might uncover subtle influences that inform product development.
    - **Query Guidelines:**  
      - Revisit the approach from Task 81 with additional product attributes.

100. **Identify Cross-Sell Opportunities Once More**  
    - **Rewritten Task:**  
      Create an alternative query to identify additional cross-sell opportunities by exploring different product combinations.
    - **Detailed Explanation:**  
      A different approach might uncover new pairing opportunities that were not visible before.
    - **Query Guidelines:**  
      - Use variations in your grouping and correlation analysis based on Task 82�s strategy.

---

Each of these rewritten tasks and explanations not only clarifies the intent behind the original question but also provides you with a step-by-step guideline to write your own queries. As you develop your SQL statements, consider the schema relationships in AdventureWorks (e.g., primary keys, foreign keys, and table relationships) and adjust your JOINs, aggregation functions, and filtering conditions accordingly.

Feel free to adapt these guidelines based on your specific requirements and the SQL dialect you are using. Happy querying!

*/


-- Mistral AI


Here is a comprehensive list of 100 SQL query tasks, each rewritten for clarity and accompanied by detailed explanations and guidelines. These tasks are designed to help you practice and improve your SQL skills using the AdventureWorks OLTP database.

---

## **Basic Data Retrieval and Aggregation Tasks**

1. **Identify the Top 10 Highest-Paid Employees**
   - **Task:** Retrieve the top 10 employees who receive the highest salaries from the employee salary data.
   - **Explanation:** This task involves identifying the employees with the highest compensation. You need to locate the table(s) that store salary information (e.g., *EmployeePayHistory*) and join with the employee master table to retrieve additional details (like name or job title).
   - **Guidelines:**
     - Determine which table(s) contain salary information.
     - Join with the employee master table to retrieve additional details if necessary.
     - Use an ORDER BY clause on the salary column in descending order.
     - Limit the result to 10 records using TOP or LIMIT based on your SQL dialect.

2. **Compute the Total Number of Orders Placed Each Year**
   - **Task:** Calculate the yearly count of orders, allowing you to track order volume trends over time.
   - **Explanation:** This analysis helps in understanding the business growth and seasonal patterns by aggregating orders by the year they were placed.
   - **Guidelines:**
     - Identify the orders table (e.g., *SalesOrderHeader*) and the column that holds the order date.
     - Use a GROUP BY clause to group orders by the year extracted from the order date.
     - Use an aggregate function (COUNT) to get the total orders for each year.

3. **Find Loyal Customers with More Than 5 Orders**
   - **Task:** Retrieve customers who have placed more than five orders, highlighting the most engaged customers.
   - **Explanation:** By finding customers with multiple orders, you can target them for loyalty rewards or special marketing campaigns.
   - **Guidelines:**
     - Identify the customer and order tables.
     - Join these tables if necessary.
     - Group the data by customer ID and count the number of orders per customer.
     - Use a HAVING clause to filter customers where the count exceeds five.

4. **Determine the Most Popular Product by Sales Quantity**
   - **Task:** Find the product that has been sold in the highest quantity, indicating its popularity.
   - **Explanation:** This task measures product demand by summing the sales quantity across all transactions.
   - **Guidelines:**
     - Locate the sales detail table that records product quantities sold (e.g., *SalesOrderDetail*).
     - GROUP BY product ID and sum the quantity sold.
     - Order the results in descending order by the total quantity and limit to the top result.

5. **Calculate Revenue Per Product Category**
   - **Task:** Write a query to calculate the total revenue generated by each product category, providing insight into category performance.
   - **Explanation:** This analysis helps in understanding which product categories drive revenue and can influence inventory and marketing decisions.
   - **Guidelines:**
     - Identify the tables containing sales and product category details (e.g., *SalesOrderDetail*, *Product*, *ProductCategory*).
     - Use JOINs to combine sales data with category information.
     - Multiply quantity by price (or use an existing revenue column) and sum the revenue per category.
     - Group by product category.

6. **Identify Customers Without Any Orders**
   - **Task:** List customers who have never placed an order.
   - **Explanation:** This task is useful for identifying inactive or new customers for re-engagement campaigns.
   - **Guidelines:**
     - Identify the customer table and the orders table.
     - Use an outer join or a NOT EXISTS subquery to find customers that do not have matching orders in the orders table.

7. **Compute the Average Order Total for Each Customer**
   - **Task:** Calculate the average order value per customer, giving insights into customer spending patterns.
   - **Explanation:** This measure of customer spending helps in understanding purchasing behavior and segmenting customers by value.
   - **Guidelines:**
     - Identify the order totals from the orders table.
     - Group by customer ID and use AVG() to compute the average order total for each customer.

8. **Find Employees with Over 10 Years of Service**
   - **Task:** Identify employees who have been with the company for more than 10 years.
   - **Explanation:** Recognizing long-tenured employees can support internal award programs and understand retention trends.
   - **Guidelines:**
     - Identify the employee table with hire date information.
     - Calculate the difference between the current date and the hire date.
     - Filter for employees whose tenure exceeds 10 years.

9. **List Employees with Their Manager’s Name**
   - **Task:** Show each employee along with the name of their direct manager.
   - **Explanation:** This hierarchical view helps understand the reporting structure within the organization.
   - **Guidelines:**
     - Use the employee table where a manager or supervisor ID is stored.
     - Perform a self-join on the employee table to link each employee to their manager’s record.
     - Select the employee name and the manager name in your result.

10. **Calculate the Average Monthly Sales for the Past 5 Years**
    - **Task:** Compute the average sales per month over the last 5 years to analyze ongoing sales trends.
    - **Explanation:** This task helps in identifying long-term trends by smoothing out fluctuations across months over multiple years.
    - **Guidelines:**
      - Identify the sales table and the column for order date and sales amount.
      - Filter data to include only the last 5 years.
      - Group by month (and possibly year) and calculate the monthly totals, then compute the average over these months.

---

## **Exploring Schema Metadata**

11. **Retrieve Metadata for a Specific Table**
    - **Task:** Extract detailed column information (names, data types, etc.) from a specific table in the database.
    - **Explanation:** Understanding the table schema is essential for building correct queries and ensuring data integrity.
    - **Guidelines:**
      - Use system catalog views or information schema views (e.g., *INFORMATION_SCHEMA.COLUMNS*) to retrieve column details.
      - Filter the results by the table name you are interested in.

---

## **Advanced and Expert SQL Practice Tasks**

12. **List Products That Have Never Been Sold**
    - **Task:** Identify products in your inventory that have no associated sales records.
    - **Explanation:** This can help in inventory management by highlighting products that may need promotions or discontinuation.
    - **Guidelines:**
      - Identify the product table and the sales details table.
      - Use a LEFT JOIN or NOT EXISTS clause to filter products with no matching sales records.

13. **Construct an Employee Hierarchy Using a Recursive CTE**
    - **Task:** Create a recursive Common Table Expression (CTE) to build a full reporting hierarchy of employees.
    - **Explanation:** Recursive CTEs are useful for traversing hierarchical or tree-structured data such as an organizational chart.
    - **Guidelines:**
      - Start with the top-level manager(s) as the anchor query.
      - Recursively join the employee table to add subordinates.
      - Ensure the recursion terminates properly to avoid infinite loops.

14. **Determine the Top 5 Customers by Order Count**
    - **Task:** Rank and retrieve the five customers who have placed the highest number of orders.
    - **Explanation:** This analysis helps identify customers who frequently engage with your business.
    - **Guidelines:**
      - Group orders by customer ID and count the orders.
      - Order the result in descending order by the count and limit the output to the top 5.

15. **Retrieve Products Ordered Over 100 Times**
    - **Task:** Find products which have been ordered more than 100 times.
    - **Explanation:** Identifying high-demand products can inform inventory decisions and marketing strategies.
    - **Guidelines:**
      - Aggregate order data from the sales details table grouped by product ID.
      - Filter using a HAVING clause where the summed quantity is greater than 100.

16. **Find Products in the Same Category as 'Mountain Bikes'**
    - **Task:** List all products that belong to the same category as the 'Mountain Bikes' product.
    - **Explanation:** This can be useful for cross-selling by recommending similar products to customers.
    - **Guidelines:**
      - Identify the product category of 'Mountain Bikes'.
      - Use JOINs to match products with their category and filter for the matching category.

17. **Join Orders with Customer Information Using Various Join Types**
    - **Task:** Combine order data with customer details using different types of joins (INNER, LEFT, RIGHT, etc.) to see how they affect the result set.
    - **Explanation:** Exploring different join types will help you understand how to include or exclude records based on the existence of related data.
    - **Guidelines:**
      - Identify the orders table and the customer table.
      - Write separate queries for each join type to observe the differences in the returned dataset.

18. **Identify Vendors Supplying the Largest Number of Products**
    - **Task:** Determine which vendors supply the most products to your inventory.
    - **Explanation:** This helps in supplier management and negotiating better terms by knowing which vendors are the primary sources of products.
    - **Guidelines:**
      - Identify tables containing vendor information and product details.
      - Group the products by vendor and count the number of products each supplies.
      - Order the result in descending order by product count.

19. **Discover Products Purchased by the Most Unique Customers**
    - **Task:** Identify the products that have been bought by the highest number of distinct customers.
    - **Explanation:** This indicates products with broad appeal and can help in understanding customer preferences.
    - **Guidelines:**
      - Use the sales details table and customer data.
      - Group by product and use COUNT(DISTINCT customerID) to find unique customer counts.
      - Order the results to highlight the most popular products by customer diversity.

20. **Find Employees Sharing the Same Job Title Using a Self-Join**
    - **Task:** Develop a query that finds pairs or groups of employees who hold the same job title by joining the employee table with itself.
    - **Explanation:** This can help analyze role distributions and verify whether multiple employees perform similar functions.
    - **Guidelines:**
      - Self-join the employee table on the job title column.
      - Exclude self-matches if necessary and select distinct job titles along with employee details.

21. **Compute the Running Total of Monthly Sales**
    - **Task:** Calculate a cumulative sum of sales totals by month.
    - **Explanation:** A running total can help visualize sales growth and monitor progress over a period.
    - **Guidelines:**
      - Use window functions (like SUM() OVER (ORDER BY month)) to compute cumulative totals.
      - Ensure that data is ordered correctly (by month or date).

22. **Rank Products Within Each Category by Sales Quantity**
    - **Task:** Assign a rank to products based on the quantity sold within each product category.
    - **Explanation:** Ranking products within categories helps highlight top performers and may inform category-specific strategies.
    - **Guidelines:**
      - Use window functions such as RANK() or DENSE_RANK() partitioned by category.
      - Order by the sales quantity in descending order.

23. **Determine Each Product’s Contribution to Total Sales (Percentage)**
    - **Task:** Calculate what percentage of the overall sales each product represents.
    - **Explanation:** This analysis aids in understanding the relative performance of each product.
    - **Guidelines:**
      - Sum sales per product and calculate the total sales.
      - Use a subquery or window function to compute each product’s percentage contribution.

24. **Compute Month-over-Month Sales Differences**
    - **Task:** Determine the difference in sales between each consecutive month.
    - **Explanation:** Analyzing the difference between months helps identify trends, seasonal patterns, or sudden changes.
    - **Guidelines:**
      - Use window functions like LAG() to compare the sales amount of the current month with the previous month.
      - Calculate the difference and format the output for clarity.

25. **Calculate a 3-Month Moving Average for Sales**
    - **Task:** Compute a moving average of sales over a 3-month window to smooth out fluctuations.
    - **Explanation:** A moving average helps in identifying longer-term trends by minimizing short-term volatility.
    - **Guidelines:**
      - Use window functions (e.g., AVG() OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)).
      - Ensure proper ordering and partitioning if needed.

26. **Find Customers Who Purchased Products from Every Category Using a CTE**
    - **Task:** List customers who have made purchases in all available product categories.
    - **Explanation:** This query identifies diverse buyers whose purchasing patterns span the entire product line.
    - **Guidelines:**
      - Use a CTE to first determine all product categories.
      - Join or compare customer purchase records against the complete list of categories, filtering for those matching all.

27. **Identify Cross-Selling Opportunities with Subqueries**
    - **Task:** Create a query that uses subqueries to identify products that are frequently purchased together.
    - **Explanation:** Discovering product affinities can lead to effective cross-selling strategies and improved customer recommendations.
    - **Guidelines:**
      - Analyze order details to determine co-occurrence of products in the same order.
      - Use subqueries to compare order lists and identify frequent pairings.

28. **Generate a Hierarchical View of Product Categories and Subcategories Using a CTE**
    - **Task:** Write a recursive CTE to build a tree structure showing product categories and their respective subcategories.
    - **Explanation:** This approach clarifies the product catalog structure and aids in categorization analysis.
    - **Guidelines:**
      - Identify parent-child relationships in the category table.
      - Construct an anchor query for the top-level categories and a recursive part for subcategories.

29. **Detect Products with a History of Price Changes Using a CTE**
    - **Task:** Create a query that uses a CTE to list products that have experienced changes in pricing over time.
    - **Explanation:** Tracking price changes can reveal pricing strategy trends and inform future adjustments.
    - **Guidelines:**
      - Identify historical price records from the product pricing history table.
      - Use a CTE to compare previous and current prices, filtering for products with differences.

30. **Identify the Top 3 Products in Each Subcategory by Sales Amount**
    - **Task:** Rank products within each subcategory and extract the top three based on sales revenue.
    - **Explanation:** This analysis helps pinpoint high-performing products at a more granular subcategory level.
    - **Guidelines:**
      - Use window functions like RANK() partitioned by subcategory.
      - Filter to return only the top three per subcategory.

31. **Analyze Sales by Day of the Week**
    - **Task:** Aggregate sales data by day of the week, highlighting daily performance patterns.
    - **Explanation:** Understanding daily sales trends can inform staffing, promotions, and operational planning.
    - **Guidelines:**
      - Extract the day of the week from the order date.
      - GROUP BY this extracted value and sum the sales for each day.

32. **Identify Seasonal Trends in Sales by Quarter and Month**
    - **Task:** Analyze sales data by both quarter and month to detect seasonal variations.
    - **Explanation:** This analysis helps in planning for seasonal demand and adjusting strategies accordingly.
    - **Guidelines:**
      - Extract quarter and month from the order date.
      - Group the data accordingly and compare sales totals across different time frames.

33. **Calculate the Delivery Time for Each Order**
    - **Task:** Compute the number of days between the order date and the ship date.
    - **Explanation:** This metric is critical for evaluating order fulfillment efficiency.
    - **Guidelines:**
      - Use date functions to subtract the order date from the ship date.
      - Present the result as a new column representing the delivery duration.

34. **Identify Orders Shipped After the Promised Due Date**
    - **Task:** Flag orders where the ship date exceeds the promised delivery date.
    - **Explanation:** Highlighting late shipments can help in addressing fulfillment issues and improving service.
    - **Guidelines:**
      - Compare the ship date with the due date in your orders table.
      - Filter for records where the ship date is later than the due date.

35. **Analyze Yearly and Quarterly Sales Growth Rates**
    - **Task:** Calculate sales growth rates by comparing sales data from consecutive years and quarters.
    - **Explanation:** This helps in tracking business performance trends and forecasting future growth.
    - **Guidelines:**
      - Group sales data by year and quarter.
      - Compute the growth rate by comparing the current period’s sales with the previous period.

36. **Examine Sales Performance by Territory**
    - **Task:** Analyze product sales across different geographic territories.
    - **Explanation:** Regional analysis can reveal market trends and areas needing targeted strategies.
    - **Guidelines:**
      - Join sales data with territory information (which might come from customer or sales tables).
      - Aggregate sales by territory.

37. **Calculate Customer Lifetime Value (CLV)**
    - **Task:** Compute the lifetime value of each customer based on their historical purchases.
    - **Explanation:** CLV is a critical metric for understanding customer profitability and guiding retention strategies.
    - **Guidelines:**
      - Sum all orders per customer over time.
      - Consider additional factors such as profit margins if available.

38. **Determine Product Profit Margins**
    - **Task:** Calculate the profit margin for each product.
    - **Explanation:** This helps in assessing product profitability and informing pricing strategies.
    - **Guidelines:**
      - Use revenue and cost data from the product and sales tables.
      - Compute margin as (Sales Price - Cost) divided by Sales Price.

39. **Segment Customers Based on Recency, Frequency, and Monetary Value (RFM Analysis)**
    - **Task:** Group customers by evaluating how recently and frequently they buy, and how much they spend.
    - **Explanation:** RFM segmentation helps identify high-value customers and tailor marketing strategies accordingly.
    - **Guidelines:**
      - Calculate the recency, frequency, and total spend for each customer.
      - Use CASE statements or additional subqueries to group customers into segments.

40. **Analyze Sales Trends by Demographic Factors**
    - **Task:** Compare sales data across various customer demographic groups.
    - **Explanation:** This analysis aids in understanding market segments and targeting promotions more effectively.
    - **Guidelines:**
      - Join customer demographic tables with sales records.
      - Group and aggregate sales by relevant demographic attributes.

41. **Identify the Most Resource-Intensive Queries Using Execution Statistics**
    - **Task:** Reveal the queries consuming the most system resources based on execution statistics.
    - **Explanation:** This is crucial for database performance tuning and identifying areas for optimization.
    - **Guidelines:**
      - Query system views or DMVs that capture query execution statistics.
      - Order the results based on metrics such as CPU time or execution duration.

42. **Examine Index Usage Statistics**
    - **Task:** Review how frequently indexes are used, which can help in performance tuning.
    - **Explanation:** Analyzing index usage helps determine whether existing indexes are effective or if new indexes are needed.
    - **Guidelines:**
      - Query system catalog views that report index statistics.
      - Focus on usage counts and performance metrics.

43. **Identify Tables Lacking Indexes**
    - **Task:** List tables that do not have any indexes, indicating potential performance issues.
    - **Explanation:** Tables without indexes can lead to slower query performance, especially on large datasets.
    - **Guidelines:**
      - Query system metadata to find tables without associated index entries.

44. **Find Unused Indexes**
    - **Task:** Detect indexes that are rarely or never used.
    - **Explanation:** Unused indexes can be removed to optimize storage and performance.
    - **Guidelines:**
      - Use system DMV reports that include index usage statistics.
      - Filter for indexes with little to no usage over a defined period.

45. **Create an Indexed View for Frequently Accessed Data**
    - **Task:** Write a query to create an indexed view that pre-aggregates or pre-joins data frequently accessed by users.
    - **Explanation:** Indexed views can speed up query performance by storing computed results.
    - **Guidelines:**
      - Define the view with a SELECT statement that aggregates or joins data.
      - Create a unique clustered index on the view to materialize it.

46. **Develop a Stored Procedure to Retrieve Customer Orders**
    - **Task:** Create a stored procedure that accepts customer parameters and returns their order details.
    - **Explanation:** Stored procedures encapsulate logic for reusability and can improve security and performance.
    - **Guidelines:**
      - Define input parameters (e.g., customer ID).
      - Write the SELECT query to retrieve order details and include error handling as needed.

47. **Build a Function to Calculate Total Inventory Value**
    - **Task:** Write a scalar function that computes the total inventory value by multiplying quantities by their unit costs.
    - **Explanation:** This function helps in assessing the overall value of inventory holdings.
    - **Guidelines:**
      - Accept necessary parameters if needed, or reference inventory tables directly.
      - Return the computed total using appropriate arithmetic operations.

48. **Create a Stored Procedure for Product Reordering Analysis**
    - **Task:** Develop a stored procedure that analyzes product sales and inventory levels to suggest when reordering is required.
    - **Explanation:** This helps ensure inventory levels are optimized, preventing stockouts.
    - **Guidelines:**
      - Include logic that compares current inventory levels against historical sales or reorder thresholds.
      - Return products that require reordering based on defined criteria.

49. **Develop a Function to Calculate Employee Tenure**
    - **Task:** Create a scalar function that computes the length of service (tenure) for an employee using their hire date.
    - **Explanation:** Employee tenure insights can support HR analyses and recognition programs.
    - **Guidelines:**
      - Accept an employee’s hire date as input.
      - Return the tenure by calculating the difference from the current date.

50. **Construct a Stored Procedure for Sales Forecasting**
    - **Task:** Write a stored procedure that processes historical sales data to forecast future sales trends.
    - **Explanation:** Sales forecasting can inform budgeting and strategy by predicting future revenue.
    - **Guidelines:**
      - Use historical sales data aggregated over time periods.
      - Incorporate statistical functions or simple trend analysis logic.

---

## **Data Quality, Integrity, and Complex Analysis Tasks**

51. **Detect Duplicate Customer Records**
    - **Task:** Identify customer records with duplicate key identifiers, indicating potential data quality issues.
    - **Explanation:** Finding duplicates helps maintain clean and accurate customer data.
    - **Guidelines:**
      - Group customer records by a unique identifier (or combination) and count occurrences.
      - Filter groups where the count is greater than one.

52. **Validate Product Data Integrity**
    - **Task:** Check for anomalies or inconsistencies in product data (e.g., missing values, invalid types).
    - **Explanation:** Ensuring product data integrity is essential for reliable reporting and decision-making.
    - **Guidelines:**
      - Check for nulls or out-of-range values in critical columns.
      - Use conditional expressions to flag anomalies.

53. **Identify Orders with Inconsistent Shipping Information**
    - **Task:** Detect orders where shipping information is incomplete or inconsistent.
    - **Explanation:** This helps highlight potential issues in logistics or data entry errors.
    - **Guidelines:**
      - Compare shipping details (like ship date, address) for inconsistencies.
      - Use conditional checks and filtering to isolate problematic records.

54. **Find Customers Missing Email Addresses**
    - **Task:** List customers whose records lack an email address.
    - **Explanation:** Identifying missing contact information is crucial for customer communications.
    - **Guidelines:**
      - Filter the customer table for rows with NULL or empty email fields.

55. **Detect Products with Inconsistent Pricing History**
    - **Task:** Identify products with irregularities in their pricing history, indicating potential errors or strategy changes.
    - **Explanation:** Analyzing pricing consistency can support competitive pricing analysis.
    - **Guidelines:**
      - Compare historical price data using joins or window functions to highlight anomalies.

56. **Segment Customers by Purchase Behavior**
    - **Task:** Group customers based on patterns in their purchasing behavior.
    - **Explanation:** Customer segmentation aids targeted marketing by identifying distinct behavior patterns.
    - **Guidelines:**
      - Use aggregate functions to summarize purchase frequency, value, and recency.
      - Apply CASE statements or clustering logic for segmentation.

57. **Conduct a Product Affinity Analysis**
    - **Task:** Analyze which products are frequently purchased together.
    - **Explanation:** Understanding product affinity can reveal cross-selling opportunities.
    - **Guidelines:**
      - Analyze order line items to detect product co-occurrences.
      - Use subqueries or self-joins to aggregate and count pairs of products.

58. **Recalculate Customer Lifetime Value (CLV)**
    - **Task:** Recompute each customer’s lifetime value based on their cumulative purchase history.
    - **Explanation:** CLV is critical for prioritizing high-value customers and tailoring engagement strategies.
    - **Guidelines:**
      - Sum total customer spending from the orders table.
      - Optionally, factor in profit margins for a more refined analysis.

59. **Perform Product Performance Analysis with Seasonality**
    - **Task:** Analyze how product sales vary with the seasons.
    - **Explanation:** Identifying seasonal effects on product sales can inform inventory and marketing strategies.
    - **Guidelines:**
      - Aggregate sales data by season or month.
      - Compare results across different seasons to highlight trends.

60. **Analyze Sales Trends by Territory**
    - **Task:** Examine how sales figures differ across various geographic regions.
    - **Explanation:** This regional analysis supports market segmentation and targeted strategies.
    - **Guidelines:**
      - Join sales data with territory or regional information.
      - Group and aggregate sales by territory.

61. **Examine Customer Acquisition and Retention Metrics**
    - **Task:** Analyze both the acquisition of new customers and the retention of existing ones.
    - **Explanation:** This dual analysis provides insights into overall customer lifecycle health.
    - **Guidelines:**
      - Use historical order data to identify new versus repeat customers.
      - Calculate metrics such as acquisition rate and retention rate.

62. **Compare Employee Sales Performance Against Targets**
    - **Task:** Evaluate each employee’s sales performance relative to their set targets.
    - **Explanation:** This helps in assessing individual performance and identifying top performers.
    - **Guidelines:**
      - Join employee sales data with target values.
      - Calculate differences or percentages to measure performance.

63. **Conduct an Inventory Turnover Analysis**
    - **Task:** Calculate the rate at which inventory is sold and replaced over a period.
    - **Explanation:** High turnover indicates efficient inventory management, while low turnover may signal overstocking.
    - **Guidelines:**
      - Use sales and inventory data to compute turnover ratios.
      - Consider time-based grouping to analyze trends.

64. **Perform a Detailed Customer Demographic Analysis**
    - **Task:** Examine customer demographics (e.g., age, region) and correlate them with purchasing behavior.
    - **Explanation:** This analysis helps in tailoring marketing efforts to specific customer segments.
    - **Guidelines:**
      - Join customer demographic tables with order data.
      - Group and aggregate sales by demographic attributes.

65. **Assess Product Category Performance**
    - **Task:** Analyze and compare the performance (sales and profitability) of different product categories.
    - **Explanation:** Understanding category performance aids in inventory and promotional decisions.
    - **Guidelines:**
      - Join product and sales tables to aggregate performance metrics per category.
      - Use SUM and AVG functions to evaluate revenue and profitability.

66. **Evaluate the Impact of Sales Discounts on Revenue**
    - **Task:** Analyze how discounting strategies affect overall sales revenue.
    - **Explanation:** This query helps determine if discounts are driving higher volume or eroding margins.
    - **Guidelines:**
      - Compare sales amounts with and without discounts.
      - Use calculations to derive percentage differences and analyze trends.

67. **Revisit Customer RFM Analysis for Segmentation**
    - **Task:** Develop a query that segments customers using Recency, Frequency, and Monetary metrics.
    - **Explanation:** RFM analysis is a repeatable strategy to identify the most valuable customer segments.
    - **Guidelines:**
      - Calculate recency, frequency, and monetary values as in Task 39.
      - Apply segmentation logic to classify customers accordingly.

68. **Analyze Sales Returns and Their Impact**
    - **Task:** Quantify and analyze sales returns, including the return rate and associated revenue loss.
    - **Explanation:** Understanding return patterns can help improve product quality and customer satisfaction.
    - **Guidelines:**
      - Identify returns from sales or return transaction tables.
      - Aggregate data to calculate return rates and revenue impact.

69. **Compare Customer Acquisition Costs to Lifetime Value**
    - **Task:** Develop a query that compares how much is spent on acquiring a customer versus the revenue they generate over time.
    - **Explanation:** This comparison informs marketing budget allocation and customer profitability analysis.
    - **Guidelines:**
      - Use customer acquisition cost data (if available) along with lifetime purchase data.
      - Calculate ratios or differences to assess profitability.

70. **Perform a Price Elasticity Analysis**
    - **Task:** Evaluate how changes in product pricing affect demand.
    - **Explanation:** This analysis helps determine the sensitivity of customers to price changes.
    - **Guidelines:**
      - Compare sales data before and after price changes.
      - Use percentage change calculations to derive elasticity metrics.

71. **Report and Benchmark Employee Performance**
    - **Task:** Create a query to generate a detailed report of employee performance, comparing actual sales against benchmarks.
    - **Explanation:** Such reports support performance reviews and internal benchmarking.
    - **Guidelines:**
      - Aggregate sales data by employee.
      - Join with target/benchmark information to calculate variances.

72. **Forecast Sales Using Seasonal Trends**
    - **Task:** Develop a query that uses historical seasonal patterns to predict future sales.
    - **Explanation:** Seasonal forecasting can inform inventory and staffing decisions.
    - **Guidelines:**
      - Aggregate historical sales data by season.
      - Use trend analysis functions or statistical models if available.

73. **Segment Customers by Purchase Behavior (Alternate Approach)**
    - **Task:** Write an alternative query for customer segmentation based on their purchasing patterns, reinforcing insights from Task 56.
    - **Explanation:** Multiple segmentation approaches may yield additional insights.
    - **Guidelines:**
      - Experiment with different grouping strategies or thresholds in your segmentation logic.

74. **Analyze Product Bundle Performance**
    - **Task:** Examine which product bundles (grouped items) perform best in terms of sales.
    - **Explanation:** Bundled products can drive higher revenue and customer satisfaction if optimized.
    - **Guidelines:**
      - Identify orders that include bundled products.
      - Aggregate sales data to compare performance across different bundles.

75. **Assess Sales Channel Effectiveness**
    - **Task:** Analyze and compare the effectiveness of various sales channels (e.g., online, in-store).
    - **Explanation:** This analysis reveals which channels drive the most revenue and could influence future channel strategy.
    - **Guidelines:**
      - Join sales data with channel information.
      - Group and sum revenue by each channel.

76. **Revisit the Comparison of Customer Acquisition Cost and Lifetime Value**
    - **Task:** Write an alternative query that re-evaluates customer acquisition cost versus lifetime value for improved clarity.
    - **Explanation:** A refined analysis may provide deeper insights into customer profitability.
    - **Guidelines:**
      - Use similar methods as in Task 69 but consider adding more granularity or segmentation.

77. **Analyze the Customer Purchase Path**
    - **Task:** Develop a query that traces the sequence of actions or transactions leading to a purchase.
    - **Explanation:** Understanding the customer journey helps optimize the sales funnel.
    - **Guidelines:**
      - Use time-ordered data from customer interactions or transaction logs.
      - Identify common paths or drop-off points.

78. **Perform Price Optimization Analysis**
    - **Task:** Explore different pricing strategies and their impact on sales performance.
    - **Explanation:** The goal is to identify an optimal price point that maximizes revenue while staying competitive.
    - **Guidelines:**
      - Compare sales volumes at different price points.
      - Use statistical aggregation to determine the most effective pricing ranges.

79. **Conduct a Conversion Funnel Analysis**
    - **Task:** Create a query that breaks down the sales funnel stages, from customer visits to completed purchases, and calculates conversion rates at each stage.
    - **Explanation:** This analysis pinpoints where potential customers drop out, guiding optimization efforts.
    - **Guidelines:**
      - Use event or transaction logs that capture funnel steps.
      - Calculate conversion percentages between stages.

80. **Analyze Repeat Purchase Probability**
    - **Task:** Estimate the likelihood that a customer will make a repeat purchase.
    - **Explanation:** This metric is key for understanding customer loyalty and planning retention strategies.
    - **Guidelines:**
      - Analyze historical order data to determine repeat purchase rates.
      - Use ratios or probability calculations based on customer frequency.

81. **Assess the Impact of Product Features on Sales**
    - **Task:** Analyze how different product features correlate with sales performance.
    - **Explanation:** Insights here can guide product development and marketing strategies.
    - **Guidelines:**
      - Join product attribute tables with sales data.
      - Use correlation or grouping techniques to compare performance across feature variations.

82. **Identify Cross-Sell Opportunities**
    - **Task:** Create a query that identifies products that could be marketed together to boost sales.
    - **Explanation:** Cross-selling analysis can uncover combinations that increase average order value.
    - **Guidelines:**
      - Analyze order data for frequent co-purchase patterns.
      - Use subqueries or association rules to identify product pairs or groups.

83. **Detect Customers at Risk of Churn**
    - **Task:** Identify customers who show signs of decreasing engagement or purchasing frequency.
    - **Explanation:** Early detection of churn risk allows for timely intervention and retention strategies.
    - **Guidelines:**
      - Analyze recency and frequency metrics from order data.
      - Use thresholds to flag customers with reduced activity.

84. **Revisit Product Affinity Analysis**
    - **Task:** Develop an alternative query to identify products that are frequently purchased together, reinforcing Task 57.
    - **Explanation:** Multiple approaches may reveal different insights into product affinities.
    - **Guidelines:**
      - Use a variation in join or grouping strategies to cross-validate previous findings.

85. **Analyze Seasonal Trends for Specific Product Categories**
    - **Task:** Determine how sales of specific product categories vary seasonally.
    - **Explanation:** This helps in forecasting and inventory management by category.
    - **Guidelines:**
      - Filter and group sales data by product category and season/month.
      - Compare seasonal totals to identify patterns.

86. **Develop a Dynamic Pricing Model**
    - **Task:** Create a query (or set of queries) to build a model that adjusts product prices based on factors like demand, inventory, and seasonality.
    - **Explanation:** Dynamic pricing models help optimize revenue by adapting to market conditions in real time.
    - **Guidelines:**
      - Gather historical sales, inventory, and pricing data.
      - Use statistical functions or incorporate external factors to simulate pricing adjustments.

87. **Predict Customer Lifetime Value**
    - **Task:** Forecast the future lifetime value of customers based on their past purchasing behavior.
    - **Explanation:** Predictive CLV helps prioritize high-value customers and adjust marketing strategies.
    - **Guidelines:**
      - Use historical order data along with trend analysis.
      - Incorporate growth trends or regression analysis as part of the prediction.

88. **Analyze the Marketing Attribution Model**
    - **Task:** Evaluate which marketing channels contribute most effectively to customer conversions.
    - **Explanation:** Attribution analysis reveals how different marketing efforts drive sales.
    - **Guidelines:**
      - Combine marketing campaign data with sales conversion data.
      - Compare conversion rates and revenue generated per channel.

89. **Develop an Inventory Optimization Model**
    - **Task:** Analyze current inventory levels, sales trends, and reorder patterns to optimize inventory.
    - **Explanation:** This analysis helps in reducing overstock or stockouts by aligning inventory with demand.
    - **Guidelines:**
      - Aggregate sales and inventory data over time.
      - Use calculations to identify optimal reorder points and quantities.

90. **Revisit Customer Demographic Analysis**
    - **Task:** Create a query that re-examines customer demographics and their purchase patterns, possibly with additional segmentation.
    - **Explanation:** A refreshed demographic analysis might provide new insights into emerging customer segments.
    - **Guidelines:**
      - Use similar joins as in Task 64, but consider additional demographic fields or finer segmentation.

91. **Reassess Product Category Performance Analysis**
    - **Task:** Write a query to revisit the performance of product categories, including additional performance metrics if needed.
    - **Explanation:** This analysis confirms or refines previous insights on category performance.
    - **Guidelines:**
      - Use aggregate functions on sales and profit data by category.
      - Compare with previous results to identify trends.

92. **Evaluate the Effects of Sales Discounting Again**
    - **Task:** Develop an alternate query to assess the impact of discounts on sales revenue and profitability.
    - **Explanation:** Re-examining discount effects might reveal different insights when segmented by product or time period.
    - **Guidelines:**
      - Use a similar approach as in Task 66 with potential segmentation.

93. **Reperform Customer RFM Analysis for a Refined Segmentation**
    - **Task:** Write another version of the RFM analysis query to segment customers, possibly using different thresholds.
    - **Explanation:** A refined segmentation can help better target specific customer groups.
    - **Guidelines:**
      - Reuse the logic from Tasks 39 and 67 with adjustments to grouping criteria.

94. **Conduct Another Round of Sales Return Analysis**
    - **Task:** Create a query that further examines sales returns, focusing on different time frames or product groups.
    - **Explanation:** This can help identify if return rates vary by season or product type.
    - **Guidelines:**
      - Use additional grouping or filtering beyond Task 68 to drill down into the data.

95. **Revisit the Comparison Between Customer Acquisition Cost and Lifetime Value**
    - **Task:** Write a further refined query to compare acquisition costs against lifetime value for deeper insights.
    - **Explanation:** Iterating on this analysis can help validate previous findings or highlight new trends.
    - **Guidelines:**
      - Use additional segmentation or more detailed cost data if available.

96. **Conduct Another Price Optimization Analysis**
    - **Task:** Develop an alternate query for evaluating optimal pricing strategies, considering new variables if possible.
    - **Explanation:** This may involve incorporating external market factors to refine your pricing model.
    - **Guidelines:**
      - Extend the approach from Task 78 with additional variables or time segments.

97. **Perform a Detailed Conversion Funnel Analysis Again**
    - **Task:** Write another query to dissect the conversion funnel with more granularity.
    - **Explanation:** A detailed breakdown can pinpoint the precise stages where conversion rates drop.
    - **Guidelines:**
      - Use detailed logs and multiple aggregation layers to analyze each funnel stage.

98. **Reevaluate Repeat Purchase Probability**
    - **Task:** Develop an alternate query to assess the probability of repeat purchases, refining the model from earlier.
    - **Explanation:** Additional segmentation may reveal nuances in customer loyalty.
    - **Guidelines:**
      - Build on Task 80’s methodology, adding segmentation by customer type or region.

99. **Assess How Product Features Impact Sales Again**
    - **Task:** Write a query to further analyze the correlation between various product features and their sales performance.
    - **Explanation:** This deeper analysis might uncover subtle influences that inform product development.
    - **Guidelines:**
      - Revisit the approach from Task 81 with additional product attributes.

100. **Identify Cross-Sell Opportunities Once More**
    - **Task:** Create an alternative query to identify additional cross-sell opportunities by exploring different product combinations.
    - **Explanation:** A different approach might uncover new pairing opportunities that were not visible before.
    - **Guidelines:**
      - Use variations in your grouping and correlation analysis based on Task 82’s strategy.

---

Each of these tasks provides a clear objective and detailed guidelines to help you craft your SQL queries effectively. As you work through these tasks, consider the schema relationships in AdventureWorks (e.g., primary keys, foreign keys, and table relationships) and adjust your JOINs, aggregation functions, and filtering conditions accordingly. Happy querying!





-- Gemini

Absolutely! Let's break down each of these questions into more clearly defined tasks and provide a better, deeper explanation with guidance on how to approach writing the queries.

**General Guidelines:**

* **Identify the Tables:** Determine which tables in the AdventureWorks database contain the necessary data.
* **Specify Columns:** List the specific columns needed for the query.
* **Define Relationships:** Understand how tables are related (primary keys, foreign keys) and plan your JOIN operations.
* **Apply Filters:** Use `WHERE` clauses to filter data based on specific criteria.
* **Aggregate Data:** Use aggregate functions (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`) to summarize data.
* **Order Results:** Use `ORDER BY` to sort the results.
* **Limit Results:** Use `TOP` (SQL Server) or `LIMIT` (MySQL, PostgreSQL) to restrict the number of rows returned.
* **Use CTEs (Common Table Expressions):** For complex queries involving multiple steps or recursive operations, CTEs can improve readability and maintainability.
* **Consider Performance:** When dealing with large datasets, think about indexes, query optimization, and efficient data retrieval.

**Detailed Breakdown of Questions:**

1.  **Retrieve the top 10 employees with the highest salaries.**
    * **Task:** Identify the 10 employees with the highest `Rate` from the `HumanResources.EmployeePayHistory` table.
    * **Explanation:** This helps to understand the highest earners within the company.
    * **Guidance:**
        * Select employee ID and rate.
        * Order the results by rate in descending order.
        * Limit the results to the top 10 rows.

2.  **Find the total number of orders placed in each year.**
    * **Task:** Calculate the total number of orders from the `Sales.SalesOrderHeader` table, grouped by the year of the `OrderDate`.
    * **Explanation:** This provides an overview of annual order volume, revealing trends and fluctuations.
    * **Guidance:**
        * Extract the year from the `OrderDate`.
        * Count the number of orders, grouped by the extracted year.

3.  **Retrieve the customers who have placed more than 5 orders.**
    * **Task:** Identify customers from the `Sales.SalesOrderHeader` table who have more than 5 order records.
    * **Explanation:** This helps to identify loyal customers who place many orders.
    * **Guidance:**
        * Group orders by customer ID.
        * Count the number of orders for each customer.
        * Filter the results to include only customers with a count greater than 5.

4.  **Find the most popular product (with the highest sales quantity).**
    * **Task:** Determine the product from the `Sales.SalesOrderDetail` table with the highest total `OrderQty`.
    * **Explanation:** This identifies the top-selling product.
    * **Guidance:**
        * Join `Sales.SalesOrderDetail` with the product table.
        * Sum the `OrderQty` for each product.
        * Order the results by the summed quantity in descending order.
        * Retrieve the top product.

5.  **Retrieve the total revenue generated per product category.**
    * **Task:** Calculate the total revenue from the `Sales.SalesOrderDetail` table, grouped by product category (using joins with product and product category tables).
    * **Explanation:** This reveals which product categories are most profitable.
    * **Guidance:**
        * Join `Sales.SalesOrderDetail`, `Production.Product`, and `Production.ProductCategory`.
        * Calculate revenue (quantity * unit price).
        * Sum revenue, grouped by category name.

6.  **Retrieve the customers who have never placed an order.**
    * **Task:** Identify customers from the `Sales.Customer` table who do not have corresponding records in the `Sales.SalesOrderHeader` table.
    * **Explanation:** This helps to identify potential customers who have not yet made a purchase.
    * **Guidance:**
        * Use a `LEFT JOIN` or `NOT EXISTS` subquery to find customers without matching orders.

7.  **Calculate the average order total per customer.**
    * **Task:** Calculate the average `TotalDue` from the `Sales.SalesOrderHeader` table, grouped by customer ID.
    * **Explanation:** This shows the average spending per customer.
    * **Guidance:**
        * Group orders by customer ID.
        * Calculate the average `TotalDue`.

8.  **Find employees who have been with the company for more than 10 years.**
    * **Task:** Identify employees from the `HumanResources.Employee` table whose time between `HireDate` and the current date is more than 10 years.
    * **Explanation:** This identifies long term employees.
    * **Guidance:**
        * Calculate the difference between the hire date and the current date in years.
        * Filter the result for any employee that the difference is greater than 10.

9.  **List all employees along with their manager’s name.**
    * **Task:** Retrieve employee names and their manager names from the `HumanResources.Employee` table using a self-join.
    * **Explanation:** This provides a hierarchical view of the organization.
    * **Guidance:**
        * Use a self-join on the `HumanResources.Employee` table, using the `ManagerID` column.

10. **Find the average sales per month over the last 5 years.**
    * **Task:** Calculate the average `TotalDue` from the `Sales.SalesOrderHeader` table, grouped by year and month, for the last 5 years.
    * **Explanation:** This shows monthly sales trends.
    * **Guidance:**
        * Filter the sales order header table for the last 5 years.
        * Extract the year and the month from the order date.
        * Group the data by year and month.
        * calculate the average total due.

11. **Retrieve column details for a specific table.**
    * **Task:** Retrieve metadata about the columns of a specified table (e.g., `Sales.Customer`).
    * **Explanation:** This helps to understand the structure of the database.
    * **Guidance:**
        * Use system tables or information schema views to retrieve column names, data types, and other details.

12. **Identify products that have never been sold.**
    * **Task:** Find products from the `Production.Product` table that do not have corresponding records in the `Sales.SalesOrderDetail` table.
    * **Explanation:** Identifing products that have not sold helps with inventory management.
    * **Guidance:**
        * Use a left join or a not exists subquery.

13. **Create a recursive Common Table Expression (CTE) for employee hierarchy.**
    * **Task:** Construct a CTE that recursively traverses the employee hierarchy in the `HumanResources.Employee` table.
    * **Explanation:** This helps to visualise the employee organizational structure.
    * **Guidance:**
        * Use a recursive CTE.
        * The anchor member should select the top level managers.
        * The recursive member should join the cte back to the employee table.

14. **Retrieve the top 5 customers by total number of orders.**
    * **Task:** Identify the 5 customers with the highest number of orders from the `Sales.SalesOrderHeader` table.
    * **Explanation:** This identifies the customers that order the most.
    * **Guidance:**
        * Group by customer ID.
        * Count the number of orders.
        * Order by count descending.
        * limit the results to the top 5.

15. **Retrieve products that have been ordered more than 100 times.**
    * **Task:** From the `Sales.SalesOrderDetail` table, identify products with a total order count greater than 100.
    * **Explanation:** This identifies popular high volume products.
    * **Guidance:**
        * Group by product ID.
        * Count the product ID.
        * Filter for counts greater than 100.

16. **Find products that are in the same category as 'Mountain Bikes'.**
    * **Task:** Identify products from the `Production.Product` table that belong to the same category as 'Mountain Bikes'.
    * **Explanation:** This helps with cross selling strategies.
    * **Guidance:**
        * Join the product table, the product subcategory, and the product category tables.
        * Filter the product category by the name 'Mountain Bikes'.
        * Select all products that are in the same category id.

17. **Retrieve all orders along with customer information using different join types.**
    * **Task:** Use `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and `FULL OUTER JOIN` to retrieve orders and customer information from the `Sales.SalesOrderHeader` and `Sales.Customer` tables.
    * **Explanation:** This shows the effects of the different join types.
    * **Guidance:**
        * Use each join type.

18. **Find vendors who supply the most number of products.**
    * **Task:** Identify vendors from the `Purchasing.Vendor` table who supply the highest number of products.
    * **Explanation:** This identifies key suppliers.
    * **Guidance:**
        * Join the vendor table, and the product vendor table.
        * Group by Vendor ID.
        * Count the product ID.
        * Order by the count descending.

19. **Find products that have been purchased by the most customers.**
    * **Task:** Identify products from the `Sales.SalesOrderDetail` table that have been purchased by the largest number of unique customers.
    * **Explanation:** This identifies products with the broadest appeal.
    * **Guidance:**
        * Join the sales order detail table, and the sales order header table.
        * Group by product ID.
        * Count the distinct customer Id's.
        * Order by the count descending.

20. **Self-join to find employees who have the same job title.**
    * **Task:** Use a self-join on the `HumanResources.Employee` table to find employees with the same `JobTitle`.
    * **Explanation:** This helps to analyze employee job roles.
    * **Guidance:**
        * Self join the employee table on the JobTitle.

21. **Calculate running total of sales by month.**
    * **Task:** Calculate the cumulative sum of sales (from `Sales.SalesOrderDetail`) for each month.
    * **Explanation:** This shows the progression of sales over time.
    * **Guidance:**
        * Use a window function to calculate the running total.

22. **Rank products by sales quantity within each category.**
    * **Task:** Rank products within their respective categories based on `OrderQty` from the `Sales.SalesOrderDetail` table.
    * **Explanation:** This identifies the top selling products within each subcategory.
    * **Guidance:**
        * Use the RANK or DENSE_RANK window function.
        * Partition by the product subcategory.
        * Order by the sum of order quantity descending.

23. **Calculate the percentage of total sales each product contributes.**
    * **Task:** Calculate the percentage of total sales that each product contributes, using `Sales.SalesOrderDetail`.
    * **Explanation:** This shows the relative importance of each product.
    * **Guidance:**
        * Use window functions to calculate the total sales.
        * Calculate the percentage of each products sales.

24. **Find the difference in sales between consecutive months.**
    * **Task:** Calculate the difference in sales between consecutive months using `Sales.SalesOrderDetail`.
    * **Explanation:** This helps to identify monthly sales trends.
    * **Guidance:**
        * Use the LAG window function.

25. **Calculate the moving average of sales over a 3-month period.**
    * **Task:** Calculate the moving average of sales (from `Sales.SalesOrderDetail`) over a 3-month window.
    * **Explanation:** This smoothes out short term fluctuations.
    * **Guidance:**
        * Use the AVG window function with a range or rows frame clause.

26. **Use CTE to find customers who have purchased products from all categories.**
    * **Task:** Use a CTE to identify customers who have made purchases in every product category.
    * **Explanation:** This identifies diverse purchasing customers.
    * **Guidance:**
        * Use a cte to get all distinct product categories.
        * Use a second cte to get distinct customer ID's and product category Id's.
        * Using a group by and having clause, find the customers that have the same count of product category id's as the first CTE.

27. **Identify potential cross-selling opportunities using subqueries.**
    * **Task:** Use subqueries to identify products that are frequently purchased together.
    * **Explanation:** This helps to increase sales.
    * **Guidance:**
        * Use subqueries to find products that are purchased within the same order.

28. **Use CTE for hierarchical query of product categories and subcategories.**
    * **Task:** Use a CTE to create a hierarchical view of product categories and subcategories from the `Production.ProductCategory` and `Production.ProductSubcategory` tables.
    * **Explanation:** This shows product catalog structure.
    * **Guidance:**
        * use a recursive CTE.

29. **Find products that have had price changes using CTE.**
    * **Task:** Use a CTE to identify products from the `Production.ProductCostHistory` table that have had price changes.
    * **Explanation:** This helps with pricing strategy analysis.
    * **Guidance:**
        * Use a CTE and the LAG window function.

30. **Find the top 3 products in each subcategory by sales amount.**
    * **Task:** Identify the top 3 products in each subcategory based on sales amount (from `Sales.SalesOrderDetail`).
    * **Explanation:** This identifies top performing items.
    * **Guidance:**
        * Use the RANK or DENSE_RANK window function.
        * Partition by product subcategory.
        * Order by sales amount descending.
        * Filter the rank to less than or equal to 3.

31. **Analyze sales by day of week.**
    * **Task:** Analyze sales data from `Sales.SalesOrderHeader` by day of the week.
    * **Explanation:** This shows weekly sales patterns.
    * **Guidance:**
        * Use the Datepart function to get the day of the week.
        * Group by the day of the week.

32. **Find seasonality in sales (by quarter and month).**
    * **Task:** Analyze sales data from `Sales.SalesOrderHeader` by quarter and month.
    * **Explanation:** This shows seasonal trends.
    * **Guidance:**
        * Use the Datepart function to get the quarter and month.
        * Group by the quarter and month.

33. **Calculate the number of days between order date and ship date.**
    * **Task:** Calculate the number of days between `OrderDate` and `ShipDate` from the `Sales.SalesOrderHeader` table.
    * **Explanation:** This helps with order fulfillment analysis.
    * **Guidance:**
        * Use the DATEDIFF function.

34. **Identify orders that were shipped late (after the promised due date).**
    * **Task:** Identify orders from `Sales.SalesOrderHeader` where `ShipDate` is after `DueDate`.
    * **Explanation:** This helps to identify order fulfillment issues.
    * **Guidance:**
        * Filter the sales order header table where the ship date is greater than the due date.

35. **Analyze sales trends by year and quarter with growth rate.**
    * **Task:** Analyze sales trends from `Sales.SalesOrderHeader` by year and quarter, calculating the growth rate.
    * **Explanation:** This shows long term sales trends.
    * **Guidance:**
        * use the LAG window function to get the previous quarter sales.
        * calculate the growth rate.

36. **Analyze the sales performance of products by territory.**
    * **Task:** Analyze sales performance of products from `Sales.SalesOrderDetail` and related tables by territory.
    * **Explanation:** This shows regional sales patterns.
    * **Guidance:**
        * Join the required tables.
        * Group by the territory ID.

37. **Find customer lifetime value (CLV).**
    * **Task:** Calculate the customer lifetime value (CLV).
    * **Explanation:** This helps to identify profitable customers.
    * **Guidance:**
        * CLV calculation can be complex, and require multiple steps.
        * Calculate the total amount spent by each customer, the amount of orders, and the amount of time they have been a customer.
        * Use those values to calculate the CLV.

38. **Calculate product profit margins.**
    * **Task:** Calculate profit margins for products using `Production.Product` and related tables.
    * **Explanation:** This shows product profitability.
    * **Guidance:**
        * Join the product table, and the sales order detail table.
        * Calculate the profit margin.

39. **Segment customers based on recency, frequency, and monetary value (RFM analysis).**
    * **Task:** Perform RFM analysis on customers using `Sales.SalesOrderHeader`.
    * **Explanation:** This helps to identify customer segments.
    * **Guidance:**
        * Calculate the recency, frequency, and monetary values.
        * Segment the customers based on those values.

40. **Analyze sales trends by demographic factors.**
    * **Task:** Analyze sales trends by demographic factors (if available) from related tables.
    * **Explanation:** This shows customer segment purchasing behavior.
    * **Guidance:**
        * Join the required tables.
        * Group by the demographic factors.

41. **Find the most expensive queries using execution statistics.**
    * **Task:** Use system views to identify the most resource intensive queries.
    * **Explanation:** This helps to optimize database performance.
    * **Guidance:**
        * Use system views such as sys.dm_exec_query_stats.

42. **Analyze index usage statistics.**
    * **Task:** Use system views to analyze index usage.
    * **Explanation:** This helps to optimize index performance.
    * **Guidance:**
        * Use system views such as sys.dm_db_index_usage_stats.

43. **Identify tables without indexes.**
    * **Task:** Identify tables that do not have indexes.
    * **Explanation:** This helps to identify potential performance issues.
    * **Guidance:**
        * Use system views to identify tables without indexes.

44. **Find unused indexes.**
    * **Task:** Identify unused indexes.
    * **Explanation:** This helps to optimize index performance.
    * **Guidance:**
        * Use system views to identify unused indexes.

45. **Create indexed view for frequently accessed data.**
    * **Task:** Create an indexed view for frequently accessed data.
    * **Explanation:** This helps to improve query performance.
    * **Guidance:**
        * Create a view.
        * Create a clustered index on the view.

46. **Create a stored procedure to get customer orders.**
    * **Task:** Create a stored procedure to retrieve customer orders.
    * **Explanation:** This provides a reusable way to access order data.
    * **Guidance:**
        * Create a stored procedure that accepts a customer ID as a parameter.
        * Select the orders for that customer.

47. **Create a function to calculate total inventory value.**
    * **Task:** Create a function to calculate the total inventory value.
    * **Explanation:** This helps with inventory management.
    * **Guidance:**
        * Create a scalar or table valued function.
        * Join the product inventory table, and product table.
        * Calculate the total value.

48. **Create a stored procedure for product reordering analysis.**
    * **Task:** Create a stored procedure to analyze product reordering needs.
    * **Explanation:** This helps with inventory management.
    * **Guidance:**
        * Create a stored procedure that analyzes the product inventory table.
        * Return products that are below a reorder point.

49. **Create a function for calculating employee tenure.**
    * **Task:** Create a function to calculate employee tenure.
    * **Explanation:** This helps with employee management.
    * **Guidance:**
        * Create a scalar function that accepts an employee ID as a parameter.
        * Calculate the difference between the hire date, and the current date.

50. **Create a stored procedure for sales forecasting.**
    * **Task:** Create a stored procedure to forecast sales.
    * **Explanation:** This helps with sales planning.
    * **Guidance:**
        * Sales forecasting is complex, and can require many steps.
        * Use past sales data to forecast future sales.

51. **Check for duplicate customer records.**
    * **Task:** Identify duplicate customer records in the `Sales.Customer` table.
    * **Explanation:** This helps maintain data quality.
    * **Guidance:**
        * Use a CTE and the ROW_NUMBER function.
        * Partition by the columns that should be unique.
        * Filter the CTE where the row number is greater than 1.

52. **Validate product data integrity (continued).**
    * **Task:** Validate product data integrity in the `Production.Product` table.
    * **Explanation:** This helps maintain data quality.
    * **Guidance:**
        * Check for null values, invalid values, and inconsistent data.

53. **Identify orders with inconsistent shipping information.**
    * **Task:** Identify orders with inconsistent shipping information in `Sales.SalesOrderHeader`.
    * **Explanation:** This helps with order fulfillment.
    * **Guidance:**
        * Check for null values, invalid values, and inconsistent values.

54. **Check for missing email addresses for customers.**
    * **Task:** Identify customers with missing email addresses in `Sales.Customer`.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Filter the customer table where the email address is null.

55. **Identify products with inconsistent pricing history.**
    * **Task:** Identify products with inconsistent pricing history in `Production.ProductCostHistory`.
    * **Explanation:** This helps with pricing strategy analysis.
    * **Guidance:**
        * Use the LAG window function to check for price changes.

56. **Customer segmentation by purchase behavior.**
    * **Task:** Segment customers based on their purchase behavior.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Use the sales order header and sales order detail tables.
        * Group by customer ID.
        * Segment the customers based on their purchase behavior.

57. **Product affinity analysis.**
    * **Task:** Analyze product affinity.
    * **Explanation:** This helps with cross selling.
    * **Guidance:**
        * Use the sales order detail table.
        * Find products that are purchased together.

58. **Customer lifetime value (CLV) calculation.**
    * **Task:** Calculate customer lifetime value.
    * **Explanation:** This helps to identify profitable customers.
    * **Guidance:**
        * CLV calculation can be complex, and require multiple steps.
        * Calculate the total amount spent by each customer, the amount of orders, and the amount of time they have been a customer.
        * Use those values to calculate the CLV.

59. **Product performance analysis with seasonality.**
    * **Task:** Analyze product performance with seasonality.
    * **Explanation:** This helps with sales planning.
    * **Guidance:**
        * Use the sales order detail table.
        * Group by product ID, and month.
        * Analyze the sales trends.

60. **Territory-based sales trend analysis.**
    * **Task:** Analyze sales trends by territory.
    * **Explanation:** This helps with regional sales planning.
    * **Guidance:**
        * Join the required tables.
        * Group by territory ID.

61. **Customer acquisition and retention analysis.**
    * **Task:** Analyze customer acquisition and retention.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Use the sales order header table.
        * Calculate the number of new customers, and the number of returning customers.

62. **Sales performance by employee with targets.**
    * **Task:** Analyze sales performance by employee with targets.
    * **Explanation:** This helps with employee performance analysis.
    * **Guidance:**
        * Join the required tables.
        * Compare the employee sales to their targets.

63. **Inventory turnover analysis.**
    * **Task:** Analyze inventory turnover.
    * **Explanation:** This helps with inventory management.
    * **Guidance:**
        * Calculate the inventory turnover rate.

64. **Customer demographic analysis.**
    * **Task:** Analyze customer demographics.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Join the required tables.
        * Group by the demographic factors.

65. **Product category performance analysis.**
    * **Task:** Analyze product category performance.
    * **Explanation:** This helps with product planning.
    * **Guidance:**
        * Join the required tables.
        * Group by product category.

66. **Sales discounting effect analysis.**
    * **Task:** Analyze the effect of sales discounting.
    * **Explanation:** This helps with pricing strategy.
    * **Guidance:**
        * Compare the sales of discounted products, to the sales of non discounted products.

67. **Customer RFM (Recency, Frequency, Monetary) analysis.**
    * **Task:** Perform RFM analysis.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Calculate the recency, frequency, and monetary values.
        * Segment the customers based on those values.

68. **Sales return analysis.**
    * **Task:** Analyze sales returns.
    * **Explanation:** This helps with customer satisfaction analysis.
    * **Guidance:**
        * Use the sales return header table.
        * Calculate the return rate.

69. **Customer acquisition cost and lifetime value comparison.**
    * **Task:** Compare customer acquisition cost and lifetime value.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Calculate the customer acquisition cost.
        * Calculate the customer lifetime value.
        * Compare the two values.

70. **Price elasticity analysis.**
    * **Task:** Analyze price elasticity.
    * **Explanation:** This helps with pricing strategy.
    * **Guidance:**
        * Analyze the change in sales, due to a change in price.

71. **Employee performance reporting and benchmarking.**
    * **Task:** Analyze employee performance.
    * **Explanation:** This helps with employee management.
    * **Guidance:**
        * Join the required tables.
        * Calculate employee performance metrics.
        * Benchmark the employees.

72. **Forecasting sales using seasonal trends (continued).**
    * **Task:** Forecast sales using seasonal trends.
    * **Explanation:** This helps with sales planning.
    * **Guidance:**
        * Use past sales data to forecast future sales.

73. **Customer segmentation by purchase behavior.**
    * **Task:** Segment customers by purchase behavior.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Use the sales order header and sales order detail tables.
        * Group by customer ID.
        * Segment the customers based on their purchase behavior.

74. **Product bundle analysis.**
    * **Task:** Analyze product bundles.
    * **Explanation:** This helps with cross selling.
    * **Guidance:**
        * Use the sales order detail table.
        * Find products that are purchased together.

75. **Sales channel effectiveness analysis.**
    * **Task:** Analyze sales channel effectiveness.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Join the required tables.
        * Compare the sales of different sales channels.

76. **Customer acquisition cost and lifetime value comparison.**
    * **Task:** Compare customer acquisition cost and lifetime value.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Calculate the customer acquisition cost.
        * Calculate the customer lifetime value.
        * Compare the two values.

77. **Customer purchase path analysis.**
    * **Task:** Analyze customer purchase paths.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Use the sales order header and sales order detail tables.
        * Analyze the sequence of products that customers purchase.

78. **Price optimization analysis.**
    * **Task:** Analyze price optimization.
    * **Explanation:** This helps with pricing strategy.
    * **Guidance:**
        * Analyze the change in sales, due to a change in price.

79. **Conversion funnel analysis.**
    * **Task:** Analyze the conversion funnel.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Analyze the steps that customers take before making a purchase.

80. **Repeat purchase probability analysis.**
    * **Task:** Analyze repeat purchase probability.
    * **Explanation:** This helps with customer retention.
    * **Guidance:**
        * Calculate the probability that a customer will make a repeat purchase.

81. **Product feature impact analysis.**
    * **Task:** Analyze product feature impact.
    * **Explanation:** This helps with product design.
    * **Guidance:**
        * Analyze the impact of product features on sales.

82. **Cross-sell opportunity identification.**
    * **Task:** Identify cross-sell opportunities.
    * **Explanation:** This helps with sales.
    * **Guidance:**
        * Use the sales order detail table.
        * Find products that are purchased together.

83. **Customer churn risk detection (continued).**
    * **Task:** Detect customer churn risk.
    * **Explanation:** This helps with customer retention.
    * **Guidance:**
        * Analyze customer behavior to identify customers at risk of churn.

84. **Product affinity analysis.**
    * **Task:** Analyze product affinity.
    * **Explanation:** This helps with cross selling.
    * **Guidance:**
        * Use the sales order detail table.
        * Find products that are purchased together.

85. **Seasonal product trend analysis.**
    * **Task:** Analyze seasonal product trends.
    * **Explanation:** This helps with sales planning.
    * **Guidance:**
        * Use the sales order detail table.
        * Analyze the sales trends for each product, by month.

86. **Dynamic pricing model.**
    * **Task:** Create a dynamic pricing model.
    * **Explanation:** This helps with pricing strategy.
    * **Guidance:**
        * Create a model that adjusts prices based on demand.

87. **Customer lifetime value prediction.**
    * **Task:** Predict customer lifetime value.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Use past customer data to predict future customer lifetime value.

88. **Marketing attribution model.**
    * **Task:** Analyze marketing attribution.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Analyze the effectiveness of marketing campaigns.

89. **Inventory optimization model.**
    * **Task:** Analyze inventory optimization.
    * **Explanation:** This helps with inventory management.
    * **Guidance:**
        * Create a model that optimizes inventory levels.

90. **Customer demographic analysis.**
    * **Task:** Analyze customer demographics.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Join the required tables.
        * Group by the demographic factors.

91. **Product category performance analysis.**
    * **Task:** Analyze product category performance.
    * **Explanation:** This helps with product planning.
    * **Guidance:**
        * Join the required tables.
        * Group by product category.

92. **Sales discounting effect analysis.**
    * **Task:** Analyze the effect of sales discounting.
    * **Explanation:** This helps with pricing strategy.
    * **Guidance:**
        * Compare the sales of discounted products, to the sales of non discounted products.

93. **Customer RFM (Recency, Frequency, Monetary) analysis.**
    * **Task:** Perform RFM analysis.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Calculate the recency, frequency, and monetary values.
        * Segment the customers based on those values.

94. **Sales return analysis.**
    * **Task:** Analyze sales returns.
    * **Explanation:** This helps with customer satisfaction analysis.
    * **Guidance:**
        * Use the sales return header table.
        * Calculate the return rate.

95. **Customer acquisition cost and lifetime value comparison.**
    * **Task:** Compare customer acquisition cost and lifetime value.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Calculate the customer acquisition cost.
        * Calculate the customer lifetime value.
        * Compare the two values.

96. **Price optimization analysis.**
    * **Task:** Analyze price optimization.
    * **Explanation:** This helps with pricing strategy.
    * **Guidance:**
        * Analyze the change in sales, due to a change in price.

97. **Conversion funnel analysis.**
    * **Task:** Analyze the conversion funnel.
    * **Explanation:** This helps with marketing.
    * **Guidance:**
        * Analyze the steps that customers take before making a purchase.

98. **Repeat purchase probability analysis.**
    * **Task:** Analyze repeat purchase probability.
    * **Explanation:** This helps with customer retention.
    * **Guidance:**
        * Calculate the


*/