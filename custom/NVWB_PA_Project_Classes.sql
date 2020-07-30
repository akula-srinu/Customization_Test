-- *******************************************************************************
-- FileName:             NVWB_PA_Project_Classes.sql
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
-- output to NVWB_PA_Project_Classes.lst file

@utlspon NVWB_PA_Project_Classes

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1131;

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
      'PA_Project_Classes',
      1.0,
      'Financial_Analyst',
      null,
      '(SELECT full_name              FROM hr.per_all_people_f p             WHERE person_id = COD.ATTRIBUTE5                   AND TRUNC (SYSDATE) BETWEEN P.EFFECTIVE_START_DATE                                           AND NVL (P.EFFECTIVE_END_DATE,                                                    SYSDATE + 1))',
      10.300001,
      'EXPR',
      'Name of the financial analyst. Custom Field added by Zensar.',
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
      '10.0+',
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
      'PA_Project_Classes',
      1.0,
      'COD',
      'COD',
      'COD',
      10.1,
      'ATTR',
      'Project class codes DFF. Custom Field Added by Zensar.',
      null,
      null,
      null,
      'ATTRIBUTE%',
      'Class Codes Desc Flex',
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
      '10.0+',
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
      'PA_Project_Classes',
      1.0,
      'Attribute2',
      null,
      'NVL( PCOD.ATTRIBUTE2, NULL)',
      10.200001,
      'EXPR',
      'Attribute2. Custom Field added by Zensar.',
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
      '10.0+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1131;

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'ORDER_ENTRY',
      'PA_Project_Classes',
      '10.6+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'QUALITY',
      'PA_Project_Classes',
      '10.6+',
      null,
      null,
      'nemuser',
      'nemuser'
   );


COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff