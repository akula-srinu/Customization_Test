-- *******************************************************************************
-- FileName:             NVWB_OE_Workflow_Statuses_Base.sql
--
-- Date Created:         2019/Aug/28 06:12:39
-- Created By:           nemuser
--
-- Source:
-- - Package:            Package_2018_P11_B1_DEV_NEW
-- - Environment:        EBSPJD1
-- - NoetixViews Schema: NOETIX_VIEWS
--
-- Versions:
-- - Oracle EBS:   12.1.3
-- - Oracle DB:    11.2.0
-- - NoetixViews:  6.5.1
--
-- *******************************************************************************
-- output to NVWB_OE_Workflow_Statuses_Base.lst file

@utlspon NVWB_OE_Workflow_Statuses_Base

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1045;

UPDATE n_view_where_templates
   SET where_clause = 'AND WFL.ITEM_KEY              > ''-1''',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE query_position = 1.0
   AND upper(view_label) = 'OE_WORKFLOW_STATUSES_BASE'
   AND where_clause_position = 4.0;






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff