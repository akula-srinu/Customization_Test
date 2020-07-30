-- Title
--   xorgcfg.sql
-- Function
--   Performs some configuration needed to process the global views.
--
--   1. Loads N_NOETIX_COLUMN_LOOKUP, N_CROSS_ORG_MAP_ALIAS
--   2. Loads N_UNPARTITIONED_VIEWS_TEMP
--   3. Add new columns to the global views temporary table(s)
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   15-Oct-98 C Lee      created
--   27-Apr-99 H Schmed   Modified the n_noetix_column_lookup population section
--                        so that it now uses dynamic SQL.  The way it had been
--                        coded only worked if the Noetix_Sys account had select
--                        any table privileges.
--   01-May-99 H Schmed   Modified the section that adds HR_ORGANIZATION_UNITS
--                        to the view.  In R11 that table is called HR_ALL_
--                        ORGANIZATION_UNITS, so I changed two sections to use
--                        the appropriate table name based on the version.
--   14-May-99 H Schmed   Modified the section that adds the
--                        HR_ORGANIZATION_UNITS table.  The code was
--                        changing all from clause positions of 1 to 1.999
--                        This is very dangerous.  I changed the code to
--                        instead look up the minimum from clause position
--                        and subtract from there to get the new from
--                        clause position.
--   25-May-99 H Schmed   Changed the new column name from Organization_name to
--                        Organization_Name.
--   07-Jun-99 M Potluri  Changed to check whether adding columns(organization_
--                        Name,Operating_Unit,set_of_books_name) are already
--                        existed in in view, if exists this code
--                        doesn't add corresponding table,where_clause,column
--                        to views.
--   09-Jun-99 D Glancy   Changed Operating_Unit to Operating_Unit_Name.
--   11-jun-99 M Potluri  Modified If column_name is organization_name for
--                        XOP application_instance in n_view_columns and
--                        omit_flag 'Y', then deleted those Rows to allow
--                        add the same column and not violate the constraint.
--   14-Jun-99 D Glancy   Change XOP instance indicator from GX to X.
--   18-Jun-99 D Glancy   1.  For organization_id, give join priority to
--                        MTL_Parameters table in from clause.
--                        2.  For organization_id, remove outer join from
--                        generated where clause.
--   23-Jun-99 M Potluri  Update the c1 cursor.  Add the XOPORG
--                        special_process_code to the cursor.
--   11-Aug-99 D Glancy   Change spacing for the where clause that begins with
--                        ' AND.*' to 'AND.*'.  Effects output of genview.
--   02-Sep-99 M Potluri  Modified Cursor to look for  Set_Of_Books_Name in
--                        GL and FA, Operating_Unit_Name in subledger modules
--                        and Organization_Name in mfg modules.
--   20-Sep-99 R Lowe     Update copyright info.  Change whenever sqlerror
--                        error number to make it unique.
--   16-Feb-00 H Sumanam  Update copyright info.
--   11-Dec-00 D Glancy   Update Copyright info.
--   25-Jan-01 D Glancy   Modified the query used to populate the
--                        n_org_columns_temp table.  When the select any
--                        table option is not present, add RULE hint to
--                        queries.  Also added join to the fnd_oracle_userid
--                        table.  Since we are looking for oracle apps
--                        lookup columns this should work and save about
--                        14 minutes.
--   30-Jul-01 H Schmed   Modified the GL/FA SOB processing so that if
--                        the join table is a non-base table, it must
--                        match the view's application. (Issue 4466)
--                        Modified the operating unit and organization
--                        processing to follow the same within-appl
--                        guidelines for non-base tables.
--                        Changed the default table alias from ending
--                        with the session_id to beginning with the
--                        text 'XOP_GEN_'.
--                        Updated comments.
--                        Removed tabs from code.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   06-May-02 D Glancy   1.  Converted to use substrb instead of substr.
--                        2.  Converted to use instrb instead of instr.
--                        (Issue #5447)
--   26-Aug-02 D Glancy   Added the gen_search_by_col_flag to the inserts into
--                        the n_view_tables table.  Support for new dumptodo.
--   31-Jul-03 D Glancy   User_sys_privs may have multiple rows returned (USER
--                        or PUBLIC). Only allow one match to return.
--                        (Issue 10924)
--   21-Aug-03 H Schmed   Updated all of the n_cross_org_map_alias inserts to
--                        exclude n_view_tables records flagged as subqueries.
--                        (Pyramid Issue 11141)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   08-Apr-04 D Glancy   Missing a join in the c1 cursor.
--   28-Jun-04 D Glancy   Prevent the 'Table not found' error.
--                        No longer check for select any table.
--                        For Oracle 9i+, it's a little more complicated.  In order to read sys tables, you
--                        must have the SELECT ANY DICTIONARY privilege, or have SELECT ANY TABLE and the
--                        O7_DICTIONARY_ACCESSIBILITY parameter set to TRUE.  It's easier to
--                        let the parse process fail and then handle the exception in the exception handler.
--                        (Issue 11124)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   15-Nov-05 D Glancy   Add XOP support for GMS and IGW.
--                        (Issue 15417)
--   17-Aug-06 P Vemuru   Added gen_search_by_col_flag in insert statement of n_view_columns
--                        (Multnomah: Issue 14251)
--   16-Nov-06 D Glancy   Should be using HR_ALL_ORGANIZATION_UNITS_TL if available for 
--                        organizational unit name.
--                        (Issue 11950)
--   21-Nov-06 D Glancy   8.0.6 database did not like the use of at for an alias.  Changed alias to fix
--                        error in 10.7 and 11.
--                        (Issue 11950)
--   18-Dec-06 D Glancy   In the c1 cursor, we should outerjoin if the base_table_flag of the
--                        alias is 'N'.
--                        In the original code, we outerjoined on sob and org_id and not on organization_id.
--                        Changed code to match that if we are not using the _TL table.  Otherwise, use the outerjoin
--                        if we are using _TL table and not the base table.
--                        (Issue 11950)
--   14-Mar-07 D Glancy   Add support for 'CS' module.
--                        (Issue 16803)
--   23-Apr-07 D Glancy   SOB table is obsolete as of R12.  Replaced with GL_LEDGERS 
--                        (Issue 17537)
--   07-May-07 D Glancy   Add support for 'CSD', 'CSF', and 'CSI' modules.
--                        (Issue 17582)
--   02-Jul-07 D Glancy   Add support for 'EAM' module.
--                        (Issue 17727)
--   30-Aug-07 D Glancy   There was a problem with the updated code.  The FND_VERSION variable did not have the ampersand
--                        in front of it.
--                        (Issue 17537)
--   28-Sep-07 D Glancy   Add Support for the fact that LEDGER_NAME/_ID has 
--                        replaced SET_OF_BOOKS_NAME/_ID.
--                        (Issue 18282)
--   23-Oct-07 D Glancy   Add support for 'PJM' and 'MSC'.
--                        (Issue 18001)
--   12-Dec-07 P Vemuru   MSC application should not be included as part of the 
--                        xorgcfg check.  This is an assumption that since is global only,
--                        we will never generate the ORGANIZATION_ID variable.  This may or may not
--                        be true.  I belive that once we have included the xmap table, these issues 
--                        may go away with the proper metadata.  At that point, we may still need
--                        to address the ORGANIZATION_ID issue here.
--                        (Issue No: 5357)
--   26-Aug-08 D Glancy   Add support for QA and FV.
--                        (Issue 20395 and 20564)
--   23-Feb-09 D Glancy   Need to check for BASEVIEW% now as SEG will add another baseview type.
--                        (Issue 21542)
--   08-Feb-11 Hatakesh   Modification related to T_Column_ID implementations.(ISSUE 25640)
--   26-Oct-11 D Glancy   Performance improvement to return the table and columns.
--                        Similar to the methods used in orgid.sql.
--                        (ISSUE 28019)
--   04-Jan-13 D Glancy   Use execute immediate instead of dbms_sql.
--                        (Issue 31553)
--   13-Nov-13 kkondaveeti Added support for 'OKE' module
--
start wdrop table &NOETIX_USER n_unpartitioned_views_temp
--
whenever sqlerror exit 222
--
set serveroutput off;
--
@utlspon xorgcfg
--
set echo off
--
--
-- ################################################################################
-- Populate the temporary table(n_noteix_column_lookup) with all of the tables
-- that contain an Organization_Id, Org_Id or Set_Of_Books_Id column.
--
prompt fill temp column lookup table
DECLARE
    --
    v_has_select_any_dict   VARCHAR2(1);
    v_sql                   VARCHAR2(4000); -- Changed the variable size from 500 to 4000
    --
BEGIN

    -- No longer check for select any table.
    -- For Oracle 9i+, it's a little more complicated.  In order to read sys tables, you
    -- must have the SELECT ANY DICTIONARY privilege, or have SELECT ANY TABLE privilege
    -- AND the O7_DICTIONARY_ACCESSIBILITY parameter set to TRUE.

    -- If the n_has_select_any_dictionary function returns values other than 'Y',
    -- then executes the slower method via the exception block.
    select 'Y'
      into v_has_select_any_dict
      from dual
     where n_has_select_any_dictionary = 'Y';

    --
    -- If we can, use the faster method of selecting directly
    -- from the database catalog tables.  In order for this
    -- PL/SQL to compile in all instances, execute this new
    -- code as dynamic SQL.
    --
    v_sql := 'INSERT INTO n_noetix_column_lookup '
           ||     '( table_name, column_name ) '
           ||'SELECT /*+ RULE */ o.name, c.name '
           || ' FROM sys.obj$ o, '
           ||      ' sys.col$ c, '
           ||      ' (SELECT fou.oracle_username username '
           ||         ' FROM fnd_oracle_userid_s fou '
           ||        ' WHERE fou.oracle_username <> user '
           ||        ' UNION ALL '
           ||        ' SELECT user '
           ||          ' FROM dual)  u1, '
           ||        ' sys.user$ u '
           || 'WHERE c.name IN (''SET_OF_BOOKS_ID'', ''LEDGER_ID'',  '
           ||                 ' ''ORG_ID'', ''ORGANIZATION_ID'') '
           ||  ' AND c.obj#      = o.obj# '
           ||  ' AND o.owner#    = u.user# '
           ||  ' AND u.name NOT IN ( ''SYS'', ''SYSTEM'' ) '
           ||  ' AND u.name = u1.username '
           ||' GROUP BY o.name, c.name  ';
    --
    --
    -- Parse and execute the statement dynamically
    execute immediate v_sql;
    --
EXCEPTION
    when NO_DATA_FOUND then
        --
        -- Populate the lookup table the old fashioned way
        --
        INSERT INTO n_noetix_column_lookup
             ( table_name, 
               column_name )
        SELECT /*+ RULE */
                atc.table_name, 
                atc.column_name
          FROM all_tab_columns atc,
               fnd_oracle_userid_s fou
         WHERE atc.owner            = fou.oracle_username
           and fou.oracle_username <> user
           AND atc.column_name IN
                    ( 'SET_OF_BOOKS_ID','LEDGER_ID','ORG_ID','ORGANIZATION_ID' )
         GROUP BY atc.table_name, 
                  atc.column_name
         UNION ALL
        SELECT /*+ RULE */
               utc.table_name, 
               utc.column_name
          FROM user_objects     o,
               user_tab_columns utc
         WHERE utc.column_name   IN
                    ( 'SET_OF_BOOKS_ID','LEDGER_ID','ORG_ID','ORGANIZATION_ID' )
           AND utc.table_name     = o.object_name
           AND o.object_type NOT IN (             'PACKAGE',   'PACKAGE BODY', 
                                      'FUNCTION', 'PROCEDURE', 'INDEX', 
                                      'TYPE',     'SEQUENCE',  'TRIGGER', 'TABLE PARTITION' )
         GROUP BY utc.table_name, 
                  utc.column_name;
        --
END; -- End of adding tables to n_noetix_column_lookup
/

BEGIN  -- Add Noetix base views to n_noetix_colum_lookup (XOP only)
      --
      insert into n_noetix_column_lookup
      ( table_name, column_name )
      SELECT c.view_name,
             upper( c.column_name )
        FROM n_view_columns c,
             n_views        v
       WHERE c.view_name = v.view_name
         AND nvl( c.omit_flag,'N' )     = 'N'
         AND v.special_process_code  LIKE 'BASEVIEW%'
         AND v.application_instance  LIKE 'X%'
         AND upper( c.column_name )    IN
           ( 'SET_OF_BOOKS_ID','LEDGER_ID','ORG_ID','ORGANIZATION_ID' )
       GROUP BY c.view_name, upper( c.column_name );

END;  -- End of adding Noetix base views to n_noetix_column_lookup
/
commit
;
--
-- ################################################################################
-- Determine which table alias to use for the maps.
--   This basically picks one table for each view and query that can be used
--   as a link for SET_OF_BOOKS_ID, ORG_ID or ORGANIZATION_ID. The selection
--   criteria favors base over non-base tables
--
--
prompt Determine which table alias to use in the maps
--
--
-- Determine which table alias to use in the SOB maps
--
-- First, load the alias for those tables that are base tables
insert into n_cross_org_map_alias
     (
       application_label,
       view_label,
       view_name,
       query_position,
       map_type,
       table_alias,
       owner_name,
       table_name,
       base_table_flag,
       sob_column_name
     )
select distinct
       v.application_label,
       v.view_label,
       v.view_name,
       t.query_position,
       'SET_OF_BOOKS_ID',
       t.table_alias,
       t.owner_name,
       t.table_name,
       t.base_table_flag,
       'SET_OF_BOOKS_ID'
  from n_views           v,
       n_view_tables     t
 where t.view_label              = v.view_label
   and t.view_name               = v.view_name
   and nvl(v.omit_flag,'N')      = 'N'
   and v.application_label      in ( 'FA' ,'FV', 'GL' )
   and v.application_instance like 'X%'
   and nvl(t.omit_flag,'N')      = 'N'
   and nvl(t.subquery_flag, 'N') = 'N'
   and t.base_table_flag         = 'Y'
   and t.from_clause_position    =
     ( select min( t2.from_clause_position )
         from n_view_tables t2
        where t2.view_label              = t.view_label
          and t2.view_name               = t.view_name
          and t2.query_position          = t.query_position
          and nvl(t2.omit_flag,'N')      = 'N'
          and nvl(t2.subquery_flag, 'N') = 'N'
          and t2.base_table_flag         = 'Y'
          and exists
            ( select tt.table_name
                from n_noetix_column_lookup tt
               where tt.column_name in ('SET_OF_BOOKS_ID','LEDGER_ID')
                 and tt.table_name   = t2.table_name ) )
;
commit
/

-- Second, load the alias for those remaining tables that are non-base tables
insert into n_cross_org_map_alias
     (
       application_label,
       view_label,
       view_name,
       query_position,
       map_type,
       table_alias,
       owner_name,
       table_name,
       base_table_flag,
       sob_column_name
     )
select distinct
       v.application_label,
       v.view_label,
       v.view_name,
       t.query_position,
       'SET_OF_BOOKS_ID',
       t.table_alias,
       t.owner_name,
       t.table_name,
       t.base_table_flag,
       'SET_OF_BOOKS_ID'
  from n_views v,
       n_view_tables t
 where t.view_label              = v.view_label
   and t.view_name               = v.view_name
   and nvl(v.omit_flag,'N')      = 'N'
   and v.application_label      in ( 'FA', 'FV', 'GL' )
   and v.application_instance like 'X%'
   and nvl(t.omit_flag,'N')      = 'N'
   and nvl(t.subquery_flag, 'N') = 'N'
   and t.base_table_flag         = 'N'
   and t.from_clause_position    =
     ( select min( t2.from_clause_position )
         from n_view_tables t2
        where t2.view_label              = t.view_label
          and t2.view_name               = t.view_name
          and t2.query_position          = t.query_position
          and nvl(t2.omit_flag,'N')      = 'N'
          and nvl(t2.subquery_flag, 'N') = 'N'
          and t2.application_label       = v.application_label -- GL/FA
          and t2.base_table_flag         = 'N'
          and exists
            ( select tt.table_name
                from n_noetix_column_lookup tt
               where tt.column_name in ( 'SET_OF_BOOKS_ID', 'LEDGER_ID' )
                 and tt.table_name   = t2.table_name ) )
          and not exists
            ( select 'already here'
                from n_cross_org_map_alias coma
               where coma.application_label = v.application_label
                 and coma.view_label          = v.view_label
                 and coma.view_name           = v.view_name
                 and coma.query_position      = t.query_position
                 and coma.map_type            = 'SET_OF_BOOKS_ID' )
;
commit
/

-- If this is r12 and above determine the proper column_name for this table
update n_cross_org_map_alias map
   set sob_column_name = 'LEDGER_ID'
 where &FND_VERSION >= 12
   and map.map_type      = 'SET_OF_BOOKS_ID'
   and exists
     ( select /*+ RULE */ l.column_name
         from n_noetix_column_lookup l
        where l.table_name   = map.table_name
          and l.column_name  = 'LEDGER_ID' );

commit
/

--
-- Determine which table alias to use in the OU maps
--

-- First, load the alias for those tables that are base tables
insert into n_cross_org_map_alias
     (
       application_label,
       view_label,
       view_name,
       query_position,
       map_type,
       table_alias,
       owner_name,
       table_name,
       base_table_flag
     )
select distinct
       v.application_label,
       v.view_label,
       v.view_name,
       t.query_position,
       'ORG_ID',
       t.table_alias,
       t.owner_name,
       t.table_name,
       t.base_table_flag
  from n_views v,
       n_view_tables t
 where t.view_label              = v.view_label
   and t.view_name               = v.view_name
   and nvl(v.omit_flag,'N')      = 'N'
   and v.application_label      in
           ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' )
   and v.application_instance like 'X%'
   and nvl(t.omit_flag,'N')      = 'N'
   and nvl(t.subquery_flag, 'N') = 'N'
   and t.base_table_flag         = 'Y'
   and t.from_clause_position    =
     ( select min( t2.from_clause_position )
         from n_view_tables t2
        where t2.view_label              = t.view_label
          and t2.view_name               = t.view_name
          and t2.query_position          = t.query_position
          and nvl(t2.omit_flag,'N')      = 'N'
          and nvl(t2.subquery_flag, 'N') = 'N'
          and t2.base_table_flag         = 'Y'
          and exists
            ( select tt.table_name
                from n_noetix_column_lookup tt
               where tt.column_name    = 'ORG_ID'
                 and tt.table_name     = t2.table_name ) )
;
commit
/

-- second load the alias for those remaining tables that are non-base tables
insert into n_cross_org_map_alias
     (
       application_label,
       view_label,
       view_name,
       query_position,
       map_type,
       table_alias,
       owner_name,
       table_name,
       base_table_flag
     )
select distinct
       v.application_label,
       v.view_label,
       v.view_name,
       t.query_position,
       'ORG_ID',
       t.table_alias,
       t.owner_name,
       t.table_name,
       t.base_table_flag
  from n_views v,
       n_view_tables t
 where t.view_label              = v.view_label
   and t.view_name               = v.view_name
   and nvl(v.omit_flag,'N')      = 'N'
   and v.application_label      in
                   ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' )
   and v.application_instance like 'X%'
   and nvl(t.omit_flag,'N')      = 'N'
   and nvl(t.subquery_flag, 'N') = 'N'
   and t.base_table_flag         = 'N'
   and t.from_clause_position    =
     ( select min( t2.from_clause_position )
         from n_view_tables t2
        where t2.view_label          = t.view_label
          and t2.view_name           = t.view_name
          and t2.query_position      = t.query_position
          and nvl(t2.omit_flag,'N')  = 'N'
          and nvl(t2.subquery_flag, 'N') = 'N'
          and decode(t2.application_label,
                     'PB','PA',
                     'PC','PA',
                     'RA','AR',
                     t2.application_label) =
              decode(v.application_label,
                     'PB','PA',
                     'PC','PA',
                     'RA','AR',
                     v.application_label)
          and t2.base_table_flag     = 'N'
          and exists
            ( select tt.table_name
                from n_noetix_column_lookup tt
               where tt.column_name  = 'ORG_ID'
                 and tt.table_name   = t2.table_name ) )
  and not exists
    ( select 'already here'
        from n_cross_org_map_alias coma
       where coma.application_label  = v.application_label
         and coma.view_label         = v.view_label
         and coma.view_name          = v.view_name
         and coma.query_position     = t.query_position
         and coma.map_type           = 'ORG_ID' )
;
commit
/

--
-- Determine which table alias to use in the ORGANIZATION maps
--
-- First, try to find an MTL_PARAMETERS table we can use as the
-- table alias (no outerjoins).
insert into n_cross_org_map_alias
     (
       application_label,
       view_label,
       view_name,
       query_position,
       map_type,
       table_alias,
       owner_name,
       table_name,
       base_table_flag
     )
select distinct
       v.application_label,
       v.view_label,
       v.view_name,
       t.query_position,
       'ORGANIZATION_ID',
       t.table_alias,
       t.owner_name,
       t.table_name,
       'Y'
  from n_views v,
       n_view_tables t
 where t.view_label               = v.view_label
   and t.view_name                = v.view_name
   and nvl(v.omit_flag,'N')       = 'N'
   and v.application_label       in
             -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
             -- Leave it out of the list for now.
             ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' )
   and v.application_instance  like 'X%'
   and nvl(t.omit_flag,'N')       = 'N'
   and nvl(t.subquery_flag, 'N')  = 'N'
   and t.table_name               = 'MTL_PARAMETERS'
   and t.from_clause_position     =
     ( select min( t2.from_clause_position )
         from n_view_tables t2
        where t2.view_label              = t.view_label
          and t2.view_name               = t.view_name
          and t2.table_name              = 'MTL_PARAMETERS'
          and t2.query_position          = t.query_position
          and nvl(t2.omit_flag,'N')      = 'N'
          and nvl(t2.subquery_flag, 'N') = 'N'
          and exists
            ( select tt.table_name
                from n_noetix_column_lookup tt
               where tt.column_name = 'ORGANIZATION_ID'
                 and tt.table_name  = t2.table_name )
          -- Exclude those tables that are outer joined
          and not exists
            ( select 'Outer join exists'
                from n_view_wheres vw
               where vw.view_name           = t2.view_name
                 and vw.query_position      = t2.query_position
                 and nvl(vw.omit_flag,'N')  = 'N'
                 -- This is not perfect check
                 -- does not check conditions where a list of
                 -- tables is used on the outer join side.
                 and  (   decode(
                      sign(instrb(vw.where_clause,'=')-
                           instrb(vw.where_clause,'(+)')),
                      -1,substrb(upper(vw.where_clause),
                                instrb(vw.where_clause,'=')),
                       1,substrb(upper(vw.where_clause),1,
                                instrb(vw.where_clause,'=')),
                       0,decode(
                           sign(instrb(upper(vw.where_clause),' LIKE ')-
                                instrb(vw.where_clause,'(+)')),
                           -1,substrb(upper(vw.where_clause),
                                     instrb(vw.where_clause,'=')),
                            1,substrb(upper(vw.where_clause),1,
                                     instrb(vw.where_clause,'=')),
                            0,upper(vw.where_clause))) like
                           upper('%'||table_alias||'.%(+)%')
                   or decode(
                      sign(instrb(vw.where_clause,'=')-
                           instrb(vw.where_clause,'(+)')),
                      -1,substrb(upper(vw.where_clause),
                                instrb(vw.where_clause,'=')),
                       1,substrb(upper(vw.where_clause),1,
                                instrb(vw.where_clause,'=')),
                       0,decode(
                           sign(instrb(upper(vw.where_clause),' LIKE ')-
                                instrb(vw.where_clause,'(+)')),
                           -1,substrb(upper(vw.where_clause),
                                     instrb(vw.where_clause,'=')),
                            1,substrb(upper(vw.where_clause),1,
                                     instrb(vw.where_clause,'=')),
                            0,upper(vw.where_clause))) like
                           upper('%(+)%'||table_alias||'.%')       )
           )
     )
/
commit
/

-- Second, load the alias for those tables that are base tables
insert into n_cross_org_map_alias
     (
       application_label,
       view_label,
       view_name,
       query_position,
       map_type,
       table_alias,
       owner_name,
       table_name,
       base_table_flag
     )
select distinct
       v.application_label,
       v.view_label,
       v.view_name,
       t.query_position,
       'ORGANIZATION_ID',
       t.table_alias,
       t.owner_name,
       t.table_name,
       t.base_table_flag
  from n_views v,
       n_view_tables t
 where t.view_label               = v.view_label
   and t.view_name                = v.view_name
   and nvl(v.omit_flag,'N')       = 'N'
   and v.application_label       in
             -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
             -- Leave it out of the list for now.
                   ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' )
   and v.application_instance  like 'X%'
   and nvl(t.omit_flag,'N')       = 'N'
   and nvl(t.subquery_flag, 'N')  = 'N'
   and t.base_table_flag          = 'Y'
   and t.from_clause_position     =
     ( select min( t2.from_clause_position )
         from n_view_tables t2
        where t2.view_label              = t.view_label
          and t2.view_name               = t.view_name
          and t2.query_position          = t.query_position
          and nvl(t2.omit_flag,'N')      = 'N'
          and nvl(t2.subquery_flag, 'N') = 'N'
          and t2.base_table_flag         = 'Y'
          and exists
            ( select tt.table_name
                from n_noetix_column_lookup tt
               where tt.column_name  = 'ORGANIZATION_ID'
                 and tt.table_name   = t2.table_name ) )
   and not exists
     ( select 'already here'
         from n_cross_org_map_alias coma
        where coma.application_label   = v.application_label
          and coma.view_label            = v.view_label
          and coma.view_name             = v.view_name
          and coma.query_position        = t.query_position
          and coma.map_type              = 'ORGANIZATION_ID' )
;
commit
/

-- Third, load the alias for those remaining tables that are non-base tables
insert into n_cross_org_map_alias
     (
        application_label,
        view_label,
        view_name,
        query_position,
        map_type,
        table_alias,
        owner_name,
        table_name,
        base_table_flag
     )
select distinct
       v.application_label,
       v.view_label,
       v.view_name,
       t.query_position,
       'ORGANIZATION_ID',
       t.table_alias,
       t.owner_name,
       t.table_name,
       t.base_table_flag
  from n_views v,
       n_view_tables t
 where t.view_label              = v.view_label
   and t.view_name               = v.view_name
   and nvl(v.omit_flag,'N')      = 'N'
   and v.application_label      in
             -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
             -- Leave it out of the list for now.
               ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' )
   and v.application_instance like 'X%'
   and nvl(t.omit_flag,'N')      = 'N'
   and nvl(t.subquery_flag, 'N') = 'N'
   and t.base_table_flag         = 'N'
   and t.from_clause_position    =
     ( select min( t2.from_clause_position )
         from n_view_tables t2
        where t2.view_label              = t.view_label
          and t2.view_name               = t.view_name
          and t2.query_position          = t.query_position
          and nvl(t2.omit_flag,'N')      = 'N'
          and nvl(t2.subquery_flag, 'N') = 'N'
          and decode(t2.application_label,
                     'CRP','MRP',
                     'CST','BOM',
                     t2.application_label) =
              decode(v.application_label,
                     'CRP','MRP',
                     'CST','BOM',
                     v.application_label)
          and t2.base_table_flag     = 'N'
          and exists
             ( select tt.table_name
               from n_noetix_column_lookup tt
               where tt.column_name = 'ORGANIZATION_ID'
               and   tt.table_name  = t2.table_name ) )
   and not exists
     ( select 'already here'
         from n_cross_org_map_alias coma
        where coma.application_label   = v.application_label
          and coma.view_label            = v.view_label
          and coma.view_name             = v.view_name
          and coma.query_position        = t.query_position
          and coma.map_type              = 'ORGANIZATION_ID' )
/
commit
/

-- this code does a good job, but there are some views that need some help
prompt update cross operational configuration data
@xorgcfgm

--
-- Spool the output into xorgcfg.lst to let anyone know about views with
-- potential problems. They views might be problematic because we could
-- end up outer joining to an IN.
--
prompt Warning: The following views (if any) may have problems in the
prompt .        global instances.
prompt

select distinct
       application_label||','||view_name||','||
       query_position||','||table_alias||','||map_type Views
  from n_cross_org_map_alias
 where base_table_flag = 'N'
;
--
-- ###############################################################################
-- Note: The following views (if any) are not partitioned by set of books, org_id
-- or organization_id.  This is not an error.  We are simply saving the list in
-- case we need it later.
--
prompt store unpartitioned views
create table n_unpartitioned_views_temp (
            view_name                     varchar2(30) not null,
            query_position                number not null,
            constraint n_unpartitioned_views_temp_pk
                  primary key (view_name,query_position)
                  using index storage ( initial 10K next 10K pctincrease 0 )
            )
            storage ( initial 10K next 10K pctincrease 0 )
/
--
insert into n_unpartitioned_views_temp
     (
       view_name,
       query_position
     )
select q.view_name, 
       q.query_position
  from n_view_queries q, 
       n_views        v
 where nvl(q.omit_flag,'N')      = 'N'
   and nvl(v.omit_flag,'N')      = 'N'
   and v.view_name               = q.view_name
   and v.application_instance like 'X%'
   and not exists
     ( select 'already here'
         from n_cross_org_map_alias map
        where map.view_label     = q.view_label
          and map.view_name      = q.view_name
          and map.query_position = q.query_position )
;
commit
/

-- If a partitioning column (Set_Of_Books_Name, Ledger_Name, Operating_Unit_Name,
-- Organization_Name) already exists in the view but was flagged as
-- omitted, delete the column so we don't end up with constraint
-- errors.
--
delete from n_view_columns nvc
 where column_name in ('Set_Of_Books_Name',   'Ledger_Name',
                       'Operating_Unit_Name', 'Organization_Name')
   and application_instance like 'X%'
   and omit_flag               = 'Y'
   and exists
     ( select 'column exists'
         from n_views v
        where v.view_name            = nvc.view_name
          and v.view_label           = nvc.view_label
          and v.application_instance = nvc.application_instance
          and v.application_label    = 'INV')
;
commit
/
--
-- ###############################################################################
--
-- Add new columns that report the Set_Of_Books_Name, Operating_Unit_Name
-- or Organization_Name.
--
prompt for the global views, add additional columns that report the node name
--
declare
    cursor c1 is
    select nao.application_label,
           nao.application_instance,
           v.view_label,
           v.view_name,
           q.query_position,
           map.table_alias,
           map.map_type,
           NVL(map.base_table_flag,'N') base_table_flag,
           map.sob_column_name
      from n_application_owners nao,
           n_view_queries q,
           n_view_templates temp,
           n_views v,
           n_cross_org_map_alias map
     where v.application_label       = nao.application_label
       and v.application_instance    = nao.application_instance
       and nvl(v.omit_flag,'N')      = 'N'
       and temp.application_label    = v.application_label
       and temp.view_label           = v.view_label
       and nvl(temp.special_process_code,'NONE')
                                     in ('NONE','CATEGORY','XOPORG')
      --  and   (v.special_process_code is null
      --   or    upper(v.special_process_code) = 'NONE')
       and q.view_name               = v.view_name
       and q.view_label              = v.view_label
       and q.application_instance    = v.application_instance
       and nvl(q.omit_flag,'N')      = 'N'
       and map.application_label     = v.application_label
       and map.view_label            = v.view_label
       and map.view_name             = v.view_name
       and map.query_position        = q.query_position
       and nao.application_instance  like 'X%'
       and not exists
         ( select 'column already exists'
             from n_view_columns nvc,
                  n_views v
            where v.view_label          = map.view_label
              and v.view_name           = map.view_name
              and nvc.view_label        = v.view_label
              and nvc.view_name         = v.view_name
              and nvc.query_position    = map.query_position
              and nvc.application_instance like 'X%'
              and
                (    (    v.application_label in ('FA', 'FV', 'GL')
                      and nvc.column_name       = 'Set_Of_Books_Name' )
                  or (    v.application_label in ('FA', 'FV', 'GL')
                      and nvc.column_name       = 'Ledger_Name' )
                  or (     v.application_label in ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE',
                                                    'PA', 'PB', 'PC', 'PJM', 'PO',  'RA', 'OKE')
                       and nvc.column_name      =  'Operating_Unit_Name')
                  -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
                  -- Leave it out of the list for now.
                  or (     v.application_label in ( 'BOM', 'CRP', 'CST', 'EAM',
                                                    'ENG', 'INV', 'MRP', 'QA',  'WIP' )
                       and nvc.column_name  =  'Organization_Name' )
                )
           ) ;
    --
    --
    --
    -- Define the constants
    c_increment_existing    NUMBER := .0001;
    c_decrement_new         NUMBER := .000001;
    --
    -- Declare the local variables
    v_gl_owner                    varchar2(30);
    v_hr_owner                    varchar2(30);
    v_product_version             varchar2(30);
    v_from_clause_position        n_view_tables.from_clause_position%TYPE;
    v_man_from_clause_position    n_view_tables.from_clause_position%TYPE;
    v_table_alias                 n_view_tables.table_alias%TYPE;
    v_table_name                  n_view_tables.table_name%TYPE;
    ls_metadata_table_name        n_view_tables.metadata_table_name%TYPE;
    v_owner_name                  n_view_tables.owner_name%TYPE;
    v_column_name                 n_view_columns.column_name%TYPE;
    v_column_name2                n_view_columns.column_name%TYPE;
    v_column_position             n_view_columns.column_position%TYPE;
    v_column_expression           n_view_columns.column_expression%TYPE;
    v_column_description          n_view_columns.description%TYPE;
    v_column_description2         n_view_columns.description%TYPE;
    v_where_clause_position       n_view_wheres.where_clause_position%TYPE;
    v_where_clause                n_view_wheres.where_clause%TYPE;
    v_where_clause2               n_view_wheres.where_clause%TYPE;
    v_jointo_column               varchar2(30);
    v_outerjoin                   varchar2(5)   := ' (+) ';
    v_min_from_clause             n_view_tables.from_clause_position%TYPE;
    vi_tl_count                   INTEGER := 0; 
    --
