SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomer
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetCustomer N'EN', 1, N'EDL-C2017060011';
--exec GetCustomer N'TH', 1, N'EDL-C2017060011';
--exec GetCustomer NULL, 1, N'EDL-C2017060011';
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomer] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
, @customerId nvarchar(30) = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , CustomerName
		 , TaxCode
		 , Address1
		 , Address2
		 , City
		 , Province
		 , PostalCode
		 , Phone
		 , Mobile
		 , Fax
		 , Email
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM CustomerMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	 ORDER BY SortOrder, CustomerId
END

GO
