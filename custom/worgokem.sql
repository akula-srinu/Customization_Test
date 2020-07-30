-- Title
--   worgokem.sql
-- Function
--   Find all orgs in a pa instance for oracle 10.7+
--   look up the set_of_books_id and Organization_id
-- Description
--   The names of the Oracle user that owns the OKE data is passed in.
--    1 -- OKE oracle userid
--   This routine may be called several times by the org.sql program
--   via the mkorg.sql program.
--
-- Copyright Noetix Corporation 1992-2007  All Rights Reserved
--
-- History
--   15-Jul-97 H Schmed   Copied worgapm.sql to create worgpam.sql to
--                        handle the 10.6 to 10.7 table name change 
--   10-Aug-97 W Bonneau  Default -98 for min_sob and min_org
--   20-Sep-99 R Lowe     Update copyright info.
--   16-Feb-00 H Sumanam  Update copyright info.
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   17-Jul-03 D Glancy   Added undefine statements to clean up environment. (Issue #8561)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   23-Jan-06 D Glancy   Update the new oracle_install_status and install_status_history column.
--                        (Issue 11935)
--   04-Jun-08 Haritha    Add support for OKE.
-- 07-Apr-2011 HChodavarapu Verified for 602 build.
--
set scan off
define OKE_USERID=&1
define PA_USERID =&2
--
-- Get the minimum org id for this app
--
column  min_sob_id new_value min_sob noprint
select -98 min_sob_id
from   dual
;

select nvl(min(set_of_books_id),-98) min_sob_id
  from &PA_USERID..pa_implementations
;

--
--  Upon entry n_application_owners is already populated with one record
--  by apps.sql.  Update it to the min(org_id) of all orgs
--  found in this oke_userid.  After this we will create a new record for
--  all additional orgs in this pa_userid.
--
update n_application_owners n
   set (set_of_books_id) = 
        (select set_of_books_id
           from &PA_USERID..pa_implementations
          where set_of_books_id = &MIN_SOB) 
 where   application_label = 'OKE'
              and owner_name        = '&OKE_USERID'   
;

--
-- Get the maximum application instance for this app
--
column max_oke_inst     new_value max_oke_instance     noprint
select nvl(max(to_number(application_instance)),0) max_oke_inst
  from n_application_owners
 where application_label = 'OKE'
;
--
-- Create one record for each org except the min(org_id)
-- which was updated above
--
insert into n_application_owners
     ( application_label,
       application_id,
       base_application,
       oracle_install_status,
       install_status,
       application_instance,
       owner_name,
       oracle_id,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       org_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select n.application_label,
       n.application_id,
       n.base_application,
       n.oracle_install_status,
       n.install_status,
       &MAX_OKE_INSTANCE.+rownum,
       n.owner_name,
       n.oracle_id,
       o.set_of_books_id,
       n.set_of_books_name,
       null,
       null,
       null,
       n.chart_of_accounts_id,
       null
  from &PA_USERID..pa_implementations o,
       n_application_owners n
 where o.set_of_books_id != &MIN_SOB 
    and      n.application_label = 'OKE'
               and n.owner_name         = '&OKE_USERID'
    and o.set_of_books_id is not null
    and not exists 
      ( select null
          from n_application_owners n2
         where n2.application_label = n.application_label
           and n2.set_of_books_id   = o.set_of_books_id )
;

undefine MIN_SOB
undefine MAX_OKE_INSTANCE
undefine OKE_USERID
undefine PA_USERID

-- End worgokem.sql
set scan on