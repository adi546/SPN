USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[AddCart]    Script Date: 3/1/2025 6:46:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddCart]
	@CustomerCode NVARCHAR(50),
    @CartId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if the cart already exists
    SELECT @CartId = Id FROM TB_CartMHZPC WHERE CustomerCode = @CustomerCode;

    -- If no cart exists, create a new one
    IF @CartId IS NULL
    BEGIN
        INSERT INTO TB_CartMHZPC (CustomerCode, CreatedDate)
        VALUES (@CustomerCode, GETDATE());

        SET @CartId = SCOPE_IDENTITY();
    END
END;
GO
