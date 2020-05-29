-- For this problem, we’d like to see the total number of products in each category. Sort the results by the
-- total number of products, in descending order.
SELECT b.categoryname, COUNT(a.productID) from products a
JOIN categories b ON b.categoryID = a.categoryID
GROUP BY b.categoryname
ORDER BY COUNT(a.productID) DESC;

-- In the Customers table, show the total number of customers per Country and City.
SELECT country, city, COUNT(customerID) FROM customers
GROUP BY country, city
ORDER BY COUNT(customerID) DESC;

-- What products do we have in our inventory that should be reordered? For now, just use the fields
-- UnitsInStock and ReorderLevel, where UnitsInStock is less than the ReorderLevel, ignoring the fields
-- UnitsOnOrder and Discontinued. Order the results by ProductID.
SELECT productid, productname, unitsinstock, reorderlevel FROM products
WHERE unitsinstock < reorderlevel
ORDER BY productid;

-- Now we need to incorporate these fields—UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued—
-- into our calculation. We’ll define “products that need reordering” with the following:
-- 		UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel
-- 		The Discontinued flag is false (0)
SELECT productname products_needing_reordering, UnitsInStock, UnitsOnOrder, ReorderLevel FROM products
WHERE discontinued = 0 AND UnitsInStock+UnitsOnOrder <= ReorderLevel;

-- A salesperson for Northwind is going on a business trip to visit customers, and would like to see a list of
-- all customers, sorted by region, alphabetically. However, he wants the customers with no region (null in the Region -- field) to be at the end, instead of at the top, where you’d normally find the null values. Within the same region, 
-- companies should be sorted by CustomerID.
SELECT Region, CompanyName FROM customers
ORDER BY
	CASE
		WHEN Region= '' THEN 1
		ELSE 0
	END,
Region, CustomerID;

-- Some of the countries we ship to have very high freight charges. We'd like to investigate some more
-- shipping options for our customers, to be able to offer them lower freight charges. Return the three ship
-- countries with the highest average freight overall, in descending order by average freight.
SELECT ShipCountry, AVG(Freight) FROM Orders
GROUP BY ShipCountry
ORDER BY AVG(Freight) DESC
LIMIT 3;

-- We're continuing on the question above on high freight charges. Now, instead of using all the orders we
-- have, we only want to see orders from the year 2015. 
SELECT ShipCountry, AVG(Freight) FROM Orders
WHERE OrderDate >= '2015-01-01' AND OrderDate < '2016-01-01'
GROUP BY ShipCountry
ORDER BY AVG(Freight) DESC
LIMIT 3;

-- We're continuing to work on high freight charges. We now want to get the three ship countries with the
-- highest average freight charges. But instead of filtering for a particular year, we want to use the last 12
-- months of order data, using as the end date the last OrderDate in Orders. 
SELECT ShipCountry, AVG(Freight) FROM Orders
WHERE OrderDate >= ADDDATE((SELECT OrderDate FROM Orders ORDER BY OrderDate DESC LIMIT 1), INTERVAL -1 YEAR)
GROUP BY ShipCountry
ORDER BY AVG(Freight) DESC
LIMIT 3;

-- We're doing inventory, and need to show information like the below - employeeID, lastname, orderid, productname, 
-- quantity, for all orders. Sort by OrderID and Product ID.
SELECT a.employeeid, a.lastname, b.orderid, d.productname, c.quantity FROM employees a
JOIN orders b ON b.employeeid = a.employeeid
JOIN orderdetails c ON c.orderid = b.orderid
JOIN products d ON d.productid = c.productid
ORDER BY c.orderid, c.productid;
 
 -- There are some customers who have never actually placed an order. Show these customers.
SELECT a.CompanyName FROM customers a
LEFT JOIN orders b ON b.CustomerID = a.CustomerID
WHERE b.CustomerID IS NULL;

-- One employee (Margaret Peacock, EmployeeID 4) has placed the most orders. However, there are some
-- customers who've never placed an order with her. Show only those customers who have never placed an
-- order with her. 
SELECT DISTINCT c.CustomerID, c.companyname, b.employeeid FROM customers c
LEFT JOIN (SELECT customerid, employeeid FROM orders WHERE employeeid = 4) b ON c.CustomerID = b.customerid
WHERE b.employeeid IS NULL;






