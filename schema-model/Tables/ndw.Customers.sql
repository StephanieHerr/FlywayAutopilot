CREATE TABLE [ndw].[Customers]
(
[CustomerID] [int] NOT NULL IDENTITY(1, 1),
[FirstName] [nvarchar] (100) NOT NULL,
[LastName] [nvarchar] (100) NOT NULL,
[Email] [nvarchar] (255) NOT NULL,
[Phone] [nvarchar] (20) NULL,
[CreatedAt] [datetime2] NOT NULL CONSTRAINT [DF_Customers_CreatedAt] DEFAULT (sysutcdatetime()),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_Customers_IsActive] DEFAULT ((1))
)
GO
ALTER TABLE [ndw].[Customers] ADD CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID])
GO
ALTER TABLE [ndw].[Customers] ADD CONSTRAINT [UQ_Customers_Email] UNIQUE NONCLUSTERED ([Email])
GO
CREATE NONCLUSTERED INDEX [IX_Customers_LastName] ON [ndw].[Customers] ([LastName])
GO
