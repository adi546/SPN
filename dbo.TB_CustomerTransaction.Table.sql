USE [mazuagricusmssql01-db-db]
GO
/****** Object:  Table [dbo].[TB_CustomerTransaction]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_CustomerTransaction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerCode] [nvarchar](50) NOT NULL,
	[AvailableBalance] [decimal](18, 2) NOT NULL,
	[DepositedBalance] [decimal](18, 2) NULL,
	[TotalAvailableBalance] [decimal](18, 2) NOT NULL,
	[TransactionType] [nvarchar](30) NOT NULL,
	[LastUpdated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TB_CustomerTransaction] ADD  DEFAULT ((0)) FOR [AvailableBalance]
GO
ALTER TABLE [dbo].[TB_CustomerTransaction] ADD  DEFAULT ((0)) FOR [DepositedBalance]
GO
ALTER TABLE [dbo].[TB_CustomerTransaction] ADD  DEFAULT (getdate()) FOR [LastUpdated]
GO
