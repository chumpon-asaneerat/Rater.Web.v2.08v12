SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetMemberType.
-- Description:	Get Member Type.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetMemberType NULL, 1, 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberType] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
, @memberTypeId int = NULL
)
AS
BEGIN
	SELECT langId
		 , memberTypeId
		 , MemberTypeDescription
		 , SortOrder
		 , Enabled 
	  FROM MemberTypeMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
       AND MemberTypeId =  @memberTypeId
	 ORDER BY SortOrder, MemberTypeId
END

GO
