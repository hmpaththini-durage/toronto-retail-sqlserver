INSERT INTO Customers (FirstName, LastName, Email, City)
VALUES 
('Alice', 'Johnson', 'alice.johnson@example.com', 'Toronto'),
('Mark', 'Lee', 'mark.lee@example.com', 'Scarborough'),
('Sophia', 'Brown', 'sophia.brown@example.com', 'North York'),
('James', 'Wilson', 'james.wilson@example.com', 'Mississauga');

INSERT INTO Products (ProductName, Category, Price)
VALUES
('iPhone 15', 'Electronics', 1200.00),
('Samsung TV 55"', 'Electronics', 800.00),
('Office Chair', 'Furniture', 150.00),
('Coffee Maker', 'Appliances', 90.00);

INSERT INTO Orders (CustomerID, StoreID, OrderDate, Channel)
VALUES
(1, 101, '2024-06-15', 'Online'),
(2, 102, '2024-06-20', 'In-Store'),
(3, 103, '2024-07-01', 'Online');

INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 2, 1200.00),   -- 2 iPhones
(1, 4, 1, 90.00),      -- 1 Coffee Maker
(2, 2, 1, 800.00),     -- 1 Samsung TV
(3, 3, 4, 150.00);

SELECT * FROM OrderItems;