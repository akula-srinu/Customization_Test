-- *******************************************************************************
-- FileName:             NVWB_PO_Requisition_Line_Pos.sql
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
-- output to NVWB_PO_Requisition_Line_Pos.lst file

@utlspon NVWB_PO_Requisition_Line_Pos

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1012;

UPDATE n_view_column_templates
   SET view_label = 'PO_Requisition_Line_Pos',
       query_position = 1.0,
       column_label = 'PO_Buying_Price',
       table_alias = null,
       column_expression = 'POLIN.QUANTITY*DECODE (              POLIN.LINE_TYPE_ID,              1081, DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999/POLIN.QUANTITY),              POLIN.UNIT_PRICE)',
       column_position = 20.0,
       column_type = 'EXPR',
       description = 'PO Buying Price (Unit price * Quantity) for the line in the entered/foreign currency. Field modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 4192;



UPDATE n_view_column_templates
   SET view_label = 'PO_Requisition_Line_Pos',
       query_position = 1.0,
       column_label = 'PO_Number',
       table_alias = 'POHDR',
       column_expression = 'SEGMENT1',
       column_position = 20.0,
       column_type = 'COL',
       description = 'PO Number. Field modified by Zensar.',
       ref_application_label = null,
       ref_table_name = null,
       key_view_label = null,
       ref_lookup_column_name = 'PO_HEADER_ID',
       ref_description_column_name = null,
       ref_lookup_type = null,
       id_flex_application_id = null,
       id_flex_code = null,
       group_by_flag = 'N',
       format_mask = null,
       format_class = 'STRING',
       gen_search_by_col_flag = 'N',
       lov_view_label = 'PO_Lov_PO_Numbers',
       lov_column_label = 'PO_Number',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 4204;



UPDATE n_view_column_templates
   SET view_label = 'PO_Requisition_Line_Pos',
       query_position = 1.0,
       column_label = 'PO_Unit_Price',
       table_alias = null,
       column_expression = ' DECODE (              PO_LINE_TYPE.LINE_TYPE,              ''Contingent Worker Labor_'', DECODE (              APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (                                                (SELECT USER_NAME                                                   FROM APPLSYS.FND_USER                                                  WHERE USER_ID = APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),                                             ''Y'', POLIN.UNIT_PRICE,                                             -9999),              POLIN.UNIT_PRICE)',
       column_position = 20.0,
       column_type = 'EXPR',
       description = 'PO Unit price for the line in the entered/foreign currency. Field  modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 4206;



UPDATE n_view_column_templates
   SET view_label = 'PO_Requisition_Line_Pos',
       query_position = 1.0,
       column_label = 'PO_Unit_Price_Base',
       table_alias = null,
       column_expression = 'DECODE ( LINE_TYPE.LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', (POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,GLSOB.CURRENCY_CODE,1,NULL)), -9999),(POLIN.UNIT_PRICE)*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,GLSOB.CURRENCY_CODE,1,NULL)))',
       column_position = 20.0,
       column_type = 'EXPR',
       description = 'PO Functional (base) currency value of PO_Unit_Price: PO Unit price for the line. Field modified by Zesnar for Viasat security requirements.',
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
 WHERE t_column_id = 4207;



UPDATE n_view_column_templates
   SET view_label = 'PO_Requisition_Line_Pos',
       query_position = 1.0,
       column_label = 'Unit_Price',
       table_alias = null,
       column_expression = 'DECODE ( LINE_TYPE.LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', NVL(RQLIN.CURRENCY_UNIT_PRICE,DECODE(RQLIN.CURRENCY_CODE,GLSOB.CURRENCY_CODE,RQLIN.UNIT_PRICE,NULL,RQLIN.UNIT_PRICE,NULL)), -9999),NVL(RQLIN.CURRENCY_UNIT_PRICE,DECODE(RQLIN.CURRENCY_CODE,GLSOB.CURRENCY_CODE,RQLIN.UNIT_PRICE,NULL,RQLIN.UNIT_PRICE,NULL)))',
       column_position = 63.0,
       column_type = 'EXPR',
       description = 'Requisition Unit price in functional currency. Field modified by Zensar for Viasat security requirements. Field modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 13248;



UPDATE n_view_column_templates
   SET view_label = 'PO_Requisition_Line_Pos',
       query_position = 1.0,
       column_label = 'Unit_Price_Base',
       table_alias = null,
       column_expression = 'DECODE ( LINE_TYPE.LINE_TYPE, ''Contingent Worker Labor_'', DECODE (APPS.XXNAO_NOETIX_VSAT_SECURITY_PKG.MASK_RATE (NOETIX_VSAT_UTILITY_PKG.GET_USER_NAME(APPS.XXNAO_FND_WRAPPER_PKG.USER_ID)),''Y'', RQLIN.UNIT_PRICE, -9999),RQLIN.UNIT_PRICE)',
       column_position = 63.0,
       column_type = 'EXPR',
       description = 'PO Functional (base) currency value of Unit_Price: Requisition Unit price in functional currency. Field modified by Zensar for Viasat security requirements.',
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
 WHERE t_column_id = 13249;



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
      'PO_Requisition_Line_Pos',
      1.0,
      'PO_Unit_Price_Orig',
      null,
      'NVL(POLIN.UNIT_PRICE,NULL)',
      10.1,
      'EXPR',
      'Custom Field added by zesnar.',
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
      'PO_Requisition_Line_Pos',
      1.0,
      'Unit_Price_Orig',
      null,
      'NVL(RQLIN.CURRENCY_UNIT_PRICE,DECODE(RQLIN.CURRENCY_CODE,GLSOB.CURRENCY_CODE,RQLIN.UNIT_PRICE,NULL,RQLIN.UNIT_PRICE,NULL))',
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
      'PO_Requisition_Line_Pos',
      1.0,
      'PO_Unit_Price_Base_Orig',
      null,
      'POLIN.UNIT_PRICE*NVL(POHDR.RATE,DECODE(POHDR.CURRENCY_CODE,GLSOB.CURRENCY_CODE,1,NULL))',
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
      'PO_Requisition_Line_Pos',
      1.0,
      'Unit_Price_Base_Orig',
      null,
      'NVL(RQLIN.UNIT_PRICE,NULL)',
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