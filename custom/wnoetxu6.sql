-- Title
--    wnoetxu6.sql
-- Function
--    Perform customer update sql processes
--    will be custom for each update release
--
-- Description
--    Do nothing for this release
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   20-Nov-94 D Cowles
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--

@BNV1659.sql

update n_views 
set omit_flag='N'
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

-- end wnoetxu6.sql
