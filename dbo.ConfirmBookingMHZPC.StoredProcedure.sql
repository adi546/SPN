USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[ConfirmBookingMHZPC]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ConfirmBookingMHZPC]
    @CustomerCode NVARCHAR(50),
    @BillingAddress NVARCHAR(255),
    @ShippingAddress NVARCHAR(255),
    @ContactPersonName NVARCHAR(100),
    @ContactPersonNumber NVARCHAR(20),
    @ReturnValue INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the customer has items in the cart
    IF NOT EXISTS (SELECT 1 FROM TB_CartMHZPC WHERE CustomerCode = @CustomerCode)
    BEGIN
        SET @ReturnValue = 0; -- No cart found
        RETURN;
    END

    DECLARE @OrderNumber INT;

    -- Insert into OrdersMHZPC to create a new order record
    INSERT INTO OrdersMHZPC (CustomerCode, BillingAddress, ShippingAddress, ContactPersonName, ContactPersonNumber, OrderDate)
    VALUES (@CustomerCode, @BillingAddress, @ShippingAddress, @ContactPersonName, @ContactPersonNumber, GETDATE());

    -- Retrieve the newly created OrderNumber
    SET @OrderNumber = SCOPE_IDENTITY();

    -- Insert all cart items into DealerOrderMHZPC and link them to the new OrderNumber
    INSERT INTO DealerOrderMHZPC (
        OrderNumber, CartId, PriceCardType, ProductName, Condition_Amount, BookingPrice, OrderQuantity,
        OrderAmount, BookingAmount, BalanceAmountToPay, SecondaryProductName, SecondaryCondition_Amount, 
        SecondaryBookingPrice, SecondaryOrderQuantity, SecondaryOrderAmount, SecondaryBookingAmount, 
        SecondaryBalanceAmountToPay, DispatchStatus, TMApproval, SoNumber, DateOfPurchase, TMApproval_Date, 
        HAApproval, HAApproval_Date
    )
    SELECT 
        @OrderNumber, CartId, PriceCardType, ProductName, Condition_Amount, BookingPrice, OrderQuantity,
        OrderAmount, BookingAmount, BalanceAmountToPay, SecondaryProductName, SecondaryCondition_Amount, 
        SecondaryBookingPrice, SecondaryOrderQuantity, SecondaryOrderAmount, SecondaryBookingAmount, 
        SecondaryBalanceAmountToPay, 'Pending', 'Pending', NULL, GETDATE(), NULL, 'Pending', NULL
    FROM TB_CartItemsMHZPC 
    WHERE CartId IN (SELECT Id FROM TB_CartMHZPC WHERE CustomerCode = @CustomerCode);

    -- Delete Cart Items after order confirmation
    DELETE FROM TB_CartItemsMHZPC WHERE CartId IN (SELECT Id FROM TB_CartMHZPC WHERE CustomerCode = @CustomerCode);

    -- Delete Cart Header
    DELETE FROM TB_CartMHZPC WHERE CustomerCode = @CustomerCode;

    -- Return success
    SET @ReturnValue = 1;
END;

GO
