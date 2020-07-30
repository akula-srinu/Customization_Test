-- Title
--    apps.sql
-- Function
--    Create the list of applications (N_APPLICATION_OWNERS) that Noetix
--    will use. 
-- Description
--    By joining the list of possible apps (N_APPLICATION_OWNER_TEMPLATES)
--    and the Oracle product list get the first pass at different application
--    instances that Noetix will support.
--    This will be used to generate the grants for the setup tables in the
--    script grant2.sql. 
--    These setup tables will in turn be used in orgs.sql to expand out the
--    N_APPLICATION_OWNERS for multiple organizations.
--    As N_APPLICATION_OWNERS is created, a application_instance is defined
--    for each row. For each application_id, the application_instance starts
--    counting at '0'. Application_instances will become part of the view
--    names in popview.sql.
-- 
--    Application records will also be added for "dummy" applications
--    NOETX, XXEIS, APPS and XXNAO.
--
-- The following comments were made obsolete on 06-Dec-94
--    The applications are sorted so that the 
--    installed, base table applications get the lowest number. What this
--    means is that if there is only one installed application it will be
--    instance '0'. This in turn means that the view names will be like
--    'AP_INVOICES_FULL' rather than like 'AP1_INVOICES_FULL'.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--     13-Aug-94 M Turner  created
--     06-Dec-94 M Turner  reordered the application owners by oracle user
--                         name so that more likely to get AP1 to match PO1.
--     24-Jun-95 M Turner  add application NOETIX and assign its oracle owner.
--     26-Mar-96 M Turner  add call to app2app.sql
--     18-Aug-96 D Cowles  change role prefix from NOETIX to NOETX
--     20-Aug-96 D Cowles  remove commit after app2app, it does its own
--     04-Mar-97 D Cowles  force status of S for AK app for multi-org
--     11-Aug-98 R Padilla Added support for Rel 11 when creating 
--                         Application Owners  See RHP. Adding '11%' to 
--                         criteria.
--     15-Apr-99 D Glancy  Updated Copyright information.
--     13-Sep-99 R Lowe    Update copyright info.
--     14-Feb-00 H Sumanam Update copyright info.
--     21-Jul-00 D Glancy  Use the PRODUCT_VERSION and FND_VERSION stored in
--                         tconnect.sql.
--     11-Dec-00 D Glancy  Update copyright info.
--     08-Jan-01 R Lowe    11i bug fix. Modified the c1 cursor to force the
--                         status of application QP to shared (S) when it has
--                         the status of N.
--     12-Nov-01 D Glancy  Update copyright info. (Issue #5285)
--     15-Nov-01 D Glancy  Modified the c1 cursor to force the status of the 
--               Kumar     WSH and JTF applications to shared (S) when the 
--                         status is either null or set to N.  This allows 
--                         installer to get the owners for the tables belonging 
--                         to WSH and JTF applications.  Otherwise, the owners 
--                         are missing from the mkview.sql file.  (Issue #4831)
--     31-Oct-02 D Glancy  Update copyright info. (Issue #8615)
--     07-Nov-02 D Glancy  Add the insert of the APPS and XXEIS user into 
--                         n_application_owners.
--     11-Dec-02 D Glancy  Change the PAYROLL_INSTALLED flag to 
--                         XXXEIS_APP_DETECTED flag. (Issue 8897)
--     21-Jul-03 H Schmed  Added a section to insert XXNAO into the
--                         n_application_owners table. (Issue 10948)
--     23-Feb-04 D Glancy  Update Copyright Info. (Issue 11982)
--     03-Nov-04 D Glancy  Update Copyright Info. (Issue 13498)
--     22-Sep-05 D Glancy  Update copyright info. (Issue 15175)
--     20-Jan-06 D Glancy  Add support for new oracle_install_status column.  Initialize this to the
--                         same value as the install_status column.
--                         (Issue 15240)
--     10-Jun-08 D Glancy  Force IBY and ZX to install status 'S' due to prevent installation issues in
--                         release 12.
--                         (Issue 19830)
--     15-Oct-08 R Vattikonda  Modified the c1 cursor to force the status of the XDO application to shared (S) 
--                         when the status is either null or set to N.  This allows installer to get the owners 
--                         for the tables belonging to XDO applications.  Otherwise, the owners are missing from 
--                         the mkview.sql file.  
--                         (Issue #20869)
--     18-Feb-09 R Raghudev Added the XXKFF application to the n_application_owners for global seg.
--                         (Issue 21542)
--     13-Jul-09 R Vattikonda For Project Management views,'EGO' application needs to be generated.
--                         (Issue 22346)
--     22-Feb-09 C Kranthi Modified the role prefx from XXKFF to XXK while populating XXKFF application details.
--                         (Issue 23434)
--     23-Mar-09 D Glancy  For XXKFF insert, check to see if the record exists to avoid pk violations.
--     03-May-10 Sharas    For XXKFF and XXNAO, ensure that the records only get inserted by the manual insert statement.
--                         If the application_id already exists in oracle's tables, we're inserting the wrong record.
--                         (Issue 24012)
--     15-Apr-11 Srinivas  Added new application label XXHIE to n_application_owners for Parent Child Hierarchy Processing.
--                         (Issue 25330)
--     21-Jun-11 D Glancy  Ensure that the XXHIE application xrefs with all other applications global instances. Take into account
--                         that it might be marked as 'S' or shared.
--     01-Mar-12 D Glancy  Force FUN to install status 'S' due to prevent installation issues in
--                         release 12.
--                         (Issue 28447)
--     31-Jul-12 VSandapin Custom applications have a status of 'L' on fnd_product_installations; amend cursor c1 to return these
--                         so that they are created in n_application_owners.
--                         (Issue 30906)
--     14-Nov-12 D Glancy  Pull in all the application_id's that are not in metadata in the fnd_application table if they are tied to a 
--                         product.  This way workbench. This is in conjunction with a metadata change that already has the the application_label
--                         in place for all known applications.  If one is missed it will be picked up in the change to cursor c1.  This includes
--                         any custom applications.
--                         (Issue 28711)
--     15-Nov-12 D Glancy  Setting install_status and base_application more intelligently.  If the table is being used and the base_application is set to 'N',
--                         it actually should be 'S'.  If the application is being used by a role, then base_application should be set to 'Y'.
--                         Add special handling for custom (oracle install status = 'L') applications.
--                         (Issue 28711)
--     24-May-13 D Glancy  Move the insert into n_application_owner_templates for all the application_id's that are not in metadata in the fnd_application table 
--                         if they are tied to a product to xupdate.sql so that workbench can use them for view and role inserts.
--                         (Issue 28711)
--     02-Aug-13 D Glancy  Add one more check to ensure that custom applications base_application is set properly.
--     02-Apr-14 D Glancy  When inserting custom applications, the install_status should either be "Y" or "S".  This should help to support custom roles in the future.
--                         (Issue 21089)
--	   12-Dec-15 Kmaddireddy Modified XXKFF INSERT statement to address NV-167 Issue.
--
@utlspon apps

whenever sqlerror exit 33

-- In case workbench or hook scripts added a custom role, set the base_application flag appropriately.
UPDATE n_application_owner_templates aot
   SET aot.base_application     = 'Y'
 WHERE aot.base_application    <> 'Y'
   AND EXISTS
     ( SELECT 'Appl Label tied to a Role'
         FROM n_role_templates r
        WHERE r.application_label = aot.application_label
        UNION ALL
       SELECT 'Appl label tied to a view'
         FROM n_view_templates v
        WHERE v.application_label = aot.application_label );

-- In case workbench or hook scripts added a custom table, set the base_application flag appropriately.
UPDATE n_application_owner_templates aot
   SET aot.base_application     = 'S'
 WHERE aot.base_application     = 'N'
   AND EXISTS
     ( SELECT 'Appl Label tied to a Role'
         FROM n_view_column_templates c
        WHERE c.ref_application_label = aot.application_label
          AND rownum              = 1
        UNION ALL
       SELECT 'Appl label tied to a view'
         FROM n_view_table_templates v
        WHERE v.application_label = aot.application_label
          AND rownum              = 1
        UNION ALL
       SELECT 'Appl label tied to a view'
         FROM n_ans_table_templates v
        WHERE v.application_label = aot.application_label
          AND rownum              = 1 
        UNION ALL
       SELECT 'Appl label tied to a view'
         FROM n_grant_table_templates v
        WHERE v.application_label = aot.application_label
          AND rownum              = 1
        UNION ALL
       SELECT 'Appl label tied to a view'
         FROM n_view_table_changes_templates v
        WHERE v.new_application_label = aot.application_label
          AND rownum              = 1                       );

DECLARE
    CURSOR c1 is 
    SELECT aot.application_label,
           fpi.application_id,
           aot.base_application,
           fpi.oracle_id,
        /* if app is AK turn status=N to status=S so we will still
           consider AK installed enough to find AK_PARTITIONED_TABLES
           because multi-org code in orgid.sql is dependent upon it.
           DMG.  Added JTF, WSH, and QP to the list for 11i functionality. */
           ( case
               when (     &PRODUCT_VERSION      >= 12
                      and aot.application_label in ( 'IBY', 'ZX', 'FUN' )     ) then
                   ( case 
                       when nvl(fpi.status,'N') = 'N' then 'S'
                       else                                fpi.status
                     end )
               when (     &PRODUCT_VERSION      >= 11.5
                      and aot.application_label in ( 'AK', 'EGO', 'JTF', 'QP', 'WSH', 'XDO' )  ) then 
                   ( case 
                       when nvl(fpi.status,'N') = 'N' then 'S'
                       else                                fpi.status
                     end )
               when fpi.status = 'L' then 'L'
               else fpi.status
             end )                                           status,
           fou.oracle_username
      FROM fnd_oracle_userid_s              fou,
           fnd_product_installations_s      fpi,
           n_application_owner_templates    aot
     WHERE aot.application_id         = fpi.application_id
       AND fpi.oracle_id              = fou.oracle_id
       --  These applications are handled manually as they are owned by noetix, but will still be in the fnd_applications/fnd_oracle_userid tables.
       AND aot.application_label NOT IN ( 'XXEIS', 'XXHIE', 'XXKFF', 'XXNAO','SOX' )
     ORDER by aot.application_id  asc,
              fou.oracle_username asc;

    CURSOR c_application_label IS
    SELECT v.application_label      application_label
      FROM n_view_templates v
     UNION 
    SELECT t.application_label      application_label
      FROM n_view_table_templates t
     UNION 
    SELECT t.ref_application_label  application_label
      FROM n_view_column_templates t
     WHERE t.ref_application_label is not null
     UNION 
    SELECT t.application_label  application_label
      FROM n_grant_table_templates t;

    TYPE ltyp_application_label     IS TABLE OF INTEGER INDEX BY VARCHAR2(30);
    ltab_application_label          ltyp_application_label;

    li_application_id               fnd_product_installations_s.application_id%TYPE;
    li_instance_count               BINARY_INTEGER;
    ls_install_status               VARCHAR2(1);
begin
    li_application_id := -999;     -- Make sure 1st doesn't match.
    li_instance_count := -1;
    ltab_application_label.DELETE;
    --
    FOR r_appl_label IN c_application_label LOOP
        ltab_application_label(r_appl_label.application_label) := 1;
        --
        -- Set the base_appliciation to 'S' for those applications that come in by default as 'N'
        -- The assumption is that if we are using the table in views, it should be marked as shared.
        -- More than likely these are new tables being brought in by hook scripts.
        UPDATE n_application_owner_templates aot
           SET aot.base_application       = 'S'
         WHERE aot.application_label      = r_appl_label.application_label
           AND aot.application_label NOT IN ( 'XXEIS', 'XXHIE', 'XXKFF', 'XXNAO','SOX' )
           AND aot.base_application       = 'N';
        --
    END LOOP;
    --
    FOR rec1 IN c1 LOOP
        IF ( li_application_id = rec1.application_id ) THEN
            li_instance_count := li_instance_count + 1;
        ELSE
            li_application_id := rec1.application_id;
            li_instance_count := 0;
        END IF;
        --
        ls_install_status   := ( CASE 
                                   WHEN ( ltab_application_label.EXISTS(rec1.application_label) ) THEN
                                       ( CASE rec1.status
                                           WHEN 'L' THEN ( CASE rec1.base_application
                                                             WHEN 'Y' THEN 'I'
                                                             WHEN 'S' THEN 'S'
                                                             -- Make all custom application shared unless otherwise noted.
                                                             ELSE 'S'
                                                           END )
                                           WHEN 'I' THEN 'I'
                                           ELSE 'S' 
                                         END )
                                   ELSE 
                                       ( CASE rec1.status
                                           WHEN 'L' THEN ( CASE rec1.base_application
                                                             WHEN 'Y' THEN 'I'
                                                             WHEN 'S' THEN 'S'
                                                             -- Make all custom application shared unless otherwise noted.
                                                             ELSE 'S'
                                                           END )
                                           ELSE          rec1.status
                                         END )
                                 END );
        --
        INSERT into n_application_owners
             ( application_label,
               application_id,
               base_application,
               install_status,
               oracle_install_status,
               application_instance,
               oracle_id,
               owner_name,
               set_of_books_id,
               set_of_books_name,
               organization_id,
               organization_name,
               chart_of_accounts_id)
        VALUES
             ( rec1.application_label,
               rec1.application_id,
               rec1.base_application,
               -- Setting the INSTALL_STATUS column
               -- If custom (L) then set to I if a custom role is also defined.
               ls_install_status,
               rec1.status,
               ltrim(to_char(li_instance_count,'990')),
               rec1.oracle_id,
               rec1.oracle_username,
               null,           -- set_of_books_id
               null,           -- set_of_books_name
               null,           -- organization_id
               null,           -- organization_name
               null );           -- chart_of_accounts_id
    END LOOP;
    --
    -- Create application owners for RA that mimic AR
    -- If this is release 10
    --
    -- RHP 08/11/1998
    -- If this is release 11
    INSERT into n_application_owners
         ( APPLICATION_LABEL,
           APPLICATION_ID,
           BASE_APPLICATION,
           INSTALL_STATUS,
           ORACLE_INSTALL_STATUS,
           APPLICATION_INSTANCE,
           OWNER_NAME,
           ORACLE_ID,
           SET_OF_BOOKS_ID,
           SET_OF_BOOKS_NAME,
           ORGANIZATION_ID,
           ORGANIZATION_NAME,
           CHART_OF_ACCOUNTS_ID,
           ROLE_PREFIX )
    SELECT 'RA',
           ao.APPLICATION_ID,
           ao.BASE_APPLICATION,
           ao.INSTALL_STATUS,
           ao.ORACLE_INSTALL_STATUS,
           ao.APPLICATION_INSTANCE,
           ao.OWNER_NAME,
           ao.ORACLE_ID,
           ao.SET_OF_BOOKS_ID,
           ao.SET_OF_BOOKS_NAME,
           ao.ORGANIZATION_ID,
           ao.ORGANIZATION_NAME,
           ao.CHART_OF_ACCOUNTS_ID,
           ao.ROLE_PREFIX
           -- RHP 08/11/1998
           -- Added support for Rel 11
      FROM n_application_owners ao
     WHERE to_number( '&FND_VERSION' ) >= 10
       AND ao.application_label         = 'AR'
       AND not exists 
         ( SELECT null 
             FROM n_application_owners
            WHERE application_label = 'RA');
    --
END;
/
-- Add the application NOETIX if it doesn't already exist
insert into n_application_owner_templates(
       application_label,
       application_id,
       base_application)
select 'NOETIX',
       -999,
       'N'
  from dual
 where not exists 
       ( select 'application_label'
           from n_application_owner_templates n2
          where n2.application_label = 'NOETIX');

insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select 'NOETIX',        -- application_label
       -999,            -- application_id
       'N',             -- base_application
       'S',             -- install_status
       'S',             -- oracle_install_status
       '0',             -- application_instance
       -999,            -- oracle id
       '&NOETIX_USER',  -- oracle user name
       null,            -- set_of_books_id
       null,            -- set_of_books_name
       null,            -- organization_id
       null,            -- organization_name
       null,            -- chart_of_accounts_id
       'NOETX'          -- role_prefix
  from dual
 where not exists 
       ( select null
           from n_application_owners
          where application_label = 'NOETIX' );
--
-- make sure application NOETIX has an oracle user name
--
update n_application_owners
   set owner_name        = '&NOETIX_USER',
       role_prefix       = 'NOETX'
 where application_label = 'NOETIX';

--
-- Add the APPS owner if necessary
--
insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select aot.application_label,       -- application_label
       aot.application_id,          -- application_id
       'N',                         -- base_application
       'S',                         -- install_status
       'S',                         -- oracle_install_status
       '0',                         -- application_instance
       fou.oracle_id,               -- oracle id
       fou.oracle_username,         -- oracle user name
       null,                        -- set_of_books_id
       null,                        -- set_of_books_name
       null,                        -- organization_id
       null,                        -- organization_name
       null,                        -- chart_of_accounts_id
       aot.application_label        -- role_prefix
  from fnd_oracle_userid_s           fou,
       n_application_owner_templates aot
 where aot.application_label = 'APPS'
   and &PRODUCT_VERSION     >= 10.7
   and fou.oracle_id         = 
       ( select min(fou2.oracle_id)
           from fnd_oracle_userid_s fou2
          where fou2.read_only_flag = 'U' )
   and not exists 
       ( select 'APPS record exist'
           from n_application_owners
          where application_label = 'APPS' );

-- Add the application XXEIS if it doesn't already exist
insert into n_application_owner_templates(
       application_label,
       application_id,
       base_application)
select 'XXEIS',
       -997,
       'N'
  from sys.all_users au
 where '&XXEIS_APP_DETECTED' = 'Y'
   and &PRODUCT_VERSION     >= 11.5
   and not exists 
       ( select 'application_label'
           from n_application_owner_templates n2
          where n2.application_label = 'XXEIS');

insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select 'XXEIS',        -- application_label
       -997,            -- application_id
       'N',             -- base_application
       'S',             -- install_status
       'S',             -- oracle_install_status
       '0',             -- application_instance
       -997,            -- oracle id
       au.username,  -- oracle user name
       null,            -- set_of_books_id
       null,            -- set_of_books_name
       null,            -- organization_id
       null,            -- organization_name
       null,            -- chart_of_accounts_id
       'XXEIS'          -- role_prefix
  from sys.all_users au
 where au.username = '&XXEIS_USERID'
   and '&XXEIS_APP_DETECTED' = 'Y'
   and &PRODUCT_VERSION     >= 11.5
   and not exists 
       ( select 'XXEIS Exists'
           from n_application_owners
          where application_label = 'XXEIS' );

-- Add the application XXNAO if requested
insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select aot.application_label,   -- application_label
       aot.application_id,      -- application_id
       aot.base_application,    -- base_application
       'I',                     -- install_status
       'I',                     -- oracle_install_status
       '0',                     -- application_instance
       aot.application_id,      -- oracle id
       '&NOETIX_USER',          -- oracle user name
       null,                    -- set_of_books_id
       null,                    -- set_of_books_name
       null,                    -- organization_id
       null,                    -- organization_name
       null,                    -- chart_of_accounts_id
       'XXNAO'                  -- role_prefix
  from n_application_owner_templates aot
 where aot.application_label = 'XXNAO'
   and aot.base_application  = 'Y'
   and not exists 
     ( select 'XXNAO Exists'
         from n_application_owners
        where application_label = 'XXNAO' );

-- Add the application XXKFF if requested
insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select aot.application_label,   -- application_label
       aot.application_id,      -- application_id
--       aot.base_application,  -- base_application -- Commented it out since dumptoto always dumps this as 'N'
       'Y',                     -- base_application -- forced it to 'Y' until dumptodo is fixed.
       'I',                     -- install_status
       'I',                     -- oracle_install_status
       '0',                     -- application_instance
       aot.application_id,      -- oracle id
       '&NOETIX_USER',          -- oracle user name
       null,                    -- set_of_books_id
       null,                    -- set_of_books_name
       null,                    -- organization_id
       null,                    -- organization_name
       null,                    -- chart_of_accounts_id
       'XXK'                    -- role_prefix
  from n_application_owner_templates aot
 where aot.application_label = 'XXKFF'
   -- temporary change by Raghu.
   and NVL(aot.base_application,'N')  IN ('Y','N','S')
   and not exists 
     ( select 'XXKFF Exists'
         from n_application_owners
        where application_label = 'XXKFF' );

-- Add the application XXHIE 

insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select aot.application_label,   -- application_label
       aot.application_id,      -- application_id
--       aot.base_application,  -- base_application -- Commented it out since dumptoto always dumps this as 'N'
       'Y',                     -- base_application -- forced it to 'Y' until dumptodo is fixed.
       'I',                     -- install_status
       'I',                     -- oracle_install_status
       '0',                     -- application_instance
       aot.application_id,      -- oracle id
       '&NOETIX_USER',          -- oracle user name
       null,                    -- set_of_books_id
       null,                    -- set_of_books_name
       null,                    -- organization_id
       null,                    -- organization_name
       null,                    -- chart_of_accounts_id
       'HIER'                   -- role_prefix
  from n_application_owner_templates aot
 where aot.application_label = 'XXHIE'
   and NVL(aot.base_application,'N')  IN ('Y','N','S')
   and not exists 
     ( select 'HIER Exists'
         from n_application_owners
        where application_label = 'XXHIE' );


-- Add the application SOX

insert into n_application_owners(
       application_label,
       application_id,
       base_application,
       install_status,
       oracle_install_status,
       application_instance,
       oracle_id,
       owner_name,
       set_of_books_id,
       set_of_books_name,
       organization_id,
       organization_name,
       chart_of_accounts_id,
       role_prefix)
select aot.application_label,   -- application_label
       aot.application_id,      -- application_id
--       aot.base_application,  -- base_application -- Commented it out since dumptoto always dumps this as 'N'
       'Y',                     -- base_application -- forced it to 'Y' until dumptodo is fixed.
       'I',                     -- install_status
       'I',                     -- oracle_install_status
       '0',                     -- application_instance
       aot.application_id,      -- oracle id
       '&NOETIX_USER',          -- oracle user name
       null,                    -- set_of_books_id
       null,                    -- set_of_books_name
       null,                    -- organization_id
       null,                    -- organization_name
       null,                    -- chart_of_accounts_id
       'SOX'                   -- role_prefix
  from n_application_owner_templates aot
 where aot.application_label = 'SOX'
   and NVL(aot.base_application,'N')  IN ('Y','N','S')
   and not exists 
     ( select 'HIER Exists'
         from n_application_owners
        where application_label = 'SOX' );

whenever sqlerror exit 34
--
commit;
--
@app2app
--
-- end apps.sql
