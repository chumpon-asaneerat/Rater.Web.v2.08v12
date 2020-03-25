/*********** Script Update Date: 2020-03-26  ***********/
EXEC DROPALL;
DROP PROCEDURE DROPALL;

/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: dboView.
-- Description:	Listing out extended properties.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[dboView]
AS
	SELECT CASE 
			WHEN ob.parent_object_id > 0
				THEN OBJECT_SCHEMA_NAME(ob.parent_object_id) + '.' + OBJECT_NAME(ob.parent_object_id) + '.' + ob.name
				ELSE OBJECT_SCHEMA_NAME(ob.object_id) + '.' + ob.name
			END + CASE WHEN ep.minor_id > 0 THEN '.' + col.name ELSE '' END AS ObjectName,
			'schema' + CASE WHEN ob.parent_object_id > 0 THEN '/table' ELSE '' END + '/' 
			         + CASE WHEN ob.type IN ('TF', 'FN', 'IF', 'FS', 'FT') THEN 'function'
					        WHEN ob.type IN ('P', 'PC', 'RF', 'X') THEN 'procedure'
							WHEN ob.type IN ('U', 'IT') THEN 'table'
							WHEN ob.type = 'SQ' THEN 'queue'
							ELSE LOWER(ob.type_desc) END
					 + CASE WHEN col.column_id IS NULL THEN '' ELSE '/column' END AS ObjectType,
		ep.name AS EPName, ep.value AS EPValue
	FROM sys.extended_properties AS ep
	INNER JOIN sys.objects AS ob ON ep.major_id = ob.object_id
		AND ep.class = 1
	LEFT OUTER JOIN sys.columns AS col ON ep.major_id = col.object_id
		AND ep.class = 1
		AND ep.minor_id = col.column_id
	UNION ALL
	(
		--indexes
		SELECT OBJECT_SCHEMA_NAME(ob.object_id) + '.' + OBJECT_NAME(ob.object_id) + '.' + ix.name,
			'schema/' + LOWER(ob.type_desc) + '/index', ep.name, value
		FROM sys.extended_properties ep
		 INNER JOIN sys.objects ob ON ep.major_id = ob.OBJECT_ID
		   AND class = 7
		 INNER JOIN sys.indexes ix ON ep.major_id = ix.Object_id
		   AND class = 7
		   AND ep.minor_id = ix.index_id
	)
	UNION ALL
	(
		--Parameters
		SELECT OBJECT_SCHEMA_NAME(ob.object_id) + '.' + OBJECT_NAME(ob.object_id) + '.' + par.name,
			   'schema/' + LOWER(ob.type_desc) + '/parameter', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.objects ob ON ep.major_id = ob.OBJECT_ID
		   AND class = 2
		 INNER JOIN sys.parameters par ON ep.major_id = par.Object_id
		   AND class = 2
		   AND ep.minor_id = par.parameter_id
	)
	UNION ALL
	(
		--schemas
		SELECT sch.name, 'schema', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.schemas sch ON class = 3
		   AND ep.major_id = SCHEMA_ID
	)
	UNION ALL
	(
		--Database 
		SELECT DB_NAME(), '', ep.name, value
		  FROM sys.extended_properties ep
		 WHERE class = 0
	)
	UNION ALL
	(
		--XML Schema Collections
		SELECT SCHEMA_NAME(SCHEMA_ID) + '.' + XC.name, 'schema/xml_Schema_collection', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.xml_schema_collections xc ON class = 10
		  AND ep.major_id = xml_collection_id
	)
	UNION ALL
	(
		--Database Files
		SELECT df.name, 'database_file', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.database_files df ON class = 22
		   AND ep.major_id = file_id
	)
	UNION ALL
	(
		--Data Spaces
		SELECT ds.name, 'dataspace', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.data_spaces ds ON class = 20
		   AND ep.major_id = data_space_id
	)
	UNION ALL
	(
		--USER
		SELECT dp.name, 'database_principal', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.database_principals dp ON class = 4
		   AND ep.major_id = dp.principal_id
	)
	UNION ALL
	(
		--PARTITION FUNCTION
		SELECT pf.name, 'partition_function', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.partition_functions pf ON class = 21
		   AND ep.major_id = pf.function_id
	)
	UNION ALL
	(
		--REMOTE SERVICE BINDING
		SELECT rsb.name, 'remote service binding', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.remote_service_bindings rsb ON class = 18
		   AND ep.major_id = rsb.remote_service_binding_id
	)	
	UNION ALL
	(
		--Route
		SELECT rt.name, 'route', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.routes rt ON class = 19
		   AND ep.major_id = rt.route_id
	)
	UNION ALL
	(
		--Service
		SELECT sv.name COLLATE DATABASE_DEFAULT, 'service', ep.name, value
		  FROM sys.extended_properties ep
		 INNER JOIN sys.services sv ON class = 17
		   AND ep.major_id = sv.service_id
	)
	UNION ALL
	(
		-- 'CONTRACT'
		SELECT svc.name, 'service_contract', ep.name, value
		  FROM sys.service_contracts svc
		 INNER JOIN sys.extended_properties ep ON class = 16
		  AND ep.major_id = svc.service_contract_id
	)
	UNION ALL
	(
		-- 'MESSAGE TYPE'
		SELECT smt.name, 'message_type', ep.name, value
		  FROM sys.service_message_types smt
		 INNER JOIN sys.extended_properties ep ON class = 15
		   AND ep.major_id = smt.message_type_id
	)
	UNION ALL
	(
		-- 'assembly'
		SELECT asy.name, 'assembly', ep.name, value
		  FROM sys.assemblies asy
		 INNER JOIN sys.extended_properties ep ON class = 5
		   AND ep.major_id = asy.assembly_id
	)
	UNION ALL
	(
		-- 'PLAN GUIDE' 
		SELECT pg.name, 'plan_guide', ep.name, value
		  FROM sys.plan_guides pg
		 INNER JOIN sys.extended_properties ep ON class = 27
		   AND ep.major_id = pg.plan_guide_id
	)
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Language.
-- Description:	The Language Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--	  - FlagId is used ISO 3166-1 alpha 2 code.
-- <2019-08-19> :
--	- Table Changes.
--	  - Remove DescriptionNative column.
--	  - Change DescriptionEN column to Description.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[Language]
(
    [LangId] [nvarchar](3) NOT NULL,
    [FlagId] [nvarchar](3) NOT NULL,
    [Description] [nvarchar](50) NOT NULL,
    [SortOrder] [int] NOT NULL,
    [Enabled] [bit] NOT NULL,
    CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_Language_FlagId]    Script Date: 4/20/2018 14:22:48 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Language_FlagId] ON [dbo].[Language]
(
	[FlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_SortOrder]  DEFAULT ((1)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_Enabled]  DEFAULT ((1)) FOR [Enabled]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 639-1 alpha 2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 3166-1-alpha-2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'FlagId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Enable Lanugage to used.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'Enabled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Unique index for FlagId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'INDEX',@level2name=N'IX_Language_FlagId'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LanguageView.
-- Description:	The Language View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View changes.
--    - Remove DescriptionNative column.
--    - Rename DescriptionEN column to Description.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LanguageView]
AS
	SELECT LangId
		 , FlagId
	     , Description
		 , SortOrder
		 , Enabled
    FROM dbo.Language

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ErrorMessage.
-- Description:	The Error Message Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[ErrorMessage](
	[ErrCode] [int] NOT NULL,
	[ErrMsg] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ErrorMessage] PRIMARY KEY CLUSTERED 
(
	[ErrCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessage', @level2type=N'COLUMN',@level2name=N'ErrCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Message.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessage', @level2type=N'COLUMN',@level2name=N'ErrMsg'
GO



/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ErrorMessageML](
	[ErrCode] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[ErrMsg] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ErrorMessageML] PRIMARY KEY CLUSTERED 
(
	[ErrCode] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessageML', @level2type=N'COLUMN',@level2name=N'ErrCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 639-1 alpha 2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessageML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Message.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessageML', @level2type=N'COLUMN',@level2name=N'ErrMsg'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ErrorMessageView]
AS
    SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , ErrorMessage.ErrCode
		 , ErrorMessage.ErrMsg
    FROM LanguageView CROSS JOIN dbo.ErrorMessage

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ErrorMessageMLView.
-- Description:	The Error Message ML View.
-- [== History ==]
-- <2018-05-18> :
--	- View Created.
-- <2019-08-19> :
--	- View changes.
--    - Remove ErrMsgNative column.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[ErrorMessageMLView]
AS
	SELECT EMV.LangId
		 , EMV.ErrCode
		 , CASE 
			WHEN EMML.ErrMsg IS NULL THEN 
				EMV.ErrMsg 
			ELSE 
				EMML.ErrMsg 
		   END AS ErrMsg
		 , EMV.Enabled
		 , EMV.SortOrder
		FROM dbo.ErrorMessageML AS EMML RIGHT OUTER JOIN ErrorMessageView AS EMV
		  ON (EMML.LangId = EMV.LangId AND EMML.ErrCode = EMV.ErrCode)

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MasterPK.
-- Description:	The Master Primary key Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[MasterPK](
	[TableName] [nvarchar](50) NOT NULL,
	[SeedResetMode] [tinyint] NOT NULL,
	[LastSeed] [int] NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[SeedDigits] [tinyint] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_MasterPK] PRIMARY KEY CLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MasterPK] ADD  CONSTRAINT [DF_MasterPK_SeedResetMode]  DEFAULT ((1)) FOR [SeedResetMode]
GO

ALTER TABLE [dbo].[MasterPK] ADD  CONSTRAINT [DF_MasterPK_LastSeed]  DEFAULT ((1)) FOR [LastSeed]
GO

ALTER TABLE [dbo].[MasterPK] ADD  CONSTRAINT [DF_MasterPK_SeedDigits]  DEFAULT ((4)) FOR [SeedDigits]
GO

ALTER TABLE [dbo].[MasterPK]  WITH CHECK ADD  CONSTRAINT [CK_MasterPK_SeedDigits] CHECK  (([SeedDigits]>=(1) AND [SeedDigits]<=(9)))
GO

ALTER TABLE [dbo].[MasterPK] CHECK CONSTRAINT [CK_MasterPK_SeedDigits]
GO

ALTER TABLE [dbo].[MasterPK]  WITH CHECK ADD  CONSTRAINT [CK_MasterPK_SeedResetMode] CHECK  (([SeedResetMode]=(3) OR [SeedResetMode]=(2) OR [SeedResetMode]=(1)))
GO

ALTER TABLE [dbo].[MasterPK] CHECK CONSTRAINT [CK_MasterPK_SeedResetMode]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reset Mode : 1: daily, 2 : monthly, 3: yearly' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'COLUMN',@level2name=N'SeedResetMode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Seed Number (integer) - value cannot be negative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'COLUMN',@level2name=N'LastSeed'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of digit for seed (default is 4)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'COLUMN',@level2name=N'SeedDigits'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Checks number of seed digits between 1 - 9' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'CONSTRAINT',@level2name=N'CK_MasterPK_SeedDigits'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Checks seed reset mode can only in range 1 - 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MasterPK', @level2type=N'CONSTRAINT',@level2name=N'CK_MasterPK_SeedResetMode'
GO


/*********** Script Update Date: 2020-03-26  ***********/


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsNullOrEmpty.
-- Description:	IsNullOrEmpty is function to check is string is in null or empty
--              returns 1 if string is null or empty string otherwise return 0.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[IsNullOrEmpty](@str nvarchar)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    IF @str IS NULL OR RTRIM(LTRIM(@str)) = N''
		SET @result = 1
	ELSE SET @result = 0

    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsSameDate.
-- Description:	IsSameDate is function to check is data is in same date
--              returns 1 if same date otherwise returns 0
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[IsSameDate](@date1 datetime, @date2 datetime)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    SELECT @diff = DATEDIFF(day, @date1, @date2);
    -- Return the result of the function
    IF @diff = 0
		SET @result = 1;
	ELSE SET @result = 0;
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsSameMonth.
-- Description:	IsSameMonth is function to check is data is in same month
--              returns 1 if same month otherwise returns 0
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[IsSameMonth](@date1 datetime, @date2 datetime)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    SELECT @diff = DATEDIFF(month, @date1, @date2);
    -- Return the result of the function
    IF @diff = 0
		SET @result = 1;
	ELSE SET @result = 0;
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsSameYear.
-- Description:	IsSameYear is function to check is data is in same year
--              returns 1 if same year otherwise returns 0
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[IsSameYear](@date1 datetime, @date2 datetime)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    SELECT @diff = DATEDIFF(year, @date1, @date2);
    -- Return the result of the function
    IF @diff = 0
		SET @result = 1;
	ELSE SET @result = 0;
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[NewIDView] AS SELECT NEWID() NEW_ID;
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NewSID.
-- Description:	New GUID in String nvarchar(80)
-- [== History ==]
-- <2018-05-29> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[NewSID]()
RETURNS nvarchar(80)
AS
BEGIN
DECLARE @id uniqueidentifier;
DECLARE @result nvarchar(80);
	SELECT @id = NEW_ID FROM NewIDView;
    SELECT @result = CONVERT(nvarchar(80), @id);
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MinDateTime.
-- Description:	MinDateTime is function to returns minimum value posible for datetime.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[MinDateTime]
(
)
RETURNS datetime
AS
BEGIN
DECLARE @dt datetime;
DECLARE @vDateStr nvarchar(40);
DECLARE @result datetime;
    SELECT @dt = CAST(CAST(0xD1BA AS BIGINT) * -1 AS DATETIME);
	SET @vDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @dt)) + '-' +
				     CONVERT(nvarchar(2), DatePart(mm, @dt)) + '-' +
					 CONVERT(nvarchar(2), DatePart(dd, @dt)) + ' ' +
					 N'00:00:00.000');
	SET @result = CONVERT(datetime, @vDateStr, 121);
    -- Return the result of the function
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MaxDateTime.
-- Description:	MaxDateTime is function to returns maximum value posible for datetime.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[MaxDateTime]
(
)
RETURNS datetime
AS
BEGIN
DECLARE @dt datetime;
DECLARE @vDateStr nvarchar(40);
DECLARE @result datetime;
    SELECT @dt = CAST(CAST(0x2D247f AS BIGINT) AS DATETIME);
	SET @vDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @dt)) + '-' +
				     CONVERT(nvarchar(2), DatePart(mm, @dt)) + '-' +
					 CONVERT(nvarchar(2), DatePart(dd, @dt)) + ' ' +
					 N'23:59:59.000');
	-- The max millisecond add with out round to next second is 998.
	SELECT @result = DATEADD(millisecond, 998, CONVERT(datetime, @vDateStr, 121));
	
    -- Return the result of the function
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ToMinTime.
-- Description: ToMinTime is function for set time of specificed datetime to 00:00:00.000.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[ToMinTime]
(
 @dt datetime
)
RETURNS datetime
AS
BEGIN
DECLARE @vDateStr nvarchar(40);
DECLARE @result datetime;
	IF (@dt IS NULL)
	BEGIN
		RETURN NULL;
	END
	SET @vDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @dt)) + '-' +
				     CONVERT(nvarchar(2), DatePart(mm, @dt)) + '-' +
					 CONVERT(nvarchar(2), DatePart(dd, @dt)) + ' ' +
					 N'00:00:00.000');
	SET @result = CONVERT(datetime, @vDateStr, 121);
    -- Return the result of the function
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ToMaxTime.
-- Description: ToMaxTime is function for set time of specificed datetime to 23:59:59.997.
--              The 997 ms is max value that not SQL Server not round to next second.
--              The data type datetime has a precision only up to 3ms, so there's no .999 precision.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[ToMaxTime]
(
 @dt datetime
)
RETURNS datetime
AS
BEGIN
DECLARE @vDateStr nvarchar(40);
DECLARE @result datetime;
	IF (@dt IS NULL)
	BEGIN
		RETURN NULL;
	END
	SET @vDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @dt)) + '-' +
				     CONVERT(nvarchar(2), DatePart(mm, @dt)) + '-' +
					 CONVERT(nvarchar(2), DatePart(dd, @dt)) + ' ' +
					 N'23:59:59.997');
	SET @result = CONVERT(datetime, @vDateStr, 121);
    -- Return the result of the function
    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsLangExist.
