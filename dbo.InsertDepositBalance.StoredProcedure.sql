USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[InsertDepositBalance]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertDepositBalance]
	@CustomerCode NVARCHAR(50),
    @PaymentDate DATETIME,
    @AmountPaid DECIMAL(18,2),
    @TransactionReferenceNo NVARCHAR(100),
    @ReceiptPath NVARCHAR(255)
AS
BEGIN
    INSERT INTO TB_DepositBalance (CustomerCode, PaymentDate, AmountPaid, TransactionReferenceNo, ReceiptPath, Status)
    VALUES (@CustomerCode, @PaymentDate, @AmountPaid, @TransactionReferenceNo, @ReceiptPath, 'Pending');

	SELECT SCOPE_IDENTITY(); 
END

GO
