-- *******************************************************************************
-- FileName:             NVWB_PO_PO_Shipments.sql
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
-- output to NVWB_PO_PO_Shipments.lst file

@utlspon NVWB_PO_PO_Shipments

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 985;

UPDATE n_view_column_templates
   SET view_label = 'PO_PO_Shipments',
       query_position = 1.0,
       column_label = 'Buying_Price',
       table_alias = null,
       column_expression = 'POLIN.QUANTITY * DECODE (              POLIN.LINE_TYPE_ID,              1081, DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999/POLIN.QUANTITY),              POLIN.UNIT_PRICE)',
       column_position = 20.0,
       column_type = 'EXPR',
       description = 'Buying Price (Unit price * Quantity) for the line in the entered/foreign currency. Field modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 13130;



UPDATE n_view_column_templates
   SET view_label = 'PO_PO_Shipments',
       query_position = 1.0,
       column_label = 'Unit_Price',
       table_alias = null,
       column_expression = ' DECODE (              LINE_TYPE,              ''Contingent Worker Labor_'', DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999),              POLIN.UNIT_PRICE)',
       column_position = 20.0,
       column_type = 'EXPR',
       description = 'Unit price for the line in the entered/foreign currency. Field modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 410;



UPDATE n_view_column_templates
   SET view_label = 'PO_PO_Shipments',
       query_position = 1.0,
       column_label = 'Unit_Price_Base',
       table_alias = null,
       column_expression = 'DECODE ( LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', POLIN.UNIT_PRICE * NVL(POHDR.RATE, DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)), -9999),POLIN.UNIT_PRICE * NVL(POHDR.RATE, DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL)))',
       column_position = 20.0,
       column_type = 'EXPR',
       description = 'Unit price for the line in the functional (base) currency.',
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
 WHERE t_column_id = 411;



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
      'PO_PO_Shipments',
      1.0,
      'Unit_Price_Base_Orig',
      null,
      'POLIN.UNIT_PRICE * NVL(POHDR.RATE, DECODE(POHDR.CURRENCY_CODE,SOB.CURRENCY_CODE,1,NULL))',
      10.700003,
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
      'PO_PO_Shipments',
      1.0,
      'Manufacturer_Part_Num',
      null,
      '(NOETIX_VIEWS.NOETIX_VSAT_UTILITY_PKG.get_Manufact_part_num(item.inventory_item_id, item.organization_id))',
      10.400002,
      'EXPR',
      'Manufacturer Part Number',
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
      'dpagadala',
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
      'PO_PO_Shipments',
      1.0,
      'Supplier_Site_ID',
      'POHDR',
      'VENDOR_SITE_ID',
      10.800003,
      'COL',
      'Supplier site identifier. Custom Field added by Zensar.',
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
      'PO_PO_Shipments',
      1.0,
      'Lead_Time',
      'SHIPM',
      'LEAD_TIME',
      10.200001,
      'COL',
      'Lead Time Custom Field Added by Zensar',
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
      'dpagadala',
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
      'PO_PO_Shipments',
      1.0,
      'Actual_Unit_Proce_Orig',
      null,
      'NVL(SHIPM.PRICE_OVERRIDE,NULL)',
      10.500002,
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
      'PO_PO_Shipments',
      1.0,
      'Manufacturer_Name',
      null,
      '(NOETIX_VIEWS.NOETIX_VSAT_UTILITY_PKG.get_Manufacturer_name(item.inventory_item_id, item.organization_id))',
      10.300001,
      'EXPR',
      'Manufacturer name. Custom Field Added by Zensar.',
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
      'PO_PO_Shipments',
      1.0,
      'Actual_Unit_Price',
      null,
      'DECODE ( LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', SHIPM.PRICE_OVERRIDE, -9999),SHIPM.PRICE_OVERRIDE)',
      10.1,
      'EXPR',
      'Actual Unit Price Custom Field Added by Zensar. Field modified by Viasat security requirements.',
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
      'dpagadala',
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
      'PO_PO_Shipments',
      1.0,
      'Unit_Price_Orig',
      null,
      'NVL(POLIN.UNIT_PRICE,NULL)',
      10.600002,
      'EXPR',
      'Custom field added by Zensar.',
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