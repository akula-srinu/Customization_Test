-- *******************************************************************************
-- FileName:             NVWB_PA_Org_Labor_Expenditures.sql
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
-- output to NVWB_PA_Org_Labor_Expenditures.lst file

@utlspon NVWB_PA_Org_Labor_Expenditures

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1068;

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
      'PA_Org_Labor_Expenditures',
      1.0,
      'Expenditure_Ending_Date',
      'EXP',
      'EXPENDITURE_ENDING_DATE',
      10.200001,
      'COL',
      'Expenditure Ending Date Custom Field Added by Zensar.',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      'Y',
      null,
      'STRING',
      'N',
      null,
      null,
      null,
      '10.0+',
      'Y',
      'Y',
      'dpagadala',
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
      'PA_Org_Labor_Expenditures',
      1.0,
      'Expenditure_Item_Date',
      'EXPI',
      'EXPENDITURE_ITEM_DATE',
      10.1,
      'COL',
      'Expenditure Item Date. Custom Field Added by Zensar.',
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      'Y',
      null,
      'STRING',
      'N',
      null,
      null,
      null,
      '10.0+',
      'Y',
      'Y',
      'dpagadala',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff