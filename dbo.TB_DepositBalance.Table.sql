USE [mazuagricusmssql01-db-db]
GO
/****** Object:  Table [dbo].[TB_DepositBalance]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TB_DepositBalance](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerCode] [nvarchar](50) NOT NULL,
	[PaymentDate] [datetime] NOT NULL,
	[AmountPaid] [decimal](18, 2) NOT NULL,
	[TransactionReferenceNo] [nvarchar](100) NULL,
	[ReceiptPath] [nvarchar](255) NULL,
	[Status] [nvarchar](20) NULL,
	[ApprovedAt] [datetime] NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TB_DepositBalance] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[TB_DepositBalance] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
