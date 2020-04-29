SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetBranchs.
-- Description:	Get Branchs.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column BranchId to branchId
-- <2020-04-30> :
--	- remove parameter @branchId
--
-- [== Example ==]
--
--exec GetBranchs NULL, 1, NULL, NULL;                 -- for only enabled languages.
--exec GetBranchs;                                     -- for get all.
--exec GetBranchs N'EN', 1;                            -- for get Branchs for EN language.
--exec GetBranchs N'TH', 1;                            -- for get Branchs for TH language.
--exec GetBranchs N'TH', 1, N'EDL-C2017060011';        -- for get Branchs by CustomerID.
-- =============================================
ALTER PROCEDURE [dbo].[GetBranchs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , branchId
		 , BranchName
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM BranchMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId;
END

GO
