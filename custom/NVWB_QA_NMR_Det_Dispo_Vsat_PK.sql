-- *******************************************************************************
-- FileName:             NVWB_QA_NMR_Det_Dispo_Vsat_PK.sql
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
-- output to NVWB_QA_NMR_Det_Dispo_Vsat_PK.lst file

@utlspon NVWB_QA_NMR_Det_Dispo_Vsat_PK

-- *******************************************************************************
-- Revision Number: 10
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1169;

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
      'QA_NMR_Det_Dispo_Vsat',
      'PK_NMR_DISPO_ID',
      'PK column added.',
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
  WHERE t.view_label               = 'QA_NMR_Det_Dispo_Vsat'
    AND t.key_name                 = 'PK_NMR_DISPO_ID'),
      2,
      'Parent_Occurrence',
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
  WHERE t.view_label               = 'QA_NMR_Det_Dispo_Vsat'
    AND t.key_name                 = 'PK_NMR_DISPO_ID'),
      1,
      'Parent_Plan_ID',
      null,
      'nemuser',
      'nemuser'
   );




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff