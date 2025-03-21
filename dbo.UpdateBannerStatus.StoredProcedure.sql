USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[UpdateBannerStatus]    Script Date: 3/20/2025 10:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateBannerStatus]
	@CompanyCode BIGINT,
    @BannerId INT,
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT OFF;  -- Enable row count return
    
    UPDATE TB_BannerImages
    SET IsActive = @IsActive,
        UpdatedOn = GETDATE()
    WHERE BannerId = @BannerId AND CompanyCode = @CompanyCode;
    
    RETURN @@ROWCOUNT;  -- Returns the number of rows affected
END
GO
