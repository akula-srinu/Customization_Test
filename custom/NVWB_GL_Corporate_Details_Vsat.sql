-- *******************************************************************************
-- FileName:             NVWB_GL_Corporate_Details_Vsat.sql
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
-- output to NVWB_GL_Corporate_Details_Vsat.lst file

@utlspon NVWB_GL_Corporate_Details_Vsat

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 949;

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
      'GL_Corporate_Details_Vsat',
      'GL',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      null,
      'Y',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'GLB',
      1.0,
      'GL',
      'GL_BALANCES',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'GLCC',
      2.0,
      'GL',
      'GL_CODE_COMBINATIONS',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'Segment4',
      'GLCC',
      'segment4',
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
      'Y',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'Segment2',
      'GLCC',
      'segment2',
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
      'Y',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'Balance',
      null,
      'SUM (GLB.period_net_dr - GLB.period_net_cr)',
      7.0,
      'EXPR',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'Segment3',
      'GLCC',
      'segment3',
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
      'Y',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'Period_Name',
      'GLB',
      'period_name',
      6.0,
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
      'Y',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'Segment5',
      'GLCC',
      'segment5',
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
      'Y',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      'Segment1',
      'GLCC',
      'segment1',
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
      'Y',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      23.0,
      'AND  f.flex_value BETWEEN e.child_flex_value_low ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      36.0,
      'AND  e.child_flex_value_high) ) )',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      4.0,
      'AND  ( ( glcc.segment4 IN (SELECT f.flex_value FROM apps.fnd_flex_value_sets a, apps.fnd_flex_values b, apps.fnd_flex_values_tl c, apps.fnd_flex_value_norm_hierarchy e, apps.fnd_flex_values f WHERE a.flex_value_set_id = b.flex_value_set_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      1.0,
      'AND GLB.code_combination_id = glcc.code_combination_id',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      18.0,
      'AND  b.flex_value_id = c.flex_value_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      28.0,
      'AND  c.language = ''US'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      16.0,
      'AND  c.language = ''US'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      26.0,
      'AND  glcc.segment5 IN (SELECT f.flex_value FROM apps.fnd_flex_value_sets a, apps.fnd_flex_values b, apps.fnd_flex_values_tl c, apps.fnd_flex_value_norm_hierarchy e, apps.fnd_flex_values f WHERE a.flex_value_set_id = b.flex_value_set_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      25.0,
      'AND  glcc.segment4 != ''52110'' ) ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      5.0,
      'AND  a.flex_value_set_id = f.flex_value_set_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      30.0,
      'AND  b.flex_value_id = c.flex_value_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      27.0,
      'AND  a.flex_value_set_id = f.flex_value_set_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      21.0,
      'AND  b.enabled_flag = ''Y'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      19.0,
      'AND  b.flex_value IN (''GANDA'') ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      32.0,
      'AND  b.summary_flag = ''Y'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      12.0,
      'AND  e.parent_flex_value = b.flex_value ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      33.0,
      'AND  b.enabled_flag = ''Y'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      22.0,
      'AND  e.parent_flex_value = b.flex_value ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      17.0,
      'AND  flex_value_set_name IN (''VSAT_ACCT'') ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      31.0,
      'AND  b.flex_value IN (''DIRPROJ'') ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      35.0,
      'AND  f.flex_value BETWEEN e.child_flex_value_low ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      11.0,
      'AND  b.enabled_flag = ''Y'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      13.0,
      'AND  f.flex_value BETWEEN e.child_flex_value_low ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      20.0,
      'AND  b.summary_flag = ''Y'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      10.0,
      'AND  b.summary_flag = ''Y'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      34.0,
      'AND  e.parent_flex_value = b.flex_value ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      24.0,
      'AND  e.child_flex_value_high) ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      2.0,
      'and GLB.actual_flag = ''A''',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      14.0,
      'AND  e.child_flex_value_high) ) or ( ( glcc.segment4 IN (SELECT f.flex_value FROM apps.fnd_flex_value_sets a, apps.fnd_flex_values b, apps.fnd_flex_values_tl c, apps.fnd_flex_value_norm_hierarchy e, apps.fnd_flex_values f WHERE a.flex_value_set_id = b.flex_value_set_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      8.0,
      'AND  b.flex_value_id = c.flex_value_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      7.0,
      'AND  flex_value_set_name IN (''VSAT_ACCT'') ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      15.0,
      'AND  a.flex_value_set_id = f.flex_value_set_id ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      9.0,
      'AND  b.flex_value IN (''SALES'') ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      6.0,
      'AND  c.language = ''US'' ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      29.0,
      'AND  flex_value_set_name IN (''VSAT_PROJ'') ',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      38.0,
      'and ( glcc.segment2 BETWEEN ''0000'' AND ''0005'' or glcc.segment2 BETWEEN ''1010'' AND ''1140'' or glcc.segment2 BETWEEN ''8000'' AND ''8000'' or glcc.segment2 BETWEEN ''9000'' AND ''9000'' or glcc.segment2 BETWEEN ''9992'' AND ''9999'' )',
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
      'GL_Corporate_Details_Vsat',
      1.0,
      3.0,
      'and GLB.currency_code = ''USD''',
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
WHENEVER SQLERROR EXIT 949;

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'SUBLEDGER_ACCOUNTING',
      'GL_Corporate_Details_Vsat',
      '%',
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
      'LEDGER',
      'GL_Corporate_Details_Vsat',
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