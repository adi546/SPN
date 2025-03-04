USE [mazuagricusmssql01-db-db]
GO
/****** Object:  Table [dbo].[OrdersMHZPC]    Script Date: 3/4/2025 1:59:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdersMHZPC](
	[OrderNumber] [int] IDENTITY(1,1) NOT NULL,
	[CustomerCode] [nvarchar](50) NOT NULL,
	[BillingAddress] [nvarchar](255) NOT NULL,
	[ShippingAddress] [nvarchar](255) NOT NULL,
	[ContactPersonName] [nvarchar](100) NOT NULL,
	[ContactPersonNumber] [nvarchar](20) NOT NULL,
	[OrderDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdersMHZPC] ADD  DEFAULT (getdate()) FOR [OrderDate]
GO
