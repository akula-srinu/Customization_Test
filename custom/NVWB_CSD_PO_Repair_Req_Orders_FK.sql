-- *******************************************************************************
-- FileName:             NVWB_CSD_PO_Repair_Req_Orders_FK.sql
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
-- output to NVWB_CSD_PO_Repair_Req_Orders_FK.lst file

@utlspon NVWB_CSD_PO_Repair_Req_Orders_FK

-- *******************************************************************************
-- Revision Number: 2
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1219;

UPDATE n_join_key_templates
   SET view_label = 'CSD_PO_Repair_Req_Orders',
       key_name = 'ROWID_FK_RPRS',
       description = 'ROWID_FK_RPRS',
       join_key_context_code = 'NONE',
       key_type_code = 'FK',
       column_type_code = 'ROWID',
       outerjoin_flag = 'Y',
       outerjoin_direction_code = 'FK',
       key_rank = 1,
       pl_ref_pk_view_name_modifier = null,
       pl_rowid_col_name_modifier = null,
       key_cardinality_code = 'N',
       referenced_pk_t_join_key_id = 445,
       product_version = '*',
       profile_option = null,
       include_flag = 'Y',
       user_include_flag = null,
       last_updated_by = 'nemuser',
       last_update_date = TO_DATE('2017-03-02 00:02:57','YYYY-MM-DD HH24:MI:SS')
 WHERE t_join_key_id = 450;




COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff