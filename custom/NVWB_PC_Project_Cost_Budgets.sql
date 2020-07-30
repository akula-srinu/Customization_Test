-- *******************************************************************************
-- FileName:             NVWB_PC_Project_Cost_Budgets.sql
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
-- output to NVWB_PC_Project_Cost_Budgets.lst file

@utlspon NVWB_PC_Project_Cost_Budgets

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1079;

UPDATE n_view_templates 
   SET application_label = 'PC',
       description = 'PC Value Added - Cost Budgets per Project',
       profile_option = null,
       essay = 'This view is modified for applying the custom security requirements for Viasat.  The project cost budgets view displays the current baselined budget for the cost and labor hours summarized for the project. The amount of detail shown in the view depends upon how the budgeting was done.    For budgets defined at the project or task (summary), all the costs and hours are summed up to the project. If the budgeting was done at the resource level (detail), then all the costs and hours are summed up to the individual resources for that project. These resources could be the budget organization, expenditure category, expenditure type, job etc.   This view returns one row for each project (and or resource). To use this view, specify the project number.',
       keywords = 'K{\footnote Project}K{\footnote Cost}K{\footnote Budgets}K{\footnote Cost Budgets}K{\footnote Budgets By Project}K{\footnote Cost Budgets By Project}',
       product_version = '10.6+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       export_view = 'Y',
       security_code = 'NONE',
       special_process_code = 'XOPORG',
       sort_layer = null,
       freeze_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS'),
       original_version = '1.0.0',
       current_version = '6.4.1.1417'
 WHERE upper(view_label) = 'PC_PROJECT_COST_BUDGETS';


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
      'PC_Project_Cost_Budgets',
      5.0,
      102.0,
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
      'PC_Project_Cost_Budgets',
      5.1,
      49.0,
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