USE [mazuagricusmssql01-db-db]
GO
/****** Object:  StoredProcedure [dbo].[GetTMStock]    Script Date: 3/20/2025 5:15:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetTMStock]
	@TM NVARCHAR(50),
	@CompanyCode BIGINT, -- Mandatory parameter
    @Variety NVARCHAR(50) = NULL,
    @Generation NVARCHAR(10) = NULL,
    @Grade NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Temporary table to store parsed material details
    CREATE TABLE #TempStockDetails (
        SrNo INT IDENTITY(1,1),
        Variety NVARCHAR(50),
        Product NVARCHAR(100),
        Generation NVARCHAR(10),
        Grade NVARCHAR(10),
        Quantity DECIMAL(18, 2)
    );

    -- Fetch stock details for the given TM and CompanyCode
    INSERT INTO #TempStockDetails (Variety, Product, Generation, Grade, Quantity)
    SELECT 
        -- Extract Variety (Second word)
        (SELECT value FROM (
            SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
            FROM STRING_SPLIT(Material_Description, ' ')
        ) AS Parts WHERE pos = 2) AS Variety,

        -- Extract Product (First 3 words)
        (SELECT STRING_AGG(value, ' ') FROM (
            SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
            FROM STRING_SPLIT(Material_Description, ' ')
        ) AS Parts WHERE pos <= 3) AS Product,

        -- Extract Generation (Third word after "POTATO")
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

        -- Extract Grade (Last word)
        (CASE 
            WHEN Material_Description LIKE '%GRADE%' THEN 
                (SELECT TOP 1 value FROM (
                    SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
                    FROM STRING_SPLIT(Material_Description, ' ')
                ) AS Parts ORDER BY pos DESC)
            WHEN Material_Description LIKE 'POTATO JYOTI%' THEN 'M12'
            WHEN Material_Description LIKE 'POTATO TIGER%' THEN 'M0'
            ELSE NULL
        END) AS Grade,

        Unrestricted_Kgs AS Quantity
    FROM TB_StockDetails SD
    INNER JOIN TB_CustomerMaster CM ON SD.Plant = CM.Plant
    WHERE 
        CM.TM = @TM
        AND CM.CompanyCode = @CompanyCode
        AND (@Variety IS NULL OR 
            (SELECT value FROM (
                SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
                FROM STRING_SPLIT(Material_Description, ' ')
            ) AS Parts WHERE pos = 2) = @Variety)

        AND (@Generation IS NULL OR 
            (CASE 
                WHEN Material_Description LIKE '%GRADE%' THEN 
                    (SELECT value FROM (
                        SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
                        FROM STRING_SPLIT(Material_Description, ' ')
                    ) AS Parts WHERE pos = 4)
                WHEN Material_Description LIKE 'POTATO JYOTI%' THEN 'G4'
                WHEN Material_Description LIKE 'POTATO TIGER%' THEN 'G3'
                ELSE NULL
            END) = @Generation)

        AND (@Grade IS NULL OR 
            (CASE 
                WHEN Material_Description LIKE '%GRADE%' THEN 
                    (SELECT TOP 1 value FROM (
                        SELECT value, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS pos
                        FROM STRING_SPLIT(Material_Description, ' ')
                    ) AS Parts ORDER BY pos DESC)
                WHEN Material_Description LIKE 'POTATO JYOTI%' THEN 'M12'
                WHEN Material_Description LIKE 'POTATO TIGER%' THEN 'M0'
                ELSE NULL
            END) = @Grade);

    -- Return final result
    SELECT * FROM #TempStockDetails;
    
    -- Cleanup
    DROP TABLE #TempStockDetails;
END;
GO
