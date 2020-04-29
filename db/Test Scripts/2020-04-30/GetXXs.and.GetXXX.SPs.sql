/*
exec GetPeriodUnits NULL, 1;  -- for only enabled languages.
exec GetPeriodUnits;          -- for get all.
exec GetPeriodUnits N'TH';    -- for get PeriodUnit for EN language.

exec GetPeriodUnit NULL, 1, 1;
exec GetPeriodUnit N'TH', 1, 1;

exec GetLimitUnits NULL, 1;  -- for only enabled languages.
exec GetLimitUnits;          -- for get all.
exec GetLimitUnits N'TH';    -- for get LimitUnit for EN language.

exec GetLimitUnit NULL, 1, 1;
exec GetLimitUnit N'TH', 1, 1;

exec GetMemberTypes NULL, 1;  -- for only enabled languages.
exec GetMemberTypes;          -- for get all.
exec GetMemberTypes N'EN';    -- for get MemberType for EN language.
exec GetMemberTypes N'TH';    -- for get MemberType for TH language.

exec GetMemberType NULL, 100;    -- all
exec GetMemberType NULL, 100, 0; -- disable only
exec GetMemberType NULL, 100, 1; -- enable only
exec GetMemberType N'TH', 100; -- TH only

exec GetDeviceTypes N'EN';
exec GetDeviceTypes N'TH';
exec GetDeviceTypes NULL, 1;
exec GetDeviceTypes NULL, 0;

exec GetDeviceType NULL, 101, 1;
exec GetDeviceType N'TH', 101;

exec GetUserInfos NULL, NULL, 1;  -- for only enabled languages.
exec GetUserInfos;                -- for get all.
exec GetUserInfos N'EN', NULL;    -- for get UserInfo for EN language all member type.
exec GetUserInfos N'TH', NULL;    -- for get UserInfo for TH language all member type.
exec GetUserInfos N'EN', 100;     -- for get UserInfo for EN language member type = 100.
exec GetUserInfos N'TH', 180;     -- for get UserInfo for TH language member type = 180.

exec GetUserInfo NULL, N'EDL-U20200402001';   -- all languages
exec GetUserInfo NULL, N'EDL-U20200402001', 1;   -- only enable languages
exec GetUserInfo N'TH', N'EDL-U20200402001';     -- only TH language
exec GetUserInfo N'EN', N'EDL-U20200402001';     -- only EN language
exec GetUserInfo N'TH', NULL;					 -- no customerId (no data returns)
exec GetUserInfo NULL, NULL;					 -- no customerId (no data returns)

exec GetCustomers NULL, 1; -- for only enabled languages.
exec GetCustomers;         -- for get all.
exec GetCustomers N'EN';   -- for get customers for EN language.
exec GetCustomers N'TH';   -- for get customers for TH language.

exec GetCustomer N'EN', N'EDL-C2020030001';   -- only EN language
exec GetCustomer N'TH', N'EDL-C2020030001';   -- only TH language
exec GetCustomer NULL, N'EDL-C2020030001', 1; -- all enable languages
exec GetCustomer NULL, N'EDL-C2020030001';    -- all languages
exec GetCustomer NULL, NULL;                  -- no customerId (no data returns)
exec GetCustomer N'TH', NULL;                 -- no customerId (no data returns)

exec GetMemberInfos NULL, N'EDL-C2020030001', 1;
exec GetMemberInfos N'TH', N'EDL-C2020030001';
exec GetMemberInfos N'TH', NULL;

exec GetMemberInfo NULL, N'EDL-C2020030001', N'M00001';      -- all languages
exec GetMemberInfo NULL, N'EDL-C2020030001', N'M00001', 1;   -- all enable languages
exec GetMemberInfo N'TH', N'EDL-C2020030001', N'M00001';     -- TH language
exec GetMemberInfo N'TH', NULL, N'M00001';                   -- no customerID (no data returns)
exec GetMemberInfo N'TH', N'EDL-C2020030001', NULL;          -- no memberId (no data returns)

exec GetBranchs N'TH', N'EDL-C2020030001', 1;        -- for get Branchs by CustomerID.
exec GetBranchs N'TH', NULL, 1;                      -- no customerID (no data returns)

exec GetBranch NULL, N'EDL-C2020030001', N'B0001';      -- all languages
exec GetBranch NULL, N'EDL-C2020030001', N'B0001', 1;   -- all enable languages
exec GetBranch N'TH', N'EDL-C2020030001', N'B0001';     -- only TH language
exec GetBranch N'TH', NULL, N'B0001';                   -- no customerId (no data returns)
exec GetBranch N'TH', N'EDL-C2020030001', NULL;         -- no branchId (no data returns)

exec GetOrgs NULL, N'EDL-C2020030001'; -- Gets orgs in enable languages all branchs.
exec GetOrgs N'EN', N'EDL-C2020030001'; -- Gets orgs in EN language all branchs.
exec GetOrgs N'TH', N'EDL-C2020030001'; -- Gets orgs in TH language all branchs.
exec GetOrgs NULL, N'EDL-C2020030001', N'B0001'; -- Gets orgs in enable languages in Branch 1.
exec GetOrgs N'EN', N'EDL-C2020030001', N'B0001'; -- Gets orgs in EN language in Branch 1.
exec GetOrgs N'TH', N'EDL-C2020030001', N'B0001'; -- Gets orgs in TH language in Branch 1.
exec GetOrgs NULL, NULL, N'B0001';                  -- no data returns.

exec GetOrg NULL, N'EDL-C2020030001', N'O0003', 1   -- all enable languages
exec GetOrg N'EN', N'EDL-C2020030001', N'O0003'     -- only EN language
exec GetOrg N'TH', N'EDL-C2020030001', N'O0003'     -- only TH language
exec GetOrg N'TH', NULL, N'O0003'                   -- no data returns
exec GetOrg N'TH', N'EDL-C2020030001', NULL         -- no data returns

exec GetDevices NULL, N'EDL-C2020030001', 1; -- get devices in all enable languages.
exec GetDevices N'TH', N'EDL-C2020030001';   -- get devices in TH language.
exec GetDevices N'TH', NULL;                 -- no data returns.

exec GetDevice NULL, N'EDL-C2020030001', N'D0001', 1;  -- get devices by CustomerID and DeviceId in all enable languages
exec GetDevice N'TH', N'EDL-C2020030001', N'D0001';    -- get devices by CustomerID and DeviceId in TH language.
exec GetDevice N'TH', NULL, N'D0001';			       -- no data returns
exec GetDevice N'TH', N'EDL-C2020030001', NULL;        -- no data returns

EXEC GetQSets NULL, N'EDL-C2020030001', 1;   -- get all QSets for enable languages
EXEC GetQSets N'EN', N'EDL-C2020030001';  -- get all QSets for EN language
EXEC GetQSets N'EN', NULL;  -- get all QSets for EN language

EXEC GetQSet NULL, N'EDL-C2020030001', N'QS00001', 1; -- get QSet in all enable languages.
EXEC GetQSet N'EN', N'EDL-C2020030001', N'QS00001';   -- get QSet in EN language.
EXEC GetQSet N'EN', NULL, N'QS00001';			        -- no data returns
EXEC GetQSet N'EN', N'EDL-C2020030001', NULL;			-- no data returns

EXEC GetQSlides NULL, N'EDL-C2020030001', NULL, 1;       -- get all QSlide in all QSet (enable languages)
EXEC GetQSlides N'EN', N'EDL-C2020030001', NULL;         -- get all QSlide in all QSet (EN language)
EXEC GetQSlides NULL, N'EDL-C2020030001', N'QS00001', 1; -- get all QSlide in Specificed QSet (enable languages)
EXEC GetQSlides N'EN', N'EDL-C2020030001', N'QS00001';   -- get all QSlide in Specificed QSet (EN language)

EXEC GetQSlide NULL, N'EDL-C2020030001', N'QS00001', 1, 1; -- enable languages only
EXEC GetQSlide N'EN', N'EDL-C2020030001', N'QS00001', 1;   -- EN language

EXEC GetQSlideItems NULL, N'EDL-C2020030001', N'QS00001', 1, 1;  -- all items in all enable languages
EXEC GetQSlideItems N'JA', N'EDL-C2020030001', N'QS00001', 1;    -- all items in all JA language
EXEC GetQSlideItems N'JA', NULL, N'QS00001', 1;
EXEC GetQSlideItems N'JA', N'EDL-C2020030001', NULL, 1;
EXEC GetQSlideItems N'JA', N'EDL-C2020030001', N'QS00001', NULL;

EXEC GetQSlideItem NULL, N'EDL-C2020030001', N'QS00001', 1, 1, 1; -- enable languages
EXEC GetQSlideItem N'JA', N'EDL-C2020030001', N'QS00001', 1, 1;   -- JA language
*/
