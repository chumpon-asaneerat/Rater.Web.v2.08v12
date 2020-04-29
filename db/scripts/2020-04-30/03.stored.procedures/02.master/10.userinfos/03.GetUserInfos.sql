SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetUserInfos
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column UserId to userId
-- <2019-08-19> :
--	- Remove column PrefixNative.
--	- Remove column FirstNameNative.
--	- Remove column LastNameNative.
--	- Remove column FullNameNative.
--	- Rename column PrefixEN to FullName.
--	- Rename column FirstNameEN to FullName.
--	- Rename column LastNameEN to FullName.
--	- Rename column FullNameEN to FullName.
-- <2020-04-30> :
--	- reorder parameter @enabled.
--
-- [== Example ==]
--
--exec GetUserInfos NULL, 1, NULL;     -- for only enabled languages.
--exec GetUserInfos;                   -- for get all.
--exec GetUserInfos N'EN', 1;          -- for get UserInfo for EN language all member type.
--exec GetUserInfos N'TH', 1;          -- for get UserInfo for TH language all member type.
--exec GetUserInfos N'EN', 1, 100;     -- for get UserInfo for EN language member type = 100.
--exec GetUserInfos N'TH', 1, 180;     -- for get UserInfo for TH language member type = 180.
-- =============================================
CREATE PROCEDURE [dbo].[GetUserInfos] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
, @memberType int = NULL
)
AS
BEGIN
	SELECT langId
		 , userId
		 , MemberType
		 , Prefix
		 , FirstName
		 , LastName
		 , FullName
		 , UserName
		 , Password
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM UserInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND [MemberType] = COALESCE(@memberType, [MemberType])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, UserId
END

GO
