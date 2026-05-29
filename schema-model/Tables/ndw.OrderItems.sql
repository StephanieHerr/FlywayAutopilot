CREATE TABLE [ndw].[OrderItems]
(
[OrderItemID] [int] NOT NULL IDENTITY(1, 1),
[OrderID] [int] NOT NULL,
[ProductID] [int] NOT NULL,
[Quantity] [int] NOT NULL,
[UnitPrice] [decimal] (10, 2) NOT NULL
)
GO
ALTER TABLE [ndw].[OrderItems] ADD CONSTRAINT [CK_OrderItems_Price] CHECK (([UnitPrice]>=(0)))
GO
ALTER TABLE [ndw].[OrderItems] ADD CONSTRAINT [CK_OrderItems_Qty] CHECK (([Quantity]>(0)))
GO
ALTER TABLE [ndw].[OrderItems] ADD CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED ([OrderItemID])
GO
CREATE NONCLUSTERED INDEX [IX_OrderItems_OrderID] ON [ndw].[OrderItems] ([OrderID])
GO
ALTER TABLE [ndw].[OrderItems] ADD CONSTRAINT [FK_OrderItems_Order] FOREIGN KEY ([OrderID]) REFERENCES [ndw].[Orders] ([OrderID])
GO
ALTER TABLE [ndw].[OrderItems] ADD CONSTRAINT [FK_OrderItems_Product] FOREIGN KEY ([ProductID]) REFERENCES [ndw].[Products] ([ProductID])
GO
