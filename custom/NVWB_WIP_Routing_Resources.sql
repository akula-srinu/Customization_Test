-- *******************************************************************************
-- FileName:             NVWB_WIP_Routing_Resources.sql
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
-- output to NVWB_WIP_Routing_Resources.lst file

@utlspon NVWB_WIP_Routing_Resources

-- *******************************************************************************
-- Revision Number: 5
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1109;

UPDATE n_view_table_templates
   SET table_alias = 'JTYP',
       from_clause_position = 13.0,
       application_label = 'NOETIX',
       table_name = 'N_MFG_LOOKUPS_VL',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'N',
       base_table_flag = 'N',
       key_view_label = null,
       subquery_flag = 'N',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS'),
       gen_search_by_col_flag = 'N'
 WHERE query_position = 2.0
   AND upper(table_alias) = 'JTYP'
   AND upper(view_label) = 'WIP_ROUTING_RESOURCES';


UPDATE n_view_column_templates
   SET view_label = 'WIP_Routing_Resources',
       query_position = 2.0,
       column_label = 'Department',
       table_alias = 'DEPT',
       column_expression = 'DEPARTMENT_CODE',
       column_position = 71.0,
       column_type = 'COL',
       description = 'The department at which the resource was used.',
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
       lov_view_label = 'WIP_Lov_Departments_Vsat',
       lov_column_label = 'Department_Code',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 14:38:09','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 113845;



UPDATE n_view_column_templates
   SET view_label = 'WIP_Routing_Resources',
       query_position = 2.0,
       column_label = 'Job_Type',
       table_alias = null,
       column_expression = '          (SELECT jtyp.meaning              FROM NOETIX_VIEWS.N_MFG_LOOKUPS_VL JTYP             WHERE     1 = 1                   AND JTYP.LOOKUP_CODE(+) = DJOB.JOB_TYPE                   AND JTYP.LOOKUP_TYPE(+) = ''WIP_DISCRETE_JOB''                   AND JTYP.LANGUAGE(+) = NOETIX_ENV_PKG.GET_LANGUAGE                   AND JTYP.SECURITY_GROUP_ID(+) =                        NOETIX_APPS_SECURITY_PKG.LOOKUP_SECURITY_GROUP (                             JTYP.LOOKUP_TYPE(+),                             JTYP.VIEW_APPLICATION_ID(+)))           || '' ''           || ETYP.MEANING',
       column_position = 2.0,
       column_type = 'EXPR',
       description = 'The job is defined as either a discrete job (Standard and Non-standard), lot based job (Standard and Non-standard), repetitive schedules or maintenance jobs.',
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
       lov_view_label = null,
       lov_column_label = null,
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 95058;



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
      'WIP_Routing_Resources',
      2.0,
      'Project_Number',
      null,
      '(select p.segment1 from pa.pa_projects_all p where p.project_id = djob.project_id)',
      10.200001,
      'EXPR',
      'Project number. Custom Field added by Zensar.',
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
      '11.0+',
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
      'WIP_Routing_Resources',
      2.0,
      'Organization_Code',
      null,
      '(select mp.organization_code from inv.mtl_parameters mp where mp.organization_id = xmap.organization_id)',
      10.1,
      'EXPR',
      'Organization code. Custom Field added by Zensar.',
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
      '11.0+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );


UPDATE n_view_where_templates
   SET where_clause = 'AND JTYP.LOOKUP_CODE(+)= DJOB.JOB_TYPE',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'N',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE query_position = 2.0
   AND upper(view_label) = 'WIP_ROUTING_RESOURCES'
   AND where_clause_position = 271.0;


UPDATE n_view_where_templates
   SET where_clause = 'AND JTYP.LOOKUP_TYPE(+) = ''WIP_DISCRETE_JOB''',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'N',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE query_position = 2.0
   AND upper(view_label) = 'WIP_ROUTING_RESOURCES'
   AND where_clause_position = 272.0;


UPDATE n_view_where_templates
   SET where_clause = 'AND JTYP.LANGUAGE (+) = NOETIX_ENV_PKG.GET_LANGUAGE',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'N',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE query_position = 2.0
   AND upper(view_label) = 'WIP_ROUTING_RESOURCES'
   AND where_clause_position = 273.0;




UPDATE n_view_column_templates
   SET view_label = 'WIP_Routing_Resources',
       query_position = 3.0,
       column_label = 'Department',
       table_alias = 'DEPT',
       column_expression = 'DEPARTMENT_CODE',
       column_position = 72.0,
       column_type = 'COL',
       description = 'The department at which the resource was used.',
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
       lov_view_label = 'WIP_Lov_Departments_Vsat',
       lov_column_label = 'Department_Code',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 14:38:09','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 113851;



UPDATE n_view_column_templates
   SET view_label = 'WIP_Routing_Resources',
       query_position = 3.0,
       column_label = 'Job_Type',
       table_alias = null,
       column_expression = 'Repetitive Schedule',
       column_position = 2.0,
       column_type = 'CONST',
       description = 'The job is defined as either a discrete job (Standard and Non-standard), lot based job (Standard and Non-standard), repetitive schedules or maintenance jobs.',
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
       lov_view_label = null,
       lov_column_label = null,
       profile_option = null,
       product_version = '11.0+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 95188;



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
      'WIP_Routing_Resources',
      3.0,
      'Organization_Code',
      null,
      '(select mp.organization_code from inv.mtl_parameters mp where mp.organization_id = xmap.organization_id)',
      10.1,
      'EXPR',
      'Organization code. Custom Field added by Zensar.',
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
      '11.0+',
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
      'WIP_Routing_Resources',
      3.0,
      'Project_Number',
      null,
      'TO_CHAR(NULL)',
      10.200001,
      'EXPR',
      'Project number. Custom Field added by Zensar.',
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
      '11.0+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff