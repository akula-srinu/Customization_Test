-- *******************************************************************************
-- FileName:             NVWB_WIP_Jobs.sql
--
-- Date Created:         2019/Aug/28 06:12:40
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
-- output to NVWB_WIP_Jobs.lst file

@utlspon NVWB_WIP_Jobs

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1106;

UPDATE n_view_column_templates
   SET view_label = 'WIP_Jobs',
       query_position = 1.0,
       column_label = 'Job_Type',
       table_alias = null,
       column_expression = 'JTYP.MEANING ||'' ''|| ETYP.MEANING',
       column_position = 2.0,
       column_type = 'EXPR',
       description = 'The job is defined as either a discrete job (Standard and Non-standard), lot based job (Standard and Non-standard), repetitive schedules or maintenance jobs. Field modified by Zensar.',
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
       lov_view_label = 'XLA_Lov_WIP_Job_Types',
       lov_column_label = 'Job_Type',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 2859;



INSERT INTO n_view_column_templates(
      view_label,
      query_position,
      column_label,
      table_alias,
      column_expression,
      column_position,
      column_type,
      description,
      ref_application_label,
      ref_table_name,
      key_view_label,
      ref_lookup_column_name,
      ref_description_column_name,
      ref_lookup_type,
      id_flex_application_id,
      id_flex_code,
      group_by_flag,
      format_mask,
      format_class,
      gen_search_by_col_flag,
      lov_view_label,
      lov_column_label,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'WIP_Jobs',
      1.0,
      'Organization_Code',
      'MPARM',
      'ORGANIZATION_CODE',
      10.1,
      'COL',
      'Organization code. Custom Field Added by Zensar.',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      'N',
      null,
      'STRING',
      'N',
      'INV_Lov_Orgn_Codes_Vsat',
      'Organization_Code',
      null,
      '10.0+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );




UPDATE n_view_column_templates
   SET view_label = 'WIP_Jobs',
       query_position = 2.0,
       column_label = 'Job_Type',
       table_alias = 'RJOB',
       column_expression = 'Repetitive Schedule',
       column_position = 2.0,
       column_type = 'CONST',
       description = 'The job is defined as either a discrete job (Standard and Non-standard), lot based job (Standard and Non-standard), repetitive schedules or maintenance jobs. Field modified by Zensar.',
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
       lov_view_label = 'XLA_Lov_WIP_Job_Types',
       lov_column_label = 'Job_Type',
       profile_option = null,
       product_version = '10.0+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 13440;



INSERT INTO n_view_column_templates(
      view_label,
      query_position,
      column_label,
      table_alias,
      column_expression,
      column_position,
      column_type,
      description,
      ref_application_label,
      ref_table_name,
      key_view_label,
      ref_lookup_column_name,
      ref_description_column_name,
      ref_lookup_type,
      id_flex_application_id,
      id_flex_code,
      group_by_flag,
      format_mask,
      format_class,
      gen_search_by_col_flag,
      lov_view_label,
      lov_column_label,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'WIP_Jobs',
      2.0,
      'Organization_Code',
      'MPARM',
      'ORGANIZATION_CODE',
      10.1,
      'COL',
      'Organization code. Custom Field Added by Zensar.',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      'N',
      null,
      'STRING',
      'N',
      'INV_Lov_Orgn_Codes_Vsat',
      'Organization_Code',
      null,
      '10.0+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff