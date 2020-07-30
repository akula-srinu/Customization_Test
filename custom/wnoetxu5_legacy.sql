-- Title
--    wnoetxu5.sql
-- Function
--    Perform customer update sql processes
--    will be custom for each update release
--
-- Description
--    Do nothing for this release
--
-- Copyright Noetix Corporation 1992-2013  All Rights Reserved
--
-- History
--   20-Nov-94 D Cowles
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--



UPDATE n_join_keys
   SET outerjoin_flag = DECODE (key_type_code,  'PK', NULL,  'FK', 'Y'),
       OUTERJOIN_DIRECTION_CODE =
          DECODE (key_type_code,  'PK', NULL,  'FK', 'PK')
 WHERE     view_label IN
              ('HR_EI_Asg_Ben_Derived', 'HR_EI_Job_Types', 'HR_EI_Per_Types')
       AND view_name IN
              ('HRG0_EI_Asg_Ben_Derived',
               'HRG0_EI_Job_Government_Labor_C',
               'HRG0_EI_Job_Job_Category',
               'HRG0_EI_Per_US_Ethnic_Origin',
               'HRG0_EI_Role_Users');

COMMIT;


UPDATE n_view_wheres
   SET omit_flag = 'Y'
 WHERE view_name LIKE 'HRG0_SI_Type_ViaSat_Prior_Empl'
       AND where_clause_position IN ('5', '6');

COMMIT;

update n_views 
set omit_flag='Y'
where view_name in 
(
'POG0_SOX_WO_Open_POs_Vsat',
'INVG0_SOX_Onhand_Quantities_Vs',
'INVG0_SOX_Cycle_Count_Apprv_Vs',
'WIPG0_SOX_Routing_Resources',
'GLG0_SOX_All_Je_Lines',
'POG0_SOX_Receipts_Vsat'
);

COMMIT;


update n_join_keys
set outerjoin_flag='Y'
where key_name = 'ROWID_FK_PEO'
and view_name like  'HRG0_SI_Type_ViaSat_Prior_Empl';

COMMIT;

@HRG0_SI_Type_ViaSat_Internatio_col_add_u5.sql
@HRG0_SI_Type_ViaSat_Education_col_add_u5.sql

-- end wnoetxu5.sql
