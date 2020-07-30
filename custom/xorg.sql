-- Title
--    xorg.sql
--    @(#)xorg.sql
-- Function
--    @(#) Add custom applications for cross-org, cross-sob views
--
-- Description
--    Populates n_application_owners with the cross-op instances if all 
--    of the appropriate configuration data has been supplied AND there
--    are more than one "component" instances.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   13-Jul-98 C Lee      Created file based on INV stuff in org and concert 
--                        solution
--   26-Apr-99 H Schmed   Changed references from fnd_id_flex_structures to
--                        fnd_id_flex_structures_view to allow for R11 changes.
--   27-Apr-99 H Schmed   Moved xop inserts from PL/SQL to standard SQL.  This
--                        was done to help with debugging.  Now, I can see the
--                        insert counts in the .lst file.
--   18-May-99 H Schmed   Fixed the PA insert to only add Xop PA records if 
--                        the application instance count is greater than 1.
--                        (The old version had added xop if greater than 0.)
--   14-Jun-99 D Glancy   Change XOP instance indicator from GX to X.
--   27-Jun-99 M Potluri  Modified  to solve the problem of shared 
--                        manufacturing views of financial modules for Cross-Op
--                        and commented out the code which populates XOP to NON 
--                        XOP references in n_application_xref table. 
--   01-Jul-99 M Potluri, R Kompella added code to insert relationships 
--                        between AR <-> RA
--                        (PA,PB,PC) <-> (PA,PB,PC) and 
--                        all XO instances to HR, PAY, NOETIX, FND.
--   13-Jul-99 H Schmed   Updated n_application_owners insert statements by
--                        adding an insert to chart_of_accounts_name.
--                        Added an additional statement to populate the 
--                        master_organization_id column.
--   15-Jul-99 H Schmed   Updated the first xref insert statement.  It was 
--                        excluding GL and FA cross-references to other modules
--                        because it was requiring a join on organization in the
--                        subquery.  I also changed the master organization 
--                        statement from the complex list of OR statements on
--                        the application label to a single statement on the
--                        master_organization_id column.
--   16-Jul-99 D Glancy   Map Cross-Op instance to NON Cross-Op instance only 
--                        when a Cross-Op instance to Cross-Op instance X 
--                        reference does not exists.  Solves the problem where 
--                        the Cross-Op instance does not have a valid reference 
--                        to another Cross-Op instance. Now the missing columns 
--                        in the inventory module appear as expected. 
--   22-Jul-99 D Glancy   1.  Change "create_cross_org_views_flag" variable name 
--                        to "create_cross_op_views_flag".  This will avoid some 
--                        confusion by the user.
--                        2.  Modified the mapping function from XOP to non-XOP.
--                        Was receiving duplicate rows inserted error.  Now will
--                        only create this mapping if the xop to xop reference 
--                        did not exist and only if the number of instances that
--                        correspond to the chart of accounts is equal to 1.
--   26-Jul-99 D Glancy   1.  Do not include any cross references that should 
--                        have been like 'X%' but did not generate because the 
--                        application was not loaded/referenced.
--   28-Jul-99 H Schmed   Updated the Xop insert statement for HR, Noetix, FND,
--                        etc. to insert a install status of S (rather than I)
--                        since they will only be used as references.
--   28-Jul-99 H Schmed   Updated the Xop insert statement for HR, Noetix, FND,
--                        etc. so that it only inserts Xop roles when the user
--                        has answered 'Y' to the Xop question.
--   10-Aug-99 D Glancy   1.  Update the 
--                            n_view_parameters.create_cross_op_views_flag
--                            column with the user selection.
--                        2.  Print the selection in the xorg.lst file.
--   12-Aug-99 D Glancy   Changed the utlprmpt call with a normal prompt 
--                        statement. No need to display this to the user.
--   16-Aug-99 D Glancy   Reworked how we create the instance number.
--                        Created the gen_xop_instance procedure to 
--                        create the "X%" instances starting with 0 and 
--                        incrementing from there.
--   18-Aug-99 D Glancy   Add the period_set_name and global_multi_calendar 
--                        columns to the update statements.
--   30-Aug-99 R Kompella Added update statement to populate xop_instance
--                        column for standard views.
--   20-Sep-99 R Lowe     Update copyright info.
--   01-Dec-99 H Schmed   Modified cursors C1 and C2 so that they now group
--                        by owner_name (to remove the chance that multi-
--                        owner installations will try to install XOP). Added
--                        cursor comments and formatted the script history.
--   16-Feb-00 H Sumanam  Update copyright info.
--   21-Jul-00 D Glancy   Use the PRODUCT_VERSION and FND_VERSION stored in tconnect.sql.
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   22-May-02 D Glancy   Added the "column owner_name clear" statement to ensure the owner_name
--                        and table_name columns do not affect column definitions in later scripts.
--                        (Issue #6596)
--   06-Feb-03 D Glancy   Updated retrieval of HR userid to be standard with other modules.
--   07-Feb-03 D Glancy   Fixed bugs introduced in 6-Feb-03 change.
--   19-May-03 D Glancy   Do an extra check for 'APP REQUIRES APP' references between OE and 
--                        JTP, QP, and WSH.  Ensure we connect any XOP OE instances to the 
--                        corresponding JTP, QP, and WSH applications.
--                        NOTE:  If we ever add the JTF, QP, and WSH as 'REAL' applications, 
--                        we may need to rethink this design.  The above assumes that JTF, 
--                        QP, and WSH are the equivalent to OE and can be shared with OE 
--                        instances.
--                        (Issue 10563,9617)
--   22-May-03 M Potluri  Fixed xref from XOP instance to non XOP instance if XOP intance to XOP
--                        reference is not existed. issue #10564
--   17-Jul-03 D Glancy   Added undefine statements to clean up environment. (Issue #8561)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   15-Nov-05 D Glancy   Add XOP support for GMS and IGW.
--                        (Issue 15417)
--   23-Jan-06 D Glancy   Add support for new columns in n_application_owners.
--                        (Issue 11935)
--   18-Mar-06 D Glancy   Checking the xop_instance_allowed flag for the c3 cursor was causing query block errors in
--                        autojoin.  To fix this issue for now, we'll not check the flag and insert these records normally,
--                        even though an xop instance will not be created.  Don't really want to set this flag to Y for 
--                        the affected modules, but may need them to xref properly between xop and these modules.
--                        (Issue 11935)
--   16-Nov-06 D Glancy   Should be using HR_ALL_ORGANIZATION_UNITS_TL if available for 
--                        organizational unit name.
--                        (Issue 11950)
--   21-Nov-06 D Glancy   Fixed bug introduced by original fix for this issue.
--                        The HR_TL_COMMENT variable was in the wrong place in the where clause.
--                        (Issue 11950)
--   21-Nov-06 D Glancy   Additional problem found with use of the hr_organization_units table for 10.7.
--                        (Issue 11950)
--   02-Mar-07 D Glancy   It looks like since the Global instance is getting included in the counts when determining
--                        if the XOP grouping should be created.  Updated the code to exclude Global (and XOP just in case)
--                        from the detection sql.
--                        (Issue 16816)
--   14-Mar-07 D Glancy   Add support for 'CS' module.
--                        (Issue 16803)
--   07-May-07 D Glancy   Add support for 'CSD', 'CSF', and 'CSI' module.
--                        (Issue 17582)
--   02-Jul-07 D Glancy   Add support for 'EAM' module.
--                        (Issue 17727)
--   09-Jul-07 D Glancy   Fixed issue with support for 'EAM' module.
--                        (Issue 17727)
--   28-Sep-07 D Glancy   Add Support for the fact that LEDGER_NAME/_ID has 
--                        replaced SET_OF_BOOKS_NAME/_ID.
--                        (Issue 18282)
--   23-Oct-07 D Glancy   Add support for 'PJM' and 'MSC'.
--                        (Issue 18001)
--   12-Dec-07 P Vemuru   Added Source_Instance_ID as part of MSC views development (Issue No: 5357)
--   21-Mar-08 D Glancy   Add an extra commit to sync up the environment.  This seems to work better in some
--                        environments.
--                        (Issue 19247)
--   23-Apr-08 D Glancy   The 19247 issue was brought up again with Issue 19564.  I believe that some of the
--                        inserts into n_application_xref caused this issues on 10g databases.  I believe by
--                        using group by instead of distinct and adding a rownum = 1 to the exists/not exists clauses
--                        will prevent a buffer overflow in the insert clause.  This is conjecture, but it appears to fix
--                        the issue for now.
--                        (Issue 19247 and 19564)
--   04-Jun-08 D Glancy   Remove the "select distinct" in favor with "Group By".  Think this may help
--                        with the problems we have with seg as not all columns are being inserted correctly.
--                        Optimized as many queries as possible.
--                        (Issue - 19418)
--   26-Aug-08 D Glancy   Add support for QA and FV.
--                        (Issue 20398 and 20564)
--    09-Feb-09 D Glancy  Ensure that the XXNAO application xrefs with all other X% applications/application_instances.
--                        We're doing this so that we can include the XXNAO_ACL_<APPL>_<ORG TYPE>_MAP_BASE views
--                        in modules other than XXNAO.
--                        (Issue 21378)
--    13-Feb-09 R Raghudev Ensure that XXKFF application xrefs with all other G0 application instances. We are doing this
--                        so that we can include XXKFF views in modules other than XXKFF.
--                        (Issue 21542)
--    10-Sep-09 D Glancy  Add xref between IBY and both AP(XOP), AR (XOP), and PO(XOP).
--                        (Issue 22496)
--    22-Jun-11  D Glancy XXHIE should be treated as a global module much like XXKFF.
--
-- Ask the user which option to choose: 
--             create views that spans business units or not.
--   13-Nov-13  Kkondaveeti Add support for 'OKE' module.
--

@utlspon xorg
set termout off

--
-- New function to determine what the next application instance number
-- should be for XOP instances.
--
create or replace 
procedure gen_xop_instances(i_app_label in varchar2)
as
    --
    -- Identify XOP roles for FA, GL, GMS, IGW, PA, PB, PC applications
    -- grouping by distinct COAS.
    cursor c1( c_app_label varchar2 ) is
    select nao.application_label,                                  -- 1
           nao.application_id,                                     -- 2
--           'S'                             base_application,       -- 4
           max(nao.base_application)       base_application,       -- 4
           max(nao.oracle_install_status)  oracle_install_status,  -- 5a
           'I'                             install_status,         -- 5b
           max(nao.owner_name)             owner_name,             -- 6
           max(nao.oracle_id)              oracle_id,              -- 7
           'Cross '||( CASE
                         WHEN ( &PRODUCT_VERSION >= 12 ) THEN 'Ledger'
                         ELSE 'Set of Books'
                       END )||' (COA: '||
                       max(coa.id_flex_structure_name)||')'
                                           set_of_books_name,      -- 9
           ''                              organization_name,      -- 11
           max(nao.chart_of_accounts_id)   chart_of_accounts_id,   -- 14
           max(coa.id_flex_structure_name) chart_of_accounts_name, -- 15
           ( CASE count(distinct nao.currency_code)
               WHEN 1 THEN max(nao.currency_code)
               ELSE ''
             END      )                    currency_code,          -- 16
           ( CASE count(distinct nao.currency_code)
               WHEN 1 THEN 'N'
               ELSE 'Y'
             END           )               global_multi_currency,  -- 18
           ( CASE count(distinct nao.period_set_name)
               WHEN 1 THEN max(nao.period_set_name)
               ELSE ''
             END      )                    period_set_name,        -- 19
           ( CASE count(distinct nao.period_set_name)
               WHEN 1 THEN 'N'
               ELSE 'Y'
             END       )                   global_multi_calendar,  -- 20
           ( CASE nao.application_label
               WHEN 'FA' THEN ''
               WHEN 'FV' THEN ''
               WHEN 'GL' THEN ''
               ELSE 'Cross Operating Unit COA: '||
                     max(coa.id_flex_structure_name)||')' 
             END       )                   org_name                -- 22
      from n_application_owner_templates  naot,
           n_application_owners           nao,
           fnd_id_flex_structures_view    coa
     where nao.application_label    = c_app_label
       and nao.install_status       in ('I','S')
       and nao.base_application     in ('Y','S')
       and substrb(nao.application_instance,1,1) not in ('G','X')
       and nao.chart_of_accounts_id is not null
       and coa.id_flex_num (+)      = nao.chart_of_accounts_id
       and coa.id_flex_code         = 'GL#'
       and coa.application_id       = 101
       and naot.application_label   = nao.application_label
       and nvl(naot.xop_instances_allowed,'N')    = 'Y'
       and upper( '&CREATE_CROSS_OP_VIEWS_FLAG' ) = 'Y'
     group by nao.application_label, 
              nao.application_id, 
--              nao.base_application,
              nao.chart_of_accounts_id,
              nao.owner_name
    having count(nao.application_instance) > 1;
    --
    -- Identify XOP roles for manufacturing and subledger applications
    -- grouping by distinct COAS and master organization.
    cursor c2( c_app_label varchar2 ) is
    select nao.application_label,                                  -- 1
           nao.application_id,                                     -- 2
--           'S'                             base_application,       -- 4
           max(nao.base_application)       base_application,       -- 4
           max(nao.oracle_install_status)  oracle_install_status,  -- 5a
           'I'                             install_status,         -- 5b
           max(nao.owner_name)             owner_name,             -- 6
           max(nao.oracle_id)              oracle_id,              -- 7
           'Cross '||( CASE
                         WHEN ( &PRODUCT_VERSION >= 12 ) THEN 'Ledger'
                         ELSE 'Set of Books'
                       END )||' (COA: '||
                   max(coa.id_flex_structure_name)||')'
                                           set_of_books_name,      -- 9
           'Cross INV/MFG Organization '||
           '(COA: '||max(coa.id_flex_structure_name)||')'
                                           organization_name,      -- 11
           max(nao.master_organization_id) master_organization_id, -- 12
           max(nao.chart_of_accounts_id)   chart_of_accounts_id,   -- 14
           max(coa.id_flex_structure_name) chart_of_accounts_name, -- 15
           ( CASE count(distinct nao.currency_code)
               WHEN 1 THEN max(nao.currency_code)
               ELSE ''
             END      )                    currency_code,          -- 16
           ( CASE count(distinct nao.currency_code)
               WHEN 1 THEN 'N'
               ELSE 'Y'
             END       )                   global_multi_currency,  -- 18
           ( CASE count(distinct nao.period_set_name)
               WHEN 1 THEN max(nao.period_set_name)
               ELSE ''
             END      )                    period_set_name,        -- 19
           ( CASE count(distinct nao.period_set_name)
               WHEN 1 THEN 'N'
               ELSE 'Y'
             END           )               global_multi_calendar,  -- 20
           ( CASE nao.application_label
               WHEN 'INV' THEN ''
               WHEN 'BOM' THEN ''
               WHEN 'CST' THEN ''
               WHEN 'WIP' THEN ''
               WHEN 'EAM' THEN ''
               WHEN 'ENG' THEN ''
               WHEN 'MRP' THEN ''
               WHEN 'QA'  THEN ''
                   --## EXCLUDE MSC as it it not INV and ##--
                   --## COA is null                      ##--
               WHEN 'CRP' THEN ''
               ELSE 'Cross Operating Unit (COA: '||
                    max(coa.id_flex_structure_name)||')' 
             END )                        org_name                -- 22
      from n_application_owner_templates  naot,
           n_application_owners           nao,
           fnd_id_flex_structures_view    coa
     where nao.application_label        = c_app_label
       and nao.install_status          in ('I','S')
       and nao.base_application        in ('Y','S')
       and substrb(nao.application_instance,1,1) not in ('G','X')
       and nao.chart_of_accounts_id    is not null
       and nao.master_organization_id  is not null
       and coa.id_flex_num (+)          = nao.chart_of_accounts_id
       and coa.id_flex_code             = 'GL#'
       and coa.application_id           = 101
       and naot.application_label   = nao.application_label
       and nvl(naot.xop_instances_allowed,'N')    = 'Y'
       and upper( '&CREATE_CROSS_OP_VIEWS_FLAG')  = 'Y'
     group by nao.application_label,
           nao.application_id, 
--           nao.base_application,
           nao.chart_of_accounts_id, 
           nao.master_organization_id,
           nao.owner_name
    having count(nao.application_instance) > 1;
    --
    -- Identify "dummy" XOP roles for non-XOP applications.
    cursor c3( c_app_label varchar2 ) is
    select nao.application_label,                                  -- 1
           nao.application_id,                                     -- 2
           'S'                             base_application,       -- 4
           nao.oracle_install_status       oracle_install_status,  -- 5a
           'S'                             install_status,         -- 5b
           nao.owner_name,                                         -- 6
           nao.oracle_id,                                          -- 7
           nao.set_of_books_name,                                  -- 9
           nao.organization_name,                                  -- 11
           nao.master_organization_id,                             -- 12
           nao.chart_of_accounts_id,                               -- 14
           nao.currency_code,                                      -- 16
           'N'                             global_multi_currency,  -- 18
           nao.period_set_name,                                    -- 19
           'N'                             global_multi_calendar,  -- 20
           ''                              org_name                -- 22
      from n_application_owner_templates  naot,
           n_application_owners           nao
     where nao.application_label                = c_app_label
       and naot.application_label               = nao.application_label
       -- ********************************************************
       -- Need these instance to be xop-able but not really sure if we want to update the allowed flag to yes, since
       -- it is not really true.  For now, we'll allow these applications to create the dummy xop instance.
       --
       -- and nvl(naot.xop_instances_allowed,'N')  = 'Y'
       --
       -- ********************************************************
       and upper('&CREATE_CROSS_OP_VIEWS_FLAG') = 'Y' 
       and nao.application_instance =
           ( select min(b.application_instance)
               from n_application_owners b
              where nao.application_label = b.application_label
                and nao.application_id    = b.application_id
                and rownum                = 1
           );

    v_seq_number number := 0;
begin

    --
    --  Create cross org views for application_label 'CS','CSD', 'CSF', 'CSI' 
    --  Create cross org views for application_label 'GL','FA'        - 
    --  Create cross org views for application_label 'PB', 'PA', 'PC', 'PJM', 'OKE' -
    --  Create cross org views for application_label 'GMS', 'IGW'     -
    --  chart of accounts is required.
    --
    if i_app_label in ( 'CS', 'CSD', 'CSF', 'CSI', 'FA', 'FV', 'GL', 'GMS', 'IGW', 
                        'PA', 'PB',  'PC',  'PJM', 'OKE' ) then
        for r1 in c1( i_app_label ) loop -- {

            insert into n_application_owners
            (
                application_label,            -- 1
                application_id,               -- 2
                application_instance,         -- 3
                base_application,             -- 4
                oracle_install_status,        -- 5a
                install_status,               -- 5b
                owner_name,                   -- 6
                oracle_id,                    -- 7
                set_of_books_name,            -- 9
                organization_name,            -- 11
                chart_of_accounts_id,         -- 14
                chart_of_accounts_name,       -- 15
                currency_code,                -- 16
                global_multi_currency,        -- 18
                period_set_name,              -- 19
                global_multi_calendar,        -- 20
                org_name                      -- 22
            )
            values
            (
                r1.application_label,         -- 1
                r1.application_id,            -- 2
                'X'||to_char(v_seq_number),   -- 3
                r1.base_application,          -- 4
                r1.oracle_install_status,     -- 5a
                r1.install_status,            -- 5b
                r1.owner_name,                -- 6
                r1.oracle_id,                 -- 7
                r1.set_of_books_name,         -- 9
                r1.organization_name,         -- 11
                r1.chart_of_accounts_id,      -- 14
                r1.chart_of_accounts_name,    -- 15
                r1.currency_code,             -- 16
                r1.global_multi_currency,     -- 18
                r1.period_set_name,           -- 19
                r1.global_multi_calendar,     -- 20
                r1.org_name                   -- 22
            );

            v_seq_number := v_seq_number + 1;

        end loop;
    --
    -- Create the global application instances for the sub-ledgers -
    -- Create the global application instances for the manufacturing modules -
    -- chart of accounts and master organization are required.
    --
    elsif i_app_label in ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP',
                           'AP',  'AR',  'OE',  'PJM', 'PO',  'RA'   ) then

        for r2 in c2( i_app_label ) loop -- {

            insert into n_application_owners 
            (
                   application_label,      -- 1
                   application_id,         -- 2
                   application_instance,   -- 3
                   base_application,       -- 4
                   oracle_install_status,  -- 5a
                   install_status,         -- 5b
                   owner_name,             -- 6
                   oracle_id,              -- 7
                   set_of_books_name,      -- 9
                   organization_name,      -- 11
                   master_organization_id, -- 12
                   chart_of_accounts_id,   -- 14
                   chart_of_accounts_name, -- 15
                   currency_code,          -- 16
                   global_multi_currency,  -- 18
                   period_set_name,        -- 19
                   global_multi_calendar,  -- 20
                   org_name                -- 22
            )
            values
            (
                r2.application_label,         -- 1
                r2.application_id,            -- 2
                'X'||to_char(v_seq_number),   -- 3
                r2.base_application,          -- 4
                r2.oracle_install_status,     -- 5a
                r2.install_status,            -- 5b
                r2.owner_name,                -- 6
                r2.oracle_id,                 -- 7
                r2.set_of_books_name,         -- 9
                r2.organization_name,         -- 11
                r2.master_organization_id,    -- 12
                r2.chart_of_accounts_id,      -- 14
                r2.chart_of_accounts_name,    -- 15
                r2.currency_code,             -- 16
                r2.global_multi_currency,     -- 18
                r2.period_set_name,           -- 19
                r2.global_multi_calendar,     -- 20
                r2.org_name                   -- 22
            );
 
            v_seq_number := v_seq_number + 1;

        end loop;
    -- NOTE:  Added MSC here as it should never generate an "real" XOP record
    -- However I have this commented out below.  If we still need the dummy record,
    -- we can uncomment the gen_xop_instance call.
    elsif i_app_label in ('HR','PAY','NOETIX','FND','MSC') then

        for r3 in c3( i_app_label ) loop -- {

            insert into n_application_owners 
            (
                   application_label,      -- 1
                   application_id,         -- 2
                   application_instance,   -- 3
                   base_application,       -- 4
                   oracle_install_status,  -- 5a
                   install_status,         -- 5b
                   owner_name,             -- 6
                   oracle_id,              -- 7
                   set_of_books_name,      -- 9
                   organization_name,      -- 11
                   master_organization_id, -- 12
                   chart_of_accounts_id,   -- 14
                   currency_code,          -- 16
                   global_multi_currency,  -- 18
                   period_set_name,        -- 19
                   global_multi_calendar,  -- 20
                   org_name                -- 22
            )
            values
            (
                r3.application_label,         -- 1
                r3.application_id,            -- 2
                'X'||to_char(v_seq_number),   -- 3
                r3.base_application,          -- 4
                r3.oracle_install_status,     -- 5a
                r3.install_status,            -- 5b
                r3.owner_name,                -- 6
                r3.oracle_id,                 -- 7
                r3.set_of_books_name,         -- 9
                r3.organization_name,         -- 11
                r3.master_organization_id,    -- 12
                r3.chart_of_accounts_id,      -- 14
                r3.currency_code,             -- 16
                r3.global_multi_currency,     -- 18
                r3.period_set_name,           -- 19
                r3.global_multi_calendar,     -- 20
                r3.org_name                   -- 22
            );
 
            v_seq_number := v_seq_number + 1;

        end loop;

    end if;

end gen_xop_instances;
/
show errors;

prompt
prompt Generate Cross Operations Extension Views (if required)
prompt 
prompt User selected the following option:
prompt .    Create Cross Operations Extension Views?  - &CREATE_CROSS_OP_VIEWS_FLAG
prompt 

--
-- Execute code to populate n_application_owners with the new Cross Operational
-- instances (X% instances).
--
begin
   
    --
    --  Create cross org views for application_label 'GL','FA' - 
    --  chart of accounts is required.
    --
    gen_xop_instances('FA');
    gen_xop_instances('FV');
    gen_xop_instances('GL');

    --
    --  Create cross org views for application_label 'PB', 'PA', 'PC', 'PJM', 'OKE' -
    --  chart of accounts is required.
    --      
    gen_xop_instances('PA');
    gen_xop_instances('PB');
    gen_xop_instances('PC');
    gen_xop_instances('PJM');
    gen_xop_instances('OKE');

    --
    --  Create cross org views for application_label 'CS' -
    --  chart of accounts is required.
    --      
    gen_xop_instances('CS');
    gen_xop_instances('CSD');
    gen_xop_instances('CSF');
    gen_xop_instances('CSI');

    --
    --  Create cross org views for application_label 'GMS', 'IGW' -
    --  chart of accounts is required.
    --      
    gen_xop_instances('GMS');
    gen_xop_instances('IGW');

    --
    -- Create the global application instances for the sub-ledgers -
    -- chart of accounts and master organization are required.
    --
    gen_xop_instances('AP');
    gen_xop_instances('AR');
    gen_xop_instances('OE');
    gen_xop_instances('PO');
    gen_xop_instances('RA');

    --
    -- Create the global application instances for the manufacturing modules -
    -- chart of accounts and master organization are required.
    --
    gen_xop_instances('BOM');
    gen_xop_instances('CRP');
    gen_xop_instances('CST');
    gen_xop_instances('EAM');
    gen_xop_instances('ENG');
    gen_xop_instances('INV');
    gen_xop_instances('MRP');
    gen_xop_instances('QA');
    gen_xop_instances('WIP');

    --
    -- Create Global application instances for HR,PAY,FND,NOETIX,MSC
    -- (with an install status of S for shared)
    --

    gen_xop_instances('FND');
    gen_xop_instances('HR');
    gen_xop_instances('NOETIX');
    gen_xop_instances('PAY');
    -- Since MSC is not supposed to be XREF'd anyway,
    -- Comment out for now.
    -- gen_xop_instances('MSC');

end;
/

commit;

--
--
-- Populate the master organization name for the xop view records in 
-- n_application_owners.
--

--
-- Update n_application_owners with the master organization name.
--
UPDATE n_application_owners ao
   SET ao.master_organization_name = 
       ( SELECT replace(hrtl.name, '''', '''''')
           FROM hr_all_organization_units_tl_s hrtl,
                hr_all_organization_units_s    hr
          WHERE hr.organization_id = ao.master_organization_id
            AND hrtl.organization_id (+) = hr.organization_id
            AND hrtl.language (+)     like NOETIX_ENV_PKG.GET_LANGUAGE      )
 WHERE ao.application_instance like 'X%'
/

-- Commit here as it seems to help catch up the commits for the later processing.
commit;

--
--
@utlprmpt "Create Cross Operational References (if required)"

--
--
-- Map Cross-Op instance to Cross-Op instance
--
insert into n_application_xref 
(
       application_label,
       application_instance,
       ref_application_label,
       ref_application_instance
)
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       refap.application_instance
  from n_application_owners ap,
       n_application_owners refap,
       n_app_to_app a2a
 where ap.application_label       = a2a.application_label 
   and refap.application_label    = a2a.ref_application_label
   and ap.application_instance    like 'X%'
   and refap.application_instance like 'X%'
   and a2a.dependency_direction   = 'APP REQUIRES REF'
   and ap.chart_of_accounts_id    = refap.chart_of_accounts_id
   and NVL(ap.master_organization_id, -9999) = 
       NVL(refap.master_organization_id,
           NVL(ap.master_organization_id, -9999))
   and exists 
           ( select 'ref existed for non xop'
               from  n_application_xref  xref
                    ,n_application_owners  ap1
                    ,n_application_owners refap1
              where xref.application_label      = ap.application_label
                and xref.ref_application_label  = refap.application_label
                and ap1.application_label       = xref.application_label
                and ap1.application_instance    = xref.application_instance 
                and ap1.chart_of_accounts_id    = ap.chart_of_accounts_id
                and refap1.application_label    = xref.ref_application_label
                and refap1.application_instance = xref.ref_application_instance
                and refap1.chart_of_accounts_id = refap.chart_of_accounts_id
                and NVL(ap1.organization_id, -9999) =
                    NVL(refap1.organization_id, NVL(ap1.organization_id, -9999))
                and ap1.chart_of_accounts_id    = refap1.chart_of_accounts_id
                and ap1.application_instance    not like 'X%'
                and refap1.application_instance not like 'X%'
                and NVL(ap1.master_organization_id, -9999)    = NVL(ap.master_organization_id, -9999)
                and NVL(refap1.master_organization_id, -9999) = NVL(refap.master_organization_id, -9999)
                and NVL(ap.master_organization_id, -9999)     = NVL(refap.master_organization_id,
                                                                    NVL(ap.master_organization_id, -9999))
                and rownum                      = 1
           )
 group by ap.application_label,
          ap.application_instance,
          refap.application_label,
          refap.application_instance;

--
-- M Potluri, R Kompella added code to insert relationships between XOP AR <-> RA
--                       ,(PA,PB,PC) <-> (PA,PB,PC)
--
-- Insert relationships between AR and RA for Release 10
--
insert into n_application_xref 
       (
       application_label,
       application_instance,
       ref_application_label,
       ref_application_instance
       )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       refap.application_instance
  from n_application_owners refap,
       n_application_owners ap
 where &PRODUCT_VERSION >= 10
   and (   (     ap.application_label    = 'AR'
             and refap.application_label = 'RA')
        or (     ap.application_label    = 'RA'
             and refap.application_label = 'AR'))
   and ap.owner_name = refap.owner_name
   and nvl(ap.chart_of_accounts_id,-9)      = 
           nvl(refap.chart_of_accounts_id,nvl(ap.chart_of_accounts_id,-9))
   and nvl(ap.master_organization_id,-9)      = 
           nvl(refap.master_organization_id,nvl(ap.master_organization_id,-9))
   and ap.application_instance    like 'X%'       -- xorg
   and refap.application_instance like 'X%'       -- xorg               
   and not exists 
        ( select null 
            from n_application_xref x
           where x.application_label      = ap.application_label
             and x.application_instance   = ap.application_instance
             and x.ref_application_label  = refap.application_label
             and rownum                   = 1        )
 group by ap.application_label,
          ap.application_instance,
          refap.application_label,
          refap.application_instance;

--       and x.ref_application_instance = refap.application_instance);
--
-- Insert relationships between PA, PB, PC
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       refap.application_instance
  from n_application_owners refap,
       n_application_owners ap
 where &PRODUCT_VERSION >= 10
   and (
        (       ap.application_label    = 'PA'
         and    refap.application_label = 'PB')
   or   (       ap.application_label    = 'PB'
         and    refap.application_label = 'PA')
   or   (       ap.application_label    = 'PA'
         and    refap.application_label = 'PC')
   or   (       ap.application_label    = 'PC'
         and    refap.application_label = 'PA')
   or   (       ap.application_label    = 'PB'
         and    refap.application_label = 'PC')
   or   (       ap.application_label    = 'PC'
         and    refap.application_label = 'PB')
   or   (       ap.application_label    = 'OKE'
         and    refap.application_label = 'PA')
   or   (       ap.application_label    = 'PA'
         and    refap.application_label = 'OKE')
   or   (       ap.application_label    = 'OKE'
         and    refap.application_label = 'PB')
   or   (       ap.application_label    = 'PB'
         and    refap.application_label = 'OKE')
   or   (       ap.application_label    = 'OKE'
         and    refap.application_label = 'PC')
   or   (       ap.application_label    = 'PC'
         and    refap.application_label = 'OKE')
       )
   and ap.owner_name                   = refap.owner_name
   and ap.chart_of_accounts_id         = refap.chart_of_accounts_id
   and ap.application_instance      like 'X%'  -- xorg
   and refap.application_instance   like 'X%'  -- xorg        
   and not exists 
     ( select null 
         from n_application_xref x
        where x.application_label     = ap.application_label
          and x.application_instance  = ap.application_instance
          and x.ref_application_label = refap.application_label)
 group by ap.application_label,
          ap.application_instance,
          refap.application_label,
          refap.application_instance
;

-- Clean up any actions so far.
commit;
-- 
-- Insert relationships between existing XOP instances and HR,PAY,NOETIX,FND
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       min(refap.application_instance)
  from n_application_owners refap,
       n_application_owners ap
 where &PRODUCT_VERSION >= 10
   and ap.application_label         != refap.application_label
   and refap.application_label      in ('HR','PAY','FND','NOETIX')
   and ap.application_instance    like 'X%'     -- xorg
   and refap.application_instance like 'X%'     -- xorg        
   and not exists 
     ( select null 
         from n_application_xref x
        where x.application_label     = ap.application_label
          and x.application_instance  = ap.application_instance
          and x.ref_application_label = refap.application_label)
 group by ap.application_label,
          ap.application_instance,
          refap.application_label;
-- 
-- Insert relationships between existing XOP instances and XXNAO
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       min(refap.application_instance)
  from n_application_owners refap,
       n_application_owners ap
 where &PRODUCT_VERSION >= 10
   and ap.application_label         != refap.application_label
   and refap.application_label      in ('XXNAO')
   and ap.application_instance    like 'X%'     -- xorg
   and refap.application_instance like '0'      -- xorg        
   and not exists 
     ( select null 
         from n_application_xref x
        where x.application_label     = ap.application_label
          and x.application_instance  = ap.application_instance
          and x.ref_application_label = refap.application_label)
 group by ap.application_label,
          ap.application_instance,
          refap.application_label;
--
--
-- 
-- Insert relationships between existing XOP/G0 instances and XXKFF
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       min(refap.application_instance)
  from n_application_owners refap,
       n_application_owners ap
 where &PRODUCT_VERSION >= 10
   and ap.application_label         != refap.application_label
   and refap.application_label      in ('XXKFF','XXHIE')
   and (ap.application_instance    like 'X%' OR
        ap.application_instance    like 'G0')    -- xorg
   and refap.application_instance  like '0'      -- xorg        
   and not exists 
     ( select null 
         from n_application_xref x
        where x.application_label     = ap.application_label
          and x.application_instance  = ap.application_instance
          and x.ref_application_label = refap.application_label)
 group by ap.application_label,
          ap.application_instance,
          refap.application_label;
--
--
-- Make sure the dependencies are reciprocal
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select x.ref_application_label,
       x.ref_application_instance,
       x.application_label,
       min(x.application_instance)
  from n_application_xref x
 where not exists 
    ( select null
        from n_application_xref x2
       where x2.ref_application_label    = x.application_label
    --   and x2.ref_application_instance = x.application_instance
         and x2.application_label        = x.ref_application_label
         and x2.application_instance     = x.ref_application_instance )
   and x.application_instance      like 'X%'   -- Do it for XOP <-> XOP only
   and x.ref_application_instance  like 'X%'  
 group by x.ref_application_label,
          x.ref_application_instance,
          x.application_label
;
--
-- 
-- dglancy 16-Jul-1999
-- Map Cross-Op instance to NON Cross-Op instance only when
-- a Cross-Op instance to Cross-Op instance X reference does not exists.
-- Solves the problem where the Cross-Op instance does not have a valid
-- reference to another Cross-Op instance.  Now the missing columns in the
-- inventory module appear as expected. 
--
insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       min(refap.application_instance)
  from n_application_owners ap,
       n_application_owners refap,
       n_app_to_app         a2a
 where ap.application_label              = a2a.application_label
   and refap.application_label           = a2a.ref_application_label
   and ap.application_instance        like 'X%'
   and refap.application_instance not like 'X%'
   and a2a.dependency_direction          = 'APP REQUIRES REF'
   and ap.chart_of_accounts_id           = refap.chart_of_accounts_id
   -- Add the X ref to GL, FA, HR modules
   and (    (     refap.application_label in ('FA','FV','GL','HR')
              and NVL( ap.master_organization_id, -9999) = 
                       NVL( refap.master_organization_id,
                            NVL(ap.master_organization_id, -9999 ) ) )
   -- Add xref to other modules 
         or (     refap.application_label not in ('FA','FV','GL','HR')
              and NVL(ap.master_organization_id, -9999) = 
                ( select nvl(min(nap.master_organization_id),
                             nvl(ap.master_organization_id,-9999))
                    from n_application_owners nap
                   where nap.application_label      = refap.application_label
                     and nap.master_organization_id = refap.master_organization_id
                     and nap.chart_of_accounts_id   = ap.chart_of_accounts_id )
            )  )
   and not exists
     ( select 'XOP reference exists'
         from n_application_owners ap1,
              n_application_owners refap1,
              n_application_xref   apxref
        where ap1.application_label           = apxref.application_label
          and refap1.application_label        = apxref.ref_application_label
          and apxref.application_instance     = ap.application_instance
          and apxref.ref_application_instance like 'X%'
          and ap1.chart_of_accounts_id        = ap.chart_of_accounts_id
          and ap1.application_label           = ap.application_label
          and refap1.application_label        = refap.application_label
          and ap1.chart_of_accounts_id        = refap1.chart_of_accounts_id
          and NVL(ap1.master_organization_id, -9999) = 
                  NVL(refap1.master_organization_id,
                      NVL(ap1.master_organization_id, -9999))  
          and rownum                          = 1 )
-- Do not include any cross references that should have been like 'X%' but did 
-- not generate because the application was not loaded/referenced.
   and exists 
     ( select 'Non-xop exists'
         from n_application_owners refap1
        where refap1.application_label                  = refap.application_label
          and refap1.application_instance        not like 'X%'
          and refap1.chart_of_accounts_id               = refap.chart_of_accounts_id
          and NVL(refap1.master_organization_id, -9999) = NVL(refap.master_organization_id,-9999) )
   and exists 
     ( select 'ref existed for non xop'
         from n_application_xref    xref,
              n_application_owners  ap1,
              n_application_owners  refap1
        where xref.application_label             = ap.application_label
          and xref.ref_application_label         = refap.application_label
          and ap1.application_label              = xref.application_label
          and ap1.application_instance           = xref.application_instance 
          and ap1.chart_of_accounts_id           = ap.chart_of_accounts_id
          and refap1.chart_of_accounts_id        = refap.chart_of_accounts_id
          and refap1.application_label           = xref.ref_application_label
          and refap1.application_instance        = xref.ref_application_instance
          and refap1.application_instance        = xref.ref_application_instance 
          and NVL(ap1.organization_id, -9999)    =
                      NVL(refap1.organization_id, NVL(ap1.organization_id, -9999))
          and ap1.chart_of_accounts_id           = refap1.chart_of_accounts_id
          and ap1.application_instance    not like 'X%'
          and refap1.application_instance not like 'X%'
          and NVL(ap1.master_organization_id, -9999)    = NVL(ap.master_organization_id, -9999)
          and NVL(refap1.master_organization_id, -9999) = NVL(refap.master_organization_id, -9999)
          and NVL(ap.master_organization_id, -9999)     = NVL(refap.master_organization_id,
                                                             NVL(ap.master_organization_id, -9999))
          and rownum                             = 1                )
 group by ap.application_label,
          ap.application_instance,
          refap.application_label
;

insert into n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
select ap.application_label,
       ap.application_instance,
       refap.application_label,
       min(refap.application_instance)
  from n_application_owners ap,
       n_application_owners refap,
       n_app_to_app a2a
 where ap.application_label              = 'OE'
   and ap.application_label              = a2a.application_label
   and refap.application_label          in ( 'JTF', 'QP', 'WSH' )
   and refap.application_label           = a2a.ref_application_label
   and ap.application_instance        like 'X%'
   and refap.application_instance not like 'X%'
   --and a2a.dependency_direction   = 'APP REQUIRES REF'
   and not exists
     ( select 'XOP reference exists'
         from n_application_xref   apxref
        where apxref.application_label        = ap.application_label
          and apxref.application_instance     = ap.application_instance
          and apxref.ref_application_label    = refap.application_label
          and apxref.ref_application_instance = refap.application_instance   )
 group by ap.application_label,
          ap.application_instance,
          refap.application_label
;

INSERT INTO n_application_xref 
     ( application_label,
       application_instance,
       ref_application_label,
       ref_application_instance )
SELECT ap.application_label,
       ap.application_instance,
       refap.application_label,
       min(refap.application_instance)
  FROM n_application_owners ap,
       n_application_owners refap,
       n_app_to_app a2a
 WHERE ap.application_label             in ( 'AP', 'AR', 'PO' )
   AND ap.application_label              = a2a.application_label
   AND refap.application_label          in ( 'IBY' )
   AND refap.application_label           = a2a.ref_application_label
   AND ap.application_instance        like 'X%'
   AND refap.application_instance not like 'X%'
   --And a2a.dependency_direction   = 'APP REQUIRES REF'
   AND not exists
     ( SELECT 'XOP reference exists'
         FROM n_application_xref   apxref
        WHERE apxref.application_label        = ap.application_label
          AND apxref.application_instance     = ap.application_instance
          AND apxref.ref_application_label    = refap.application_label
          AND apxref.ref_application_instance = refap.application_instance   )
 GROUP by ap.application_label,
          ap.application_instance,
          refap.application_label
;


-- Update the XOP_INSTANCE column with the correct XOP application_instance
update n_application_owners nao
   set xop_instance = ( select application_instance
                          from n_application_owners nao1
                         where nao1.application_label       = nao.application_label
                           and application_instance      like 'X%'
                           and nao1.chart_of_accounts_id    = nao.chart_of_accounts_id
                           and nvl(nao1.master_organization_id,-9999)
                                                            = nvl(nao.master_organization_id,-9999)
 )
 where application_instance not like 'X%'
   and application_instance not like 'G%';
--
-- Populate the flag depending on the value of the xop_instance column
-- 'Y' means we want to use the org in xop
-- 'N' means we don't want to use this org in xop
update n_application_owners nao
   set use_org_in_xop_flag = ( CASE substrb(nao.xop_instance,1,1)
                                 WHEN 'X' THEN 'Y'
                                 ELSE 'N'
                               END    )
 where application_instance not like 'X%'
   and application_instance not like 'G%';
--
commit;
--
@utlspoff

-- end xorg.sql
