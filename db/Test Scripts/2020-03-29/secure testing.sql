SELECT * FROM LogInView WHERE LangId = N'EN'

EXEC GetAccessUser N'EN', NULL, 'edl'

EXEC CheckAccess N'id', N'edl'

SELECT * FROM EDLAccess
SELECT * FROM CustomerAccess
SELECT * FROM DeviceAccess
