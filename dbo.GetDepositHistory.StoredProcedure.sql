USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[GetDepositHistory]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetDepositHistory]
    @CustomerCode NVARCHAR(50),
    @FromDate DATE = NULL,
    @ToDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM TB_DepositBalance
    WHERE CustomerCode = @CustomerCode
          AND Status = 'Approved'
          AND (@FromDate IS NULL OR PaymentDate >= @FromDate)
          AND (@ToDate IS NULL OR PaymentDate <= @ToDate)
    ORDER BY CreatedAt DESC;
END
GO
