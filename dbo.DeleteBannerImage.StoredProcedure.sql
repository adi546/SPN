USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[DeleteBannerImage]    Script Date: 3/18/2025 6:25:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DeleteBannerImage]
	@BannerId INT
AS
BEGIN

	

     DELETE FROM TB_BannerImages
     WHERE BannerId = @BannerId;
END

GO
