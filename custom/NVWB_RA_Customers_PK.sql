-- *******************************************************************************
-- FileName:             NVWB_RA_Customers_PK.sql
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
-- output to NVWB_RA_Customers_PK.lst file

@utlspon NVWB_RA_Customers_PK

-- *******************************************************************************
-- Revision Number: 1
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1313;

UPDATE n_join_key_templates
   SET view_label = 'RA_Customers',
       key_name = 'ROWID_PK',
       description = 'ROWID_PK',
       join_key_context_code = 'NONE',
       key_type_code = 'PK',
       column_type_code = 'ROWID',
       outerjoin_flag = null,
       outerjoin_direction_code = null,
       key_rank = 1,
       pl_ref_pk_view_name_modifier = null,
       pl_rowid_col_name_modifier = null,
       key_cardinality_code = '1',
       referenced_pk_t_join_key_id = null,
       product_version = '*',
       profile_option = null,
       include_flag = 'Y',
       user_include_flag = null,
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2016-05-20 20:40:22','YYYY-MM-DD HH24:MI:SS')
 WHERE t_join_key_id = 2010;




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff