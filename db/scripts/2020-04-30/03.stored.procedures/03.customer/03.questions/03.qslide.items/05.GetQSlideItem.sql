SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlideItems.
-- Description:	Get Question Slide Items.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- /* Gets item for QSet:'QS00001', Slide: 1, Item: 1 */
--EXEC GetQSlideItems NULL, N'EDL-C2018050001', N'QS00001', 1, 1, 1; -- enable languages
--EXEC GetQSlideItems N'JA', N'EDL-C2018050001', N'QS00001', 1, 1;   -- JA language
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlideItems]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @qSeq int = NULL
, @qSSeq int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , qSeq
		 , qSSeq
		 , QItemText
		 , IsRemark
         , Choice
		 , QItemStatus
		 , QItemOrder
		 , Enabled 
	  FROM QSlideItemMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
	   AND QSeq = @qSeq
	   AND QSSeq = @qSSeq
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO
