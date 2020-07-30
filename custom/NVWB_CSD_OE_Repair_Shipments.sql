-- *******************************************************************************
-- FileName:             NVWB_CSD_OE_Repair_Shipments.sql
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
-- output to NVWB_CSD_OE_Repair_Shipments.lst file

@utlspon NVWB_CSD_OE_Repair_Shipments

-- *******************************************************************************
-- Revision Number: 10
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1330;

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
      'CSD_OE_Repair_Shipments',
      1.0,
      'WND',
      23.0,
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
      'CSD_OE_Repair_Shipments',
      1.0,
      'WDA',
      22.0,
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
      'CSD_OE_Repair_Shipments',
      1.0,
      'Original_Ship_Date',
      null,
      '(SELECT civ.attribute_value                     FROM CSI.csi_i_extended_attribs cea                         ,CSI.csi_iea_values civ                     WHERE cea.attribute_id=civ.attribute_id                         AND cea.attribute_code=''ORIGINAL_SHIP_DATE''                         and sysdate between cea.active_start_date and nvl(cea.active_end_date,sysdate)                         and sysdate between civ.active_start_date and nvl(civ.active_end_date,sysdate)                         and civ.instance_id=BASE.instance_id)',
      10.200001,
      'EXPR',
      'Original ship date. Custom field added by Zensar.',
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
      'N',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      'Waybill_Number',
      'WND',
      'WAYBILL',
      10.0,
      'COL',
      'Way bill number. Custom field added by Zensar.',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      'Line_Attachment_Text',
      null,
      '(SELECT fda.short_text              FROM apps.fnd_documents_short_text fda,                   apps.fnd_documents fd,                   apps.FND_ATTACHED_DOCUMENTS FAT             WHERE     fda.media_id = fd.media_id                   AND fd.document_id = fat.document_id                   AND fat.entity_name = ''OE_ORDER_LINES''                   AND ROWNUM = 1                   AND fat.pk1_value = TO_CHAR (ORDL.LINE_ID))',
      10.300001,
      'EXPR',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      'DDU250',
      'ORDL',
      'ATTRIBUTE9',
      10.1,
      'COL',
      'Descriptive flex field. Custom field added by Zensar.',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      'Repair_Line_ID',
      'RPRS',
      'REPAIR_LINE_ID',
      10.400002,
      'COL',
      'Repair line identifier. Custom field added by Zensar.',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      34.0,
      'AND PDTRX.PROD_TXN_STATUS <> ''CANCELLED''',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      36.0,
      'AND WDA.DELIVERY_DETAIL_ID (+) = WDD.DELIVERY_DETAIL_ID ',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      35.0,
      'AND ORDL.LINE_ID = ESTD.ORDER_LINE_ID',
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
      'CSD_OE_Repair_Shipments',
      1.0,
      37.0,
      'AND WND.DELIVERY_ID (+) = WDA.DELIVERY_ID',
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