USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[CreditLimitOfDealer]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreditLimitOfDealer] 
    @SalesOrganisation NVARCHAR(5),
    @Dist_Channel NVARCHAR(10) NULL,
    @Division NVARCHAR(10) NULL,
    @CustomerCode NVARCHAR(50) NULL,
    @CreditControlArea NVARCHAR(10) NULL,
    @CreditLimit DECIMAL(18,2) NULL,
    @CreditLimitValidityDate DATE NULL,
    @TotalReceivables DECIMAL(18,2) NULL,
    @CreditExposure DECIMAL(18,2) NULL,
    @AvailableCreditLimit DECIMAL(18,2) NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        IF EXISTS (
            SELECT 1 
            FROM TB_CreditLimitOfDealer
            WHERE 
                SalesOrganisation = @SalesOrganisation
                AND CreditControlArea = @CreditControlArea 
                AND CustomerCode = @CustomerCode
        )
        BEGIN
            -- Update TB_CreditLimitOfDealer
            UPDATE TB_CreditLimitOfDealer
            SET 
                Dist_Channel = @Dist_Channel,
                Division = @Division,
                CreditLimit = @CreditLimit,
                CreditLimitValidityDate = @CreditLimitValidityDate,
                TotalReceivables = @TotalReceivables,
                CreditExposure = @CreditExposure,
                AvailableCreditLimit = @AvailableCreditLimit
            WHERE 
                SalesOrganisation = @SalesOrganisation
                AND CreditControlArea = @CreditControlArea 
                AND CustomerCode = @CustomerCode;
        END
        ELSE
        BEGIN
            -- Insert into TB_CreditLimitOfDealer
            INSERT INTO TB_CreditLimitOfDealer (
                SalesOrganisation,
                Dist_Channel,
                Division,
                CustomerCode,
                CreditControlArea,
                CreditLimit,
                CreditLimitValidityDate,
                TotalReceivables,
                CreditExposure,
                AvailableCreditLimit
            )
            VALUES (
                @SalesOrganisation,
                @Dist_Channel,
                @Division,
                @CustomerCode,
                @CreditControlArea,
                @CreditLimit,
                @CreditLimitValidityDate,
                @TotalReceivables,
                @CreditExposure,
                @AvailableCreditLimit
            );
        END;

        -- 🟢 **Sync Data to TB_CustomerTransaction**
        IF NOT EXISTS (
            SELECT 1 FROM TB_CustomerTransaction WHERE CustomerCode = @CustomerCode
        )
        BEGIN
            INSERT INTO TB_CustomerTransaction (
                CustomerCode,
                AvailableBalance,
                DepositedBalance,
                TotalAvailableBalance,
                TransactionType,
                LastUpdated
            )
            VALUES (
                @CustomerCode,
                @AvailableCreditLimit,  -- Initial Available Balance from SAP
                0,                      -- No deposit yet
                @AvailableCreditLimit,  -- Total balance = Available Balance + Deposited Balance
                'Fetch',
                GETDATE()
            );
        END
        ELSE
        BEGIN
            -- Update Available Balance in TB_CustomerTransaction
            UPDATE TB_CustomerTransaction
            SET AvailableBalance = @AvailableCreditLimit,
                TotalAvailableBalance = @AvailableCreditLimit + DepositedBalance,
                LastUpdated = GETDATE()
            WHERE CustomerCode = @CustomerCode;
        END;

        COMMIT TRANSACTION;
        RETURN 1; -- Success
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RETURN 0; -- Failure
    END CATCH
END;
GO
