USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[GetBannerById]    Script Date: 3/17/2025 9:58:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetBannerById]

  @BannerId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        BannerId,
        Title,
        ImageURL,
        CreatedOn,
        IsActive,
        UpdatedOn,
        CompanyCode
    FROM TB_BannerImages
    WHERE BannerId = @BannerId;
END;
GO
