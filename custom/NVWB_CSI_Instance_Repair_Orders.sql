-- *******************************************************************************
-- FileName:             NVWB_CSI_Instance_Repair_Orders.sql
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
-- output to NVWB_CSI_Instance_Repair_Orders.lst file

@utlspon NVWB_CSI_Instance_Repair_Orders

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1293;

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
      'CSI_Instance_Repair_Orders',
      1.0,
      'Customer_Delivery_Date',
      null,
      '(SELECT civ.attribute_value FROM CSI.csi_i_extended_attribs cea, CSI.csi_iea_values civ WHERE cea.attribute_id = civ.attribute_id AND cea.attribute_code =''CUSTOMER_DELIVERY_DATE'' AND SYSDATE BETWEEN cea.active_start_date AND NVL (cea.active_end_date, SYSDATE) AND SYSDATE BETWEEN civ.active_start_date AND NVL (civ.active_end_date, SYSDATE) AND civ.instance_id = BASE.instance_id and rownum=1) ',
      10.1,
      'EXPR',
      'Customer delivery date. Custom field added by Zensar.',
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