-- Description:	IsLangExist is function to check is langId is exist or not
--              returns 0 if langId is not exist otherwise return 1.
-- [== History ==]
-- <2018-05-29> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[IsLangExist]
(
 @langid nvarchar(3)
)
RETURNS bit
AS
BEGIN
DECLARE @lId nvarchar(3);
DECLARE @iCnt int;
DECLARE @result bit;
	IF (dbo.IsNullOrEmpty(@langId) = 1)
	BEGIN
		SET @lId = N'EN';
	END
	ELSE
	BEGIN
		SET @lId = @langId;
	END

	SELECT @iCnt = COUNT(*)
	  FROM Language
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@lId)));
	IF (@iCnt = 0)
	BEGIN
		SET @result = 0;
	END
	ELSE
	BEGIN
		SET @result = 1;
	END

    RETURN @result;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DropAll.
-- Description:	Drop all Stored Procedures/Views/Tables/Functions
-- [== History ==]
-- <2019-08-19> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec DropAll
-- =============================================
CREATE PROCEDURE [dbo].[DropAll]
AS
BEGIN
CREATE TABLE #SP_NAMES
(
    ProcName nvarchar(100)
);

CREATE TABLE #VIEW_NAMES
(
    ViewName nvarchar(100)
);

CREATE TABLE #TABLE_NAMES
(
    TableName nvarchar(100)
);

CREATE TABLE #FN_NAMES
(
    FuncName nvarchar(100)
);

DECLARE @sql nvarchar(MAX);
DECLARE @name nvarchar(100);
DECLARE @dropSPCursor CURSOR;
DECLARE @dropViewCursor CURSOR;
DECLARE @dropTableCursor CURSOR;
DECLARE @dropFuncCursor CURSOR;
	/*========= DROP PROCEDURES =========*/
    INSERT INTO #SP_NAMES
        (ProcName)
    SELECT name
      FROM sys.objects 
	 WHERE type = 'P' 
	   AND NAME <> 'DropAll' -- ignore current procedure.
	 ORDER BY modify_date DESC

    SET @dropSPCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT ProcName
    FROM #SP_NAMES;

    OPEN @dropSPCursor;
    FETCH NEXT FROM @dropSPCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop procedures.
        SET @sql = 'DROP PROCEDURE ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropSPCursor INTO @name;
    END
    CLOSE @dropSPCursor;
    DEALLOCATE @dropSPCursor;

    DROP TABLE #SP_NAMES;

	/*========= DROP VIEWS =========*/
    INSERT INTO #VIEW_NAMES
        (ViewName)
    SELECT name
    FROM sys.views;

    SET @dropViewCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT ViewName
    FROM #VIEW_NAMES;

    OPEN @dropViewCursor;
    FETCH NEXT FROM @dropViewCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP VIEW ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropViewCursor INTO @name;
    END
    CLOSE @dropViewCursor;
    DEALLOCATE @dropViewCursor;

    DROP TABLE #VIEW_NAMES;

	/*========= DROP TABLES =========*/
    INSERT INTO #TABLE_NAMES
        (TableName)
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = N'BASE TABLE';

    SET @dropTableCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT TableName
    FROM #TABLE_NAMES;

    OPEN @dropTableCursor;
    FETCH NEXT FROM @dropTableCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP TABLE ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropTableCursor INTO @name;
    END
    CLOSE @dropTableCursor;
    DEALLOCATE @dropTableCursor;

    DROP TABLE #TABLE_NAMES;

	/*========= DROP FUNCTIONS =========*/
    INSERT INTO #FN_NAMES
        (FuncName)
    SELECT O.name
      FROM sys.sql_modules M
     INNER JOIN sys.objects O 
	    ON M.object_id = O.object_id
     WHERE O.type IN ('IF','TF','FN')

    SET @dropFuncCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT FuncName
    FROM #FN_NAMES;

    OPEN @dropFuncCursor;
    FETCH NEXT FROM @dropFuncCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP FUNCTION ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropFuncCursor INTO @name;
    END
    CLOSE @dropFuncCursor;
    DEALLOCATE @dropFuncCursor;

    DROP TABLE #FN_NAMES;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetRandomode.
-- Description:	GetRandomCode is generate random code with specificed length max 50.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2018-05-29> :
--  - rename from GetRandomHexCode to GetRandomCode.
--	- extend @RandomString parameter size from 20 to 50.
--
-- [== Example ==]
-- /* execute */
-- exec GetRandomCode; -- generate 6 digit code.
-- exec GetRandomCode 4; -- generate 4 digit code.
-- /* use out parameter */
-- declare @code nvarchar(20);
-- exec dbo.GetRandomCode 6, @code out;
-- select @code;
-- =============================================
CREATE PROCEDURE [dbo].[GetRandomCode]
(
  @length int = 6
, @RandomString nvarchar(50) = null out
)
AS
BEGIN
DECLARE @PoolLength int;
DECLARE @CharPool nvarchar(40);
    -- define allowable character explicitly
    SET @CharPool = N'ABCDEFGHIJKLMNPQRSTUVWXYZ1234567890';
    SET @PoolLength = Len(@CharPool);
    SET @RandomString = '';

    WHILE (LEN(@RandomString) < @Length) BEGIN
        SET @RandomString = @RandomString +  SUBSTRING(@Charpool, CONVERT(int, RAND() * @PoolLength), 1)
    END

    SELECT @RandomString as Code;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetErrorMsg.
-- Description:	Get Error Message.
-- [== History ==]
-- <2018-04-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetErrorMsg 101 @errNum out, @errMsg out
-- =============================================
CREATE PROCEDURE GetErrorMsg
(
  @errCode as int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iCnt int = 0;
	SELECT @iCnt = COUNT(*)
	  FROM ErrorMessage
	 WHERE ErrCode = @errCode;

	IF @iCnt = 0
	BEGIN
	-- Not Found.
	SET @errNum = @errCode;
	SET @errMsg = 'Error Code Not Found.';
	END
	ELSE
	BEGIN
		SELECT @errNum = ErrCode
			 , @errMsg = ErrMsg
		  FROM ErrorMessage
		 WHERE ErrCode = @errCode;
	END 
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveErrorMsg.
-- Description:	Save Error Message.
-- [== History ==]
-- <2018-04-16> :
--	- Stored Procedure Created.
-- <2018-05-18> :
--	- Change parameter name.
--
-- [== Example ==]
--
--EXEC SaveErrorMsg 0, N'Success.';
--EXEC SaveErrorMsg 101, N'Language Id cannot be null or empty string.';
-- =============================================
CREATE PROCEDURE [dbo].[SaveErrorMsg](
  @errCode as int
, @message as nvarchar(MAX))
AS
BEGIN
DECLARE @iCnt int = 0;
    SELECT @iCnt = COUNT(*)
      FROM ErrorMessage
     WHERE ErrCode = @errCode;

    IF @iCnt = 0
    BEGIN
        -- INSERT
        INSERT INTO ErrorMessage
        (
              ErrCode
            , ErrMsg
        )
        VALUES
        (
              @errCode
            , @message
        );
    END
    ELSE
    BEGIN
        -- UPDATE
        UPDATE ErrorMessage
           SET ErrMsg = COALESCE(@message, ErrMsg)
         WHERE ErrCode = @errCode;
    END 
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveErrorMsgML.
-- Description:	Save LimitUnit ML.
-- [== History ==]
-- <2018-05-18> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveErrorMsgML 101, N'TH', N'รหัสภาษาไม่สามารถใส่ค่าว่างได้'
-- =============================================
CREATE PROCEDURE [dbo].[SaveErrorMsgML] 
(
  @errCode as int = null
, @langId as nvarchar(3) = null
, @message as nvarchar(MAX) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iMsgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 2201 : Error Code cannot be null or empty string.
	-- 2202 : Language Id cannot be null or empty string.
	-- 2203 : Language Id not found.
	-- 2204 : Error Message (ML) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@errCode IS NULL)
		BEGIN
            -- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 2201, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
            -- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 2202, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
            -- Language Id not found.
            EXEC GetErrorMsg 2203, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@message) = 1)
		BEGIN
            -- Error Message (ML) cannot be null or empty string.
            EXEC GetErrorMsg 2204, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iMsgCnt = COUNT(*)
		  FROM ErrorMessageML
		 WHERE ErrCode = @errCode
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF @iMsgCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO ErrorMessageML
			(
				  ErrCode
				, [LangId]
				, ErrMsg
			)
			VALUES
			(
				  @errCode
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@message))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE ErrorMessageML
			   SET ErrMsg = RTRIM(LTRIM(@message))
			 WHERE ErrCode = @errCode
			   AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetErrorMessages.
-- Description:	Get Error Messages.
-- [== History ==]
-- <2018-05-18> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--  - Remove ErrMsgNative column.
--
-- [== Example ==]
--
--exec GetErrorMsgs N'EN'; -- for only EN language.
--exec GetErrorMsgs;       -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetErrorMsgs] 
(
  @langId nvarchar(3) = null
, @errCode int = null
)
AS
BEGIN
	SELECT langId
		 , ErrCode
		 , ErrMsg
		 , SortOrder
		 , Enabled
	  FROM ErrorMessageMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND ErrCode = COALESCE(@errCode, ErrCode)
	   AND Enabled = 1
	 Order By SortOrder, ErrCode
END

GO

