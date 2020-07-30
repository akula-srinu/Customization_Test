-- *******************************************************************************
-- FileName:             NVWB_PB_Revenue_Budgets.sql
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
-- output to NVWB_PB_Revenue_Budgets.lst file

@utlspon NVWB_PB_Revenue_Budgets

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1078;

UPDATE n_view_templates 
   SET application_label = 'PB',
       description = 'PB Value Added - Revenue Budget by Project/Task/Revenue Category',
       profile_option = null,
       essay = 'This view is modified for applying the custom security requirements for Viasat.  The revenue budgets view summarizes the current baselined revenue budget amounts for a project and its tasks. It shows the revenue budgets for both summary (project/task) and detail (resource) levels. For each task, the revenue budgeted for the task is indicated (Revenue_Budget), and is rolled up from budgets at lower level tasks (Rollup_Revenue_Budget) for the period which the budget has been defined. For detailed budgets, these amounts are shown along with their corresponding resources against which they are budgeted. If nothing was budgeted at lower level tasks, the budgeted revenue amount is shown as zero. A summary of the revenue budget at the project level is indicated by a blank value at the task related columns. Each combination of project, task (and resource name, if the project has a detailed budget) is reported separately. This view returns one row for the budget type, project, task (both parent and child) and resource that has been budgeted. To use this view, specify the project number and budget type.',
       keywords = 'K{\footnote Task Level Budget}K{\footnote Project Level Budget}K{\footnote Revenue Budget}',
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
       current_version = '6.0.0.849'
 WHERE upper(view_label) = 'PB_REVENUE_BUDGETS';


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
      'PB_Revenue_Budgets',
      3.0,
      49.0,
      'AND (PROJ.PROJECT_ID IN (SELECT PROJECT_ID FROM PAG0_USER_PROJECTS_VSAT_BASE WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID))',
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
      'PB_Revenue_Budgets',
      4.0,
      29.0,
      'AND (PROJ.PROJECT_ID IN (SELECT PROJECT_ID FROM PAG0_USER_PROJECTS_VSAT_BASE WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID))',
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
      'PB_Revenue_Budgets',
      4.1,
      28.0,
      'AND (PROJ.PROJECT_ID IN (SELECT PROJECT_ID FROM PAG0_USER_PROJECTS_VSAT_BASE WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID))',
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
      'PB_Revenue_Budgets',
      5.0,
      56.0,
      'AND (PROJ.PROJECT_ID IN (SELECT PROJECT_ID FROM PAG0_USER_PROJECTS_VSAT_BASE WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID))',
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
      'PB_Revenue_Budgets',
      6.0,
      22.0,
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

@utlspoff