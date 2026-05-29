SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- ============================================================
-- STORED PROCEDURE: usp_PlaceOrder
-- Creates a new order and its line items in a transaction.
-- Decrements stock and returns the new OrderID.
--
-- Usage example:
--   DECLARE @NewOrderID INT;
--   EXEC ndw.usp_PlaceOrder
--       @CustomerID = 1,
--       @Items      = N'[{"ProductID":2,"Quantity":3},{"ProductID":5,"Quantity":1}]',
--       @Notes      = N'Please gift wrap',
--       @OrderID    = @NewOrderID OUTPUT;
-- ============================================================

CREATE PROCEDURE [ndw].[usp_PlaceOrder]
    @CustomerID INT,
    @Items      NVARCHAR(MAX),   -- JSON array: [{"ProductID":n,"Quantity":n}, ...]
    @Notes      NVARCHAR(MAX) = NULL,
    @OrderID    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate customer exists and is active
    IF NOT EXISTS (
        SELECT 1 FROM ndw.Customers
        WHERE  CustomerID = @CustomerID AND IsActive = 1
    )
    BEGIN
        RAISERROR('Customer not found or inactive.', 16, 1);
        RETURN;
    END;

    -- Parse and validate the items JSON
    IF ISJSON(@Items) = 0
    BEGIN
        RAISERROR('Items must be a valid JSON array.', 16, 1);
        RETURN;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Create the order header
        INSERT INTO ndw.Orders (CustomerID, Notes)
        VALUES (@CustomerID, @Notes);

        SET @OrderID = SCOPE_IDENTITY();

        -- Insert line items and decrement stock
        INSERT INTO ndw.OrderItems (OrderID, ProductID, Quantity, UnitPrice)
        SELECT
            @OrderID,
            p.ProductID,
            j.Quantity,
            p.UnitPrice
        FROM OPENJSON(@Items)
            WITH (
                ProductID INT  '$.ProductID',
                Quantity  INT  '$.Quantity'
            ) AS j
        JOIN ndw.Products p ON p.ProductID = j.ProductID AND p.IsActive = 1;

        -- Check we got at least one valid line item
        IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('No valid active products found in the items list.', 16, 1);
            RETURN;
        END;

        -- Decrement stock quantities
        UPDATE p
        SET    p.StockQty = p.StockQty - j.Quantity
        FROM   ndw.Products p
        JOIN   OPENJSON(@Items)
               WITH (ProductID INT '$.ProductID', Quantity INT '$.Quantity') AS j
               ON j.ProductID = p.ProductID;

        -- Guard against negative stock
        IF EXISTS (SELECT 1 FROM ndw.Products WHERE StockQty < 0)
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('Insufficient stock for one or more products.', 16, 1);
            RETURN;
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
