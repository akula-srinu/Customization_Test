-- *******************************************************************************
-- FileName:             NVWB_PO_Blanket_PO_Lines_FK.sql
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
-- output to NVWB_PO_Blanket_PO_Lines_FK.lst file

@utlspon NVWB_PO_Blanket_PO_Lines_FK

-- *******************************************************************************
-- Revision Number: 8
-- *******************************************************************************

SET DEFINE OFF;
WHENEVER SQLERROR EXIT 1085;

DELETE 
  FROM n_join_key_templates
 WHERE t_join_key_id = 1897;

DELETE 
  FROM n_join_key_templates
 WHERE t_join_key_id = 1866;


COMMIT;
SET DEFINE ON;
WHENEVER SQLERROR CONTINUE;

@utlspoff