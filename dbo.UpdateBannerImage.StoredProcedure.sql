USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[UpdateBannerImage]    Script Date: 3/17/2025 9:58:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateBannerImage]
	@BannerId INT,
    @Title NVARCHAR(255),
    @ImageURL NVARCHAR(MAX),
    @UpdatedOn DATETIME,
    @IsActive BIT,
    @CompanyCode BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE TB_BannerImages
    SET Title = @Title,
        ImageURL = @ImageURL,
        UpdatedOn = @UpdatedOn,
        IsActive = @IsActive,
        CompanyCode = @CompanyCode
    WHERE BannerId = @BannerId;
END
GO
