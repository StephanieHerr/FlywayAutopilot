CREATE TABLE [ndw].[Orders]
(
[OrderID] [int] NOT NULL IDENTITY(1, 1),
[CustomerID] [int] NOT NULL,
[OrderDate] [datetime2] NOT NULL CONSTRAINT [DF_Orders_OrderDate] DEFAULT (sysutcdatetime()),
[Status] [nvarchar] (20) NOT NULL CONSTRAINT [DF_Orders_Status] DEFAULT ('Pending'),
[Notes] [nvarchar] (max) NULL
)
GO
ALTER TABLE [ndw].[Orders] ADD CONSTRAINT [CK_Orders_Status] CHECK (([Status]='Cancelled' OR [Status]='Delivered' OR [Status]='Shipped' OR [Status]='Processing' OR [Status]='Pending'))
GO
ALTER TABLE [ndw].[Orders] ADD CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED ([OrderID])
GO
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerID] ON [ndw].[Orders] ([CustomerID])
GO
CREATE NONCLUSTERED INDEX [IX_Orders_Status] ON [ndw].[Orders] ([Status])
GO
ALTER TABLE [ndw].[Orders] ADD CONSTRAINT [FK_Orders_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [ndw].[Customers] ([CustomerID])
GO
