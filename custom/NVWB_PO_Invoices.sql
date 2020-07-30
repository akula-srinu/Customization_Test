-- *******************************************************************************
-- FileName:             NVWB_PO_Invoices.sql
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
-- output to NVWB_PO_Invoices.lst file

@utlspon NVWB_PO_Invoices

-- *******************************************************************************
-- Revision Number: 5
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1275;

UPDATE n_view_column_templates
   SET view_label = 'PO_Invoices',
       query_position = 2.0,
       column_label = 'PO_Line_Amount',
       table_alias = null,
       column_expression = '(CASE       WHEN POLIN.MATCHING_BASIS=''QUANTITY'' AND POHDR.TYPE_LOOKUP_CODE=''STANDARD''                  THEN NVL (POLIN.QUANTITY, 1) * DECODE (              POLIN.LINE_TYPE_ID,              1081, DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999/NVL (POLIN.QUANTITY, 1)),              POLIN.UNIT_PRICE)       WHEN POLIN.MATCHING_BASIS=''AMOUNT'' AND POHDR.TYPE_LOOKUP_CODE=''STANDARD''                  THEN DECODE (              POLIN.LINE_TYPE_ID,              1081, DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.AMOUNT,                                             -9999),              POLIN.AMOUNT)       WHEN POLIN.MATCHING_BASIS=''QUANTITY'' AND POHDR.TYPE_LOOKUP_CODE=''BLANKET''                  THEN DECODE (              POLIN.LINE_TYPE_ID,              1081, DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999/SHIPM.QUANTITY),              POLIN.UNIT_PRICE)*SHIPM.QUANTITY            ELSE 0         END           )',
       column_position = 65.0,
       column_type = 'EXPR',
       description = 'Purchasing Document Line Amount in the entered/foreign currency (Unit Price * PO Line Quantity). Do not summarize on this field.  It may be duplicated. Field modified by Zensar for Viasat security.',
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
       format_class = 'NUMERIC AMOUNT',
       gen_search_by_col_flag = 'N',
       lov_view_label = null,
       lov_column_label = null,
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 33384;



UPDATE n_view_column_templates
   SET view_label = 'PO_Invoices',
       query_position = 2.0,
       column_label = 'PO_Line_Unit_Price',
       table_alias = null,
       column_expression = ' DECODE (              LINE_TYPE,              ''Contingent Worker Labor_'', DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999),              POLIN.UNIT_PRICE)',
       column_position = 114.0,
       column_type = 'EXPR',
       description = 'Unit price for purchase order line items in the entered/transaction currency. Field modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 95093;



UPDATE n_view_column_templates
   SET view_label = 'PO_Invoices',
       query_position = 2.0,
       column_label = 'PO_Line_Unit_Price_Base',
       table_alias = null,
       column_expression = 'DECODE ( LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', (POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)), -9999),(POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)))',
       column_position = 113.0,
       column_type = 'EXPR',
       description = 'Accounting/functional currency value of unit price for purchase order line items. Field modified by Zensar for Viasat security requirements.',
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
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 95094;



UPDATE n_view_column_templates
   SET view_label = 'PO_Invoices',
       query_position = 2.0,
       column_label = 'PO_Unit_Price',
       table_alias = null,
       column_expression = 'NVL(IDSTR.UNIT_PRICE, DECODE (              POLIN.LINE_TYPE_ID,              1081, DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999),              POLIN.UNIT_PRICE))',
       column_position = 114.0,
       column_type = 'EXPR',
       description = 'PO Unit price for purchase order matched invoice items in the entered/foreign currency.  You can summarize on this field when multiplied by Quantity_Invoiced. Field modified by Zensar.',
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
       last_update_date = TO_DATE('2016-05-21 14:35:20','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 33429;



UPDATE n_view_column_templates
   SET view_label = 'PO_Invoices',
       query_position = 2.0,
       column_label = 'PO_Unit_Price_Base',
       table_alias = null,
       column_expression = 'DECODE ( LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', (POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)), -9999),(POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)))',
       column_position = 113.0,
       column_type = 'EXPR',
       description = 'Functional (base) currency value of PO_Unit_Price : Unit price for purchase order matched invoice items.  You can summarize on this field when multiplied by Quantity_Invoiced. Field modified by Zensar',
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
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 14:34:30','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 95095;



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
      'PO_Invoices',
      2.0,
      'PO_Unit_Price_Base_Orig',
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
      'PO_Invoices',
      2.0,
      'PO_Line_Unit_Price_Orig',
      null,
      'NVL(POLIN.UNIT_PRICE,NULL)',
      10.300001,
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
      'PO_Invoices',
      2.0,
      'PO_Unit_Price_Orig',
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
      'PO_Invoices',
      2.0,
      'PO_Line_Unit_Price_Base_Orig',
      null,
      'POLIN.UNIT_PRICE*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,XMAP.CURRENCY_CODE,1,NULL))',
      10.400002,
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
      '11.5+',
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff