USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[InsertProductImage]    Script Date: 3/21/2025 1:59:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertProductImage]
	  @ProductName NVARCHAR(255),
      @ImageUrl NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO TB_ProductImages (ProductName, ImageUrl)
    VALUES (@ProductName, @ImageUrl);

    -- Return the newly inserted ProductId
    SELECT SCOPE_IDENTITY();
END
GO
