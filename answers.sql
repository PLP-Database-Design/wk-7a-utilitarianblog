-- Question 1: Transform ProductDetail table into 1NF
-- Assuming the initial data is present in a table called ProductDetail
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(Product) AS Product
FROM (
    SELECT OrderID, CustomerName, 
           SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1) AS Product
    FROM ProductDetail
    CROSS JOIN (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) n
    WHERE LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= n.n - 1
) AS exploded;

-- Question 2: Transform OrderDetails table into 2NF by removing partial dependencies
-- Create a new Orders table for order-specific data
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create a new OrderItems table for the product-specific data
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;
