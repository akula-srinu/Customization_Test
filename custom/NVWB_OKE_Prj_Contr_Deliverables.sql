-- *******************************************************************************
-- FileName:             NVWB_OKE_Prj_Contr_Deliverables.sql
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
-- output to NVWB_OKE_Prj_Contr_Deliverables.lst file

@utlspon NVWB_OKE_Prj_Contr_Deliverables

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1046;

UPDATE n_view_templates 
   SET application_label = 'OKE',
       description = 'OKE Basic - Deliverable line information',
       profile_option = 'OKE_1159_ONWARDS',
       essay = 'This view is modified for applying the custom security requirements for Viasat.  This view returns information of deliverable line and the associated projects (if any), of the project contracts. This information was supplied in the Deliverables Tracking System window of the Project Contracts module in Oracle E-Business suite. A record is returned for each combination of a contract number, contract type and line number and deliverable line number. Use this view for getting information about contracts that are associated with the project. Use this view to track the current status of contracts. This view returns contract details like contract number, type and status. The view provides information of deliverable lines such as deliverable number, status, start date, end date, quantity. The view also provides details about the project, and tasks. The Default_Deliverable_Flag column indicates whether the deliverable line is the default one or not. The Subcontracted_Flag column indicates whether or not the manufacturing of an item is subcontracted. The Drop_Ship_Flag column indicates whether or not the item can be drop-shipped. Billable_Flag column indicates whether or not the line can be billed. Hold_Flag column indicates whether or not the contract is on hold. For optimal performance, filter the records by the Contract_Number, Contract_Line_Number, and Deliverable_Number columns.',
       keywords = 'K{\footnote Deliverable}K{\footnote Contract Lines}K{\footnote Project Contracts}',
       product_version = '11.5+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       export_view = 'Y',
       security_code = 'NONE',
       special_process_code = 'NONE',
       sort_layer = null,
       freeze_flag = 'N',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2014-11-19 04:45:34','YYYY-MM-DD HH24:MI:SS'),
       original_version = '5.7.1.383',
       current_version = '5.7.1.383'
 WHERE upper(view_label) = 'OKE_PRJ_CONTR_DELIVERABLES';


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
      'OKE_Prj_Contr_Deliverables',
      1.0,
      'Customer_Number',
      'CACT',
      'ACCOUNT_NUMBER',
      10.1,
      'COL',
      'Customer number. Custom Field added by Zensar.',
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
      'OKE_Prj_Contr_Deliverables',
      1.0,
      40.0,
      'AND (PROJ.PROJECT_ID IN (SELECT PROJECT_ID FROM PAG0_USER_PROJECTS_VSAT_BASE WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID))',
      null,
      null,
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
      'OKE_Prj_Contr_Deliverables',
      2.0,
      'Customer_Number',
      'CACT',
      'ACCOUNT_NUMBER',
      10.1,
      'COL',
      'Customer number. Custom Field added by Zensar.',
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
      'OKE_Prj_Contr_Deliverables',
      2.0,
      52.0,
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