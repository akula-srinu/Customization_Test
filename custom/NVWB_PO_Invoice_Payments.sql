-- *******************************************************************************
-- FileName:             NVWB_PO_Invoice_Payments.sql
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
-- output to NVWB_PO_Invoice_Payments.lst file

@utlspon NVWB_PO_Invoice_Payments

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1092;

UPDATE n_view_column_templates
   SET view_label = 'PO_Invoice_Payments',
       query_position = 1.0,
       column_label = 'PO_Line_Unit_Price',
       table_alias = null,
       column_expression = ' DECODE (              LINE_TYPE,              ''Contingent Worker Labor_'', DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999),              POLIN.UNIT_PRICE)',
       column_position = 98.0,
       column_type = 'EXPR',
       description = 'PO Line Unit price for the item in the entered/foreign currency. Do not summarize on this field.  It may be duplicated. Field modified by Zensar for Viasat security requirements.',
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
       format_class = 'NUMERIC REAL',
       gen_search_by_col_flag = 'N',
       lov_view_label = null,
       lov_column_label = null,
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 2338;



UPDATE n_view_column_templates
   SET view_label = 'PO_Invoice_Payments',
       query_position = 1.0,
       column_label = 'PO_Line_Unit_Price_Base',
       table_alias = null,
       column_expression = 'DECODE ( LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', (POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)), -9999),(POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)))',
       column_position = 98.0,
       column_type = 'EXPR',
       description = 'PO Functional (base) currency value of PO_Line_Unit_Price: PO Line Unit price for the item. Do not summarize on this field.  It may be duplicated. Field modified by Zensar for Viasat security requirem',
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
       format_class = 'NUMERIC REAL',
       gen_search_by_col_flag = 'N',
       lov_view_label = null,
       lov_column_label = null,
       profile_option = 'POMULTICUR',
       product_version = '10.5+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 2150;



UPDATE n_view_column_templates
   SET view_label = 'PO_Invoice_Payments',
       query_position = 1.0,
       column_label = 'Vendor_Name',
       table_alias = 'VEND',
       column_expression = 'VENDOR_NAME',
       column_position = 98.0,
       column_type = 'COL',
       description = 'Vendor Name. Field modified by Zensar.',
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
       lov_view_label = 'AP_Lov_Vendor_Name',
       lov_column_label = 'Vendor_Name',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 13071;



UPDATE n_view_column_templates
   SET view_label = 'PO_Invoice_Payments',
       query_position = 1.0,
       column_label = 'Vendor_Number',
       table_alias = 'VEND',
       column_expression = 'SEGMENT1',
       column_position = 98.0,
       column_type = 'COL',
       description = 'Vendor number. Field modified by Zensar.',
       ref_application_label = null,
       ref_table_name = null,
       key_view_label = null,
       ref_lookup_column_name = 'VENDOR_ID',
       ref_description_column_name = null,
       ref_lookup_type = null,
       id_flex_application_id = null,
       id_flex_code = null,
       group_by_flag = 'N',
       format_mask = null,
       format_class = 'STRING',
       gen_search_by_col_flag = 'N',
       lov_view_label = 'AP_Lov_Vendor_Number',
       lov_column_label = 'Vendor_Number',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 13072;



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
      'PO_Invoice_Payments',
      1.0,
      'PO_Line_Unit_Price_Base_Orig',
      null,
      'POLIN.UNIT_PRICE*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,XMAP.CURRENCY_CODE,1,NULL))',
      10.200001,
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
      'PO_Invoice_Payments',
      1.0,
      'PO_Line_Unit_Price_Orig',
      null,
      'NVL(POLIN.UNIT_PRICE,NULL)',
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