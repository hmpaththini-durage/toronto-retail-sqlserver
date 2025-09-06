CREATE DATABASE TorontoRetailDB;

USE TorontoRetailDB;

CREATE TABLE Customers (
	CustomerID INT IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50),
	Email NVARCHAR(100) UNIQUE,
	City NVARCHAR(50),
    CreatedDate DATE DEFAULT GETDATE()
);

CREATE TABLE Products  (
	ProductID INT IDENTITY PRIMARY KEY,
	ProductName NVARCHAR(100),
	Category NVARCHAR(50),
	Price DECIMAL(10,2),
    CreatedDate DATE DEFAULT GETDATE()
);

CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    StoreID INT,
    OrderDate DATE DEFAULT GETDATE(),
    Channel NVARCHAR(20) CHECK (Channel IN ('Online','In-Store'))
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal AS (Quantity * UnitPrice) PERSISTED
);

