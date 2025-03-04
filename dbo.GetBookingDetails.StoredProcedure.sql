USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[GetBookingDetails]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetBookingDetails]
    @UserCode NVARCHAR(50),
    @BookingStatus NVARCHAR(50),
    @CustomerCode NVARCHAR(50) = NULL  
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @RoleId INT;

    -- Get the RoleId of the logged-in user
    SELECT @RoleId = UM.RoleId
    FROM Users UM
    WHERE UM.UserCode = @UserCode;

    -- CTE to find all TMs under the given higher authority
    WITH UserHierarchy AS (
        SELECT UserCode FROM Users WHERE UserCode = @UserCode
        UNION ALL
        SELECT U.UserCode FROM Users U 
        INNER JOIN UserHierarchy UH ON U.RepManCode = UH.UserCode
    )

    -- Fetch booking details
    SELECT 
        O.[OrderNumber], 
        O.[CustomerCode], 
        O.[BillingAddress], 
        O.[ShippingAddress], 
        DO.[PriceCardType], 
        DO.[ProductName], 
        DO.[Condition_Amount], 
        DO.[BookingPrice], 
        DO.[OrderQuantity], 
        DO.[BookingAmount], 
        DO.[BalanceAmountToPay], 
        DO.[SecondaryProductName], 
        DO.[SecondaryCondition_Amount], 
        DO.[SecondaryBookingPrice], 
        DO.[SecondaryOrderQuantity], 
        DO.[SecondaryOrderAmount], 
        DO.[SecondaryBookingAmount], 
        DO.[SecondaryBalanceAmountToPay], 
        DO.[DispatchStatus], 
        DO.[TMApproval], 
		DO.[HAApproval],
        DO.[DateOfPurchase]
    FROM DealerOrderMHZPC DO
	INNER JOIN OrdersMHZPC O ON DO.OrderNumber = O.OrderNumber
    WHERE 
        (
            -- Case 1: Customers (RoleId = 1) can only see their own bookings
            (@RoleId = 1 AND O.CustomerCode = @UserCode)

            -- Case 2: Territory Manager (TM) (RoleId = 2)
            OR (@RoleId = 2 AND 
                (
                    (@CustomerCode IS NOT NULL AND O.CustomerCode = @CustomerCode)
                    OR (@CustomerCode IS NULL AND O.CustomerCode IN 
                        (SELECT CustomerCode FROM TB_CustomerMaster WHERE TM = @UserCode))
                )
            )

            -- Case 3: Higher Authorities (RoleId > 2)
            OR (@RoleId > 2 AND 
                (
                    -- Fetch specific customer if provided
                    (@CustomerCode IS NOT NULL AND O.CustomerCode = @CustomerCode)

                    -- Fetch all customers under this authority if no specific customer is provided
                    OR (@CustomerCode IS NULL AND O.CustomerCode IN 
                        (SELECT CustomerCode FROM TB_CustomerMaster 
                         WHERE TM IN (SELECT UserCode FROM UserHierarchy)
                        )
                    )
                )
            )
        )
       AND (
    -- Booking is Rejected if TMApproval is Rejected
    (@BookingStatus = 'Rejected' AND DO.TMApproval = 'Rejected')

    -- Booking is Rejected if TMApproval is Approved but HAApproval is Rejected
    OR (@BookingStatus = 'Rejected' AND DO.TMApproval = 'Approved' AND DO.HAApproval = 'Rejected')

    -- Booking is Pending when DispatchStatus is Pending and either TM or HA approval is still Pending
    OR (@BookingStatus = 'Pending' AND DO.DispatchStatus = 'Pending' 
        AND (DO.TMApproval = 'Pending' OR DO.HAApproval = 'Pending')
    )

    -- Booking is Approved when DispatchStatus is Pending, but both TM and HA approvals are Approved
    OR (@BookingStatus = 'Approved' AND DO.DispatchStatus = 'Pending' 
        AND DO.TMApproval = 'Approved' AND DO.HAApproval = 'Approved'
    )

    -- Booking is Completed when DispatchStatus is Dispatched and both TM and HA approvals are Approved
    OR (@BookingStatus = 'Completed' AND DO.DispatchStatus = 'Dispatched' 
        AND DO.TMApproval = 'Approved' AND DO.HAApproval = 'Approved'
    )
);


END;
GO
