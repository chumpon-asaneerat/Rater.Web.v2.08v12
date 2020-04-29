SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberInfo
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetMemberInfo N'TH', NULL, N'EDL-C2017060011', N'M00001'; -- for get MemberInfo by CustomerID and MemberId.
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberInfo] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
, @customerId nvarchar(30) = NULL
, @memberId nvarchar(30) = NULL
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
	   AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(@memberId)))
	 ORDER BY SortOrder, LangId, CustomerId, MemberId;
END

GO
