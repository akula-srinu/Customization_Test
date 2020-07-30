-- *******************************************************************************
-- FileName:             NVWB_GL_SOX_All_Je_Lines_FK.sql
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
-- output to NVWB_GL_SOX_All_Je_Lines_FK.lst file

@utlspon NVWB_GL_SOX_All_Je_Lines_FK

-- *******************************************************************************
-- Revision Number: 2
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1233;

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
      'GL_SOX_All_Je_Lines',
      'ROWID_FK_Acct',
      'ROWID_FK_Acct',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      null,
      'N',
      670,
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
  WHERE t.view_label               = 'GL_SOX_All_Je_Lines'
    AND t.key_name                 = 'ROWID_FK_Acct'),
      1,
      'Acct',
      null,
      'NOETIX',
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
      'GL_SOX_All_Je_Lines',
      'ROWID_FK_GLHDR',
      'ROWID_FK_GLHDR',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      null,
      'N',
      737,
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
  WHERE t.view_label               = 'GL_SOX_All_Je_Lines'
    AND t.key_name                 = 'ROWID_FK_GLHDR'),
      1,
      'GLHDR$GL_Journal_Entries',
      null,
      'NOETIX',
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
      'GL_SOX_All_Je_Lines',
      'ROWID_FK_GLBTC',
      'ROWID_FK_GLBTC',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      null,
      'N',
      763,
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
  WHERE t.view_label               = 'GL_SOX_All_Je_Lines'
    AND t.key_name                 = 'ROWID_FK_GLBTC'),
      1,
      'GLBTC$GL_Journal_Entry_Batches',
      null,
      'NOETIX',
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
      'GL_SOX_All_Je_Lines',
      'HFK1',
      'GL_All_Je_Lines view Foreign Key for  column_label-based join relationships (Hierarchy context.)',
      'HIER',
      'FK',
      'COL',
      'N',
      null,
      2,
      null,
      null,
      'N',
      247,
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
  WHERE t.view_label               = 'GL_SOX_All_Je_Lines'
    AND t.key_name                 = 'HFK1'),
      1,
      'Acct',
      'CODE_COMBINATION_ID',
      'NOETIX',
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
      'GL_SOX_All_Je_Lines',
      'ROWID_FK_GLLIN',
      'ROWID_FK_GLLIN',
      'NONE',
      'FK',
      'ROWID',
      'N',
      null,
      1,
      null,
      null,
      'N',
      784,
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
  WHERE t.view_label               = 'GL_SOX_All_Je_Lines'
    AND t.key_name                 = 'ROWID_FK_GLLIN'),
      1,
      'GLLIN$GL_Journal_Entry_Lines',
      null,
      'NOETIX',
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
      'GL_SOX_All_Je_Lines',
      'DFK1',
      'GL_All_Je_Lines view Foreign Key for  column_label-based join relationships (Dimension context.)',
      'DIM',
      'FK',
      'COL',
      'N',
      null,
      2,
      null,
      null,
      'N',
      248,
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
  WHERE t.view_label               = 'GL_SOX_All_Je_Lines'
    AND t.key_name                 = 'DFK1'),
      1,
      'Acct',
      'CODE_COMBINATION_ID',
      'NOETIX',
      'nemuser'
   );




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff