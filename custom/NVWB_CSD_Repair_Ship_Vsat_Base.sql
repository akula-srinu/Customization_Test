-- *******************************************************************************
-- FileName:             NVWB_CSD_Repair_Ship_Vsat_Base.sql
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
-- output to NVWB_CSD_Repair_Ship_Vsat_Base.lst file

@utlspon NVWB_CSD_Repair_Ship_Vsat_Base

-- *******************************************************************************
-- Revision Number: 2
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1126;

INSERT INTO n_view_templates(
      view_label,
      application_label,
      description,
      profile_option,
      essay,
      keywords,
      product_version,
      include_flag,
      user_include_flag,
      export_view,
      security_code,
      special_process_code,
      sort_layer,
      freeze_flag,
      created_by,
      last_updated_by,
      original_version,
      current_version
  ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      'CSD',
      null,
      null,
      null,
      null,
      '%',
      'Y',
      'Y',
      'Y',
      'NONE',
      'BASEVIEW',
      '0',
      'N',
      'nemuser',
      'nemuser',
      null,
      null
  );

INSERT INTO n_view_query_templates(
      view_label,
      query_position,
      union_minus_intersection,
      group_by_flag,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      view_comment,
      created_by,
      last_updated_by
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      null,
      'N',
      null,
      '%',
      'Y',
      'Y',
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'ITEM',
      8.0,
      'INV',
      'MTL_SYSTEM_ITEMS_B',
      null,
      '%',
      'Y',
      'Y',
      'Y',
      null,
      'N',
      'nemuser',
      'nemuser',
      'Y'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'PDTRX',
      7.0,
      'CSD',
      'CSD_PRODUCT_TRANSACTIONS',
      null,
      '%',
      'Y',
      'Y',
      'Y',
      null,
      'N',
      'nemuser',
      'nemuser',
      'Y'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'WDA',
      2.0,
      'WSH',
      'WSH_DELIVERY_ASSIGNMENTS',
      null,
      '%',
      'Y',
      'Y',
      'N',
      null,
      'N',
      'nemuser',
      'nemuser',
      'N'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'SBASE',
      9.0,
      'CSD',
      'CSD_SERVICE_REQUEST_BASE',
      null,
      '%',
      'Y',
      'Y',
      'Y',
      null,
      'N',
      'nemuser',
      'nemuser',
      'Y'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'WND',
      1.0,
      'WSH',
      'WSH_NEW_DELIVERIES',
      null,
      '%',
      'Y',
      'Y',
      'N',
      null,
      'N',
      'nemuser',
      'nemuser',
      'N'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'ORDH',
      5.0,
      'OE',
      'OE_ORDER_HEADERS_ALL',
      null,
      '%',
      'Y',
      'Y',
      'N',
      null,
      'N',
      'nemuser',
      'nemuser',
      'N'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'WDD',
      3.0,
      'WSH',
      'WSH_DELIVERY_DETAILS',
      null,
      '%',
      'Y',
      'Y',
      'N',
      null,
      'N',
      'nemuser',
      'nemuser',
      'N'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'ESTD',
      6.0,
      'CS',
      'CS_ESTIMATE_DETAILS',
      null,
      '%',
      'Y',
      'Y',
      'N',
      null,
      'N',
      'nemuser',
      'nemuser',
      'N'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'RPRS',
      10.0,
      'CSD',
      'CSD_REPAIRS',
      null,
      '%',
      'Y',
      'Y',
      'Y',
      null,
      'N',
      'nemuser',
      'nemuser',
      'Y'
   );

INSERT INTO n_view_table_templates(
      view_label,
      query_position,
      table_alias,
      from_clause_position,
      application_label,
      table_name,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      base_table_flag,
      key_view_label,
      subquery_flag,
      created_by,
      last_updated_by,
      gen_search_by_col_flag
   ) VALUES (
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'ORDL',
      4.0,
      'OE',
      'OE_ORDER_LINES_ALL',
      null,
      '%',
      'Y',
      'Y',
      'N',
      null,
      'N',
      'nemuser',
      'nemuser',
      'N'
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Repair_Line_Id',
      'RPRS',
      'repair_line_id',
      5.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Unit_Selling_Price',
      'ORDL',
      'unit_selling_price',
      8.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Delivery_Scheduled_Date',
      'WDD',
      'DATE_SCHEDULED',
      10.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Waybill_Number',
      'WND',
      'waybill',
      3.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Ship_To_Address1',
      'SBASE',
      'ship_to_address1',
      9.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Repair_Number',
      'RPRS',
      'repair_number',
      6.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Item_Number',
      'ITEM',
      'segment1',
      4.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Source_Serial_Number',
      'PDTRX',
      'source_serial_number',
      1.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Order_Number',
      'ORDH',
      'order_number',
      7.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      'Subinventory_Name',
      'PDTRX',
      'sub_inventory',
      2.0,
      'COL',
      null,
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
      '%',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      4.0,
      'and pdtrx.action_type = ''SHIP''',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      1.0,
      'AND 1 = 1',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      11.0,
      'and pdtrx.prod_txn_status <> ''CANCELLED''',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      3.0,
      'and pdtrx.repair_line_id = rprs.repair_line_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      9.0,
      'and ordh.header_id (+) = estd.order_header_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      17.0,
      'and ordl.line_id = estd.order_line_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      14.0,
      'and wdd.source_header_id (+) = ordl.header_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      5.0,
      'and estd.estimate_detail_id = pdtrx.estimate_detail_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      10.0,
      'and ordl.header_id (+) = ordh.header_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      8.0,
      'and item.organization_id = noetix_service_pkg.get_item_val_org_id (                     estd.inventory_item_id)',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      15.0,
      'and wda.delivery_detail_id (+) = wdd.delivery_detail_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      2.0,
      'and sbase.incident_id = rprs.incident_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      12.0,
      'and n_sec_manager_mdsec_pkg.check_sr_access (                  ''CSD'',                  sbase.incident_type_id) = 1',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      7.0,
      'and item.inventory_item_id = estd.inventory_item_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      16.0,
      'and wnd.delivery_id (+) = wda.delivery_id',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      6.0,
      'and estd.source_code = ''DR''',
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
      'CSD_Repair_Ship_Vsat_Base',
      1.0,
      13.0,
      'and wdd.source_line_id (+) = ordl.line_id',
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
WHENEVER SQLERROR EXIT 1126;

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'DEPOT_REPAIR',
      'CSD_Repair_Ship_Vsat_Base',
      '%',
      null,
      null,
      'nemuser',
      'nemuser'
   );


COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff