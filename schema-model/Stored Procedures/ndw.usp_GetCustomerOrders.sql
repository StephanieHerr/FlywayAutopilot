SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- ============================================================
-- STORED PROCEDURE: usp_GetCustomerOrders
-- Returns all orders (with totals) for a given customer.
-- ============================================================

CREATE PROCEDURE [ndw].[usp_GetCustomerOrders]
    @CustomerID INT,
    @Status     NVARCHAR(20) = NULL   -- optional filter
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        OrderID,
        OrderDate,
        Status,
        LineItemCount,
        OrderTotal
    FROM  ndw.vw_OrderSummary
    WHERE CustomerID = @CustomerID
      AND (@Status IS NULL OR Status = @Status)
    ORDER BY OrderDate DESC;
END;
GO
