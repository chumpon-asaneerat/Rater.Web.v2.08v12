SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetUserInfo.
-- Description:	Get User Info.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetUserInfo NULL, 1, N'EDL-U20200402001'
-- =============================================
CREATE PROCEDURE [dbo].[GetUserInfo] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
, @userId nvarchar(30) = NULL
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
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
       AND UserId = @userId
	 ORDER BY SortOrder, UserId
END

GO
