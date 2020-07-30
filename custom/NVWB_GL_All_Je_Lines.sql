-- *******************************************************************************
-- FileName:             NVWB_GL_All_Je_Lines.sql
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
-- output to NVWB_GL_All_Je_Lines.lst file

@utlspon NVWB_GL_All_Je_Lines

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 944;

UPDATE n_view_column_templates
   SET view_label = 'GL_All_Je_Lines',
       query_position = 1.0,
       column_label = 'Acct',
       table_alias = 'GLLIN',
       column_expression = 'CODE_COMBINATION_ID',
       column_position = 11.0,
       column_type = 'KEY',
       description = 'Account that transaction was posted to. Field modified by Zensar.',
       ref_application_label = 'GL',
       ref_table_name = 'GL_CODE_COMBINATIONS',
       key_view_label = 'GL_Chart_Of_Accounts',
       ref_lookup_column_name = 'CODE_COMBINATION_ID',
       ref_description_column_name = null,
       ref_lookup_type = null,
       id_flex_application_id = '101',
       id_flex_code = 'GL#',
       group_by_flag = 'N',
       format_mask = null,
       format_class = 'STRING',
       gen_search_by_col_flag = 'N',
       lov_view_label = 'GL_Lov_Accounting_Flexfield',
       lov_column_label = 'Acct',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 3814;


DELETE 
  FROM n_view_property_templates
  WHERE t_view_property_id = 3434;

DELETE 
  FROM n_view_property_templates
  WHERE t_view_property_id = 942;

DELETE 
  FROM n_view_property_templates
  WHERE t_view_property_id = 2188;

INSERT INTO n_view_property_templates(
      view_label,
      query_position,
      property_type_id,
      t_source_pk_id,
      value1,
      value2,
      value3,
      value4,
      value5,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      version_id,
      created_by,
      last_updated_by
   ) VALUES (
      'GL_All_Je_Lines',
      1.0,
      15,
      3814,
      'GL_ACCOUNT',
      'Y',
      'Y',
      null,
      null,
      null,
      '*',
      null,
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_view_property_templates(
      view_label,
      query_position,
      property_type_id,
      t_source_pk_id,
      value1,
      value2,
      value3,
      value4,
      value5,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      version_id,
      created_by,
      last_updated_by
   ) VALUES (
      'GL_All_Je_Lines',
      1.0,
      7,
      3814,
      null,
      null,
      null,
      null,
      null,
      null,
      '*',
      null,
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_view_property_templates(
      view_label,
      query_position,
      property_type_id,
      t_source_pk_id,
      value1,
      value2,
      value3,
      value4,
      value5,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      version_id,
      created_by,
      last_updated_by
   ) VALUES (
      'GL_All_Je_Lines',
      1.0,
      15,
      3814,
      'GL_BALANCING',
      'Y',
      'Y',
      null,
      null,
      null,
      '*',
      null,
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_view_property_templates(
      view_label,
      query_position,
      property_type_id,
      t_source_pk_id,
      value1,
      value2,
      value3,
      value4,
      value5,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      version_id,
      created_by,
      last_updated_by
   ) VALUES (
      'GL_All_Je_Lines',
      1.0,
      15,
      3814,
      'FA_COST_CTR',
      'Y',
      'Y',
      null,
      null,
      null,
      '*',
      null,
      null,
      null,
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
      'GL_All_Je_Lines',
      1.0,
      'JE_Line_ROWID',
      null,
      'NVL(GLLIN.ROWID,NULL)',
      10.1,
      'EXPR',
      'RowID of the journal line. Custom Field added by Zensar.',
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
      '*',
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
      'GL_All_Je_Lines',
      1.0,
      'User_Je_Category',
      null,
      '(SELECT glcat.user_je_category_name user_je_category   FROM gl.gl_je_categories_tl glcat  WHERE     1 = 1        AND glcat.je_category_name = glhdr.je_category        AND glcat.language LIKE noetix_env_pkg.get_language)',
      10.200001,
      'EXPR',
      'User je category. Custom Field added by Zensar.',
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
      '*',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff