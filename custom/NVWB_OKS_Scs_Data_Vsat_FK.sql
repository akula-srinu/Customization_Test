-- *******************************************************************************
-- FileName:             NVWB_OKS_Scs_Data_Vsat_FK.sql
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
-- output to NVWB_OKS_Scs_Data_Vsat_FK.lst file

@utlspon NVWB_OKS_Scs_Data_Vsat_FK

-- *******************************************************************************
-- Revision Number: 10
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1265;

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
      'OKS_Scs_Data_Vsat',
      'ROWID_FK_PROJ',
      'ROWID_FK_PROJ',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      'PROJ',
      'N',
      (SELECT t.t_join_key_id
   FROM n_join_key_templates t
  WHERE t.view_label               = 'PA_Projects'
    AND t.key_name                 = 'ROWID_PK'),
      '*',
      null,
      'Y',
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
  WHERE t.view_label               = 'OKS_Scs_Data_Vsat'
    AND t.key_name                 = 'ROWID_FK_PROJ'),
      1,
      'PROJ$PA_Projects',
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
      'OKS_Scs_Data_Vsat',
      'ROWID_FK_TASK',
      'ROWID_FK_TASK',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      'TASK',
      'TASK',
      'N',
      (SELECT t.t_join_key_id
   FROM n_join_key_templates t
  WHERE t.view_label               = 'PA_Tasks'
    AND t.key_name                 = 'ROWID_PK'),
      '*',
      null,
      'Y',
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
  WHERE t.view_label               = 'OKS_Scs_Data_Vsat'
    AND t.key_name                 = 'ROWID_FK_TASK'),
      1,
      'TASK$PA_Tasks',
      null,
      'nemuser',
      'nemuser'
   );




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff