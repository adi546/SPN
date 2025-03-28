USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[InsertBannerImage]    Script Date: 3/17/2025 9:58:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertBannerImage]
	@Title NVARCHAR(255),
	@ImageUrl NVARCHAR(MAX),
	@IsActive BIT = 1,
	@CompanyCode BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO TB_BannerImages 
	(
	 Title,
	 ImageURL,
	 IsActive,
	 CreatedOn,
	 CompanyCode
	 
	)
	VALUES
	(
	 @Title,
	 @ImageURL,
	 @IsActive,
	 GetDate(),
	 @CompanyCode
	);

	SELECT SCOPE_IDENTITY() AS BannerId;  -- Return the generated BannerId
  
   
END
GO
