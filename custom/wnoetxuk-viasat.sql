-- Title
--    wnoetxuk.sql
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
--   18-Aug-96 D Cowles
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--

@utlspon wnoetxuk

update n_application_owner_templates set single_instances_enabled = 'N' 
  where application_label = 'PAY';

update n_application_owner_templates set base_application = 'N' 
  where application_label = 'XXEIS';

commit;

@utlspoff

-- end wnoetxuk.sql
