-- *******************************************************************************
-- FileName:             NVWB_INV_Items.sql
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
-- output to NVWB_INV_Items.lst file

@utlspon NVWB_INV_Items

-- *******************************************************************************
-- Revision Number: 3
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 903;

UPDATE n_view_column_templates
   SET view_label = 'INV_Items',
       query_position = 1.0,
       column_label = 'ItemCat',
       table_alias = 'CAT',
       column_expression = 'CATEGORY_ID',
       column_position = 7.0,
       column_type = 'SEG',
       description = 'Inventory category.  This category is associated with the category set assigned to Inventory.',
       ref_application_label = 'INV',
       ref_table_name = 'MTL_CATEGORIES_B',
       key_view_label = null,
       ref_lookup_column_name = 'CATEGORY_ID',
       ref_description_column_name = null,
       ref_lookup_type = null,
       id_flex_application_id = '401',
       id_flex_code = 'MCAT',
       group_by_flag = 'N',
       format_mask = null,
       format_class = 'STRING',
       gen_search_by_col_flag = 'N',
       lov_view_label = 'INV_Lov_Item_Category_Flexs',
       lov_column_label = 'ItemCat',
       profile_option = null,
       product_version = '*',
       include_flag = 'Y',
       user_include_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-06-20 05:51:03','YYYY-MM-DD HH24:MI:SS')
 WHERE t_column_id = 4799;


DELETE 
  FROM n_view_property_templates
  WHERE t_view_property_id = 4592;

INSERT INTO n_view_property_templates(
      view_label,
      query_position,
      property_type_id,
      t_source_pk_id,
      value1,
      value2,
      value3,
      value4,
      value5,
      profile_option,
      product_version,
      include_flag,
      user_include_flag,
      version_id,
      created_by,
      last_updated_by
   ) VALUES (
      'INV_Items',
      1.0,
      16,
      4799,
      null,
      null,
      '1',
      null,
      null,
      null,
      '*',
      'Y',
      null,
      null,
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
      'INV_Items',
      1.0,
      'Item_Creation_Date',
      'ITEM',
      'CREATION_DATE',
      10.200001,
      'COL',
      'Creation date of the item.Custom Field Added by Zensar.',
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
      'INV_Items',
      1.0,
      'Serial_Control_Type',
      null,
      ' (SELECT FNDLV.MEANING            FROM APPLSYS.FND_LOOKUP_VALUES FNDLV          WHERE ITEM.SERIAL_NUMBER_CONTROL_CODE = FNDLV.LOOKUP_CODE                AND FNDLV.LOOKUP_TYPE = ''MTL_SERIAL_NUMBER'')',
      10.300001,
      'EXPR',
      'Serial Control Type, Custom Field Added By Zensar',
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
      'INV_Items',
      1.0,
      'Receiving_Routing_ID',
      'ITEM',
      'RECEIVING_ROUTING_ID',
      10.1,
      'COL',
      'Receiving routing identifier. Custom Field Added by Zensar.',
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
      'INV_Items',
      1.0,
      'Source_Vendor',
      null,
      '(SELECT POV.VENDOR_NAME           FROM PO.PO_HEADERS_ALL POH,                AP.AP_SUPPLIERS POV,                INV.MTL_TRANSACTION_LOT_NUMBERS MTLN          WHERE     POH.VENDOR_ID = POV.VENDOR_ID                AND POH.PO_HEADER_ID = MTLN.TRANSACTION_SOURCE_ID                AND ITEM.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID                AND ITEM.ORGANIZATION_ID = MTLN.ORGANIZATION_ID                AND ROWNUM = 1)',
      10.500002,
      'EXPR',
      'Source Vendor, Custom Field Added BY Zensar',
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
      'INV_Items',
      1.0,
      'Source_PO',
      null,
      '(SELECT POH.SEGMENT1           FROM PO.PO_HEADERS_ALL POH, INV.MTL_TRANSACTION_LOT_NUMBERS MTLN          WHERE     POH.PO_HEADER_ID = MTLN.TRANSACTION_SOURCE_ID                AND ITEM.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID                AND ITEM.ORGANIZATION_ID = MTLN.ORGANIZATION_ID                AND ROWNUM = 1)',
      10.600002,
      'EXPR',
      'Source PO, Custom Field Added BY Zensar',
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
      'INV_Items',
      1.0,
      'Purchasing_Cat_Code',
      null,
      ' (DECODE (            CAT.STRUCTURE_ID,            1, CAT.SEGMENT1 || ''.'' || CAT.SEGMENT2,            2, CAT.SEGMENT1,            3, CAT.SEGMENT1,            4, CAT.SEGMENT1,            5, CAT.SEGMENT1,            6, CAT.SEGMENT1,            101,    CAT.SEGMENT3                 || ''.''                 || CAT.SEGMENT6                 || ''.''                 || CAT.SEGMENT10                 || ''.''                 || CAT.SEGMENT15,            201, CAT.SEGMENT1 || ''.'' || CAT.SEGMENT6,            50136,    CAT.SEGMENT1                   || ''.''                   || CAT.SEGMENT2                   || ''.''                   || CAT.SEGMENT3                   || ''.''                   || CAT.SEGMENT5,            50165, CAT.SEGMENT1,            50166, CAT.SEGMENT1,            50183, CAT.SEGMENT2 || ''.'' || CAT.SEGMENT6 || ''.'' || CAT.SEGMENT11,            50184, CAT.SEGMENT1 || ''.'' || CAT.SEGMENT15 || ''.'' || CAT.SEGMENT20,            50185,    CAT.SEGMENT1                   || ''.''                   || CAT.SEGMENT5                   || ''.''                   || CAT.SEGMENT10                   || ''.''                   || CAT.SEGMENT15,            50230, CAT.SEGMENT1 || ''.'' || CAT.SEGMENT2,            50231, CAT.SEGMENT1,            50257,    CAT.SEGMENT1                   || ''.''                   || CAT.SEGMENT2                   || ''.''                   || CAT.SEGMENT3                   || ''.''                   || CAT.SEGMENT4,            50258, CAT.SEGMENT1,            50282, CAT.SEGMENT1,            50518, CAT.SEGMENT1 || ''.'' || CAT.SEGMENT2 || ''.'' || CAT.SEGMENT3,            50558, CAT.SEGMENT1,            50562, CAT.SEGMENT1 || ''.'' || CAT.SEGMENT2,            50563, CAT.SEGMENT1,            NULL))',
      10.400002,
      'EXPR',
      'Purchasing Category Code, Custom Field Added By Zensar',
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
      'N',
      'nemuser',
      'nemuser'
   );






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff