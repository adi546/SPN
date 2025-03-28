USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[GetStockDropdownValues]    Script Date: 3/20/2025 5:15:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetStockDropdownValues]
	 @TM NVARCHAR(50),
     @CompanyCode BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
        (SELECT value FROM (
            SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
            FROM STRING_SPLIT(Material_Description, ' ')
        ) AS Parts WHERE pos = 2) AS Variety,
        
        (CASE 
            WHEN Material_Description LIKE '%GRADE%' THEN 
                (SELECT value FROM (
                    SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
                    FROM STRING_SPLIT(Material_Description, ' ')
                ) AS Parts WHERE pos = 4)
            WHEN Material_Description LIKE 'POTATO JYOTI%' THEN 'G4'
            WHEN Material_Description LIKE 'POTATO TIGER%' THEN 'G3'
            ELSE NULL
        END) AS Generation,

        (CASE 
            WHEN Material_Description LIKE '%GRADE%' THEN 
                (SELECT TOP 1 value FROM (
                    SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
                    FROM STRING_SPLIT(Material_Description, ' ')
                ) AS Parts ORDER BY pos DESC)
            WHEN Material_Description LIKE 'POTATO JYOTI%' THEN 'M12'
            WHEN Material_Description LIKE 'POTATO TIGER%' THEN 'M0'
            ELSE NULL
        END) AS Grade
    FROM TB_StockDetails SD
    INNER JOIN TB_CustomerMaster CM ON SD.Plant = CM.Plant
    WHERE CM.TM = @TM AND CM.CompanyCode = @CompanyCode;
END;
GO
