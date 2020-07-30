-- *******************************************************************************
-- FileName:             NVWB_PA_SOX_UB_UE_Rel_Proj_Vsat.sql
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
-- output to NVWB_PA_SOX_UB_UE_Rel_Proj_Vsat.lst file

@utlspon NVWB_PA_SOX_UB_UE_Rel_Proj_Vsat

-- *******************************************************************************
-- Revision Number: 2
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1291;

INSERT INTO n_view_templates(
      view_label,
      application_label,
      description,
      profile_option,
      essay,
      keywords,
      product_version,
      include_flag,
      user_include_flag,
      export_view,
      security_code,
      special_process_code,
      sort_layer,
      freeze_flag,
      created_by,
      last_updated_by,
      original_version,
      current_version
  ) VALUES (
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      'PA',
      null,
      null,
      null,
      null,
      '%',
      'Y',
      'Y',
      'Y',
      'NONE',
      'NONE',
      '0',
      'N',
      'nemuser',
      'nemuser',
      null,
      null
  );

INSERT INTO n_view_query_templates(
      view_label,
      query_position,
      union_minus_intersection,
      group_by_flag,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      view_comment,
      created_by,
      last_updated_by
   ) VALUES (
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      null,
      'N',
      null,
      '%',
      'Y',
      'Y',
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      'PPA',
      2.0,
      'PA',
      'PA_PROJECTS_ALL',
      null,
      '%',
      'Y',
      'Y',
      'Y',
      null,
      'N',
      'nemuser',
      'nemuser',
      'Y'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      'PPCV',
      1.0,
      'PA',
      'PA_PROJECT_CLASSES',
      null,
      '%',
      'Y',
      'Y',
      'Y',
      null,
      'N',
      'nemuser',
      'nemuser',
      'Y'
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
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      'Description',
      'PPA',
      'description',
      2.0,
      'COL',
      null,
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
      '%',
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
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      'Project_Number',
      'PPA',
      'SEGMENT1',
      1.0,
      'COL',
      null,
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
      '%',
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
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      'Project_Type',
      'PPA',
      'project_type',
      3.0,
      'COL',
      null,
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
      '%',
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
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      'Class_Code',
      'PPCV',
      'class_code',
      5.0,
      'COL',
      null,
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
      '%',
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
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      'Class_Category',
      'PPCV',
      'class_category',
      4.0,
      'COL',
      null,
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
      '%',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );


INSERT INTO n_view_where_templates(
      view_label,
      query_position,
      where_clause_position,
      where_clause,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      1.0,
      'AND ppa.project_id = ppcv.project_id',
      null,
      null,
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );

INSERT INTO n_view_where_templates(
      view_label,
      query_position,
      where_clause_position,
      where_clause,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      1.0,
      2.0,
      'and ppcv.class_category = ''Related Projects''',
      null,
      null,
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );





COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1291;

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'FIN_SOX',
      'PA_SOX_UB_UE_Rel_Proj_Vsat',
      '%',
      null,
      null,
      'nemuser',
      'nemuser'
   );


COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff