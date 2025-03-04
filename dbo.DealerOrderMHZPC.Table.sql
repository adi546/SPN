USE [mazuagricusmssql01-db-db]
GO
/****** Object:  Table [dbo].[DealerOrderMHZPC]    Script Date: 3/4/2025 1:59:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DealerOrderMHZPC](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderNumber] [int] NULL,
	[CartId] [int] NULL,
	[PriceCardType] [nvarchar](50) NULL,
	[ProductName] [nvarchar](255) NULL,
	[Condition_Amount] [decimal](18, 2) NULL,
	[BookingPrice] [decimal](18, 2) NULL,
	[OrderQuantity] [int] NULL,
	[OrderAmount] [decimal](18, 2) NULL,
	[BookingAmount] [decimal](18, 2) NULL,
	[BalanceAmountToPay] [decimal](18, 2) NULL,
	[SecondaryProductName] [nvarchar](255) NULL,
	[SecondaryCondition_Amount] [decimal](18, 2) NULL,
	[SecondaryBookingPrice] [decimal](18, 2) NULL,
	[SecondaryOrderQuantity] [int] NULL,
	[SecondaryOrderAmount] [decimal](18, 2) NULL,
	[SecondaryBookingAmount] [decimal](18, 2) NULL,
	[SecondaryBalanceAmountToPay] [decimal](18, 2) NULL,
	[DispatchStatus] [nvarchar](50) NULL,
	[TMApproval] [nvarchar](50) NULL,
	[SoNumber] [nvarchar](50) NULL,
	[DateOfPurchase] [datetime] NULL,
	[TMApproval_Date] [datetime] NULL,
	[HAApproval] [nvarchar](50) NULL,
	[HAApproval_Date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DealerOrderMHZPC] ADD  DEFAULT ('Pending') FOR [DispatchStatus]
GO
ALTER TABLE [dbo].[DealerOrderMHZPC] ADD  DEFAULT ('Pending') FOR [TMApproval]
GO
ALTER TABLE [dbo].[DealerOrderMHZPC] ADD  DEFAULT (getdate()) FOR [DateOfPurchase]
GO
ALTER TABLE [dbo].[DealerOrderMHZPC] ADD  DEFAULT ('Pending') FOR [HAApproval]
GO
ALTER TABLE [dbo].[DealerOrderMHZPC]  WITH CHECK ADD FOREIGN KEY([OrderNumber])
REFERENCES [dbo].[OrdersMHZPC] ([OrderNumber])
GO
