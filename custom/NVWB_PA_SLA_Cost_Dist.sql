-- *******************************************************************************
-- FileName:             NVWB_PA_SLA_Cost_Dist.sql
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
-- output to NVWB_PA_SLA_Cost_Dist.lst file

@utlspon NVWB_PA_SLA_Cost_Dist

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1074;

UPDATE n_view_column_templates
   SET view_label = 'PA_SLA_Cost_Dist',
       query_position = 1.0,
       column_label = 'Burdened_Cost',
       table_alias = null,
       column_expression = 'DECODE(INSTR(UPPER(EXPI.EXPENDITURE_TYPE),''LABOR''), 0, NVL(CDIST.ACCT_BURDENED_COST,0) ,                          DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.VIEW_COST(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID),''Y'', NVL(CDIST.ACCT_BURDENED_COST,0) , -9999))',
       column_position = 71.0,
       column_type = 'EXPR',
       description = 'Burdened cost in accounting currency. Field modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 137802;



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
      'PA_SLA_Cost_Dist',
      1.0,
      'Burdened_Cost_Orig',
      null,
      'NVL(CDIST.ACCT_BURDENED_COST,0) ',
      10.1,
      'EXPR',
      'Custom Field added by Zensar.',
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