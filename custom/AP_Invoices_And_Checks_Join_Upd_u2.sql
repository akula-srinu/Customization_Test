-- This line added by Srinivas

-- File Name: AP_Invoices_And_Checks_Join_Upd_u2.sql
--
-- Date Created: 02-12-2015
--
-- Purpose: Updating the equi join between AP_Invoices and AP_Invoice_Checks
--
-- Requested By: Viasat.
--
-- Versions:
-- - Oracle EBS:R12
-- - Oracle DB:
-- - NoetixViews:6.3
--
-- Change History:
-- ===============
-- Date         Who            Comments
-- -----------  -------------  ---------
-- 02-12-2015     Srinivasa Rao Akula    Created. 

-- This file is called from wnoetxu2.sql

-- ****************************************************************************

-- output to .lst file

@utlspon AP_Invoices_And_Checks_Join_Upd_u2



UPDATE n_join_key_templates
   SET outerjoin_flag = 'Y',OUTERJOIN_DIRECTION_CODE= 'PK'
 WHERE t_join_key_id IN
          (SELECT t_join_key_id
             FROM n_join_key_templates a
            WHERE view_label LIKE 'AP_Invoice_Checks'
                  AND a.referenced_pk_t_join_key_id IN
                         (SELECT t_join_key_id
                            FROM n_join_key_templates
                           WHERE view_label LIKE 'AP_Invoices'
                                 AND key_type_code = 'PK'));

COMMIT;

@utlspoff
