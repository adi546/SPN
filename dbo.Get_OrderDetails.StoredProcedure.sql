USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[Get_OrderDetails]    Script Date: 3/1/2025 6:46:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Get_OrderDetails]
    @UserCode NVARCHAR(50),
    @PriceCardType NVARCHAR(10),  -- 'Single' or 'Combo'
    @Condition_Amount DECIMAL(18,2),
    @BookingPrice DECIMAL(18,2),
    @SecondaryCondition_Amount DECIMAL(18,2) = NULL,
    @SecondaryBookingPrice DECIMAL(18,2) = NULL,
    @PrimaryRatio BIGINT = NULL,
    @SecondaryRatio BIGINT = NULL,
    @OrderQuantity INT = 0  -- OrderQuantity in Metric Tons (MT)
	
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AvailableCreditLimit DECIMAL(18,2);
    DECLARE @OrderAmount DECIMAL(18,2) = 0;
    DECLARE @BookingAmount DECIMAL(18,2) = 0;
    DECLARE @SecondaryOrderQuantity INT = 0;
    DECLARE @SecondaryOrderAmount DECIMAL(18,2) = 0;
    DECLARE @SecondaryBookingAmount DECIMAL(18,2) = 0;
	DECLARE @BalanceAmountToPay DECIMAL(18,2) = 0;
	DECLARE @SecondaryBalanceAmountToPay DECIMAL(18,2) = 0;

    -- Fetch Available Credit Limit
    SELECT @AvailableCreditLimit = AvailableCreditLimit 
    FROM TB_CreditLimitOfDealer 
    WHERE CustomerCode = @UserCode;

    -- Convert OrderQuantity from MT to KG
    DECLARE @OrderQuantityKG INT = @OrderQuantity * 1000;

    IF @OrderQuantity > 0
    BEGIN
        -- Calculate for Single Price Card Type
        IF @PriceCardType = 'Single'
        BEGIN
            SET @OrderAmount = @Condition_Amount * @OrderQuantityKG;
            SET @BookingAmount = @BookingPrice * @OrderQuantityKG;
			SET @BalanceAmountToPay = @OrderAmount - @BookingAmount;
        END
        ELSE IF @PriceCardType = 'Combo'
        BEGIN
            -- Calculate Secondary Order Quantity in KG
            IF @SecondaryRatio IS NOT NULL AND @PrimaryRatio IS NOT NULL AND @PrimaryRatio > 0
            BEGIN
                SET @SecondaryOrderQuantity = (@OrderQuantityKG * @SecondaryRatio) / @PrimaryRatio;
            END

            -- Calculate Primary and Secondary Order Amounts in KG
            SET @OrderAmount = @Condition_Amount * @OrderQuantityKG;
            SET @BookingAmount = @BookingPrice * @OrderQuantityKG;
            SET @BalanceAmountToPay = @OrderAmount - @BookingAmount;
            SET @SecondaryOrderAmount = @SecondaryCondition_Amount * @SecondaryOrderQuantity;
            SET @SecondaryBookingAmount = @SecondaryBookingPrice * @SecondaryOrderQuantity;
			SET @SecondaryBalanceAmountToPay = @SecondaryOrderAmount - @SecondaryBookingAmount;
        END
    END

    -- Return calculated values
    SELECT 
        @AvailableCreditLimit AS AvailableCreditLimit,
        @OrderQuantity AS OrderQuantity,  -- Order Quantity in Metric Tons
        @OrderAmount AS OrderAmount,
        @BookingAmount AS BookingAmount,
        @SecondaryOrderQuantity / 1000 AS SecondaryOrderQuantity,  -- Convert back to MT
        @SecondaryOrderAmount AS SecondaryOrderAmount,
        @SecondaryBookingAmount AS SecondaryBookingAmount,
		@BalanceAmountToPay AS BalanceAmountToPay,
		@SecondaryBalanceAmountToPay AS SecondaryBalanceAmountToPay
END;
GO
