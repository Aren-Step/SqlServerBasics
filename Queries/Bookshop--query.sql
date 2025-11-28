USE [Bookshop]

CREATE TABLE Authors(
    AuthorId INT IDENTITY(1,1),
    Name VARCHAR(255),
    CONSTRAINT PK_Authors PRIMARY KEY(AuthorId) -- One to many
)

CREATE TABLE Books(
    BookId INT IDENTITY(1,1),
    Title VARCHAR(255) NOT NULL,
    Author INT,
    Year INT,
    CONSTRAINT PK_Books PRIMARY KEY(BookId), -- Many to Many with Customers
    CONSTRAINT FK_Books_Authors FOREIGN KEY(Author) REFERENCES Authors(AuthorId) -- Many to One
)

CREATE TABLE BestSellers(
    id INT IDENTITY (1,1),
    BookId INT UNIQUE,
    AuthorId INT UNIQUE,
    CONSTRAINT PK_BestSellers PRIMARY KEY(id),
    CONSTRAINT FK_BestSellers_Books FOREIGN KEY(BookId) REFERENCES Books(BookId),           -- One to One
    CONSTRAINT FK_BestSellers_Authors FOREIGN KEY(AuthorId) REFERENCES Authors(AuthorId)    -- One to One
)
GO

CREATE TABLE Customers(
    id INT IDENTITY(1,1),
    Name VARCHAR(255),
    CONSTRAINT PK_Customers PRIMARY KEY(id) -- Many to Many with Books
)

CREATE TABLE Orders(
    id INT IDENTITY(1,1),
    BookId INT,
    CustomerId INT,
    Quantity INT,
    CONSTRAINT PK_Orders PRIMARY KEY(id),
    CONSTRAINT FK_Orders_Books FOREIGN KEY(BookId) REFERENCES Books(BookId),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY(CustomerId) REFERENCES Customers(id)
)
GO

-- DROP TABLE IF EXISTS BestSellers
-- DROP TABLE IF EXISTS Books
-- DROP TABLE IF EXISTS Authors
-- GO