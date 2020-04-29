SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetOrg
-- Description:	Get Organization.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--/* With Specificed CustomerId, BranchId, OrgId */
--exec GetOrg N'EN', 1, N'EDL-C2020030001', N'B0001', N'O0003'
--exec GetOrg N'TH', 1, N'EDL-C2020030001', N'B0001', N'O0003'
-- =============================================
CREATE PROCEDURE [dbo].[GetOrg] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
, @orgId nvarchar(30) = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , orgId
		 , parentId
		 , branchId
		 , OrgName
		 , BranchName
		 , OrgStatus
		 , BranchStatus
		 , SortOrder
		 , Enabled 
	  FROM OrgMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(COALESCE(@branchId, BranchId))))
	   AND UPPER(LTRIM(RTRIM(OrgId))) = UPPER(LTRIM(RTRIM(@orgId)))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId, OrgId
END

GO
