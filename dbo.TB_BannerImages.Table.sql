USE [mazuagricusmssql01-db-db]
GO
/****** Object:  Table [dbo].[TB_BannerImages]    Script Date: 3/17/2025 9:58:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_BannerImages](
	[BannerId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[ImageUrl] [nvarchar](max) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[IsActive] [bit] NULL,
	[UpdatedOn] [datetime] NULL,
	[CompanyCode] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BannerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TB_BannerImages] ADD  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[TB_BannerImages] ADD  DEFAULT ((1)) FOR [IsActive]
GO
