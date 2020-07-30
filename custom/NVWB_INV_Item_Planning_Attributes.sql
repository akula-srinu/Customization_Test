-- *******************************************************************************
-- FileName:             NVWB_INV_Item_Planning_Attributes.sql
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
-- output to NVWB_INV_Item_Planning_Attributes.lst file

@utlspon NVWB_INV_Item_Planning_Attributes

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1260;

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
      'INV_Item_Planning_Attributes',
      1.0,
      'Planning_Make_Buy_Code',
      null,
      '(SELECT PMBC.MEANING  FROM NOETIX_VIEWS.N_MFG_LOOKUPS_VL PMBC  WHERE ITEM.PLANNING_MAKE_BUY_CODE = PMBC.LOOKUP_CODE  AND PMBC.LOOKUP_TYPE = ''MTL_PLANNING_MAKE_BUY''  AND PMBC.LANGUAGE = NOETIX_ENV_PKG.GET_LANGUAGE)',
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






COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff