USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[UpdateDepositStatus]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateDepositStatus] 
    @Id INT,
    @Status NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @RowsAffected INT = 0;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @CustomerCode NVARCHAR(50);
        DECLARE @DepositedAmount DECIMAL(18,2);
        DECLARE @CurrentBalance DECIMAL(18,2);

        -- Get the CustomerCode and DepositedAmount from TB_DepositBalance
        SELECT @CustomerCode = CustomerCode, 
               @DepositedAmount = AmountPaid
        FROM TB_DepositBalance 
        WHERE Id = @Id AND Status = 'Pending';

        -- If no matching record is found, rollback and return
        IF @CustomerCode IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Update status in TB_DepositBalance
        UPDATE TB_DepositBalance
        SET Status = @Status,
            ApprovedAt = CASE WHEN @Status = 'Approved' THEN GETDATE() ELSE ApprovedAt END
        WHERE Id = @Id;

        -- If the deposit is approved, update customer balance
        IF @Status = 'Approved'
        BEGIN
            -- Fetch latest TotalAvailableBalance
            SET @CurrentBalance = ISNULL(
                (SELECT TOP 1 TotalAvailableBalance 
                 FROM TB_CustomerTransaction 
                 WHERE CustomerCode = @CustomerCode 
                 ORDER BY LastUpdated DESC), 0);

            -- Insert new transaction record
            INSERT INTO TB_CustomerTransaction (CustomerCode, AvailableBalance, DepositedBalance, TotalAvailableBalance, TransactionType, LastUpdated)
            VALUES (@CustomerCode, @CurrentBalance, @DepositedAmount, @CurrentBalance + @DepositedAmount, 'Deposit', GETDATE());
        END;

        COMMIT TRANSACTION;
		RETURN @RowsAffected;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;

GO
