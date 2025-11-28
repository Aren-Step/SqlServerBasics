USE [Example-Database]

CREATE TABLE [payment] (
    [id] INT NOT NULL IDENTITY(1,1),
    [person] INT NOT NULL,
    [money] DECIMAL(10, 5) NOT NULL,
    CONSTRAINT [PK_payment] PRIMARY KEY ([id])

)

CREATE TABLE [Employee] (
    [id] INT NOT NULL IDENTITY (1, 1),
    [passport] CHAR(9) NOT NULL,
    [name] VARCHAR(50) NOT NULL,
    CONSTRAINT [PK_Employee] PRIMARY KEY ([id])
)
GO

ALTER TABLE [employee]
    ADD CONSTRAINT [UQ_employee_passport] UNIQUE ([passport]);

ALTER TABLE [payment]
    ADD CONSTRAINT [FK_payment_employee] FOREIGN KEY ([person]) REFERENCES [Employee] ([id]);