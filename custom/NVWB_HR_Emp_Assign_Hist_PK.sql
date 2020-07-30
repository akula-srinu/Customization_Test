-- *******************************************************************************
-- FileName:             NVWB_HR_Emp_Assign_Hist_PK.sql
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
-- output to NVWB_HR_Emp_Assign_Hist_PK.lst file

@utlspon NVWB_HR_Emp_Assign_Hist_PK

-- *******************************************************************************
-- Revision Number: 5
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1227;

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
      'HR_Emp_Assign_Hist',
      'PK_Emp_Asg_Hist',
      'HR_Emp_Assign_Hist view Primary Key for column_based join relation ships (Employee_ID).',
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
  WHERE t.view_label               = 'HR_Emp_Assign_Hist'
    AND t.key_name                 = 'PK_Emp_Asg_Hist'),
      3,
      'Emp_Effective_End_Date',
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
  WHERE t.view_label               = 'HR_Emp_Assign_Hist'
    AND t.key_name                 = 'PK_Emp_Asg_Hist'),
      2,
      'Emp_Effective_Start_Date',
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
  WHERE t.view_label               = 'HR_Emp_Assign_Hist'
    AND t.key_name                 = 'PK_Emp_Asg_Hist'),
      1,
      'Employee_ID',
      null,
      'nemuser',
      'nemuser'
   );




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff