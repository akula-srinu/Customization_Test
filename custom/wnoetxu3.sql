-- Title
--    wnoetxu3.sql
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

@utlspon wnoetxu3

-- Suppression script goes here...

update n_user_role_config
   set user_enabled_flag = 'N'   
 where application_label = 'PAY';


commit;

--commit;

@utlspoff