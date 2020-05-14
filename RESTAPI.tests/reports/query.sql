EXEC GetVoteSummaries 
	 NULL
   , N'EDL-C2020050001'
   , N'QS00001'
   , 1
   , N'2020-05-01'
   , N'2020-05-31'
   , N'O0001'
   , NULL --device id
   , NULL --user id

EXEC GetQSet N'EN', N'EDL-C2020050001', 'QS00001', 1
-- update script 2020-05-12
-- - supports NULL QSeq
EXEC GetQSlideItems NULL, N'EDL-C2020050001', N'QS00001', NULL, 1

SELECT * FROM UserInfo