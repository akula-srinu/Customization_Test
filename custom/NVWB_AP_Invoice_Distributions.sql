-- *******************************************************************************
-- FileName:             NVWB_AP_Invoice_Distributions.sql
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
-- output to NVWB_AP_Invoice_Distributions.lst file

@utlspon NVWB_AP_Invoice_Distributions

-- *******************************************************************************
-- Revision Number: 3
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 918;

UPDATE n_view_column_templates
   SET view_label = 'AP_Invoice_Distributions',
       query_position = 4.0,
       column_label = 'Period_Name',
       table_alias = 'IDSTR',
       column_expression = 'PERIOD_NAME',
       column_position = 11.0,
       column_type = 'COL',
       description = 'Period name. Field Modified by Zensar.',
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
       lov_view_label = 'AP_Lov_GL_Periods',
       lov_column_label = 'Period_Name',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 86026;



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
      'AP_Invoice_Distributions',
      4.0,
      'Last_Check_Date',
      null,
      '                    (select min(chk.check_date)  from AP.AP_INVOICE_PAYMENTS_ALL INPAY,                     AP.AP_CHECKS_ALL CHK where INPAY.CHECK_ID = chk.check_id and inpay.invoice_id = inv.invoice_id)',
      10.1,
      'EXPR',
      'Check date of the last payment. Custom filed added by Zensar.',
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
      '12.0+',
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
      'AP_Invoice_Distributions',
      6.0,
      'Last_Check_Date',
      null,
      '                    (select min(chk.check_date)  from AP.AP_INVOICE_PAYMENTS_ALL INPAY,                     AP.AP_CHECKS_ALL CHK where INPAY.CHECK_ID = chk.check_id and inpay.invoice_id = inv.invoice_id)',
      10.1,
      'EXPR',
      'Check date of the last payment. Custom filed added by Zensar.',
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
      '12.0+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff