SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberInfos
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column MemberId to memberId
-- <2020-04-30> :
--  - reorder @enabled parameter.
--  - remove @memberId parameter.
--
-- [== Example ==]
--
--exec GetMemberInfos NULL, 1, NULL, NULL;              -- for only enabled languages.
--exec GetMemberInfos;                                  -- for get all.
--exec GetMemberInfos N'EN';                            -- for get MemberInfos for EN language.
--exec GetMemberInfos N'TH';                            -- for get MemberInfos for TH language.
--exec GetMemberInfos N'TH', NULL, N'EDL-C2017060011';  -- for get MemberInfos by CustomerID.
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberInfos] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
, @customerId nvarchar(30) = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , memberId
		 , MemberType
		 , Prefix
		 , FirstName
		 , LastName
		 , FullName
		 , IDCard
		 , TagId
		 , EmployeeCode
		 , UserName
		 , Password
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM MemberInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	 ORDER BY SortOrder, LangId, CustomerId, MemberId;
END

GO
