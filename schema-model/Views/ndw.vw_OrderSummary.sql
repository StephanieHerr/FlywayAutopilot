SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- ============================================================
-- VIEW: vw_OrderSummary
-- One row per order with customer name and calculated total.
-- ============================================================

CREATE VIEW [ndw].[vw_OrderSummary]
AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.Status,
    c.CustomerID,
    c.FirstName + ' ' + c.LastName  AS CustomerName,
    c.Email                          AS CustomerEmail,
    COUNT(oi.OrderItemID)            AS LineItemCount,
    SUM(oi.Quantity * oi.UnitPrice)  AS OrderTotal
FROM      ndw.Orders      o
JOIN      ndw.Customers   c  ON c.CustomerID = o.CustomerID
LEFT JOIN ndw.OrderItems  oi ON oi.OrderID   = o.OrderID
GROUP BY
    o.OrderID,
    o.OrderDate,
    o.Status,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email;
GO