begin
    -- first, get the owners of GL and HR
    select distinct owner_name
      into v_gl_owner
      from n_application_owners
     where application_label = 'GL';

    select distinct owner_name
      into v_hr_owner
      from n_application_owners
     where application_label = 'HR';

    -- look up the current version
    select max(release_name) release_name
      into v_product_version
      from fnd_product_groups_v
     where product_group_id = 1;
    --
    -- Initialize the position variables
    v_from_clause_position        := 150;
    v_man_from_clause_position    := 1;
    v_where_clause_position       := 1500;
    v_column_position             := 200;

    SELECT count(*) 
      INTO vi_tl_count
      FROM all_tables a
     WHERE a.owner      = v_hr_owner
       AND a.table_name = 'HR_ALL_ORGANIZATION_UNITS_TL'
       AND rownum       = 1;

    for r1 in c1 loop

          v_column_name2 := null;
          if ( r1.map_type = 'SET_OF_BOOKS_ID' ) then
                v_table_alias         := 'SOB';
                if ( to_number('&FND_VERSION') < 12 ) then
                    v_table_name                := 'GL_SETS_OF_BOOKS';
                    ls_metadata_table_name      := 'GL_SETS_OF_BOOKS';
                    v_jointo_column             := 'set_of_books_id';
                else
                    ls_metadata_table_name      := 'GL_LEDGERS';
                    v_table_name                := get_target_table_name( v_gl_owner,
                                                                          ls_metadata_table_name );
                    v_jointo_column             := 'ledger_id';
                    v_column_name2              := 'Ledger_Name';
                    v_column_description        :=
                        'The name of the Ledger the current line is associated with.';
                end if;
                -- v_column_name := 'Xo_Set_Of_Books';
                v_owner_name          := v_gl_owner;
                v_column_expression   := 'NAME';
                v_column_description  :=
                        'The name of the &GL_ORG_NAMING_SINGLE that the current line is associated with.';
                v_column_name         := 'Set_Of_Books_Name';
                v_outerjoin           := ' (+) ';
          elsif ( r1.map_type = 'ORG_ID' ) then
                v_table_alias         := 'OU';
                if (substrb(v_product_version, 1, 2) = '10') then
                    ls_metadata_table_name      := 'HR_ORGANIZATION_UNITS';
                    v_table_name                := 'HR_ORGANIZATION_UNITS';
                else
                    if ( vi_tl_count = 0 ) then
                        ls_metadata_table_name      := 'HR_ALL_ORGANIZATION_UNITS';
                        v_table_name                := get_target_table_name( v_hr_owner,
                                                                              ls_metadata_table_name );
                    else
                        ls_metadata_table_name      := 'HR_ALL_ORGANIZATION_UNITS_TL';
                        v_table_name                := get_target_table_name( v_hr_owner,
                                                                              ls_metadata_table_name );
                    end if;
                end if;
                v_owner_name          := v_hr_owner;
                -- v_column_name := 'Xo_Operating_Unit';
                v_column_name         := 'Operating_Unit_Name';
                v_column_expression   := 'NAME';
                v_column_description  :=
               'The name of the Operating Unit the current line is '||
               'associated with.';
                v_jointo_column       := 'organization_id';
                v_outerjoin           := ' (+) ';
          elsif ( r1.map_type = 'ORGANIZATION_ID' ) then
                --
                -- We want to add the organization as the driving
                -- table, so its from clause position must be less
                -- than all existing from clause positions.
                --
                -- To accomplish this we first look up the minimum
                -- existing from clause position.
                --
                select min(from_clause_position)
                  into v_min_from_clause
                  from n_view_tables
                 where query_position  = r1.query_position
                   and view_name       = r1.view_name;
  
                -- If the min from clause position is 1, we're in a bind
                -- because the table constraints say that the from clause
                -- position must be between 1 and 200.
                -- If this is the case, we should update the existing
                -- minimum from clause position by our c_increment_existing
                -- constant (.0001) and then add the new record with a
                -- from clause position of the updated minimum from
                -- clause position minus the c_decrement_new constant
                -- (.000001).
                if (v_min_from_clause = 1) then
                      --
                      v_min_from_clause := v_min_from_clause +
                                           c_increment_existing;
                      update n_view_tables
                         set from_clause_position = v_min_from_clause
                       where query_position       = r1.query_position
                         and from_clause_position = 1
                         and view_name            = r1.view_name;
                end if;

                v_man_from_clause_position := v_min_from_clause;

                v_table_alias := 'ORG';
                if (substrb(v_product_version, 1, 2) = '10') then
                    ls_metadata_table_name      := 'HR_ORGANIZATION_UNITS';
                    v_table_name                := get_target_table_name( v_hr_owner,
                                                                          ls_metadata_table_name );
                else
                    if ( vi_tl_count = 0 ) then
                        ls_metadata_table_name      := 'HR_ALL_ORGANIZATION_UNITS';
                        v_table_name                := get_target_table_name( v_hr_owner,
                                                                              ls_metadata_table_name );
                    else
                        ls_metadata_table_name      := 'HR_ALL_ORGANIZATION_UNITS_TL';
                        v_table_name                := get_target_table_name( v_hr_owner,
                                                                              ls_metadata_table_name );
                    end if;
                end if;
                v_owner_name          := v_hr_owner;
                --    v_column_name := 'Xo_Inv_Organization';
                v_column_name         := 'Organization_Name';
                v_column_expression   := 'NAME';
                v_column_description  :=
                  'The name of the Inv-Mfg Organization the current line '||
                  'is associated with.';
                v_jointo_column       := 'organization_id';
                -- do not want to outer join organization_id columns
                if ( vi_tl_count        = 0   and
                     r1.base_table_flag = 'Y' ) then
                    v_outerjoin           := null;
                else
                    v_outerjoin           := ' (+) ';
                end if;
          end if;

          -- Create the generated table alias
          v_table_alias := 'XOP_GEN_'||v_table_alias;

          -- build the where clause as
          --  AND exist_t.set_of_books_id = new_t.set_of_books_id (+)
          --

          v_where_clause  := 'AND '||v_table_alias||'.'||v_jointo_column||v_outerjoin||' = '||
                                     r1.table_alias||'.'||nvl(r1.sob_column_name,r1.map_type);
          v_where_clause2 := 'AND '||v_table_alias||'.language (+) = noetix_env_pkg.get_language';


          v_from_clause_position     := v_from_clause_position     + 0.01;
          v_man_from_clause_position := v_man_from_clause_position - c_decrement_new;
          
          v_where_clause_position    := v_where_clause_position + 0.01;
          v_column_position          := v_column_position       + 0.01;

          --
          -- insert the new table into the query
          --
          insert into n_view_tables
          (
              view_name,
              view_label,
              query_position,
              table_alias,
              from_clause_position,
              application_label,
              owner_name,
              table_name,
              metadata_table_name,
              application_instance,
              base_table_flag,
              omit_flag,
              generated_flag,
              subquery_flag,
              gen_search_by_col_flag
          )
          values
          (
              r1.view_name,
              r1.view_label,
              r1.query_position,
              v_table_alias,
              decode(r1.map_type, 'ORGANIZATION_ID',
                   v_man_from_clause_position ,v_from_clause_position ),
              r1.application_label,
              v_owner_name,
              v_table_name,
              ls_metadata_table_name,
              r1.application_instance,
              -- decode(r1.map_type, 'ORGANIZATION_ID' , 'Y','N'),
              'N',
              'N',
              'Y',
              'N',
              'N'
          );

          --
          -- insert the new column into the query
          --
          insert into n_view_columns
          (   column_ID,
              view_name,              --1
              view_label,             --2
              query_position,         --3
              column_name,            --4
              column_label,           --5
              table_alias,            --6
              column_expression,      --7
              column_position,        --8
              column_type,            --9
              description,            --10
              group_by_flag,          --11
              application_instance,   --12
              omit_flag,              --13
              generated_flag,          --14
              gen_search_by_col_flag  --15
          )
          values
          (
              n_view_columns_seq.NEXTVAL,              -- generated column ID
              r1.view_name,           --1
              r1.view_label,          --2
              r1.query_position,      --3
              v_column_name,          --4
              v_column_name,          --5
              v_table_alias,          --6
              v_column_expression,    --7
              v_column_position,      --8
              'COL',                  --9
              v_column_description,   --10
              'Y',                    --11
              r1.application_instance,--12
              'N',                    --13
              'Y',                     --14
              'N'                     --15
          );
          
          if ( v_column_name2 is not null ) then
              --
              v_column_position          := v_column_position       + 0.01;
              --
              -- insert the new column into the query
              --
              insert into n_view_columns
              (   column_ID,
                  view_name,              --1
                  view_label,             --2
                  query_position,         --3
                  column_name,            --4
                  column_label,           --5
                  table_alias,            --6
                  column_expression,      --7
                  column_position,        --8
                  column_type,            --9
                  description,            --10
                  group_by_flag,          --11
                  application_instance,   --12
                  omit_flag,              --13
                  generated_flag,          --14
                  gen_search_by_col_flag  --15
              )
              values
              (   n_view_columns_seq.NEXTVAL,              -- generated column ID
                  r1.view_name,           --1
                  r1.view_label,          --2
                  r1.query_position,      --3
                  v_column_name2,         --4
                  v_column_name2,         --5
                  v_table_alias,          --6
                  v_column_expression,    --7
                  v_column_position,      --8
                  'COL',                  --9
                  v_column_description2,  --10
                  'Y',                    --11
                  r1.application_instance,--12
                  'N',                    --13
                  'Y',                     --14
                  'N'                     --15
              );
          end if;

          --
          -- insert a new where clause into the query, joining
          -- the new table to the one determined by c1
          --
          insert into n_view_wheres
          (
              view_name,
              view_label,
              query_position,
              where_clause_position,
              where_clause,
              application_instance,
              omit_flag,
              generated_flag
          )
          values
          (
              r1.view_name,
              r1.view_label,
              r1.query_position,
              v_where_clause_position,
              v_where_clause,
              r1.application_instance,
              'N',
              'Y'
          );

          -- If we're using the HR TL table, join in the language column.
          if ( vi_tl_count   <> 0 AND
               r1.map_type   <> 'SET_OF_BOOKS_ID' ) then
              insert into n_view_wheres
              (
                  view_name,
                  view_label,
                  query_position,
                  where_clause_position,
                  where_clause,
                  application_instance,
                  omit_flag,
                  generated_flag
              )
              values
              (
                  r1.view_name,
                  r1.view_label,
                  r1.query_position,
                  v_where_clause_position + .01,
                  v_where_clause2,
                  r1.application_instance,
                  'N',
                  'Y'
              );
          end if;

          -- commit whats been done so far
          commit;

    end loop;    -- r1
end;
/
--
commit
/
--
set echo on
--
@utlspoff

-- End xorgcfg.sql