/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLanguage.
-- Description:	Save Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-06> :
--	- Update parameters for match change table structure.
--	- Add logic to allow to change DescriptionEN if in Update Mode.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2017-06-12> :
-- - Fixed all checks logic.
-- <2018-04-16> :
-- - Remove Currency.
-- - Replace FlagIconCss with FlagId.
-- - Replace Error Message code.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove @descriptionNative parameter.
--    - Rename @descriptionEN parameter to @description.
-- <2019-10-10> :
--	- Stored Procedure Changes.
--    - Remove Remove check descrption duplicate.
--
-- [== Example ==]
--
--exec SaveLanguage N'EN', N'US', N'English', 1, 1
--exec SaveLanguage N'JP', N'JA', N'中文', 2, 1
--exec SaveLanguage N'CN', N'ZH', N'中文', 3, 1
-- =============================================
CREATE PROCEDURE [dbo].[SaveLanguage] (
  @langId as nvarchar(3) = null
, @flagId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @sortOrder as int = null
, @enabled as bit = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iDescCnt int = 0;
DECLARE @iSortOrder int = 0;
DECLARE @bEnabled bit = 0;

	-- Error Code:
	--   0 : Success
	-- 101 : Language Id cannot be null or empty string.
	-- 102 : Description cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			EXEC GetErrorMsg 101, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			EXEC GetErrorMsg 102, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLangCnt = COUNT(*)
		  FROM [dbo].[Language]
		 WHERE LOWER(RTRIM(LTRIM([LangId]))) = LOWER(RTRIM(LTRIM(@langId)))

		IF @iLangCnt = 0
		BEGIN
			-- Auto set sort order if required.
			IF (@sortOrder IS NULL)
			BEGIN
				SELECT @iSortOrder = MAX([SortOrder])
				  FROM [dbo].[Language];
				IF (@iSortOrder IS NULL)
				BEGIN
					SET @iSortOrder = 1;
				END
				ELSE
				BEGIN
					SET @iSortOrder = @iSortOrder + 1;
				END
			END
			ELSE
			BEGIN
				SET @iSortOrder = @sortOrder;
			END
			-- Check enabled flag.
			IF (@enabled IS NULL)
			BEGIN
				SET @bEnabled = 0; -- default mode is disabled.
			END
			ELSE
			BEGIN
				SET @bEnabled = @enabled; -- change mode.
			END

			-- INSERT
			INSERT INTO [dbo].[Language]
			(
				  [LangId]
				, [FlagId]
				, [Description]
				, [SortOrder]
				, [Enabled]
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@langId)))
				, COALESCE(UPPER(RTRIM(LTRIM(@flagId))), UPPER(RTRIM(LTRIM(@langId))))
				, RTRIM(LTRIM(@description))
				, @iSortOrder
				, @bEnabled
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE [dbo].[Language]
			   SET [FlagId] =  COALESCE(UPPER(RTRIM(LTRIM(@flagId))), [FlagId])
			     , [Description] = RTRIM(LTRIM(@description))
			     , [SortOrder] = COALESCE(@sortOrder, [SortOrder])
			     , [Enabled] =  COALESCE(@enabled, [Enabled])
			 WHERE LOWER(RTRIM(LTRIM([LangId]))) = LOWER(RTRIM(LTRIM(@langId)));
		END
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DisableLanguage.
-- Description:	Disable Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- Change langId type from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec DisableLanguage N'ES' -- Disable Language.
-- =============================================
CREATE PROCEDURE [dbo].[DisableLanguage]
(
    @langId nvarchar(3) = null
)
AS
BEGIN
    UPDATE [dbo].[Language]
	   SET [ENABLED] = 0
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: EnagleLanguage.
-- Description:	Enable Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- Change langId type from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec EnagleLanguage N'ES' -- Enable Language.
-- =============================================
CREATE PROCEDURE [dbo].[EnableLanguage]
(
    @langId nvarchar(3) = null
)
AS
BEGIN
    UPDATE [dbo].[Language]
	   SET [ENABLED] = 1
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLanguages.
-- Description:	Gets languages.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- The @enabled parameter default value is NULL.
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column FlagId to flagId
-- <2019-08-19> :
--  - Remove DescriptionNative column.
--  - Rename DescriptionEN column to Description.
--
-- [== Example ==]
--
--exec GetLanguages; -- for get all.
--exec GetLanguages 1; -- for only enabled language.
--exec GetLanguages 0; -- for only disabled language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLanguages]
(
    @enabled bit = null
)
AS
BEGIN
    SELECT langId
		 , flagId
		 , Description
		 , SortOrder
		 , Enabled
      FROM [dbo].[LanguageView]
     WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
     ORDER BY SortOrder
END

GO

/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init supports languages
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLanguages
-- =============================================
CREATE PROCEDURE [dbo].[InitLanguages]
AS
BEGIN
    /*
    EXEC SaveLanguage N'', N'', N'', 1, 1
    */
    EXEC SaveLanguage N'EN', N'US', N'English', 1, 1
    EXEC SaveLanguage N'TH', N'TH', N'ไทย', 2, 1
    EXEC SaveLanguage N'ZH', N'CN', N'中文', 3, 1
    EXEC SaveLanguage N'JA', N'JP', N'中文', 4, 1
    EXEC SaveLanguage N'DE', N'DE', N'Deutsche', 5, 0
    EXEC SaveLanguage N'FR', N'FR', N'français', 6, 0
    EXEC SaveLanguage N'KO', N'KR', N'한국어', 7, 1
    EXEC SaveLanguage N'RU', N'RU', N'Россия', 8, 0
    EXEC SaveLanguage N'ES', N'ES', N'Spanish', 9, 1
END

GO

EXEC InitLanguages;

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextMasterPK.
-- Description:	SetMasterPK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2016-11-02> :
--	- Change Size of @prefix from nvarchar(5) to nvarchar(10) due to table MasterPK changed.
--	- Add checks parameter code.
-- <2018-04-16> :
--	- change code(s).
--
-- [== Example ==]
--
--exec SetMasterPK N'Customer', 1, 'EDL', 5
-- =============================================
CREATE PROCEDURE [dbo].[SetMasterPK] (
  @tableName nvarchar(50)
, @seedResetMode int = 1
, @prefix nvarchar(10)
, @seedDigits tinyint
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 201 : Table Name is null or empty string.
	-- 202 : Seed Reset Mode should be number 1-3.
	-- 203 : Seed Digits should be number 1-9.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			EXEC GetErrorMsg 201, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedResetMode is null OR @seedResetMode <= 0 OR @seedResetMode > 3
		BEGIN
			EXEC GetErrorMsg 202, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedDigits is null OR @seedDigits <= 0 OR @seedDigits > 9
		BEGIN
			EXEC GetErrorMsg 203, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM MasterPK
		 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
			INSERT INTO MasterPK(
			        [TableName]
				  , SeedResetMode
				  , LastSeed
				  , [Prefix]
				  , SeedDigits
				  , LastUpdated
				 )
			     VALUES (
				    RTRIM(LTRIM(@tableName))
				  , @seedResetMode
				  , 0
				  , COALESCE(@prefix, N'')
				  , @seedDigits
				  , GETDATE()
				 );
		END
		ELSE
		BEGIN
			UPDATE MasterPK
			   SET [TableName] = RTRIM(LTRIM(@tableName))
			     , SeedResetMode = @seedResetMode
				 , LastSeed = 0
				 , [Prefix] = COALESCE(@prefix, N'')
				 , SeedDigits = @seedDigits
				 , LastUpdated = GETDATE()
			 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)));
		END

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextMasterPK.
-- Description:	NextMasterPK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2016-11-02> :
--	- Change Size of @prefix from nvarchar(5) to nvarchar(10) due to table MasterPK changed.
--	- Add checks parameter code.
-- <2018-04-16> :
--	- change code(s).
--   
-- [== Example ==]
--
-- <Simple>
--exec NextMasterPK N'Customer';
--
-- <Complex>
--declare @seedNo as nvarchar(30);
--declare @errNum as int;
--declare @errMsg as nvarchar(max);
--exec NextMasterPK N'Customer'
--				, @seedNo out
--				, @errNum out
--				, @errMsg out;
--select @seedNo as seedcode
--     , @errNum as ErrNumber
--     , @errMsg as ErrMessage;
--select * from MasterPK;
-- =============================================
CREATE PROCEDURE [dbo].[NextMasterPK] 
(
  @tableName as nvarchar(50)
, @seedcode nvarchar(MAX) = N'' out  -- prefix(max:10) + date(max:10) + seedi(max:10) = 30
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @lastSeedId int;
DECLARE @resetMode tinyint;
DECLARE @prefix nvarchar(10);
DECLARE @seedDigits tinyint;
DECLARE @lastDate datetime;
DECLARE @now datetime;
DECLARE @isSameDate bit;
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 201 : Table name cannot be null or empty string.
	-- 204 : Table name is not exists in MasterPK table.
	-- 205 : Not supports reset mode.
	-- 206 : Cannot generate seed code major cause should be 
	--		 seed reset mode is not supports.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			EXEC GetErrorMsg 201, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM MasterPK
		 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
            EXEC GetErrorMsg 204, @errNum out, @errMsg out
			RETURN;
		END

		SET @now = GETDATE();
		-- for testing
		--SET @now = CONVERT(datetime, '2017-12-03 23:55:11:123', 121);
		SELECT @lastSeedId = LastSeed
			 , @resetMode = SeedResetMode
			 , @prefix = [prefix]
			 , @seedDigits = SeedDigits
			 , @lastDate = LastUpdated
			FROM MasterPK
			WHERE LOWER([TableName]) = LOWER(@tableName)
		-- for testing
		--SELECT @lastDate = CONVERT(datetime, '2016-11-03 23:55:11:123', 121);

		IF @lastSeedId IS NOT NULL OR @lastSeedId >= 0
		BEGIN
			-- format code
			SET @seedcode = @prefix;

			IF @resetMode = 1
			BEGIN
				SELECT @isSameDate = dbo.IsSameDate(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- daily
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(dd, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 2
			BEGIN
				SELECT @isSameDate = dbo.IsSameMonth(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- monthly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 3
			BEGIN
				SELECT @isSameDate = dbo.IsSameYear(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- yearly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE
			BEGIN
				-- not supports
                EXEC GetErrorMsg 205, @errNum out, @errMsg out
				RETURN;
			END

			IF @seedcode IS NOT NULL OR @seedcode <> N''
			BEGIN
				-- update nexvalue and stamp last updated date.
				UPDATE MasterPK
					SET LastSeed = @lastSeedId
					  , LastUpdated = @now
					WHERE LOWER([TableName]) = LOWER(@tableName)
				
				EXEC GetErrorMsg 0, @errNum out, @errMsg out
			END
			ELSE
			BEGIN
                EXEC GetErrorMsg 206, @errNum out, @errMsg out
                SET @errMsg = ' ' + @errMsg + '.'
			END
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetMasterPK.
-- Description:	GetUniquePK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetMasterPK N'Customer'; -- for get match by name
--exec GetMasterPK; -- for get all
-- =============================================
CREATE PROCEDURE [dbo].[GetMasterPK] 
(
  @tableName nvarchar(50) = null
)
AS
BEGIN
	SELECT LastSeed
		 , SeedResetMode
		 , CASE SeedResetMode
			 WHEN 1 THEN N'Daily'
			 WHEN 2 THEN N'Monthly'
			 WHEN 3 THEN N'Yearly'
		   END AS ResetMode
		 , [prefix]
		 , SeedDigits
		 , LastUpdated
		FROM MasterPK
		WHERE LOWER([TableName]) = LOWER(COALESCE(@tableName, [TableName]));
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Default user for EDL and add related reset all generate id for PK.
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Remove Auto Create EDL Admin User. Need to call manually.
--
-- [== Example ==]
--
--exec InitMasterPKs
-- =============================================
CREATE PROCEDURE [dbo].[InitMasterPKs] (
  @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		-- For EDL
		exec SetMasterPK N'UserInfo', 1, 'EDL-U', 3;
		-- For Customer
		exec SetMasterPK N'Customer', 2, 'EDL-C', 4;

		IF (@errNum <> 0)
		BEGIN
			RETURN
		END
		SET @errNum = 0;
		SET @errMsg = N'success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

EXEC InitMasterPKs;

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitErrorMessages.
-- Description:	Init error messages.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-05-10> :
--	- Update new error messages.
-- <2019-10-01> :
--	- Update new error messages.
--
-- [== Example ==]
--
--exec InitErrorMessages
-- =============================================
CREATE PROCEDURE [dbo].[InitErrorMessages]
AS
BEGIN
    -- SUCCESS.
    EXEC SaveErrorMsg 0000, N'Success.'
    -- LANGUAGES.
    EXEC SaveErrorMsg 0101, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0102, N'Description cannot be null or empty string.'
    -- MASTER PK.
    EXEC SaveErrorMsg 0201, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0202, N'Seed Reset Mode should be number 1-3.'
    EXEC SaveErrorMsg 0203, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0204, N'Table name is not exists in MasterPK table.'
    EXEC SaveErrorMsg 0205, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0206, N'Cannot generate seed code for table:'
    -- PERIOD UNITS.
    EXEC SaveErrorMsg 0301, N'PeriodUnit Id cannot be null.'
    EXEC SaveErrorMsg 0302, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0303, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0304, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0305, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0306, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- LIMIT UNITS.
    EXEC SaveErrorMsg 0401, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0402, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0403, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0404, N'UnitText (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0405, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0406, N'Language Id not found.'
    EXEC SaveErrorMsg 0407, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0408, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0409, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- USER INFO(S).
    EXEC SaveErrorMsg 0501, N'FirstName (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0502, N'UserName cannot be null or empty string.'
    EXEC SaveErrorMsg 0503, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 0504, N'User Full Name (default) already exists.'
    EXEC SaveErrorMsg 0505, N'UserName already exists.'
    EXEC SaveErrorMsg 0506, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0507, N'The Language Id not exist.'
    EXEC SaveErrorMsg 0508, N'User Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0509, N'FirstName (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0510, N'No User match UserId.'
    EXEC SaveErrorMsg 0511, N'User Full Name (ML) already exists.'
    -- LICENSE TYPES.
    EXEC SaveErrorMsg 0601, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0602, N'Advertise Text (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0603, N'PeriodUnitId cannot be null.'
    EXEC SaveErrorMsg 0604, N'PeriodUnitId not found.'
    EXEC SaveErrorMsg 0605, N'Number of Period cannot be null.'
    EXEC SaveErrorMsg 0606, N'Price cannot be null.'
    EXEC SaveErrorMsg 0607, N'Cannot add new item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0608, N'Cannot change item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0609, N'Cannot add new item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0610, N'Cannot change item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0611, N'LicenseTypeId cannot be null.'
    EXEC SaveErrorMsg 0612, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0613, N'Language Id not found.'    
    EXEC SaveErrorMsg 0614, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0615, N'Advertise Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0616, N'Price (ML) cannot be null.'
    EXEC SaveErrorMsg 0617, N'Description (ML) is duplicated.'    
    -- LICENSE FEATURES.
    EXEC SaveErrorMsg 0701, N'LicenseType Id cannot be null.'
    EXEC SaveErrorMsg 0702, N'LicenseType Id not found.'
    EXEC SaveErrorMsg 0703, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0704, N'LimitUnit Id not found.'
    EXEC SaveErrorMsg 0705, N'LimitUnit Id already exists.'
    EXEC SaveErrorMsg 0706, N'No Of Limit cannot be null.'
    EXEC SaveErrorMsg 0707, N'No Of Limit should be zero or more.'
    EXEC SaveErrorMsg 0708, N'Invalid Seq Number.' 
    -- CUSTOMER PK.
    EXEC SaveErrorMsg 0801, N'CustomerId is null or empty string.'
    EXEC SaveErrorMsg 0802, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0803, N'Seed Reset Mode should be number 1-4.'
    EXEC SaveErrorMsg 0804, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0805, N'Table Name not exists in CustomerPK table.'
    EXEC SaveErrorMsg 0806, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0807, N'Cannot generate seed code for table:'    
    -- CUSTOMERS.
    EXEC SaveErrorMsg 0901, N'Customer Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0902, N'The Customer Id is not exists.'
    EXEC SaveErrorMsg 0903, N'Customer Name (default) is already exists.'
    EXEC SaveErrorMsg 0904, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0905, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0906, N'Lang Id not found.'
    EXEC SaveErrorMsg 0907, N'Customer Name (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0908, N'Customer Name (ML) is already exist.'
    -- BRANCH.
    EXEC SaveErrorMsg 1001, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1002, N'Branch Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1003, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1004, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1005, N'Branch Name (default) already exists.'
    EXEC SaveErrorMsg 1006, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1007, N'Language Id not exist.'
    EXEC SaveErrorMsg 1008, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1009, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1010, N'Branch Name (ML) is already exists.'
    -- MEMBER INTO(S).
    EXEC SaveErrorMsg 1101, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1102, N'Customer Id not found.'
    EXEC SaveErrorMsg 1103, N'First Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1104, N'User Name cannot be null or empty string.'
    EXEC SaveErrorMsg 1105, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 1106, N'MemberType cannot be null.'
    EXEC SaveErrorMsg 1107, N'MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.'
    EXEC SaveErrorMsg 1108, N'Member Full Name (default) already exists.'
    EXEC SaveErrorMsg 1109, N'User Name already exists.'
    EXEC SaveErrorMsg 1110, N'Member Id is not found.'
    EXEC SaveErrorMsg 1111, N'IDCard is already exists.'
    EXEC SaveErrorMsg 1112, N'Employee Code is already exists.'
    EXEC SaveErrorMsg 1113, N'TagId is already exists.'
    EXEC SaveErrorMsg 1114, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1115, N'Lang Id not exist.'
    EXEC SaveErrorMsg 1116, N'Member Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1117, N'No Member match MemberId in specificed Customer Id.'
    EXEC SaveErrorMsg 1118, N'Member Full Name (ML) already exists.'
    -- ORGS.
    EXEC SaveErrorMsg 1201, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1202, N'Customer Id not found.'
    EXEC SaveErrorMsg 1203, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1204, N'Branch Id not found.'
    EXEC SaveErrorMsg 1205, N'The Root Org already assigned.'
    EXEC SaveErrorMsg 1206, N'The Parent Org Id is not found.'
    EXEC SaveErrorMsg 1207, N'Org Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1208, N'Org Name (default) already exists.'
    EXEC SaveErrorMsg 1209, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1210, N'Lang Id not found.'
    EXEC SaveErrorMsg 1211, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1212, N'Customer Id not found.'
    EXEC SaveErrorMsg 1213, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1214, N'No Org match Org Id in specificed Customer Id.'
    EXEC SaveErrorMsg 1215, N'Org Name (ML) already exists.'
    -- QSETS.
    EXEC SaveErrorMsg 1401, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1402, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1403, N'QSet Id is not found.'
    EXEC SaveErrorMsg 1404, N'QSet is already used in vote table.'
    EXEC SaveErrorMsg 1405, N'Begin Date and/or End Date should not be null.'
    EXEC SaveErrorMsg 1406, N'Display Mode is null or value is not in 0 to 1.'
    EXEC SaveErrorMsg 1407, N'Begin Date should less than End Date.'
    EXEC SaveErrorMsg 1408, N'Begin Date or End Date is overlap with another Question Set.'
    EXEC SaveErrorMsg 1409, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1410, N'Lang Id not found.'
    EXEC SaveErrorMsg 1411, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1412, N'Customer Id not found.'
    EXEC SaveErrorMsg 1413, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1414, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1415, N'Description(ML) already exists.'
    EXEC SaveErrorMsg 1416, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1417, N'Description (default) already exists.'
    EXEC SaveErrorMsg 1418, N'Begin Date or End Date is overlap with another Question Set.'
    -- QSLIDES.
    EXEC SaveErrorMsg 1501, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1502, N'Question Set Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1503, N'Question Text cannot be null or empty string.'
    EXEC SaveErrorMsg 1504, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1505, N'QSetId is not found.'
    EXEC SaveErrorMsg 1506, N'QSeq is not found.'
    EXEC SaveErrorMsg 1507, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1508, N'Lang Id not found.'
    EXEC SaveErrorMsg 1509, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1510, N'Customer Id not found.'
    EXEC SaveErrorMsg 1511, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1512, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1513, N'QSeq is null or less than zero.'
    EXEC SaveErrorMsg 1514, N'No QSlide match QSetId and QSeq.'
    EXEC SaveErrorMsg 1515, N'Question Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 1516, N'Question Text (ML) already exists.'
    -- QSLIDEITEMS.
    EXEC SaveErrorMsg 1601, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1602, N'Question Set Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1603, N'QSeq cannot be null or less than zero.'
    EXEC SaveErrorMsg 1604, N'Question Text cannot be null or empty string.'
    EXEC SaveErrorMsg 1605, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1606, N'QSetId is not found.'
    EXEC SaveErrorMsg 1607, N'QSlide is not found.'
    EXEC SaveErrorMsg 1608, N'QSSeq is not found.'
    EXEC SaveErrorMsg 1609, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1610, N'Lang Id not found.'
    EXEC SaveErrorMsg 1611, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1612, N'Customer Id not found.'
    EXEC SaveErrorMsg 1613, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1614, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1615, N'QSeq is null or less than zero.'
    EXEC SaveErrorMsg 1616, N'No QSlide match QSetId and QSeq.'
    EXEC SaveErrorMsg 1617, N'QSSeq is null or less than zero.'
    EXEC SaveErrorMsg 1618, N'No QSlideItem match QSetId, QSeq and QSSeq.'
    EXEC SaveErrorMsg 1619, N'Question Item Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 1620, N'Question Item Text (ML) already exists.'
    -- VOTES.
    EXEC SaveErrorMsg 1701, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1702, N'Customer Id not found.'
    EXEC SaveErrorMsg 1703, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1704, N'Branch Id not found.'
    EXEC SaveErrorMsg 1705, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1706, N'Org Id not found.'
    EXEC SaveErrorMsg 1707, N'QSet Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1708, N'QSet Id not found.'
    -- REGISTER CUSTOMER.
    EXEC SaveErrorMsg 1801, N'CustomerName cannot be null or empty string.'
    EXEC SaveErrorMsg 1802, N'UserName and Password cannot be null or empty string.'
	EXEC SaveErrorMsg 1803, N'LicenseTypeId cannot be null.'
	EXEC SaveErrorMsg 1804, N'LicenseTypeId not exists.'
    -- SIGNIN.
    EXEC SaveErrorMsg 1901, N'User Name cannot be null or empty string.'
    EXEC SaveErrorMsg 1902, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 1903, N'Cannot found User that match information.'
    EXEC SaveErrorMsg 1904, N''
    -- GET VOTE SUMMARIES.
    EXEC SaveErrorMsg 2001, N'CustomerId cannot be null or empty string.'
    EXEC SaveErrorMsg 2002, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 2003, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 2004, N'The default OrgId not found.'
    EXEC SaveErrorMsg 2005, N'The BranchId not found.'
    -- GET RAW VOTES
    EXEC SaveErrorMsg 2101, N'CustomerId cannot be null or empty string.'
    EXEC SaveErrorMsg 2102, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 2103, N'QSeq cannot be null or less than 1.'
    EXEC SaveErrorMsg 2104, N'Begin Date and End Date cannot be null.'
    EXEC SaveErrorMsg 2105, N'LangId Is Null Or Empty String.'
    -- ERROR MESSAGES
    EXEC SaveErrorMsg 2201, N'Error Code cannot be null or empty string.'
    EXEC SaveErrorMsg 2202, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2203, N'Language Id not found.'
    EXEC SaveErrorMsg 2204, N'Error Message (ML) cannot be null or empty string.'
    -- CLIENTS
    EXEC SaveErrorMsg 2301, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2302, N'Access Id not found.'
    EXEC SaveErrorMsg 2303, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2304, N'Lang Id not found.'
    EXEC SaveErrorMsg 2305, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2306, N'Access Id not found.'
    EXEC SaveErrorMsg 2307, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2308, N'Access Id not found.'
    -- DEVICES
    EXEC SaveErrorMsg 2401, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2402, N'Device Type Id not found.'
    EXEC SaveErrorMsg 2403, N'Device Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 2404, N'Customer Id is not found.'
    EXEC SaveErrorMsg 2405, N'Device Id is not found.'
    EXEC SaveErrorMsg 2406, N'Device Name (default) already exists.'
    EXEC SaveErrorMsg 2407, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2408, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2409, N'Lang Id not exist.'
    EXEC SaveErrorMsg 2410, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2411, N'Device Id is not found.'
    EXEC SaveErrorMsg 2412, N'Device Name (ML) is already exists.'
	-- CHECK LICENSE
	EXEC SaveErrorMsg 2501, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2502, N'Customer Id not exists.'
	EXEC SaveErrorMsg 2503, N'LicenseTypeId cannot be null.'
	EXEC SaveErrorMsg 2504, N'LicenseTypeId not exists.'
	-- SAVE LICENSE HISTORY
	EXEC SaveErrorMsg 2601, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2602, N'Customer Id not exists.'
	EXEC SaveErrorMsg 2603, N'LicenseTypeId cannot be null.'
	EXEC SaveErrorMsg 2604, N'LicenseTypeId not exists.'
	EXEC SaveErrorMsg 2605, N'Request is on processing.'
	EXEC SaveErrorMsg 2606, N'Your Free License is already used.'
	-- REVOKE LICENSE HISTORY
	EXEC SaveErrorMsg 2701, N'History Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2702, N'History Id not exists.'	
	-- EXTEND LICENSE HISTORY
	EXEC SaveErrorMsg 2801, N'History Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2802, N'History Id not exists.'
    EXEC SaveErrorMsg 2803, N'License Still in active state.'
	-- SETUP DEVICE ORG
	EXEC SaveErrorMsg 2901, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2902, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2903, N'Customer Id is not found.'
	EXEC SaveErrorMsg 2904, N'Device Id Not Found.'
    EXEC SaveErrorMsg 2905, N'Org Id is not found.'
	-- SETUP DEVICE USER
	EXEC SaveErrorMsg 3001, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 3002, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 3003, N'Customer Id is not found.'
	EXEC SaveErrorMsg 3004, N'Device Id Not Found.'
    EXEC SaveErrorMsg 3005, N'Member Id is not found.'
    -- DELETE MEMBER INFO
    EXEC SaveErrorMsg 4001, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4002, N'Member Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4003, N'Cannot be remove default admin.'
    -- DELETE BRANCH
    EXEC SaveErrorMsg 4051, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4052, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4103, N'Cannot be remove default branch.'
    -- DELETE ORG
    EXEC SaveErrorMsg 4101, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4102, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4103, N'Cannot be remove default org.'
    -- DELETE QSET
    EXEC SaveErrorMsg 4151, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4152, N'Qset Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4153, N'Cannot be remove qset that already in used.'
    -- DELETE QSLIDE
    EXEC SaveErrorMsg 4201, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4202, N'Qset Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4203, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 4204, N'Cannot be remove qslide that already in used.'
    -- DELETE QSLIDEITEM
    EXEC SaveErrorMsg 4251, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4252, N'Qset Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4253, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 4254, N'QSSeq cannot be null.'
    EXEC SaveErrorMsg 4255, N'Cannot be remove qslideitem that already in used.'
    -- DELETE DEVICE
    EXEC SaveErrorMsg 4301, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4302, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4303, N'Cannot be remove default device.'
    -- DELETE VOTE
    EXEC SaveErrorMsg 4351, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4352, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4353, N'QSet Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4354, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 4355, N'VoteSeq cannot be null.'
    EXEC SaveErrorMsg 4356, N'VoteDate cannot be null.'
    -- Change Customer
    EXEC SaveErrorMsg 4501, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4502, N'Access Id not found.'
    EXEC SaveErrorMsg 4503, N'Customer Id not found.'
    -- Set Access Device
    EXEC SaveErrorMsg 4601, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4602, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4603, N'Access Id not found.'
    EXEC SaveErrorMsg 4604, N'Device Id not found.'
    -- Get QSet By Date
    EXEC SaveErrorMsg 4701, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4702, N'Begin Date is null.'
    EXEC SaveErrorMsg 4703, N'Begin Date should less than End Date.'
    EXEC SaveErrorMsg 4704, N'No QSet Found.'
END

GO

EXEC InitErrorMessages;

GO

