-- *******************************************************************************
-- FileName:             NVWB_CSD_Repair_Order_Notes_Vsat_PK.sql
--
-- Date Created:         2019/Aug/28 06:12:40
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
-- output to NVWB_CSD_Repair_Order_Notes_Vsat_PK.lst file

@utlspon NVWB_CSD_Repair_Order_Notes_Vsat_PK

-- *******************************************************************************
-- Revision Number: 9
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1215;

INSERT INTO n_join_key_templates(
      view_label,
      key_name,
      description,
      join_key_context_code,
      key_type_code,
      column_type_code,
      outerjoin_flag,
      outerjoin_direction_code,
      key_rank,
      pl_ref_pk_view_name_modifier,
      pl_rowid_col_name_modifier,
      key_cardinality_code,
      referenced_pk_t_join_key_id,
      product_version,
      profile_option,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'CSD_Repair_Order_Notes_Vsat',
      'ROWID_PK',
      'ROWID_PK',
      'NONE',
      'PK',
      'ROWID',
      null,
      null,
      1,
      null,
      null,
      '1',
      null,
      '*',
      null,
      'Y',
      null,
      'NOETIX',
      '6.3 JOIN KEY CONVERSION'
   );

INSERT INTO n_join_key_col_templates(
      t_join_key_id,
      t_column_position,
      column_label,
      kff_table_pk_column_name,
      created_by,
      last_updated_by
   ) VALUES (
      (SELECT t.t_join_key_id
   FROM n_join_key_templates t
  WHERE t.view_label               = 'CSD_Repair_Order_Notes_Vsat'
    AND t.key_name                 = 'ROWID_PK'),
      1,
      'RPRS$CSD_Repair_Order_Notes_V',
      null,
      'NOETIX',
      '6.3 JOIN KEY CONVERSION'
   );



INSERT INTO n_join_key_templates(
      view_label,
      key_name,
      description,
      join_key_context_code,
      key_type_code,
      column_type_code,
      outerjoin_flag,
      outerjoin_direction_code,
      key_rank,
      pl_ref_pk_view_name_modifier,
      pl_rowid_col_name_modifier,
      key_cardinality_code,
      referenced_pk_t_join_key_id,
      product_version,
      profile_option,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'CSD_Repair_Order_Notes_Vsat',
      'PK_CONT_LINE',
      'Primary key on contract_line_id.',
      'NONE',
      'PK',
      'COL',
      null,
      null,
      1,
      null,
      null,
      '1',
      null,
      '*',
      null,
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );

INSERT INTO n_join_key_col_templates(
      t_join_key_id,
      t_column_position,
      column_label,
      kff_table_pk_column_name,
      created_by,
      last_updated_by
   ) VALUES (
      (SELECT t.t_join_key_id
   FROM n_join_key_templates t
  WHERE t.view_label               = 'CSD_Repair_Order_Notes_Vsat'
    AND t.key_name                 = 'PK_CONT_LINE'),
      2,
      'Contract_Number',
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_join_key_col_templates(
      t_join_key_id,
      t_column_position,
      column_label,
      kff_table_pk_column_name,
      created_by,
      last_updated_by
   ) VALUES (
      (SELECT t.t_join_key_id
   FROM n_join_key_templates t
  WHERE t.view_label               = 'CSD_Repair_Order_Notes_Vsat'
    AND t.key_name                 = 'PK_CONT_LINE'),
      1,
      'Contract_Line_ID',
      null,
      'nemuser',
      'nemuser'
   );



INSERT INTO n_join_key_templates(
      view_label,
      key_name,
      description,
      join_key_context_code,
      key_type_code,
      column_type_code,
      outerjoin_flag,
      outerjoin_direction_code,
      key_rank,
      pl_ref_pk_view_name_modifier,
      pl_rowid_col_name_modifier,
      key_cardinality_code,
      referenced_pk_t_join_key_id,
      product_version,
      profile_option,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'CSD_Repair_Order_Notes_Vsat',
      'COL_ID_CUST_PROD_ID',
      'column id based on customer product identifier.',
      'NONE',
      'PK',
      'COL',
      null,
      null,
      1,
      null,
      null,
      '1',
      null,
      '*',
      null,
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );

INSERT INTO n_join_key_col_templates(
      t_join_key_id,
      t_column_position,
      column_label,
      kff_table_pk_column_name,
      created_by,
      last_updated_by
   ) VALUES (
      (SELECT t.t_join_key_id
   FROM n_join_key_templates t
  WHERE t.view_label               = 'CSD_Repair_Order_Notes_Vsat'
    AND t.key_name                 = 'COL_ID_CUST_PROD_ID'),
      1,
      'Customer_Product_ID',
      null,
      'nemuser',
      'nemuser'
   );



INSERT INTO n_join_key_templates(
      view_label,
      key_name,
      description,
      join_key_context_code,
      key_type_code,
      column_type_code,
      outerjoin_flag,
      outerjoin_direction_code,
      key_rank,
      pl_ref_pk_view_name_modifier,
      pl_rowid_col_name_modifier,
      key_cardinality_code,
      referenced_pk_t_join_key_id,
      product_version,
      profile_option,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'CSD_Repair_Order_Notes_Vsat',
      'COL_ID_REP_LINE',
      'Master key added.',
      'NONE',
      'PK',
      'COL',
      null,
      null,
      1,
      null,
      null,
      '1',
      null,
      '*',
      null,
      'Y',
      'Y',
      'nemuser',
      'nemuser'
   );

INSERT INTO n_join_key_col_templates(
      t_join_key_id,
      t_column_position,
      column_label,
      kff_table_pk_column_name,
      created_by,
      last_updated_by
   ) VALUES (
      (SELECT t.t_join_key_id
   FROM n_join_key_templates t
  WHERE t.view_label               = 'CSD_Repair_Order_Notes_Vsat'
    AND t.key_name                 = 'COL_ID_REP_LINE'),
      1,
      'Repair_Line_ID',
      null,
      'nemuser',
      'nemuser'
   );




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff