-- *******************************************************************************
-- FileName:             NVWB_GL_Status_Of_Periods.sql
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
-- output to NVWB_GL_Status_Of_Periods.lst file

@utlspon NVWB_GL_Status_Of_Periods

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 955;

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'BILL_OF_MATERIALS',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'DEPOT_REPAIR',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'MRP',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'PAYROLL',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'PROJECT_CONTRACTS',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'SERVICE_CONTRACTS',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'COST_MANAGEMENT',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'PAYABLES',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'TELESERVICE',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'WORK_IN_PROCESS',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'CASH_MANAGEMENT',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'PROJECT_MANUFACTURING',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'INSTALL_BASE',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

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
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'FIXED_ASSETS',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'INVENTORY',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'ORDER_ENTRY',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'SUBLEDGER_ACCOUNTING',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'RECEIVABLES',
      'GL_Status_Of_Periods',
      '10.0+',
      null,
      null,
      'nemuser',
      'nemuser'
   );

INSERT INTO n_role_view_templates(
      role_label,
      view_label,
      product_version,
      include_flag,
      user_include_flag,
      created_by,
      last_updated_by
   ) VALUES (
      'QUALITY',
      'GL_Status_Of_Periods',
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