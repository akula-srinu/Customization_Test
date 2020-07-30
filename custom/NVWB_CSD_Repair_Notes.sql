-- *******************************************************************************
-- FileName:             NVWB_CSD_Repair_Notes.sql
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
-- output to NVWB_CSD_Repair_Notes.lst file

@utlspon NVWB_CSD_Repair_Notes

-- *******************************************************************************
-- Revision Number: 5
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1127;

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
      'CSD_Repair_Notes',
      1.0,
      'Repair_Line_ID',
      'RPRS',
      'REPAIR_LINE_ID',
      10.1,
      'COL',
      'Repair line identifier. Custom field added by Zensar.',
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
      null,
      null,
      null,
      '11.5+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );


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
      'CSD_Repair_Notes',
      1.0,
      'Depot_Repair_Number',
      'RPRS',
      'REPAIR_NUMBER',
      10.0,
      'COL',
      'Repair number. Custom field added by Zensar.',
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
      null,
      null,
      null,
      '11.5+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );


UPDATE n_view_where_templates
   SET where_clause = 'AND CONT.INCIDENT_ID (+) = INCD.INCIDENT_ID',
       profile_option = null,
       product_version = '11.5+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2018-08-13 22:55:43','YYYY-MM-DD HH24:MI:SS')
 WHERE query_position = 1.0
   AND upper(view_label) = 'CSD_REPAIR_NOTES'
   AND where_clause_position = 17.0;


UPDATE n_view_where_templates
   SET where_clause = 'AND CONT.PRIMARY_FLAG (+) = ''Y''',
       profile_option = null,
       product_version = '11.5+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2018-08-13 22:55:43','YYYY-MM-DD HH24:MI:SS')
 WHERE query_position = 1.0
   AND upper(view_label) = 'CSD_REPAIR_NOTES'
   AND where_clause_position = 18.0;






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff