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
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnit.
-- Description:	The Period Unit Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[PeriodUnit](
	[PeriodUnitId] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PeriodUnit] PRIMARY KEY CLUSTERED 
(
	[PeriodUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Description For Period Unit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PeriodUnit', @level2type=N'COLUMN',@level2name=N'Description'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitML.
-- Description:	The Period Unit ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[PeriodUnitML](
	[PeriodUnitId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PeriodUnitML] PRIMARY KEY CLUSTERED 
(
	[PeriodUnitId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Description For Period Unit by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PeriodUnitML', @level2type=N'COLUMN',@level2name=N'Description'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitView.
-- Description:	The Period Unit View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove DescriptionNative column.
--    - Rename DescriptionEN column to Description.
--    - Rename PeriodUnitDescriptionEN column to PeriodUnitDescription.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[PeriodUnitView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , PeriodUnit.PeriodUnitId
		 , PeriodUnit.Description AS PeriodUnitDescription
	  FROM LanguageView CROSS JOIN dbo.PeriodUnit
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitMLView.
-- Description:	The Period Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove PeriodUnitDescriptionNative column.
--    - Rename PeriodUnitDescriptionEN column to PeriodUnitDescription.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[PeriodUnitMLView]
AS
	SELECT PUV.LangId
		 , PUV.PeriodUnitId
		 , CASE 
			WHEN (PUML.Description IS NULL OR LTRIM(RTRIM(PUML.Description)) = '') THEN 
				PUV.PeriodUnitDescription
			ELSE 
				PUML.Description 
		   END AS PeriodUnitDescription
		 , PUV.SortOrder
		 , PUV.Enabled
		FROM dbo.PeriodUnitML AS PUML RIGHT OUTER JOIN PeriodUnitView AS PUV
		  ON (PUML.LangId = PUV.LangId AND PUML.PeriodUnitId = PUV.PeriodUnitId)
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnit.
-- Description:	The Limit Unit Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[LimitUnit](
	[LimitUnitId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[UnitText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LimitUnit] PRIMARY KEY CLUSTERED 
(
	[LimitUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LimitUnitId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The English Description for LimitUnit.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The English limit unit text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'UnitText'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitML.
-- Description:	The Limit Unit ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[LimitUnitML](
	[LimitUnitId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[UnitText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LimitUnitML] PRIMARY KEY CLUSTERED 
(
	[LimitUnitId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LimitUnit Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description by specificed language id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The limit unit text for specificed language id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'UnitText'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitView.
-- Description:	The Limit Unit View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove DescriptionNative column.
--    - Rename DescriptionEN column to Description.
--    - Rename LimitUnitDescriptionEN column to LimitUnitDescription.
--    - Rename LimitUnitTextEN column to LimitUnitText.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , LimitUnit.LimitUnitId
		 , LimitUnit.Description AS LimitUnitDescription
		 , LimitUnit.UnitText AS LimitUnitText
	  FROM LanguageView CROSS JOIN dbo.LimitUnit

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitMLView.
-- Description:	The Limit Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove LimitUnitDescriptionNative column.
--    - Remove LimitUnitTextNative column.
--    - Rename LimitUnitDescriptionEN column to LimitUnitDescription.
--    - Rename LimitUnitTextEN column to LimitUnitText.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitMLView]
AS
	SELECT LUV.LangId
		 , LUV.LimitUnitId
		 , CASE 
			WHEN (LMML.Description IS NULL OR LTRIM(RTRIM(LMML.Description)) = '') THEN 
				LUV.LimitUnitDescription
			ELSE 
				LMML.Description 
		   END AS LimitUnitDescription
		 , CASE 
			WHEN (LMML.UnitText IS NULL OR LTRIM(RTRIM(LMML.UnitText)) = '') THEN 
				LUV.LimitUnitText
			ELSE 
				LMML.UnitText 
		   END AS LimitUnitText
		 , LUV.Enabled
		 , LUV.SortOrder
		FROM dbo.LimitUnitML AS LMML RIGHT OUTER JOIN LimitUnitView AS LUV
		  ON (LMML.LangId = LUV.LangId AND LMML.LimitUnitId = LUV.LimitUnitId)

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MemberType.
-- Description:	The MemberType Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[MemberType](
	[MemberTypeId] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_MemberType] PRIMARY KEY CLUSTERED 
(
	[MemberTypeId] ASC,
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MemberTypeML.
-- Description:	The MemberType ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[MemberTypeML](
	[MemberTypeId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_MemberTypeML] PRIMARY KEY CLUSTERED 
(
	[MemberTypeId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberTypeView]
AS
    SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , MemberType.MemberTypeId
		 , MemberType.Description AS MemberTypeDescription
    FROM LanguageView CROSS JOIN dbo.MemberType

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberTypeMLView]
AS
    SELECT MTV.LangId
		 , MTV.MemberTypeId
		 , CASE 
			WHEN (MTML.Description IS NULL OR LTRIM(RTRIM(MTML.Description)) = '') THEN 
				MTV.MemberTypeDescription
			ELSE 
				MTML.Description 
		   END AS MemberTypeDescription
		 , MTV.Enabled
		 , MTV.SortOrder
    FROM dbo.MemberTypeML AS MTML RIGHT OUTER JOIN MemberTypeView AS MTV
        ON (MTML.LangId = MTV.LangId AND MTML.MemberTypeId = MTV.MemberTypeId)

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DeviceType](
	[DeviceTypeId] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DeviceType] PRIMARY KEY CLUSTERED 
(
	[DeviceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Device Type Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceType', @level2type=N'COLUMN',@level2name=N'DeviceTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The device description (default).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceType', @level2type=N'COLUMN',@level2name=N'Description'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DeviceTypeML](
	[DeviceTypeId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DeviceTypeML] PRIMARY KEY CLUSTERED 
(
	[DeviceTypeId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Device Type Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceTypeML', @level2type=N'COLUMN',@level2name=N'DeviceTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceTypeML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The device description (ML).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceTypeML', @level2type=N'COLUMN',@level2name=N'Description'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceTypeView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , DeviceType.DeviceTypeId
	     , DeviceType.Description
	  FROM LanguageView CROSS JOIN dbo.DeviceType
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceTypeMLView]
AS
	SELECT DTV.LangId
	     , DTV.DeviceTypeId
		 , CASE 
			WHEN (DTML.Description IS NULL OR LTRIM(RTRIM(DTML.Description)) = '') THEN 
				DTV.Description
			ELSE 
				DTML.Description 
		   END AS Description
	     , DTV.Enabled
	     , DTV.SortOrder
		FROM dbo.DeviceTypeML AS DTML RIGHT OUTER JOIN DeviceTypeView AS DTV
		  ON (    DTML.LangId = DTV.LangId 
		      AND DTML.DeviceTypeId = DTV.DeviceTypeId
			 )
GO

/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseType](
	[LicenseTypeId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[AdText] [nvarchar](max) NOT NULL,
	[PeriodUnitId] [int] NOT NULL,
	[NumberOfUnit] [int] NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[CurrencySymbol] [nvarchar](5) NOT NULL,
	[CurrencyText] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_LicenseType_1] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_PeriodDays]  DEFAULT ((30)) FOR [NumberOfUnit]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_Price]  DEFAULT ((0.00)) FOR [Price]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_CurrencySymbol]  DEFAULT (N'$') FOR [CurrencySymbol]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_CurrencyEN]  DEFAULT (N'USD') FOR [CurrencyText]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Advertise Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'AdText'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The period unit id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'PeriodUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default number of period unit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'NumberOfUnit'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Currency Symbol' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'CurrencySymbol'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Currency Unit Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'CurrencyText'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseTypeML](
	[LicenseTypeId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[AdText] [nvarchar](max) NULL,
	[Price] [decimal](18, 2) NULL,
	[CurrencySymbol] [nvarchar](5) NULL,
	[CurrencyText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LicenseTypeML] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseTypeML] ADD  CONSTRAINT [DF_LicenseTypeML_CurrencySymbol]  DEFAULT (N'$') FOR [CurrencySymbol]
GO

ALTER TABLE [dbo].[LicenseTypeML] ADD  CONSTRAINT [DF_LicenseTypeML_CurrencyText]  DEFAULT (N'USD') FOR [CurrencyText]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Currency Symbol' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'CurrencySymbol'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Currency Unit Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'CurrencyText'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseTypeView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , LicenseType.LicenseTypeId
	     , LicenseType.Description AS LicenseTypeDescription
	     , LicenseType.AdText AS AdText
	     , LicenseType.PeriodUnitId
	     , LicenseType.NumberOfUnit
	     , LicenseType.Price
		 , LicenseType.CurrencySymbol
		 , LicenseType.CurrencyText
	  FROM LanguageView CROSS JOIN dbo.LicenseType

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseTypeMLView]
AS
	SELECT LTV.LangId
		 , LTV.LicenseTypeId
		 , CASE WHEN (LTML.Description IS NULL OR LTRIM(RTRIM(LTML.Description)) = '') 
		 	THEN
				LTV.LicenseTypeDescription
			ELSE 
				LTML.Description
		  END AS LicenseTypeDescription
		 , CASE 
			WHEN (LTML.AdText IS NULL OR LTRIM(RTRIM(LTML.AdText)) = '') 
			THEN
				LTV.AdText
			ELSE 
				LTML.AdText
		  END AS AdText
		 , LTV.PeriodUnitId
		 , LTV.NumberOfUnit
		 , CASE 
			WHEN LTML.Price IS NULL 
			THEN CONVERT(bit, 1)
			ELSE CONVERT(bit, 0) 
		  END AS UseDefaultPrice
		 , CASE WHEN LTML.Price IS NULL 
			THEN
				LTV.Price
			ELSE
				LTML.Price
		  END AS Price
			, CASE WHEN (LTML.CurrencySymbol IS NULL OR LTRIM(RTRIM(LTML.CurrencySymbol)) = '') 
			 THEN
			 	LTV.CurrencySymbol
			 ELSE
			 	LTML.CurrencySymbol
			 END AS CurrencySymbol
			, CASE WHEN (LTML.CurrencyText IS NULL OR LTRIM(RTRIM(LTML.CurrencyText)) = '')
			 THEN
			 	LTV.CurrencyText
			 ELSE
			 	LTML.CurrencyText
			 END AS CurrencyText
		 , LTV.Enabled
		 , LTV.SortOrder
		FROM dbo.LicenseTypeML AS LTML RIGHT OUTER JOIN LicenseTypeView AS LTV
		  ON (LTML.LangId = LTV.LangId AND LTML.LicenseTypeId = LTV.LicenseTypeId)

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseFeature](
	[LicenseTypeId] [int] NOT NULL,
	[Seq] [int] NOT NULL,
	[LimitUnitId] [int] NOT NULL,
	[NoOfLimit] [int] NOT NULL,
 CONSTRAINT [PK_LicenseFeature] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC,
	[Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseFeature] ADD  CONSTRAINT [DF_LicenseFeature_NoOfLimit]  DEFAULT ((0)) FOR [NoOfLimit]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LicenseTypeId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'LicenseTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Feature Sequence.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'Seq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Limit Unit Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Limit Unit (<= 0 = Unlimited).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'NoOfLimit'
GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseFeatureMLView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
	     , LF.LicenseTypeId
	     , LF.Seq
		 , LF.LimitUnitId
		 , LF.LimitUnitDescription
		 , LF.NoOfLimit
		 , LF.LimitUnitText
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	  FROM LanguageView RIGHT OUTER JOIN 
	  (
	    SELECT dbo.LimitUnitMLView.LangId
			 , dbo.LicenseFeature.*
		     , dbo.LimitUnitMLView.LimitUnitDescription
		     , dbo.LimitUnitMLView.LimitUnitText
		  FROM dbo.LicenseFeature, dbo.LimitUnitMLView
		 WHERE dbo.LicenseFeature.LimitUnitId = dbo.LimitUnitMLView.LimitUnitId
	  ) AS LF ON (LanguageView.LangId = LF.LangId)

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseMLView]
AS
	SELECT LTMLV.LangId
		  ,LTMLV.LicenseTypeId
		  ,LFMLV.Seq
		  ,LTMLV.LicenseTypeDescription
		  ,LTMLV.AdText
		  ,LTMLV.PeriodUnitId
		  ,LTMLV.NumberOfUnit
		  ,LTMLV.UseDefaultPrice
		  ,LTMLV.Price
		  ,LTMLV.CurrencySymbol
		  ,LTMLV.CurrencyText
		  ,LFMLV.LimitUnitId
		  ,LFMLV.NoOfLimit
		  ,LFMLV.LimitUnitText
		  ,LFMLV.LimitUnitDescription
		  ,LTMLV.Enabled
		  ,LTMLV.SortOrder
	  FROM LicenseTypeMLView LTMLV LEFT JOIN
		(
		 SELECT * 
		   FROM LicenseFeatureMLView LFMLV
		) AS LFMLV ON (
		      LFMLV.LangId = LTMLV.LangId
		  AND LFMLV.LicenseTypeId = LTMLV.LicenseTypeId
		)
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
-- Name: SavePeriodUnit.
-- Description:	Save PeriodUnit.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
-- <2019-08-19> :
--	- Rename @descriptionEN parameter to @description
--
-- [== Example ==]
--
--exec SavePeriodUnit 4, N'quarter'
-- =============================================
CREATE PROCEDURE [dbo].[SavePeriodUnit] (
  @periodUnitId as int = null
, @description as nvarchar(50) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iPeriodCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 301 : PeriodUnit Id cannot be null.
	-- 302 : Description (default) cannot be null or empty string.
	-- 303 : Description (default) is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@periodUnitId IS NULL)
		BEGIN
            EXEC GetErrorMsg 301, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
            EXEC GetErrorMsg 302, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iPeriodCnt = COUNT(*)
		  FROM PeriodUnit
		 WHERE PeriodUnitId = @periodUnitId

		IF (@iPeriodCnt = 0)
		BEGIN
			-- Detected PeriodUnit not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnit
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iDescCnt <> 0)
			BEGIN
                EXEC GetErrorMsg 303, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iPeriodCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO PeriodUnit
			(
				  [PeriodUnitId]
				, [Description]
			)
			VALUES
			(
				  @periodUnitId
				, RTRIM(LTRIM(@description))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE PeriodUnit
			   SET [Description] = RTRIM(LTRIM(@description))
			 WHERE [PeriodUnitId] = @periodUnitId;
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
-- Name: SavePeriodUnitML.
-- Description:	Save PeriodUnit ML.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SavePeriodUnitML 4, N'EN', N'quarter'
--exec SavePeriodUnitML 4, N'TH', N'ไตรมาส'
-- =============================================
CREATE PROCEDURE [dbo].[SavePeriodUnitML] (
  @periodUnitId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iPeriodCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 101 : Language Id cannot be null or empty string.
	-- 104 : Language Id not found.
	-- 301 : PeriodUnit Id cannot be null.
	-- 304 : Description (ML) cannot be null or empty string.
	-- 305 : Cannot add new Description (ML) that already exists.
	-- 306 : Cannot change Description (ML) that alreadt exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@periodUnitId IS NULL)
		BEGIN
			-- Check Null Or Empty Period Unit Id.
            EXEC GetErrorMsg 301, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Check Null Or Empty Language Id.
            EXEC GetErrorMsg 101, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
			-- Language not found.
            EXEC GetErrorMsg 104, @errNum out, @errMsg out
			RETURN
		END
		
		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Check Null Or Empty description.
            EXEC GetErrorMsg 304, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iPeriodCnt = COUNT(*)
		  FROM PeriodUnitML
		 WHERE PeriodUnitId = @periodUnitId
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iPeriodCnt = 0)
		BEGIN
			-- Detected data not exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnitML
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 305, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			-- Detected data is exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnitML
				WHERE PeriodUnitId <> @periodUnitId
				  AND UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 306, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iPeriodCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO PeriodUnitML
			(
				  [PeriodUnitId]
				, [LangId]
				, [Description]
			)
			VALUES
			(
				  @periodUnitId
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE PeriodUnitML
			   SET [Description] = RTRIM(LTRIM(@description))
			 WHERE [PeriodUnitId] = @periodUnitId
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
-- Name: GetPeriodUnits.
-- Description:	Get Period Units.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column PeriodUnitId to periodUnitId
-- <2019-08-19> :
--	- Remove PeriodUnitDescriptionNative column.
--	- Rename PeriodUnitDescriptionEN column to PeriodUnitDescription.
--
-- [== Example ==]
--
--exec GetPeriodUnits NULL, 1;  -- for only enabled languages.
--exec GetPeriodUnits;          -- for get all.
--exec GetPeriodUnits N'EN';    -- for get PeriodUnit for EN language.
-- =============================================
CREATE PROCEDURE [dbo].[GetPeriodUnits] 
(
  @langId nvarchar(3) = NULL
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
	 ORDER BY SortOrder, PeriodUnitId
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Init Period Units.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- replace insert with sp call.
--
-- [== Example ==]
--
--exec InitPeriodUnits
-- =============================================
CREATE PROCEDURE [dbo].[InitPeriodUnits]
AS
BEGIN
    EXEC SavePeriodUnit 1, N'day'
    EXEC SavePeriodUnit 2, N'month'
    EXEC SavePeriodUnit 3, N'year'

	-- [ENGLISH]
    EXEC SavePeriodUnitML 1, N'EN', N'day'
    EXEC SavePeriodUnitML 2, N'EN', N'month'
    EXEC SavePeriodUnitML 3, N'EN', N'year'
	-- [THAI]
    EXEC SavePeriodUnitML 1, N'TH', N'วัน'
    EXEC SavePeriodUnitML 2, N'TH', N'เดือน'
    EXEC SavePeriodUnitML 3, N'TH', N'ปี'
	-- [CHINESE]
	EXEC SavePeriodUnitML 1, N'ZH', N'天'
	EXEC SavePeriodUnitML 2, N'ZH', N'月'
	EXEC SavePeriodUnitML 3, N'ZH', N'年'
	-- [JAPANESE]
	EXEC SavePeriodUnitML 1, N'JA', N'日'
	EXEC SavePeriodUnitML 2, N'JA', N'月'
	EXEC SavePeriodUnitML 3, N'JA', N'年'
	-- [GERMAN]
	EXEC SavePeriodUnitML 1, N'DE', N'Tag'
	EXEC SavePeriodUnitML 2, N'DE', N'Monat'
	EXEC SavePeriodUnitML 3, N'DE', N'Jahr'
	-- [FRENCH]
	EXEC SavePeriodUnitML 1, N'FR', N'jour'
	EXEC SavePeriodUnitML 2, N'FR', N'mois'
	EXEC SavePeriodUnitML 3, N'FR', N'an'
	-- [KOREAN]
	EXEC SavePeriodUnitML 1, N'KO', N'일'
	EXEC SavePeriodUnitML 2, N'KO', N'달'
	EXEC SavePeriodUnitML 3, N'KO', N'년'
END

GO

EXEC InitPeriodUnits;

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLimitUnit.
-- Description:	Save Limit Unit.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
-- <2019-08-19> :
--	- Rename @descriptionEN parameter to @description
--	- Rename @unitTextEN parameter to @unitText
--
-- [== Example ==]
--
--exec SaveLimitUnit 4, N'Number Of Connection', N'connection(s)'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLimitUnit] (
  @limitUnitId as int = null
, @description as nvarchar(50) = null
, @unitText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLimitCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 401 : LimitUnit Id cannot be null.
	-- 402 : Description (default) cannot be null or empty string.
	-- 403 : Description (default) is duplicated.
	-- 404 : UnitText (default) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@limitUnitId IS NULL)
		BEGIN
            EXEC GetErrorMsg 401, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
            EXEC GetErrorMsg 402, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLimitCnt = COUNT(*)
		  FROM LimitUnit
		 WHERE LimitUnitId = @limitUnitId

		IF (@iLimitCnt = 0)
		BEGIN
			-- Detected PeriodUnit not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnit
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iDescCnt <> 0)
			BEGIN
                EXEC GetErrorMsg 403, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@unitText) = 1)
		BEGIN
            EXEC GetErrorMsg 404, @errNum out, @errMsg out
			RETURN
		END

		IF @iLimitCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO LimitUnit
			(
				  [LimitUnitId]
				, [Description]
				, [UnitText]
			)
			VALUES
			(
				  @limitUnitId
				, RTRIM(LTRIM(@description))
				, RTRIM(LTRIM(@unitText))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE LimitUnit
			   SET [Description] = RTRIM(LTRIM(@description))
			     , [UnitText] = RTRIM(LTRIM(COALESCE(@unitText, [UnitText])))
			 WHERE [LimitUnitId] = @limitUnitId;
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
-- Name: SaveLimitUnitML.
-- Description:	Save LimitUnit ML.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLimitUnitML 4, N'EN', N'Number Of Connection', N'connection(s)'
--exec SaveLimitUnitML 4, N'TH', N'จำนวนการเชื่อมต่อ', N'จุด'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLimitUnitML] (
  @limitUnitId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @unitText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iLimitCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 401 : LimitUnit Id cannot be null.
	-- 405 : Language Id cannot be null or empty string.
	-- 406 : Language Id not found.
	-- 407 : Description (ML) cannot be null or empty string.
	-- 408 : Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
	-- 409 : Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@limitUnitId IS NULL)
		BEGIN
            -- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 401, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
            -- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 405, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
            -- Language Id not found.
            EXEC GetErrorMsg 406, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
            -- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 407, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLimitCnt = COUNT(*)
		  FROM LimitUnitML
		 WHERE LimitUnitId = @limitUnitId
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iLimitCnt = 0)
		BEGIN
			-- Detected data not exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnitML
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 408, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			-- Detected data is exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnitML
				WHERE LimitUnitId <> @limitUnitId
				  AND UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 409, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iLimitCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO LimitUnitML
			(
				  [LimitUnitId]
				, [LangId]
				, [Description]
				, [UnitText]
			)
			VALUES
			(
				  @limitUnitId
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
				, RTRIM(LTRIM(@unitText))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE LimitUnitML
			   SET [Description] = RTRIM(LTRIM(@description))
			     , [UnitText] = RTRIM(LTRIM(COALESCE(@unitText, [UnitText])))
			 WHERE [LimitUnitId] = @limitUnitId
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
-- Description:	GetLimitUnits
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LimitUnitId to limitUnitId
-- <2019-08-19> :
--	- Remove LimitUnitDescriptionNative column.
--	- Remove LimitUnitTextNative column.
--	- Rename LimitUnitDescriptionEN column to LimitUnitDescriptionNative.
--	- Rename LimitUnitTextNativeEN column to LimitUnitTextNative.
--
-- [== Example ==]
--
--exec GetLimitUnits NULL, 1;  -- for only enabled languages.
--exec GetLimitUnits;          -- for get all.
--exec GetLimitUnits N'EN';    -- for get LimitUnit for EN language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLimitUnits] 
(
  @langId nvarchar(3) = NULL
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
	 ORDER BY SortOrder, LimitUnitId
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Init Limit Units.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- replace insert with sp call.
--
-- [== Example ==]
--
--exec InitLimitUnits
-- =============================================
CREATE PROCEDURE [dbo].[InitLimitUnits]
AS
BEGIN
	/* DEFAULT LIMIT UNITS. */
    EXEC SaveLimitUnit 1, N'Number of Device(s)', N'device(s)'
    EXEC SaveLimitUnit 2, N'Number of User(s)', N'user(s)'
    EXEC SaveLimitUnit 3, N'Number of Client(s)', N'client(s)'

	/* [== ENGLISH ==] */
	EXEC SaveLimitUnitML 1, N'EN', N'Number of Device(s)', N'device(s)'
	EXEC SaveLimitUnitML 2, N'EN', N'Number of User(s)', N'user(s)'
	EXEC SaveLimitUnitML 3, N'EN', N'Number of Client(s)', N'client(s)'
	/* [== THAI ==] */
	EXEC SaveLimitUnitML 1, N'TH', N'จำนวนเครื่อง', N'เครื่อง'
	EXEC SaveLimitUnitML 2, N'TH', N'จำนวนบัญชีผู้ใช้', N'คน'
	EXEC SaveLimitUnitML 3, N'TH', N'จำนวนจุดติดตั้ง', N'จุด'
	/* [== JAPANESE ==] */
	EXEC SaveLimitUnitML 1, N'JA', N'番号', N'デバイス'
	EXEC SaveLimitUnitML 2, N'JA', N'ユーザー数', N'人'
	EXEC SaveLimitUnitML 3, N'JA', N'同時ユーザー', N'ポイント'
END

GO

EXEC InitLimitUnits;

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberTypes
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column MemberTypeId to memberTypeId
-- <2019-08-19> :
--	- Remove MemberTypeDescriptionNavive column.
--	- Rename MemberTypeDescriptionEN column to MemberTypeDescription.
--
-- [== Example ==]
--
--exec GetMemberTypes NULL, 1;  -- for only enabled languages.
--exec GetMemberTypes;          -- for get all.
--exec GetMemberTypes N'EN';    -- for get MemberType for EN language.
--exec GetMemberTypes N'TH';    -- for get MemberType for TH language.
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberTypes] 
(
  @langId nvarchar(3) = NULL
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
	 ORDER BY SortOrder, MemberTypeId
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Member Types.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitMemberTypesS
-- =============================================
CREATE PROCEDURE [dbo].[InitMemberTypes]
AS
BEGIN
    DELETE FROM MemberTypeML;
    DELETE FROM MemberType;

	-- [EDL - ADMIN]
	INSERT INTO MemberType VALUES (100, N'EDL - Admin')
	-- [EDL - POWER USER]
	INSERT INTO MemberType VALUES (110, N'EDL - Power User')
	-- [EDL - STAFF]
	INSERT INTO MemberType VALUES (180, N'EDL - Staff')
	-- [CUSTOMER - ADMIN]
	INSERT INTO MemberType VALUES (200, N'Admin')
	-- [CUSTOMER - EXCLUSIVE]
	INSERT INTO MemberType VALUES (210, N'Exclusive')
	-- [CUSTOMER - STAFF]
	INSERT INTO MemberType VALUES (280, N'Staff')
	-- [CUSTOMER - DEVICE]
	INSERT INTO MemberType VALUES (290, N'Device')

	-- [ENGLISH]
	INSERT INTO MemberTypeML VALUES(100, N'EN', N'EDL - Admin');
	INSERT INTO MemberTypeML VALUES(110, N'EN', N'EDL - Power User');
	INSERT INTO MemberTypeML VALUES(180, N'EN', N'EDL - Staff');
	INSERT INTO MemberTypeML VALUES(200, N'EN', N'Admin');
	INSERT INTO MemberTypeML VALUES(210, N'EN', N'Exclusive');
	INSERT INTO MemberTypeML VALUES(280, N'EN', N'Staff');
	INSERT INTO MemberTypeML VALUES(290, N'EN', N'Device');
	-- [THAI]
	INSERT INTO MemberTypeML VALUES(100, N'TH', N'อีดีแอล - ผู้ดูแลระบบ');
	INSERT INTO MemberTypeML VALUES(110, N'TH', N'อีดีแอล - เจ้าหน้าที่ระดับควบคุม');
	INSERT INTO MemberTypeML VALUES(180, N'TH', N'อีดีแอล - เจ้าหน้าที่ปฏิบัติการ');
	INSERT INTO MemberTypeML VALUES(200, N'TH', N'ผู้ดูแลระบบ');
	INSERT INTO MemberTypeML VALUES(210, N'TH', N'ผู้บริหาร');
	INSERT INTO MemberTypeML VALUES(280, N'TH', N'เจ้าหน้าที่ปฏิบัติการ');
	INSERT INTO MemberTypeML VALUES(290, N'TH', N'อุปกรณ์');
	-- [CHINESE]
	INSERT INTO MemberTypeML VALUES(100, N'ZH', N'EDL - 管理员');
	INSERT INTO MemberTypeML VALUES(110, N'ZH', N'EDL - 管理者');
	INSERT INTO MemberTypeML VALUES(180, N'ZH', N'EDL - 员工');
	INSERT INTO MemberTypeML VALUES(200, N'ZH', N'管理员');
	INSERT INTO MemberTypeML VALUES(210, N'ZH', N'管理者');
	INSERT INTO MemberTypeML VALUES(280, N'ZH', N'员工');
	INSERT INTO MemberTypeML VALUES(290, N'ZH', N'设备');
	-- [JAPANESE]
	INSERT INTO MemberTypeML VALUES(100, N'JA', N'EDL - 支配人');
	INSERT INTO MemberTypeML VALUES(110, N'JA', N'EDL - 監督');
	INSERT INTO MemberTypeML VALUES(180, N'JA', N'EDL - 職員');
	INSERT INTO MemberTypeML VALUES(200, N'JA', N'支配人');
	INSERT INTO MemberTypeML VALUES(210, N'JA', N'監督');
	INSERT INTO MemberTypeML VALUES(280, N'JA', N'職員');
	INSERT INTO MemberTypeML VALUES(290, N'JA', N'デバイス');
	-- [GERMAN]
	INSERT INTO MemberTypeML VALUES(100, N'DE', N'EDL - Administrator');
	INSERT INTO MemberTypeML VALUES(110, N'DE', N'EDL - Aufsicht');
	INSERT INTO MemberTypeML VALUES(180, N'DE', N'EDL - Belegschaft');
	INSERT INTO MemberTypeML VALUES(200, N'DE', N'Administrator');
	INSERT INTO MemberTypeML VALUES(210, N'DE', N'Exklusiv');
	INSERT INTO MemberTypeML VALUES(280, N'DE', N'Belegschaft');
	INSERT INTO MemberTypeML VALUES(290, N'DE', N'Device');
	-- [FRENCH]
	INSERT INTO MemberTypeML VALUES(100, N'FR', N'EDL - Administrateur');
	INSERT INTO MemberTypeML VALUES(110, N'FR', N'EDL - Superviseur');
	INSERT INTO MemberTypeML VALUES(180, N'FR', N'EDL - Personnel');
	INSERT INTO MemberTypeML VALUES(200, N'FR', N'Administrateur');
	INSERT INTO MemberTypeML VALUES(210, N'FR', N'Exclusif');
	INSERT INTO MemberTypeML VALUES(280, N'FR', N'Personnel');
	INSERT INTO MemberTypeML VALUES(290, N'FR', N'Appareil');
	-- [KOREAN]
	INSERT INTO MemberTypeML VALUES(100, N'KO', N'EDL - 관리자');
	INSERT INTO MemberTypeML VALUES(110, N'KO', N'EDL - 감독자');
	INSERT INTO MemberTypeML VALUES(180, N'KO', N'EDL - 직원');
	INSERT INTO MemberTypeML VALUES(200, N'KO', N'관리자');
	INSERT INTO MemberTypeML VALUES(210, N'KO', N'감독자');
	INSERT INTO MemberTypeML VALUES(280, N'KO', N'직원');
	INSERT INTO MemberTypeML VALUES(290, N'KO', N'장치');
END

GO

EXEC InitMemberTypes;

GO


/*********** Script Update Date: 2020-03-26  ***********/
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
--
-- [== Example ==]
--
--exec GetDeviceTypes N'EN';
--exec GetDeviceTypes N'TH';
--exec GetDeviceTypes N'TH', 0;
--exec GetDeviceTypes N'TH', 101
-- =============================================
CREATE PROCEDURE [dbo].[GetDeviceTypes]
(
  @langId nvarchar(3) = NULL
, @deviceTypeId int = NULL
)
AS
BEGIN
    SELECT langId
		 , deviceTypeId
		 , Description as Type
		 , SortOrder
		 , Enabled
    FROM DeviceTypeMLView
    WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
        AND UPPER(LTRIM(RTRIM(DeviceTypeId))) = UPPER(LTRIM(RTRIM(COALESCE(@deviceTypeId, DeviceTypeId))))
    ORDER BY SortOrder, LangId, deviceTypeId;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Device Types.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitDeviceTypes
-- =============================================
CREATE PROCEDURE [dbo].[InitDeviceTypes]
AS
BEGIN
	--DELETE FROM DeviceTypeML;
	--DELETE FROM DeviceType;

	-- Unknown
	INSERT INTO DeviceType VALUES (0, N'Unknown')
	-- Browser desktop - Chrome
	INSERT INTO DeviceType VALUES (101, N'Chrome desktop browser')
	-- Browser desktop - IE-Edge
	INSERT INTO DeviceType VALUES (102, N'IE-Edge desktop browser')
	-- Browser desktop - FireFox
	INSERT INTO DeviceType VALUES (103, N'FireFox desktop browser')
	-- Browser desktop - Opera
	INSERT INTO DeviceType VALUES (104, N'Opera desktop browser')
	-- Browser desktop - Safari
	INSERT INTO DeviceType VALUES (105, N'Safari desktop browser')
	-- Browser Mobile - Chrome
	INSERT INTO DeviceType VALUES (201, N'Chrome mobile browser')
	-- Browser Mobile - Andriod
	INSERT INTO DeviceType VALUES (202, N'Andriod mobile browser')
	-- Browser Mobile - FireFox
	INSERT INTO DeviceType VALUES (203, N'FireFox mobile browser')
	-- Browser Mobile - Opera
	INSERT INTO DeviceType VALUES (204, N'Opera mobile browser')
	-- Browser Mobile - Safari
	INSERT INTO DeviceType VALUES (205, N'Safari mobile browser')
	-- Browser Mobile - Safari
	INSERT INTO DeviceType VALUES (206, N'Edge mobile browser')

	-- [ENGLISH]
	INSERT INTO DeviceTypeML VALUES(  0, N'EN', N'Unknown');
	INSERT INTO DeviceTypeML VALUES(101, N'EN', N'Chrome desktop browser');
	INSERT INTO DeviceTypeML VALUES(102, N'EN', N'IE-Edge desktop browser');
	INSERT INTO DeviceTypeML VALUES(103, N'EN', N'FireFox desktop browser');
	INSERT INTO DeviceTypeML VALUES(104, N'EN', N'Opera desktop browser');
	INSERT INTO DeviceTypeML VALUES(105, N'EN', N'Safari desktop browser');
	INSERT INTO DeviceTypeML VALUES(201, N'EN', N'Chrome mobile browser');
	INSERT INTO DeviceTypeML VALUES(202, N'EN', N'Andriod mobile browser');
	INSERT INTO DeviceTypeML VALUES(203, N'EN', N'FireFox mobile browser');
	INSERT INTO DeviceTypeML VALUES(204, N'EN', N'Opera mobile browser');
	INSERT INTO DeviceTypeML VALUES(205, N'EN', N'Safari mobile browser');
	INSERT INTO DeviceTypeML VALUES(206, N'EN', N'Edge mobile browser');
	-- [THAI]
	INSERT INTO DeviceTypeML VALUES(  0, N'TH', N'ไม่ระบุ');
	INSERT INTO DeviceTypeML VALUES(101, N'TH', N'โคลม เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(102, N'TH', N'ไออี-เอจ เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(103, N'TH', N'ไฟร์ฟอกซ์ เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(104, N'TH', N'โอเปร่า เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(105, N'TH', N'ซาฟารี เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(201, N'TH', N'โคลม โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(202, N'TH', N'แอนดรอยด์ โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(203, N'TH', N'ไฟร์ฟอกซ์ โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(204, N'TH', N'โอเปร่า โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(205, N'TH', N'ซาฟารี โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(206, N'TH', N'เอจ โมบาย เบราว์เซอร์');
END

GO

EXEC InitDeviceTypes;

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseType.
-- Description:	Save License Type.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLicenseType N'3 Months', N'Save 40%', 2, 3, 50000, N'$', N'USD'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseType] (
  @description as nvarchar(100) = null
, @adText as nvarchar(MAX) = null
, @periodUnitId as int = null
, @numberOfUnit as int = null
, @price as decimal(18, 2) = null
, @currSymbol as nvarchar(5)
, @currText as nvarchar(20)
, @licenseTypeId as int = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @vlicenseTypeId int;
DECLARE @iCnt int;
	-- Error Code:
	--   0 : Success
	-- 601 : Description (default) cannot be null or empty string.
	-- 602 : Advertise Text (default) cannot be null or empty string.
	-- 603 : PeriodUnitId cannot be null.
	-- 604 : PeriodUnitId not found.
	-- 605 : Number of Period cannot be null.
	-- 606 : Price cannot be null.
	-- 607 : Cannot add new item description because the description (default) is duplicated.
	-- 608 : Cannot change item description because the description (default) is duplicated.
	-- 609 : Cannot add new item because the period and number of period is duplicated.
    -- 610 : Cannot change item because the period and number of period is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (default) cannot be null or empty string.
            EXEC GetErrorMsg 601, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@adText) = 1)
		BEGIN
			-- Advertise Text (default) cannot be null or empty string.
            EXEC GetErrorMsg 602, @errNum out, @errMsg out
			RETURN
		END

		IF (@periodUnitId IS NULL)
		BEGIN
			-- PeriodUnitId cannot be null.
            EXEC GetErrorMsg 603, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM PeriodUnit
		 WHERE PeriodUnitId = @periodUnitId;
		IF (@iCnt = 0)
		BEGIN
			-- PeriodUnitId not found.
            EXEC GetErrorMsg 604, @errNum out, @errMsg out
			RETURN
		END

		IF (@numberOfUnit IS NULL)
		BEGIN
			-- Number of Period cannot be null.
            EXEC GetErrorMsg 605, @errNum out, @errMsg out
			RETURN
		END

		IF (@price IS NULL)
		BEGIN
			-- Price cannot be null.
            EXEC GetErrorMsg 606, @errNum out, @errMsg out
			RETURN
		END

		IF (@licenseTypeId IS NULL)
		BEGIN
			-- Detected Data not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iCnt <> 0)
			BEGIN
				-- Cannot add new item description because the description (default) is duplicated.
                EXEC GetErrorMsg 607, @errNum out, @errMsg out
				RETURN
			END
			/*
			-- Check is PeriodUnitId and NumberOfUnit is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE PeriodUnitId = @periodUnitId
			   AND NumberOfUnit = @numberOfUnit;

			IF (@iCnt >= 1)
			BEGIN
				-- Cannot add new item because the period and number of period is duplicated.
                EXEC GetErrorMsg 609, @errNum out, @errMsg out
				RETURN
			END
			*/
		END
		ELSE
		BEGIN
			-- Detected Data is exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS
			   AND LicenseTypeId <> @licenseTypeId;

			IF (@iCnt <> 0)
			BEGIN
				-- Cannot change item description because the description (default) is duplicated.
                EXEC GetErrorMsg 608, @errNum out, @errMsg out
				RETURN
			END
			/*
			-- Check is PeriodUnitId and NumberOfUnit is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE PeriodUnitId = @periodUnitId
			   AND NumberOfUnit = @numberOfUnit
			   AND LicenseTypeId <> @licenseTypeId;

			IF (@iCnt >= 1)
			BEGIN
				-- Cannot change item because the period and number of period is duplicated.
                EXEC GetErrorMsg 610, @errNum out, @errMsg out
				RETURN
			END
			*/
		END

		IF (@licenseTypeId IS NULL)
		BEGIN
			SELECT @vlicenseTypeId = (MAX([LicenseTypeId]) + 1)
			  FROM [dbo].[LicenseType];

			INSERT INTO [dbo].[LicenseType]
			(
				 LicenseTypeId
			   , Description
			   , AdText
			   , PeriodUnitId
			   , NumberOfUnit
			   , Price
			   , CurrencySymbol
			   , CurrencyText
			)
			VALUES
			(
			     @vlicenseTypeId
			   , LTRIM(RTRIM(@description))
			   , LTRIM(RTRIM(@adText))
			   , @periodUnitId
			   , @numberOfUnit
			   , @price
			   , COALESCE(@currSymbol, '$')
			   , COALESCE(@currText, 'USD')
			);
		END
		ELSE
		BEGIN
			SET @vlicenseTypeId = @licenseTypeId;

			UPDATE [dbo].[LicenseType]
			   SET [Description] = LTRIM(RTRIM(@description))
			     , AdText = LTRIM(RTRIM(COALESCE(@adText, AdText)))
				 , PeriodUnitId = COALESCE(@periodUnitId, NumberOfUnit)
				 , NumberOfUnit = COALESCE(@numberOfUnit, NumberOfUnit)
				 , Price = COALESCE(@price, Price)
				 , CurrencySymbol = COALESCE(@currSymbol, CurrencySymbol)
				 , CurrencyText = COALESCE(@currText, CurrencyText)
			 WHERE LicenseTypeId = @vlicenseTypeId;
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
-- Name: SaveLicenseTypeML.
-- Description:	Save License Type ML.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLicenseTypeML 5, N'TH', N'ทดลองใช้งาน', N'ทดลองใช้งานราคาประหยัด', 599, N'฿', N'บาท'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseTypeML] (
  @licenseTypeId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(100) = null
, @adText as nvarchar(MAX) = null
, @price as decimal(18, 2) = null
, @currSymbol as nvarchar(5) = null
, @currText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int;
	-- Error Code:
	--   0 : Success
	-- 611 : LicenseTypeId cannot be null.
	-- 612 : Language Id cannot be null or empty string.
	-- 613 : Language Id not found.
	-- 614 : Description (ML) cannot be null or empty string.
	-- 615 : Advertise Text (ML) cannot be null or empty string.
	-- 616 : Price (ML) cannot be null.
	-- 617 : Description (ML) is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@licenseTypeId IS NULL)
		BEGIN
			-- LicenseTypeId cannot be null.
            EXEC GetErrorMsg 611, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 612, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iCnt = 0)
		BEGIN
			-- Language Id not found.
            EXEC GetErrorMsg 613, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 614, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@adText) = 1)
		BEGIN
			-- Advertise Text (ML) cannot be null or empty string.
            EXEC GetErrorMsg 615, @errNum out, @errMsg out
			RETURN
		END

		IF (@price IS NULL)
		BEGIN
			-- Price (ML) cannot be null.
            EXEC GetErrorMsg 616, @errNum out, @errMsg out
			RETURN
		END

		-- Check is description is duplicated?.
		SELECT @iCnt = COUNT(*)
			FROM [dbo].[LicenseTypeML]
			WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
			  AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)))
			  AND LicenseTypeId <> @licenseTypeId;

		IF (@iCnt <> 0)
		BEGIN
			-- Description (ML) is duplicated.
            EXEC GetErrorMsg 617, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LicenseTypeML
		 WHERE UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND [LicenseTypeId] = @licenseTypeId;

		IF (@iCnt = 0)
		BEGIN
			INSERT INTO [dbo].[LicenseTypeML]
			(
				 LicenseTypeId
			   , LangId
			   , Description
			   , AdText
			   , Price
			   , CurrencySymbol
			   , CurrencyText
			)
			VALUES
			(
			     @licenseTypeId
			   , UPPER(RTRIM(LTRIM(@langId)))
			   , LTRIM(RTRIM(@description))
			   , LTRIM(RTRIM(@adText))
			   , @price
			   , @currSymbol
			   , @currText
			);
		END
		ELSE
		BEGIN
			UPDATE [dbo].LicenseTypeML
			   SET [Description] = LTRIM(RTRIM(@description))
			     , AdText = LTRIM(RTRIM(COALESCE(@adText, AdText)))
				 , Price = COALESCE(@price, Price)
				 , CurrencySymbol = COALESCE(@currSymbol, CurrencySymbol)
				 , CurrencyText = COALESCE(@currText, CurrencyText)
			 WHERE LicenseTypeId = @licenseTypeId
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
-- Description:	GetLicenses
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column PeriodUnitId to periodUnitId
-- <2019-08-19> :
--	- Remove LicenseTypeDescriptionNative column.
--	- Remove AdTextNative column.
--	- Rename LicenseTypeDescriptionEN column to LicenseTypeDescription.
--	- Rename AdTextEN column to AdText.
--
-- [== Example ==]
--
--exec GetLicenseTypes N'EN'; -- for only EN language.
--exec GetLicenseTypes;       -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenseTypes] 
(
  @langId nvarchar(3) = null
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , LicenseTypeDescription
		 , AdText
		 , periodUnitId
		 , NumberOfUnit
		 , UseDefaultPrice
		 , Price
		 , CurrencySymbol
		 , CurrencyText
		 , SortOrder
		 , Enabled 
	  FROM LicenseTypeMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND Enabled = 1
	 Order By SortOrder, LangId, LicenseTypeId;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitLicenseTypes.
-- Description:	Init Init License Types.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLicenseTypes
-- =============================================
CREATE PROCEDURE [dbo].[InitLicenseTypes]
AS
BEGIN
DECLARE @id0 int;
DECLARE @id1 int;
DECLARE @id2 int;
DECLARE @id3 int;
	/* DELETE FIRST */
	DELETE FROM LicenseTypeML;
	DELETE FROM LicenseType;

	SET @id0 = 0
	SET @id1 = 1
	SET @id2 = 2
	SET @id3 = 3
	
	-- [DAY]
	INSERT INTO LicenseType VALUES (@id0, N'Trial', N'Free Full Functional', 1, 15, 0.00, N'฿', N'BAHT')
	-- [MONTH]
	INSERT INTO LicenseType VALUES (@id1, N'Monthly', N'Save 33% with full functions', 2, 1, 55.99, N'฿', N'BAHT')
	-- [6 Months]
	INSERT INTO LicenseType VALUES (@id2, N'6 Months', N'Save 40% with full functions', 2, 6, 315.99, N'฿', N'BAHT')
	-- [YEAR]
	INSERT INTO LicenseType VALUES (@id3, N'Yearly', N'Save 60% with full functions', 3, 1, 420.99, N'฿', N'BAHT')

	-- [ENGLISH]
	EXEC SaveLicenseTypeML @id0, N'EN', N'Trial', N'Free Full Functional', 0.00
	EXEC SaveLicenseTypeML @id1, N'EN', N'Monthly', N'Save 33% with full functions', 55.99
	EXEC SaveLicenseTypeML @id2, N'EN', N'6 Months', N'Save 40% with full functions', 315.99
	EXEC SaveLicenseTypeML @id3, N'EN', N'Yearly', N'Save 60% with full functions', 420.99
	-- [THAI]
	EXEC SaveLicenseTypeML @id0, N'TH', N'ทดลองใช้', N'ทดลองใช้ฟรี ทุกฟังก์ชั่น', 0.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id1, N'TH', N'รายเดือน', N'ประหยัดทันที 33% พร้อมใช้งานทุกฟังก์ชั่น', 2000.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id2, N'TH', N'6 เดือน', N'ประหยัดทันที 40% พร้อมใช้งานทุกฟังก์ชั่น', 10800.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id3, N'TH', N'รายปี', N'ประหยัดทันที 60% พร้อมใช้งานทุกฟังก์ชั่น', 14400.00, N'฿', N'บาท'
	-- [CHINESE]
	EXEC SaveLicenseTypeML @id0, N'ZH', N'审讯', N'免费试用 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id1, N'ZH', N'每月一次', N'ประหยัดทันที 33% 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id2, N'ZH', N'6个月', N'ประหยัดทันที 40% 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id3, N'ZH', N'每年', N'ประหยัดทันที 60% 所有可用的功能', NULL
	-- [JAPANESE]
	EXEC SaveLicenseTypeML @id0, N'JA', N'実験', N'無料体験. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id1, N'JA', N'毎月', N'33％を保存. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id2, N'JA', N'6 毎月', N'40％を保存. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id3, N'JA', N'毎年', N'60％を保存. すべての利用可能な機能', NULL
	-- [GERMAN]
	EXEC SaveLicenseTypeML @id0, N'DE', N'Versuch', N'Voll funktionsfähige Prüfung. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id1, N'DE', N'monatlich', N'Sparen Sie 33%. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id2, N'DE', N'6 monatlich', N'Sparen Sie 40%. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id3, N'DE', N'jährlich', N'Sparen Sie 60%. Alle verfügbaren Funktionen.', NULL
	-- [FRENCH]
	EXEC SaveLicenseTypeML @id0, N'FR', N'épreuve', N'Complètement fonctionnel. Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id1, N'FR', N'mensuel', N'Économisez 33% Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id2, N'FR', N'6 mensuel', N'Économisez 40% Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id3, N'FR', N'annuel', N'Économisez 60% Toutes les fonctions disponibles', NULL
	-- [KOREAN]
	EXEC SaveLicenseTypeML @id0, N'KO', N'공판', N'완전 기능 시험 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id1, N'KO', N'월', N'33 % 절감 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id2, N'KO', N'6 월', N'40 % 절감 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id3, N'KO', N'매년', N'50 % 절감 사용 가능한 모든 기능을합니다.', NULL
END

GO

EXEC InitLicenseTypes;

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseFeature.
-- Description:	Save License Feature.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--declare seq int;
--exec SaveLicenseFeature 5, 1, 2, @seq out -- Save Feature Limit device with 2 device(s).
--select * from seq as Seq;
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseFeature] (
  @licenseTypeId as int = null
, @limitUnitId as int = null
, @noOfLimit as int = null
, @seq as int = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int;
DECLARE @iSeq int;
	-- Error Code:
	--   0 : Success
	-- 701 : LicenseType Id cannot be null.
	-- 702 : LicenseType Id not found.
	-- 703 : LimitUnit Id cannot be null.
	-- 704 : LimitUnit Id not found.
	-- 705 : LimitUnit Id already exists.
	-- 706 : No Of Limit cannot be null.
	-- 707 : No Of Limit should be zero or more.
	-- 708 : Invalid Seq Number.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@licenseTypeId IS NULL)
		BEGIN
			-- LicenseType Id cannot be null.
            EXEC GetErrorMsg 701, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LicenseType
		 WHERE LicenseTypeId = @licenseTypeId;
		IF (@iCnt = 0)
		BEGIN
			--LicenseType Id not found.
            EXEC GetErrorMsg 702, @errNum out, @errMsg out
			RETURN
		END

		IF (@limitUnitId IS NULL)
		BEGIN
			-- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 703, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LimitUnit
		 WHERE LimitUnitId = @limitUnitId;
		IF (@iCnt = 0)
		BEGIN
			-- LimitUnit Id not found.
            EXEC GetErrorMsg 704, @errNum out, @errMsg out
			RETURN
		END

		IF (@seq IS NULL)
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND LimitUnitId = @limitUnitId;
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND LimitUnitId = @limitUnitId
			   AND Seq <> @seq;
		END

		IF (@iCnt <> 0)
		BEGIN
			-- LimitUnit Id already exists.
            EXEC GetErrorMsg 705, @errNum out, @errMsg out
			RETURN
		END

		IF (@noOfLimit IS NULL)
		BEGIN
			-- No Of Limit cannot be null.
            EXEC GetErrorMsg 706, @errNum out, @errMsg out
			RETURN
		END

		IF (@noOfLimit < 0)
		BEGIN
			-- No Of Limit should be zero or more.
            EXEC GetErrorMsg 707, @errNum out, @errMsg out
			RETURN
		END

		IF (@seq IS NULL)
		BEGIN
			SELECT @iSeq = MAX(Seq)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId;
			IF (@iSeq IS NULL)
			BEGIN
				SET @iSeq = 1;
			END
			ELSE
			BEGIN
				SET @iSeq = @iSeq + 1;
			END
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND Seq = @seq;
			
			IF (@iCnt = 0)
			BEGIN
				-- Invalid Seq Number.
                EXEC GetErrorMsg 708, @errNum out, @errMsg out
				RETURN
			END

			SET @iSeq = @seq;
		END

		IF (@seq IS NULL)
		BEGIN
			INSERT INTO [dbo].[LicenseFeature]
			(
				 LicenseTypeId
			   , Seq
			   , LimitUnitId
			   , NoOfLimit
			)
			VALUES
			(
			     @licenseTypeId
			   , @iSeq
			   , @limitUnitId
			   , @noOfLimit
			);

			-- SET OUTPUT SEQ.
			SET @seq = @iSeq;
		END
		ELSE
		BEGIN
			UPDATE [dbo].[LicenseFeature]
			   SET LimitUnitId = COALESCE(@limitUnitId, LimitUnitId)
				 , NoOfLimit = COALESCE(@noOfLimit, NoOfLimit)
			 WHERE LicenseTypeId = @licenseTypeId
			   AND Seq = @iSeq;
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
-- Name: GetLicenseFeatures.
-- Description:	Get License Features.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column LimitUnitId to limitUnitId
-- <2019-08-19> :
--	- Remove column LimitUnitDescriptionNative.
--	- Remove column LimitUnitTextNative.
--	- Rename column LimitUnitDescriptionEN to LimitUnitDescription.
--	- Rename column LimitUnitTextEN to LimitUnitText.
--
-- [== Example ==]
--
--exec GetLicenseFeatures N'EN';    -- for only EN language.
--exec GetLicenseFeatures;          -- for get all.
--exec GetLicenseFeatures N'EN', 1; -- for all features for LicenseTypeId = 1 in EN language.
--exec GetLicenseFeatures N'TH', 0; -- for all features for LicenseTypeId = 0 in TH language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenseFeatures] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , seq
		 , limitUnitId
		 , LimitUnitDescription
		 , NoOfLimit
		 , LimitUnitText
		 , SortOrder
		 , Enabled 
	  FROM LicenseFeatureMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND Enabled = 1
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	 Order By SortOrder, LangId, LicenseTypeId;
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLicenses.
-- Description:	Get Licenses.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column PeriodUnitId to periodUnitId
--  - change column NumberOfUnit to NoOfUnit
--	- change column LimitUnitId to limitUnitId
-- <2019-08-19> :
--	- Remove column LimitUnitDescriptionNative.
--	- Remove column LimitUnitTextNative.
--	- Remove column AdTextNative.
--	- Rename column LimitUnitDescriptionEN to LimitUnitDescription.
--	- Rename column LimitUnitTextEN to LimitUnitText.
--	- Rename column AdTextEN to AdText.
--
-- [== Example ==]
--
--exec GetLicenses N'EN';    -- for only EN language.
--exec GetLicenses;          -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenses] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null  
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , seq
		 , LicenseTypeDescription
		 , AdText
		 , periodUnitId
		 , NumberOfUnit as NoOfUnit
		 , UseDefaultPrice
		 , Price
		 , CurrencySymbol
		 , CurrencyText
		 , limitUnitId
		 , LimitUnitDescription
		 , NoOfLimit
		 , LimitUnitText
		 , SortOrder
		 , Enabled
	  FROM LicenseMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	   AND Enabled = 1
	 Order By SortOrder, LicenseTypeId, Seq
END

GO


/*********** Script Update Date: 2020-03-26  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitLicenseFeatures.
-- Description:	Init InitLicense Features.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLicenseFeatures
-- =============================================
CREATE PROCEDURE [dbo].[InitLicenseFeatures]
AS
BEGIN
    -- DELETE FIRST.
    DELETE FROM LicenseFeature

	/* Trial */
	INSERT INTO LicenseFeature
		VALUES (0, 1, 1, 1);
	INSERT INTO LicenseFeature
		VALUES (0, 2, 2, 1);
	INSERT INTO LicenseFeature
		VALUES (0, 3, 3, 1);
	/* Monthly */
	INSERT INTO LicenseFeature
		VALUES (1, 1, 1, 5);
	INSERT INTO LicenseFeature
		VALUES (1, 2, 2, 10);
	INSERT INTO LicenseFeature
		VALUES (1, 3, 3, 10);

	/* 6 Months */
	INSERT INTO LicenseFeature
		VALUES (2, 1, 1, 5);
	INSERT INTO LicenseFeature
		VALUES (2, 2, 2, 10);
	INSERT INTO LicenseFeature
		VALUES (2, 3, 3, 10);

	/* Yearly */
	INSERT INTO LicenseFeature
		VALUES (3, 1, 1, 10);
	INSERT INTO LicenseFeature
		VALUES (3, 2, 2, 20);
	INSERT INTO LicenseFeature
		VALUES (3, 3, 3, 20);
END

GO

EXEC InitLicenseFeatures;

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

