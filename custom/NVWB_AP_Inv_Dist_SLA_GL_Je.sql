-- *******************************************************************************
-- FileName:             NVWB_AP_Inv_Dist_SLA_GL_Je.sql
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
-- output to NVWB_AP_Inv_Dist_SLA_GL_Je.lst file

@utlspon NVWB_AP_Inv_Dist_SLA_GL_Je

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 916;

UPDATE n_view_column_templates
   SET view_label = 'AP_Inv_Dist_SLA_GL_Je',
       query_position = 1.0,
       column_label = 'Je_Period_Name',
       table_alias = 'GLHDR',
       column_expression = 'PERIOD_NAME',
       column_position = 67.0,
       column_type = 'COL',
       description = 'Accounting period. Field Modified by Zensar.',
       ref_application_label = null,
       ref_table_name = null,
       key_view_label = null,
       ref_lookup_column_name = null,
       ref_description_column_name = null,
       ref_lookup_type = null,
       id_flex_application_id = null,
       id_flex_code = null,
       group_by_flag = 'N',
       format_mask = null,
       format_class = 'STRING',
       gen_search_by_col_flag = 'N',
       lov_view_label = 'AP_Lov_GL_Periods',
       lov_column_label = 'Period_Name',
       profile_option = null,
       product_version = '12.0+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 37291;





UPDATE n_view_column_templates
   SET view_label = 'AP_Inv_Dist_SLA_GL_Je',
       query_position = 2.0,
       column_label = 'Je_Period_Name',
       table_alias = 'GLHDR',
       column_expression = 'PERIOD_NAME',
       column_position = 67.0,
       column_type = 'COL',
       description = 'Accounting period. Field Modified by Zensar.',
       ref_application_label = null,
       ref_table_name = null,
       key_view_label = null,
       ref_lookup_column_name = null,
       ref_description_column_name = null,
       ref_lookup_type = null,
       id_flex_application_id = null,
       id_flex_code = null,
       group_by_flag = 'N',
       format_mask = null,
       format_class = 'STRING',
       gen_search_by_col_flag = 'N',
       lov_view_label = 'AP_Lov_GL_Periods',
       lov_column_label = 'Period_Name',
       profile_option = null,
       product_version = '12.0+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 35514;







COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff