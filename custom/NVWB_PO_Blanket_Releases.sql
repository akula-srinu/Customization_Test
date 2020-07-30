-- *******************************************************************************
-- FileName:             NVWB_PO_Blanket_Releases.sql
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
-- output to NVWB_PO_Blanket_Releases.lst file

@utlspon NVWB_PO_Blanket_Releases

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1087;

UPDATE n_view_templates 
   SET application_label = 'PO',
       description = 'PO Basic - Shipments released on Blanket Purchase Order',
       profile_option = null,
       essay = 'CAUTION: Please use the POG0_Release_Shipments view instead of POG0_Blanket_Releases.   The Blanket Releases view shows what has been released on a blanket Purchase Order.  A release may involve a number of shipment lines: each of these shipments appears as a separate row in this view. The Purchase Order Number and Vendor define the blanket Purchase Order.  The Release Number differentiates releases on different Release Dates.  The shipment line detail includes the Item, Agreed and Actual Unit Price, and Quantity Released.  The Agreed Quantity from the Blanket PO appear once for each Blanket PO Line;  subsequent shipments released for the same Blanket PO Line display zero for Agreed Quantity. This unusual behavior is designed to give the right totals when the Agreed Quantity and Quantity Released are summed.',
       keywords = 'K{\footnote Blanket Purchase Orders}K{\footnote Release of Blanket PO}',
       product_version = '10.0+',
       include_flag = 'Y',
       user_include_flag = 'Y',
       export_view = 'Y',
       security_code = 'NONE',
       special_process_code = 'XOPORG',
       sort_layer = null,
       freeze_flag = 'Y',
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-21 04:30:37','YYYY-MM-DD HH24:MI:SS'),
       original_version = '1.0.0',
       current_version = '6.3.0.1255'
 WHERE upper(view_label) = 'PO_BLANKET_RELEASES';


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
      'PO_Blanket_Releases',
      1.0,
      'PO_Line_Location_ID',
      'SHIP',
      'LINE_LOCATION_ID',
      10.200001,
      'COL',
      'PO line location identifier. Custom Field added by Zensar.',
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
      'PO_Blanket_Releases',
      1.0,
      'Release_ID',
      'REL',
      'PO_RELEASE_ID',
      10.1,
      'COL',
      'PO release identifier. Custom Field added by Zensar.',
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
SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1087;

DELETE 
   FROM n_role_view_templates
  WHERE upper(role_label) = 'PURCHASING'
    AND upper(view_label) = 'PO_BLANKET_RELEASES'
   AND REPLACE(NVL(TRIM(product_version),'*'),'%','*') =  NVL(TRIM('*'),'*');

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'PURCHASING',
      'PO_Blanket_Releases',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );


COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff