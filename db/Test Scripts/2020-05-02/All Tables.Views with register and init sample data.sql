/*
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = N'BASE TABLE';
SELECT name FROM sys.views;
*/
/*
-- TABLES
-- [=== Masters ===]
SELECT * FROM Language
SELECT * FROM ErrorMessage
SELECT * FROM ErrorMessageML
SELECT * FROM MemberType
SELECT * FROM MemberTypeML
SELECT * FROM DeviceType
SELECT * FROM DeviceTypeML
SELECT * FROM MasterPK
SELECT * FROM PeriodUnit
SELECT * FROM PeriodUnitML
SELECT * FROM LimitUnit
SELECT * FROM LimitUnitML
SELECT * FROM LicenseType
SELECT * FROM LicenseTypeML
SELECT * FROM LicenseFeature
-- [=== EDL ===]
SELECT * FROM UserInfo
SELECT * FROM UserInfoML
-- [=== Customer ===]
SELECT * FROM CustomerPK
SELECT * FROM Customer
SELECT * FROM CustomerML
SELECT * FROM LicenseHistory
SELECT * FROM MemberInfo
SELECT * FROM MemberInfoML
SELECT * FROM Device
SELECT * FROM DeviceML
SELECT * FROM Branch
SELECT * FROM BranchML
SELECT * FROM Org
SELECT * FROM OrgML
SELECT * FROM QSet
SELECT * FROM QSetML
SELECT * FROM QSlide
SELECT * FROM QSlideML
SELECT * FROM QSlideItem
SELECT * FROM QSlideItemML
SELECT * FROM Vote

SELECT * FROM CustomerAccess
SELECT * FROM DeviceAccess
SELECT * FROM EDLAccess

-- VIEWS
SELECT * FROM dboView
SELECT * FROM NewIDView
-- [=== Masters ===]
SELECT * FROM LanguageView
SELECT * FROM ErrorMessageView
SELECT * FROM ErrorMessageMLView
SELECT * FROM MemberTypeView
SELECT * FROM MemberTypeMLView
SELECT * FROM DeviceTypeView
SELECT * FROM DeviceTypeMLView
SELECT * FROM PeriodUnitView
SELECT * FROM PeriodUnitMLView
SELECT * FROM LimitUnitView
SELECT * FROM LimitUnitMLView
SELECT * FROM LicenseMLView
SELECT * FROM LicenseTypeView
SELECT * FROM LicenseTypeMLView
SELECT * FROM LicenseFeatureMLView
SELECT * FROM LogInView
-- [=== EDL ===]
SELECT * FROM UserInfoView
SELECT * FROM UserInfoMLView
-- [=== Customer ===]
SELECT * FROM CustomerView
SELECT * FROM CustomerMLView
SELECT * FROM LicenseHistoryMLView
SELECT * FROM MemberInfoView
SELECT * FROM MemberInfoMLView
SELECT * FROM DeviceView
SELECT * FROM DeviceMLView
SELECT * FROM BranchView
SELECT * FROM BranchMLView
SELECT * FROM OrgView
SELECT * FROM OrgMLView
SELECT * FROM QSetView
SELECT * FROM QSetMLView
SELECT * FROM QSlideView
SELECT * FROM QSlideMLView
SELECT * FROM QSlideItemView
SELECT * FROM QSlideItemMLView
*/
/*
-- Register Basic Company.
DECLARE @customerId nvarchar(30)

EXEC Register N'Softbase Co., Ltd.'
            , N'admin@softbase.co.th'
			, 1234
			, 3
			, @customerId out
			--, @memberId out, @branchId out, @orgId out, @errNum out, @errMsg out;

SELECT @customerId;

EXEC InitSampleData @customerId;
*/

