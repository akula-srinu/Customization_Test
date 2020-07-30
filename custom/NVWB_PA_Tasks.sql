-- *******************************************************************************
-- FileName:             NVWB_PA_Tasks.sql
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
-- output to NVWB_PA_Tasks.lst file

@utlspon NVWB_PA_Tasks

-- *******************************************************************************
-- Revision Number: 5
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1334;

UPDATE n_view_templates 
   SET application_label = 'PA',
       description = 'PA Basic - Task Level Information',
       profile_option = null,
       essay = 'This view is modified for applying the custom security requirements for Viasat.  The tasks view displays the basic information about a task and includes the description of the task, carrying out organization, service type, start and completion dates. If the task is completed, the Task_Completed_Flag column is indicated by a value of "Y". The task percent complete column is an estimate of the completion status of a task and is retrieved from the most recent estimate made by the task manager. This view also includes other relevant information about the project, top task and manager. If the work on the task is for a single customer, then the customer information is displayed, otherwise the columns are blank. To use this view, specify the project name or number. This view returns one row for each task within a project.',
       keywords = 'K{\footnote Task}K{\footnote Task Manager}',
       product_version = '10.6+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       export_view = 'Y',
       security_code = 'NONE',
       special_process_code = 'NONE',
       sort_layer = null,
       freeze_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS'),
       original_version = '1.0.0',
       current_version = '6.3.0.1255'
 WHERE upper(view_label) = 'PA_TASKS';


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
      'PA_Tasks',
      2.0,
      'Task_Creation_Date',
      'TASK',
      'CREATION_DATE',
      10.1,
      'COL',
      'Task creation date. Custom field added by Zensar.',
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
      'PA_Tasks',
      2.0,
      'Task_Created_By_User',
      null,
      '(SELECT TCB.USER_NAME FROM APPLSYS.FND_USER TCB WHERE TASK.CREATED_BY = TCB.USER_ID)',
      10.200001,
      'EXPR',
      'User who created the task. Custom field added by Zensar.',
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
      'PA_Tasks',
      2.0,
      18.0,
      'AND (PROJ.PROJECT_ID IN (SELECT PROJECT_ID FROM PAG0_USER_PROJECTS_VSAT_BASE WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID))',
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
WHENEVER SQLERROR EXIT 1334;

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'SERVICE_CONTRACTS',
      'PA_Tasks',
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
      'ORDER_ENTRY',
      'PA_Tasks',
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