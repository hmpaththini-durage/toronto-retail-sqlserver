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

CREATE TABLE Stores (
	StoreID INT IDENTITY PRIMARY KEY,
	StoreName NVARCHAR(100) NOT NULL,
	City NVARCHAR(50) NOT NULL,
	Neighborhood NVARCHAR(100) NOT NULL,
    OpenDate DATE NOT NULL
);

CREATE TABLE Campaigns (
    CampaignID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Channel NVARCHAR(20) CHECK (Channel IN ('Email','Social','Search','Influencer','Display')),
    CONSTRAINT CK_CampaignDates CHECK (StartDate <= EndDate)
);

ALTER TABLE Orders
ADD PaymentMethod NVARCHAR(50),
    OrderStatus NVARCHAR(20) CHECK (OrderStatus IN ('Completed','Cancelled','Refunded')),
    Subtotal DECIMAL(12,2) CHECK (Subtotal >= 0),
    DiscountAmount DECIMAL(12,2) DEFAULT 0 CHECK (DiscountAmount >= 0),
    Tax DECIMAL(12,2) CHECK (Tax >= 0),
    Total DECIMAL(12,2) CHECK (Total >= 0),
    CampaignID INT FOREIGN KEY REFERENCES Campaigns(CampaignID);

CREATE TABLE Returns (
    ReturnID INT IDENTITY PRIMARY KEY,
    OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    ReturnDate DATE NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    Reason NVARCHAR(200) NOT NULL
);

CREATE INDEX idx_order_date ON Orders(OrderDate);
CREATE INDEX idx_order_customer ON Orders(CustomerID);
CREATE INDEX idx_item_product ON OrderItems(ProductID);
CREATE INDEX idx_product_category ON Products(Category);
CREATE INDEX idx_customer_city ON Customers(City);

CREATE VIEW v_DailySales AS
SELECT 
    CAST(OrderDate AS DATE) AS SalesDate,
    Channel,
    SUM(Total) AS TotalRevenue,
    SUM(Total - Tax + DiscountAmount) AS GrossSales,
    COUNT(*) AS Orders
FROM Orders
WHERE OrderStatus = 'Completed'
GROUP BY CAST(OrderDate AS DATE), Channel;