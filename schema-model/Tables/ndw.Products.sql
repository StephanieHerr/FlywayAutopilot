CREATE TABLE [ndw].[Products]
(
[ProductID] [int] NOT NULL IDENTITY(1, 1),
[ProductName] [nvarchar] (200) NOT NULL,
[SKU] [nvarchar] (50) NOT NULL,
[UnitPrice] [decimal] (10, 2) NOT NULL,
[StockQty] [int] NOT NULL CONSTRAINT [DF_Products_StockQty] DEFAULT ((0)),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_Products_IsActive] DEFAULT ((1))
)
GO
ALTER TABLE [ndw].[Products] ADD CONSTRAINT [CK_Products_Price] CHECK (([UnitPrice]>=(0)))
GO
ALTER TABLE [ndw].[Products] ADD CONSTRAINT [CK_Products_Stock] CHECK (([StockQty]>=(0)))
GO
ALTER TABLE [ndw].[Products] ADD CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID])
GO
ALTER TABLE [ndw].[Products] ADD CONSTRAINT [UQ_Products_SKU] UNIQUE NONCLUSTERED ([SKU])
GO
