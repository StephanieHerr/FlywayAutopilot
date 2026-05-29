SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- ============================================================
-- FUNCTION: fn_GetOrderTotal
-- Returns the total value of a given order.
-- ============================================================

CREATE FUNCTION [ndw].[fn_GetOrderTotal]
(
    @OrderID INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Total DECIMAL(10, 2);

    SELECT @Total = SUM(Quantity * UnitPrice)
    FROM   ndw.OrderItems
    WHERE  OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO
