/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetPeriodUnit.
-- Description:	Get Period Unit.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetPeriodUnit NULL, 1, 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetPeriodUnit] 
(
  @langId nvarchar(3) = NULL
, @periodUnitId int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , periodUnitId
		 , PeriodUnitDescription
		 , SortOrder
		 , Enabled 
	  FROM PeriodUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
       AND PeriodUnitId =  @periodUnitId
	 ORDER BY SortOrder, PeriodUnitId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLimitUnit.
-- Description:	Get Limit Unit.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetLimitUnit NULL, 1, 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetLimitUnit] 
(
  @langId nvarchar(3) = NULL
, @limitUnitId int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , limitUnitId
		 , LimitUnitDescription
		 , LimitUnitText
		 , SortOrder
		 , Enabled
	  FROM LimitUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
       AND LimitUnitId =  @limitUnitId
	 ORDER BY SortOrder, LimitUnitId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
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
--exec GetMemberType NULL, 100;    -- all
--exec GetMemberType NULL, 100, 0; -- disable only
--exec GetMemberType NULL, 100, 1; -- enable only
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberType] 
(
  @langId nvarchar(3) = NULL
, @memberTypeId int = NULL
, @enabled bit = NULL
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


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDeviceTypes.
-- Description:	Get Devices.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
-- <2020-04-30> :
--	- Remove parameter @deviceTypeId.
--  - Add parameter @enabled.
--
-- [== Example ==]
--
--exec GetDeviceTypes N'EN';
--exec GetDeviceTypes N'TH';
--exec GetDeviceTypes NULL, 1;
--exec GetDeviceTypes NULL, 0;
-- =============================================
ALTER PROCEDURE [dbo].[GetDeviceTypes]
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
    SELECT langId
		 , deviceTypeId
		 , Description as Type
		 , SortOrder
		 , Enabled
    FROM DeviceTypeMLView
    WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
      AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
    ORDER BY SortOrder, LangId, deviceTypeId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDeviceType.
-- Description:	Get Device Type.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetDeviceType NULL, 101, 1;  -- all enable languages
--exec GetDeviceType N'TH', 101;    -- only TH language
-- =============================================
CREATE PROCEDURE [dbo].[GetDeviceType]
(
  @langId nvarchar(3) = NULL
, @deviceTypeId int = NULL
, @enabled bit = NULL
)
AS
BEGIN
    SELECT langId
		 , deviceTypeId
		 , Description as Type
		 , SortOrder
		 , Enabled
    FROM DeviceTypeMLView
    WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
      AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
      AND DeviceTypeId = @deviceTypeId
    ORDER BY SortOrder, LangId, DeviceTypeId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
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
--exec GetUserInfo NULL, N'EDL-U20200402001';      -- all languages
--exec GetUserInfo NULL, N'EDL-U20200402001', 1;   -- only enable languages
--exec GetUserInfo N'TH', N'EDL-U20200402001';     -- only TH language
--exec GetUserInfo N'EN', N'EDL-U20200402001';     -- only EN language
--exec GetUserInfo NULL, NULL;					 -- no customerId (no data returns)
--exec GetUserInfo N'TH', NULL;					 -- no customerId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetUserInfo] 
(
  @langId nvarchar(3) = NULL
, @userId nvarchar(30) = NULL
, @enabled bit = NULL
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


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomers
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-30> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
-- <2010-04-30> :
--	- remove parameter @customerId
--
-- [== Example ==]
--
--exec GetCustomers NULL, 1; -- for only enabled languages.
--exec GetCustomers;         -- for get all.
--exec GetCustomers N'EN';   -- for get customers for EN language.
--exec GetCustomers N'TH';   -- for get customers for TH language.
-- =============================================
ALTER PROCEDURE [dbo].[GetCustomers] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , CustomerName
		 , TaxCode
		 , Address1
		 , Address2
		 , City
		 , Province
		 , PostalCode
		 , Phone
		 , Mobile
		 , Fax
		 , Email
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM CustomerMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	 ORDER BY SortOrder, CustomerId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomer
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetCustomer N'EN', N'EDL-C2020030001';   -- only EN language
--exec GetCustomer N'TH', N'EDL-C2020030001';   -- only TH language
--exec GetCustomer NULL, N'EDL-C2020030001', 1; -- all enable languages
--exec GetCustomer NULL, N'EDL-C2020030001';    -- all languages
--exec GetCustomer NULL, NULL;                  -- no customerId (no data returns)
--exec GetCustomer N'TH', NULL;                 -- no customerId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomer] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , CustomerName
		 , TaxCode
		 , Address1
		 , Address2
		 , City
		 , Province
		 , PostalCode
		 , Phone
		 , Mobile
		 , Fax
		 , Email
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM CustomerMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	 ORDER BY SortOrder, CustomerId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
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
--  - remove @memberId parameter.
--
-- [== Example ==]
--
-- /* for get MemberInfos by CustomerID */
--exec GetMemberInfos NULL, N'EDL-C2020030001', 1;   -- all enable languages
--exec GetMemberInfos N'TH', N'EDL-C2017060011';     -- only TH language
-- /* for get MemberInfos without CustomerID */
--exec GetMemberInfos N'TH', NULL;                   -- no data returns
-- =============================================
ALTER PROCEDURE [dbo].[GetMemberInfos] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
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
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	 ORDER BY SortOrder, LangId, CustomerId, MemberId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
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
-- /* Get MemberInfo by CustomerID and MemberId. */
--exec GetMemberInfo NULL, N'EDL-C2017060011', N'M00001';      -- all languages
--exec GetMemberInfo NULL, N'EDL-C2017060011', N'M00001', 1;   -- all enable languages
--exec GetMemberInfo N'TH', N'EDL-C2017060011', N'M00001';     -- TH language
--exec GetMemberInfo N'TH', NULL, N'M00001';                   -- no customerID (no data returns)
--exec GetMemberInfo N'TH', N'EDL-C2020030001', NULL;          -- no memberId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberInfo] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @memberId nvarchar(30) = NULL
, @enabled bit = NULL
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
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(@memberId)))
	 ORDER BY SortOrder, LangId, CustomerId, MemberId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetBranchs.
-- Description:	Get Branchs.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column BranchId to branchId
-- <2020-04-30> :
--	- remove parameter @branchId
--
-- [== Example ==]
--
--exec GetBranchs N'TH', N'EDL-C2017060011', 1;        -- for get Branchs by CustomerID.
--exec GetBranchs N'TH', NULL, 1;                      -- no customerID (no data returns)
-- =============================================
ALTER PROCEDURE [dbo].[GetBranchs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , branchId
		 , BranchName
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM BranchMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetBranch.
-- Description:	Get Branch.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetBranch NULL, N'EDL-C2020030001', N'B0001';      -- all languages
--exec GetBranch NULL, N'EDL-C2020030001', N'B0001', 1;   -- all enable languages
--exec GetBranch N'TH', N'EDL-C2020030001', N'B0001';     -- only TH language
--exec GetBranch N'TH', NULL, N'B0001';                   -- no customerId (no data returns)
--exec GetBranch N'TH', N'EDL-C2020030001', NULL;         -- no branchId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetBranch] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , branchId
		 , BranchName
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM BranchMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(@branchId)))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetOrgs
-- Description:	Get Organizations.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column OrgId to orgId
--	- change column ParentId to parentId
--	- change column BranchId to branchId
-- <2020-04-30> :
--  - remove parameter @orgId
--
-- [== Example ==]
--
--/* With Specificed CustomerId */
--exec GetOrgs NULL, N'EDL-C2020030001';              -- Gets orgs in enable languages all branchs.
--exec GetOrgs N'EN', N'EDL-C2020030001';             -- Gets orgs in EN language all branchs.
--exec GetOrgs N'TH', N'EDL-C2020030001';             -- Gets orgs in TH language all branchs.
--/* With Specificed CustomerId, BranchId */
--exec GetOrgs NULL, N'EDL-C2020030001', N'B0001';    -- Gets orgs in enable languages in Branch 1.
--exec GetOrgs N'EN', N'EDL-C2020030001', N'B0001';   -- Gets orgs in EN language in Branch 1.
--exec GetOrgs N'TH', N'EDL-C2020030001', N'B0001';   -- Gets orgs in TH language in Branch 1.
--/* Without Specificed CustomerId */
--exec GetOrgs NULL, NULL, N'B0001';                  -- no data returns.
-- =============================================
ALTER PROCEDURE [dbo].[GetOrgs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , orgId
		 , parentId
		 , branchId
		 , OrgName
		 , BranchName
		 , OrgStatus
		 , BranchStatus
		 , SortOrder
		 , Enabled 
	  FROM OrgMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(COALESCE(@branchId, BranchId))))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId, OrgId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetOrg
-- Description:	Get Organization.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--/* With Specificed CustomerId, OrgId */
--exec GetOrg NULL, N'EDL-C2020030001', N'O0003', 1   -- all enable languages
--exec GetOrg N'EN', N'EDL-C2020030001', N'O0003'     -- only EN language
--exec GetOrg N'TH', N'EDL-C2020030001', N'O0003'     -- only TH language
--exec GetOrg N'TH', NULL, N'O0003'                   -- no data returns
--exec GetOrg N'TH', N'EDL-C2020030001', NULL         -- no data returns
-- =============================================
CREATE PROCEDURE [dbo].[GetOrg] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @orgId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , orgId
		 , parentId
		 , branchId
		 , OrgName
		 , BranchName
		 , OrgStatus
		 , BranchStatus
		 , SortOrder
		 , Enabled 
	  FROM OrgMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(OrgId))) = UPPER(LTRIM(RTRIM(@orgId)))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId, OrgId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDevices.
-- Description:	Get Devices.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
-- <2020-04-30> :
--  - reorder parameter @enabled
--  - remove parameter @deviceId
--
-- [== Example ==]
--
--exec GetDevices NULL, N'EDL-C2020030001', 1; -- get devices in all enable languages.
--exec GetDevices N'TH', N'EDL-C2020030001';   -- get devices in TH language.
--exec GetDevices N'TH', NULL;                 -- no data returns.
-- =============================================
ALTER PROCEDURE [dbo].[GetDevices] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT DMLV.langId
		 , DMLV.customerId
		 , DMLV.deviceId
		 , DMLV.deviceTypeId
		 , DTMV.Description as Type
		 , DMLV.DeviceName
		 , DMLV.Location
		 , DMLV.orgId
		 , DMLV.memberId
		 , DMLV.SortOrder
		 , DMLV.Enabled 
	  FROM DeviceMLView DMLV
	     , DeviceTypeMLView DTMV
		 --, OrgMLView OMLV
		 --, MemberInfoMLView MIMLV
	 WHERE DMLV.[ENABLED] = COALESCE(@enabled, DMLV.[ENABLED])
	   AND UPPER(LTRIM(RTRIM(DMLV.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, DMLV.LangId))))
       AND UPPER(LTRIM(RTRIM(DTMV.LangId))) = UPPER(LTRIM(RTRIM(DMLV.LangId)))
	   AND UPPER(LTRIM(RTRIM(DMLV.CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND DMLV.DeviceTypeId = DTMV.DeviceTypeId
	   --AND OMLV.CustomerId = DMLV.CustomerId
	   --AND OMLV.OrgID = DMLV.OrgId
	   --AND MIMLV.CustomerId = DMLV.CustomerId
	   --AND MIMLV.MemberID = DMLV.MemberID
	 ORDER BY DMLV.SortOrder, DMLV.LangId, DMLV.CustomerId, DMLV.DeviceId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDevice.
-- Description:	Get Device.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetDevice NULL, N'EDL-C2020030001', N'D0001', 1;  -- get devices by CustomerID and DeviceId in all enable languages
--exec GetDevice N'TH', N'EDL-C2020030001', N'D0001';    -- get devices by CustomerID and DeviceId in TH language.
--exec GetDevice N'TH', NULL, N'D0001';			       -- no data returns
--exec GetDevice N'TH', N'EDL-C2020030001', NULL;        -- no data returns
-- =============================================
CREATE PROCEDURE [dbo].[GetDevice] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @deviceId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT DMLV.langId
		 , DMLV.customerId
		 , DMLV.deviceId
		 , DMLV.deviceTypeId
		 , DTMV.Description as Type
		 , DMLV.DeviceName
		 , DMLV.Location
		 , DMLV.orgId
		 , DMLV.memberId
		 , DMLV.SortOrder
		 , DMLV.Enabled 
	  FROM DeviceMLView DMLV
	     , DeviceTypeMLView DTMV
		 --, OrgMLView OMLV
		 --, MemberInfoMLView MIMLV
	 WHERE DMLV.[ENABLED] = COALESCE(@enabled, DMLV.[ENABLED])
	   AND UPPER(LTRIM(RTRIM(DMLV.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, DMLV.LangId))))
       AND UPPER(LTRIM(RTRIM(DTMV.LangId))) = UPPER(LTRIM(RTRIM(DMLV.LangId)))
	   AND UPPER(LTRIM(RTRIM(DMLV.CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(DMLV.DeviceId))) = UPPER(LTRIM(RTRIM(@deviceId)))
	   AND DMLV.DeviceTypeId = DTMV.DeviceTypeId
	   --AND OMLV.CustomerId = DMLV.CustomerId
	   --AND OMLV.OrgID = DMLV.OrgId
	   --AND MIMLV.CustomerId = DMLV.CustomerId
	   --AND MIMLV.MemberID = DMLV.MemberID
	 ORDER BY DMLV.SortOrder, DMLV.LangId, DMLV.CustomerId, DMLV.DeviceId;
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSets.
-- Description:	Get Question Sets.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove QSetDescriptionNative column.
--    - Rename QSetDescriptionEN column to QSetDescription.
-- <2020-01-07> :
--    - Add MinVoteDate, MaxVoteDate
-- <2020-04-30> :
--    - remove parameter @qSetId
--    - temporary remove column minvotedate, maxvotedate
--
-- [== Example ==]
--
--EXEC GetQSets NULL, N'EDL-C2020030001', 1;   -- get all QSets for enable languages
--EXEC GetQSets N'EN', N'EDL-C2020030001';     -- get all QSets for EN language
--EXEC GetQSets N'EN', NULL;                   -- no data returns
-- =============================================
ALTER PROCEDURE [dbo].[GetQSets]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT A.langId
		 , A.customerId
		 , A.qSetId
		 , A.BeginDate
		 , A.EndDate
         /*
		 , (
			SELECT MIN(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
		   ) AS MinVoteDate
		 , (
			SELECT MAX(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
		   ) AS MaxVoteDate
         */
		 , A.QSetDescription
		 , A.DisplayMode
		 , A.HasRemark
		 , A.IsDefault
		 , A.QSetStatus
		 , A.SortOrder
		 , A.Enabled 
	  FROM QSetMLView A
	 WHERE A.[ENABLED] = COALESCE(@enabled, A.[ENABLED])
	   AND UPPER(LTRIM(RTRIM(A.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, A.LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	 ORDER BY A.SortOrder, A.CustomerId, A.QSetId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSet.
-- Description:	Get Question Set.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetQSet NULL, N'EDL-C2020030001', N'QS00001', 1; -- get QSet in all enable languages.
--EXEC GetQSet N'EN', N'EDL-C2020030001', N'QS00001';   -- get QSet in EN language.
--EXEC GetQSet N'EN', NULL, N'QS00001';			        -- no data returns
--EXEC GetQSet N'EN', N'EDL-C2020030001', NULL;			-- no data returns
-- =============================================
CREATE PROCEDURE [dbo].[GetQSet]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT A.langId
		 , A.customerId
		 , A.qSetId
		 , A.BeginDate
		 , A.EndDate
		 , (
			SELECT MIN(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
		   ) AS MinVoteDate
		 , (
			SELECT MAX(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
		   ) AS MaxVoteDate
		 , A.QSetDescription
		 , A.DisplayMode
		 , A.HasRemark
		 , A.IsDefault
		 , A.QSetStatus
		 , A.SortOrder
		 , A.Enabled 
	  FROM QSetMLView A
	 WHERE A.[ENABLED] = COALESCE(@enabled, A.[ENABLED])
	   AND UPPER(LTRIM(RTRIM(A.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, A.LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(A.QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
	 ORDER BY A.SortOrder, A.CustomerId, A.QSetId
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlides.
-- Description:	Get Question Slides.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove QSlideTextNative column.
--    - Rename QSlideTextEN column to QSlideText.
-- <2020-04-30> :
--    - remove parameter @qSeq
--
-- [== Example ==]
--
--EXEC GetQSlides NULL, N'EDL-C2020030001', NULL, 1;       -- get all QSlide in all QSet (enable languages)
--EXEC GetQSlides N'EN', N'EDL-C2020030001', NULL;         -- get all QSlide in all QSet (EN language)
--EXEC GetQSlides NULL, N'EDL-C2020030001', N'QS00002', 1; -- get all QSlide in Specificed QSet (enable languages)
--EXEC GetQSlides N'EN', N'EDL-C2020030001', N'QS00002';   -- get all QSlide in Specificed QSet (EN language)
-- =============================================
ALTER PROCEDURE [dbo].[GetQSlides]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , qSeq
		 , QSlideText
		 , HasRemark
		 , QSlideStatus
		 , QSlideOrder
		 , Enabled 
	  FROM QSlideMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlide.
-- Description:	Get Question Slide.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetQSlide NULL, N'EDL-C2020030001', N'QS00001', 1, 1; -- enable languages only
--EXEC GetQSlide N'EN', N'EDL-C2020030001', N'QS00001', 1;   -- EN language
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlide]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @qSeq int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , qSeq
		 , QSlideText
		 , HasRemark
		 , QSlideStatus
		 , QSlideOrder
		 , Enabled 
	  FROM QSlideMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
	   AND QSeq = @qSeq
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlideItems.
-- Description:	Get Question Slide Items.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove QItemTextNative column.
--    - Rename QItemTextEN column to QItemText.
-- <2020-03-26> :
--	- Add choice parameter.
-- <2020-04-30> :
--    - remove parameter @qSSeq
--
-- [== Example ==]
--
--EXEC GetQSlideItems NULL, N'EDL-C2020030001', N'QS00001', 1, 1;  -- all items in all enable languages
--EXEC GetQSlideItems N'JA', N'EDL-C2020030001', N'QS00001', 1;    -- all items in all JA language
--EXEC GetQSlideItems N'JA', NULL, N'QS00001', 1;                  -- no data returns
--EXEC GetQSlideItems N'JA', N'EDL-C2020030001', NULL, 1;          -- no data returns
--EXEC GetQSlideItems N'JA', N'EDL-C2020030001', N'QS00001', NULL; -- no data returns
-- =============================================
ALTER PROCEDURE [dbo].[GetQSlideItems]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @qSeq int = NULL
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
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO


/*********** Script Update Date: 2020-04-30  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlideItem.
-- Description:	Get Question Slide Item.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- /* Gets item for QSet:'QS00001', Slide: 1, Item: 1 */
--EXEC GetQSlideItem NULL, N'EDL-C2020030001', N'QS00001', 1, 1, 1; -- enable languages
--EXEC GetQSlideItem N'JA', N'EDL-C2020030001', N'QS00001', 1, 1;   -- JA language
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlideItem]
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

