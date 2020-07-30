-- *******************************************************************************
-- FileName:             NVWB_CSD_OE_Repair_Returns_Vsat_FK.sql
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
-- output to NVWB_CSD_OE_Repair_Returns_Vsat_FK.lst file

@utlspon NVWB_CSD_OE_Repair_Returns_Vsat_FK

-- *******************************************************************************
-- Revision Number: 3
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1327;

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
      'CSD_OE_Repair_Returns_Vsat',
      'ROWID_FK_ITEM',
      'ROWID_FK_ITEM',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      null,
      'N',
      1211,
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
  WHERE t.view_label               = 'CSD_OE_Repair_Returns_Vsat'
    AND t.key_name                 = 'ROWID_FK_ITEM'),
      1,
      'ITEM$INV_Items',
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
      'CSD_OE_Repair_Returns_Vsat',
      'ROWID_FK_RPRS',
      'ROWID_FK_RPRS',
      'NONE',
      'FK',
      'ROWID',
      'Y',
      'FK',
      1,
      null,
      null,
      'N',
      445,
      '*',
      null,
      'Y',
      null,
      'NOETIX',
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
  WHERE t.view_label               = 'CSD_OE_Repair_Returns_Vsat'
    AND t.key_name                 = 'ROWID_FK_RPRS'),
      1,
      'RPRS$CSD_Repair_Orders',
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
      'CSD_OE_Repair_Returns_Vsat',
      'ROWID_FK_SBASE_CS_Customers',
      'ROWID_FK_SBASE_CS_Customers',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      null,
      'N',
      491,
      '*',
      null,
      'Y',
      null,
      'NOETIX',
      '6.3 JOIN KEY EXCEPTIONS'
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
  WHERE t.view_label               = 'CSD_OE_Repair_Returns_Vsat'
    AND t.key_name                 = 'ROWID_FK_SBASE_CS_Customers'),
      1,
      'SBASE$CS_Customers',
      null,
      'NOETIX',
      '6.3 JOIN KEY EXCEPTIONS'
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
      'CSD_OE_Repair_Returns_Vsat',
      'ROWID_FK_SBASE_CSD_Service_Req',
      'ROWID_FK_SBASE_CSD_Service_Req',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      null,
      'N',
      461,
      '*',
      null,
      'Y',
      null,
      'NOETIX',
      '6.3 JOIN KEY EXCEPTIONS'
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
  WHERE t.view_label               = 'CSD_OE_Repair_Returns_Vsat'
    AND t.key_name                 = 'ROWID_FK_SBASE_CSD_Service_Req'),
      1,
      'SBASE$CSD_Service_Requests',
      null,
      'NOETIX',
      '6.3 JOIN KEY CONVERSION'
   );




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff