-- *******************************************************************************
-- FileName:             NVWB_MRP_Exception_Orders.sql
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
-- output to NVWB_MRP_Exception_Orders.lst file

@utlspon NVWB_MRP_Exception_Orders

-- *******************************************************************************
-- Revision Number: 3
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1033;

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
      'MRP_Exception_Orders',
      1.0,
      'POH2',
      22.0,
      'PO',
      'PO_HEADERS_ALL',
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
      'MRP_Exception_Orders',
      1.0,
      'BUYER',
      23.0,
      'HR',
      'PER_ALL_PEOPLE_F',
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
      'MRP_Exception_Orders',
      1.0,
      'PO_Buyer_Name',
      null,
      'DECODE(Order_Type.MEANING, ''Purchase order'', buyer.full_name, ''PO in receiving'', buyer.full_name,  PITEM.BUYER_NAME)',
      10.1,
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
      '*',
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
      'MRP_Exception_Orders',
      1.0,
      51.0,
      'AND MPO.Purchase_Order_Id = POH2.PO_Header_ID(+)',
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
      'MRP_Exception_Orders',
      1.0,
      52.0,
      'AND Buyer.PERSON_ID (+) = POH2.AGENT_ID    AND (POH2.AGENT_ID IS NULL         OR TO_CHAR(Buyer.EFFECTIVE_START_DATE, ''YYYYMMDDHH24MISS'') ||           TO_CHAR(Buyer.EFFECTIVE_END_DATE,''YYYYMMDDHH24MISS'') =           (SELECT MAX(TO_CHAR                      (HRSUB.EFFECTIVE_START_DATE, ''YYYYMMDDHH24MISS'') ||                TO_CHAR(HRSUB.EFFECTIVE_END_DATE,''YYYYMMDDHH24MISS''))              FROM HR.PER_ALL_PEOPLE_F  HRSUB             WHERE HRSUB.PERSON_ID = POH2.AGENT_ID))',
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