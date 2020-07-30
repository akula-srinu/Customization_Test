-- Title
--   xorgpop.sql
-- Function
--   Substitute configuration variables and perform other necessary 
--   magic to make these views work.
--
--   This must happen after autojoin xorgid because these scripts add
--   tables and where clauses.
--
--   1. Creates functions
--   2. Updates cross org meta-data in N_CROSS_ORG_MAP_ALIAS
--   3. Verifies if only one copy of "driving" config var exists
--   4. Adds additional where clause with config variable on driving table.
--   4. Adds "driving" config var if needed
--   5. Substitutes for all configuration variables in the WHERE clauses
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   25-Sep-98 C Lee      created
--   07-Jan-99 mpotluri   modified to identify problem views and populate those  
--                        into temp table , will be genarated separately by doing
--                        union all in genviewp.sql.
--   05-feb-99 mpotluri   modified to populate table n_xorg_global_comp which
--                        stores relation between global and componet views
--   13-Apr-99 mpotluri   modified to restrict duplicate views with the same orgid
--   04-Jun-99 mpotluri   changed  to not add duplicate rows to n_xorg_to_do_views
--   14-Jun-99 D Glancy   Change XOP instance indicator from GX to X.
--   22-Jun-99 D Glancy   Do not insert rows into n_xorg_to_do_views if the 
--                        corresponding view has the XOPORG special_process_code
--                        set.
--   19-Jul-99 M Potluri  Modified to add  omit_flag where ever this needs.
--   11-Aug-99 D Glancy   Change spacing for the where clause that begins with 
--                        ' AND.*' to 'AND.*'.  Effects output of genview.
--   30-Aug-99 H Schmed   Formatting changes only - added returns in comments and
--                        changed tabs to spaces.
--   30-Aug-99 R Kompella Consider xop_instance not being null on the component
--                        view instance while listing the component views for a
--                        given Global view.
--             M Potluri  Populating view_label,application_label,instance into 
--                        n_xorg_to_do_views.
--   20-Sep-99 R Lowe     Update copyright info.  Change whenever sqlerror
--                        error number to make it unique.
--   16-Feb-00 H Sumanam  Update copyright info.
--   16-Mar-00 H Schmed   Added a statement to insert view info into 
--                        n_xorg_prob_views if the view does not contain the
--                        "driving" configuration variables, but does contain
--                        other variables through outer joins.  Also, I added
--                        some formatting to the same section to stop the line
--                        wrapping (see the "straggler" section).
--   15-May-00 H Schmed   Placed rtrim() functions around the map_type 
--                        columns in the c1 cursor to remove the trailing 
--                        spaces.
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   06-May-02 D Glancy   1.  Converted to use instrb instead of instr.
--                        (Issue #5447)
--   26-Nov-03 D Glancy   Increased the size of the temp table to handle larger where clause lines.
--                        (Issue 11698 and 10843) 
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   26-Mar-04 D Glancy   Modified to use the new n_application_owner_globals table.  
--                        Modified the interface to n_xorgpop_func3 since we have to use
--                        a temp table to store a portion of the results.
--                        (Issue 11698 and 10843) 
--   08-Oct-04 D Glancy   When creating the decode line for SOB2CURR based where clause,
--                        an extra comma is being inserting in the where clause.  Updated
--                        the code that builds the where clause to take this into consideration.
--                        (Issue 13366)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   02-May-05 D Glancy   Truncated the n_view_where_updates_temp instead of dropping it at the 
--                        end of the routine.  We don't want the procedures/functions to go invalid. 
--                        (Issue 13945)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   15-Nov-05 D Glancy   Add XOP support for GMS and IGW.
--                        (Issue 15417)
--   20-Nov-05 D Glancy   Rename n_xop_mappings to new n_application_org_mappings.
--                        (Issue 15240)
--   16-Jan-07 D Glancy   With new xmap views, do not want to add the organization_id in list
--                        to views that are joining to one of the xmap tables.  XMAP takes
--                        care of this issue.  This is a Global Security Issue, but does not
--                        take into consideration other org related issues.  Will need to dive a bit
--                        deeper to figure out other necessary changes.
--                        (Issue 15240)
--   14-Mar-07 D Glancy   Add support for 'CS' module.
--                        (Issue 16803)
--   07-May-07 D Glancy   Add support for 'CSD', 'CSF', and 'CSI' modules.
--                        (Issue 17582)
--   02-Jul-07 D Glancy   Add support for 'EAM' module.
--                        (Issue 17727)
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
--   09-Feb-09 D Glancy   Change in design for global security.  We are now going to reference metadata
--                        generated views out of xxnao (XXNAO_ACL_<APPL>_<ORG>_MAP_BASE.
--                        (Issue 21378)
--   08-Apr-09 D Glancy   Use upper(table_name) for the XXNAO and <APPL>_<ORG_TYPE> map views in the check for 
--                        for XOPORG functionality.
--                        (Issue 21378)
--   13-Nov-13 kkondaveeti Added support for OKE
-- Drop the temporary table (if it exists)
start wdrop table &noetix_user n_view_where_updates_temp
--
whenever sqlerror exit 221
--
set serveroutput off;
set timing       on 
--
@utlspon xorgpop
--
define max_buffer=2000
column s_max_buffer new_value max_buffer noprint

select data_length s_max_buffer
  from sys.all_tab_columns
 where owner       = '&NOETIX_USER'
   and table_name  = 'N_VIEW_WHERES'
   and column_name = 'WHERE_CLAUSE'
;

--
--
set echo off
--
-- ###############################################################################
-- We need to make sure that there is only one instance of any of the "driving"
-- configuration variables in each view-query.  (Autojoin may have added some
-- additional ones through query objects, etc.)
--
-- The driving configuration variable for (a) is (b)
--   ( 'GL', 'FA' )                                              SET_OF_BOOKS_ID
--   ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 
--                 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' )   ORG_ID
-- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
-- Leave it out of the list for now.
--   ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' )  ORGANIZATION_ID
--
-- It is OK if a view has multiple copies of a non-driving configuration 
-- variable, such as if an OE view has multiple ORGANIZATION_ID variables.
-- This is because we will substitute these with a DECODE below.
--
prompt Ensure we only have one instance of any driving variables
create table n_view_where_updates_temp (
      view_name              VARCHAR2(30)                               not null,
      view_label             VARCHAR2(30),
      query_position         NUMBER                                     not null,
      where_clause_position  NUMBER                                     not null,
      where_clause           VARCHAR2(&MAX_BUFFER)                      not null,
      profile_option         VARCHAR2(30),
      application_instance   VARCHAR2(4),
      omit_flag              VARCHAR2(1),
      generated_flag         VARCHAR2(1),
      add_flag               varchar2(1)           default 'N',
      constraint n_view_where_updates_temp_pk
         primary key (view_name,query_position,where_clause_position)
         using index storage ( initial 100K next 100K pctincrease 0 )
      )
      storage ( initial 100K next 100K pctincrease 0 )
/

--
-- create the functions needed here
prompt create needed functions
@xorgpopf

--
--
declare
   cursor c1 is
   select v.application_label,
          v.application_instance,
          q.view_label,
          q.view_name,
          q.query_position,
          rtrim('SET_OF_BOOKS_ID') map_type
     from n_views v,
          n_view_queries q,
        ( select iw.view_label, 
                 iw.view_name, 
                 iw.query_position, count( iw.where_clause_position )
            from n_view_wheres iw, n_views iv
           where (    iw.where_clause like '%^SET_OF_BOOKS_ID%'
                   or iw.where_clause like '%^LEDGER_ID%' )
             and nvl(iw.omit_flag,'N')    = 'N'
             and iw.view_label            = iv.view_label
             and iw.view_name             = iv.view_name
             and nvl(iv.omit_flag,'N')    = 'N'
             and iv.application_label    in ( 'FA', 'FV', 'GL' )
             and iv.application_instance like 'X%'
           group by iw.view_label, 
                    iw.view_name, 
                    iw.query_position
          having count( iw.where_clause_position ) > 1 ) w2
     where q.view_label              = w2.view_label
       and q.view_name               = w2.view_name
       and q.query_position          = w2.query_position
       and nvl(q.omit_flag,'N')      = 'N'
       and v.view_label              = q.view_label
       and v.view_name               = q.view_name
       and nvl(v.omit_flag,'N')      = 'N'
       and v.application_instance like 'X%'
    union
    select v.application_label, 
           v.application_instance,
           q.view_label, 
           q.view_name, 
           q.query_position, 
           rtrim('ORG_ID') map_type
      from n_views v,
           n_view_queries q,
         ( select iw.view_label, iw.view_name, 
                  iw.query_position, count( iw.where_clause_position )
             from n_view_wheres iw, n_views iv
            where iw.where_clause like '%^ORG_ID%'
              and nvl(iw.omit_flag,'N') = 'N'
              and iw.view_label = iv.view_label
              and iw.view_name = iv.view_name
              and nvl(iv.omit_flag,'N') = 'N'
              and iv.application_label in 
                   ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 
                     'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' )
              and iv.application_instance like 'X%'
            group by iw.view_label, iw.view_name, iw.query_position
           having count( iw.where_clause_position ) > 1 ) w2
     where q.view_label            = w2.view_label
       and q.view_name             = w2.view_name
       and q.query_position        = w2.query_position
       and nvl(q.omit_flag,'N')    = 'N'
       and v.view_label            = q.view_label
       and v.view_name             = q.view_name
       and nvl(v.omit_flag,'N')    = 'N'
       and v.application_instance  like 'X%'
    union
    select v.application_label, 
           v.application_instance,
           q.view_label, 
           q.view_name, 
           q.query_position, 
           rtrim('ORGANIZATION_ID') map_type
      from n_views v,
           n_view_queries q,
         ( select iw.view_label, iw.view_name, 
                  iw.query_position, count( iw.where_clause_position )
             from n_view_wheres iw, n_views iv
            where iw.where_clause like '%^ORGANIZATION_ID%'
              and nvl(iw.omit_flag,'N') = 'N'
              and iw.view_label = iv.view_label
              and iw.view_name = iv.view_name
              and nvl(iv.omit_flag,'N') = 'N'
              -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
              -- Leave it out of the list for now.
              and iv.application_label in ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' )
              and iv.application_instance like 'X%'
            group by iw.view_label, iw.view_name, iw.query_position
           having count( iw.where_clause_position ) > 1 ) w2
     where q.view_label            = w2.view_label
       and q.view_name             = w2.view_name
       and q.query_position        = w2.query_position
       and nvl(q.omit_flag,'N')    = 'N'
       and v.view_label            = q.view_label
       and v.view_name             = q.view_name
       and nvl(v.omit_flag,'N')    = 'N'
       and v.application_instance  like 'X%';
    --
    cursor c2 ( p_view_name       varchar2, 
                p_query_position  number ) is
    select w.where_clause_position,
           w.where_clause
      from n_views       v, 
           n_view_wheres w
     where w.view_name = p_view_name
       and w.query_position = p_query_position
       and v.view_name = w.view_name
       and ( ( v.application_label in ( 'FA', 'FV', 'GL' ) and
               w.where_clause like '%^SET_OF_BOOKS_ID%' ) or
             ( v.application_label in ( 'FA', 'FV', 'GL' ) and
               w.where_clause like '%^LEDGER_ID%' ) or
             ( v.application_label in ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 
                                        'PA', 'PB', 'PC', 'PJM', 'PO',  'RA', 'OKE' ) and
               w.where_clause like '%^ORG_ID%' ) or
             -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
             -- Leave it out of the list for now.
             ( v.application_label in ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' ) and
               w.where_clause like '%^ORGANIZATION_ID%' ) )
       and nvl(w.omit_flag,'N') = 'N';
    --
    v_map_table_alias           n_cross_org_map_alias.table_alias%TYPE;
    v_map_column_name           n_cross_org_map_alias.sob_column_name%TYPE;
    v_search_for                varchar2(255);
    v_search_for2               varchar2(255);
    v_replace_this              varchar2(255);
    v_replace_this2             varchar2(255);
    v_outerjoin_operator        varchar2(10);
    v_lvalue_alias              varchar2(30);
    v_new_where_clause          n_view_wheres.where_clause%TYPE;
    v_error_message             varchar2(2000);
    --
begin
    --
    v_outerjoin_operator := '(+)';
    --
    -- loop through all of the view-queries that have multiple where clauses with the
    -- same driving configuration variable
    for r1 in c1 loop

        dbms_output.put_line('**** processing: '||r1.view_name||'.'||r1.query_position||'.'||
                                             r1.map_type);

        -- get the driving table alias for this view-query
        select map.table_alias,
               decode( r1.map_type,
                       'SET_OF_BOOKS_ID',map.sob_column_name,
                       'LEDGER_ID',map.sob_column_name,
                       r1.map_type )   map_sob_column_name
          into v_map_table_alias,
               v_map_column_name
          from n_cross_org_map_alias map
         where map.view_label       = r1.view_label
           and map.view_name        = r1.view_name
           and map.query_position   = r1.query_position
           and map.map_type         = r1.map_type;

        dbms_output.put_line('**** found map table alias: '||v_map_table_alias||'.'||v_map_column_name);

        -- loop through each where clause in this query
        for r2 in c2 ( r1.view_name, r1.query_position ) loop

            v_search_for        := v_map_table_alias||'.'||v_map_column_name;
            v_replace_this      := '^'||r1.map_type;
            if ( r1.map_type = 'SET_OF_BOOKS_ID' ) then
                v_search_for2   := v_map_table_alias||'.'||v_map_column_name;
                v_replace_this2 := '^LEDGER_ID';
            else
                v_replace_this2 := NULL;
            end if;
            v_lvalue_alias := NULL;

            -- look to see if this where clause involves the driving table alias
            if ( instrb( r2.where_clause, v_search_for, 1, 1 ) = 0 ) then

                dbms_output.put_line('involves non-driving table');
                dbms_output.put_line('where clause:'||r2.where_clause);

                -- it doesn't, so check to see if its outer joined
                if ( instrb( r2.where_clause, v_outerjoin_operator, 1, 1 ) = 0 ) then

                    dbms_output.put_line('it is not outer joined');

                    -- if not, then join this table to the driving table
                    v_new_where_clause := 
                        replace( r2.where_clause, v_replace_this, v_search_for );
                    
                    if ( v_replace_this2 is not null ) then
                        v_new_where_clause := 
                            replace( r2.where_clause, v_replace_this2, v_search_for2 );
                    end if;

                else

                    dbms_output.put_line('it is outer joined');

                    -- its outer joined, we need to figure out which alias is being
                    -- used in the where clause line
                    select distinct t.table_alias
                      into v_lvalue_alias
                      from n_view_tables t
                     where t.view_name               = r1.view_name
                       and t.query_position          = r1.query_position
                       and upper(r2.where_clause) like upper('% '||t.table_alias||'.'||r1.map_type||'%');

                    dbms_output.put_line('found lvalue table alias: '||v_lvalue_alias);
                
                    -- now, build the where clause from scratch as:
                    --      AND NVL( x.org_id, y.org_id ) = y.org_id
                    --
                    if ( v_lvalue_alias is not null ) then

                    --  v_new_where_clause :=
                    --      'AND NVL( '||v_lvalue_alias||'.'||r1.map_type||','||
                    --      v_search_for||' ) = '||v_search_for;

                     -- it has outer join problem, insert into temporary table
                     insert into n_xorg_prob_views values
                             (
                               r1.view_name,
                               r1.query_position
                              ) ;

                    end if;

                end if;
                commit;

                -- insert the information that will be used to update view-wheres
                if ( v_new_where_clause is not null ) then

                    dbms_output.put_line('new where clause:'||v_new_where_clause);

                    begin

                    insert into n_view_where_updates_temp
                    (
                        view_name,
                        query_position,
                        where_clause_position,
                        where_clause
                    )
                    values
                    (
                        r1.view_name,            
                        r1.query_position,
                        r2.where_clause_position,
                        v_new_where_clause
                    );

                    exception
                        when others then 
                            v_error_message := sqlerrm;
                            raise_application_error
                            ( -20010, 'insert into n_view_where_updates_temp: ' || 
                                      v_error_message );
                    end;

                else

                    dbms_output.put_line( 'Could not process where clause line: '||
                                           r1.view_name||'.'||r1.query_position||'.'||
                                           r2.where_clause_position );

                end if;

            else

                dbms_output.put_line('involves driving table');

            end if;

        end loop;
        
        -- commit whats been done so far
        commit;

    end loop;
end;
/
--
-- now update n_view_wheres.  I did this because Oracle complained when I was trying
-- to update the table when I was selecting from it.  maybe not the best, but it
-- eliminates some complexity in the code above.
--
update n_view_wheres w
   set w.where_clause = ( select wu.where_clause
                            from n_view_where_updates_temp wu
                           where wu.view_name             = w.view_name
                             and wu.query_position        = w.query_position
                             and wu.where_clause_position = w.where_clause_position )
 where w.where_clause like '%^%'
   and exists
     ( select 'have a new where clause'
         from n_view_where_updates_temp wu
        where wu.view_name             = w.view_name
          and wu.query_position        = w.query_position
          and wu.where_clause_position = w.where_clause_position )
;

commit;

truncate table n_view_where_updates_temp;

--
--
-- ###############################################################################
-- make sure that each view with a map alias has a where clause that restricts
-- to the driving configuration variable, some of these may have been removed
-- in the previous section.  for instance, if there are multiple where clauses
-- with a given config var, and if the map alias does not have this config var set,
-- there will not longer be a config var for that view
--
--      AND MPARM.ORGANIZATION_ID         = ^ORGANIZATION_ID
--      AND Base_Item.ORGANIZATION_ID (+) = ^ORGANIZATION_ID
--
-- what if neither MPARM nor Base_Item are the map alias, but ITEM is (its a base table),
-- so we get:
--
--      AND MPARM.ORGANIZATION_ID              = ITEM.ORGANIZATION_ID
--      AND NVL( Base_Item.ORGANIZATION_ID,ITEM.ORGANIZATION_ID ) = ITEM.ORGANIZATION_ID
--
-- and the view doesn't have a config var anymore. the following code will add this 
-- line to the view:
--
--      AND ITEM.ORGANIZATION_ID = ^ORGANIZATION_ID
--
prompt Add driving variable back if needed
declare
    CURSOR c1 is
    SELECT map.view_name, 
           map.query_position, 
           map.map_type, 
           map.table_alias, 
           map.base_table_flag
      FROM n_cross_org_map_alias map
     -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
     -- Leave it out of the list for now.
     WHERE map.application_label in ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' )
       -- Only do this is the mapping table/view is not detected
       AND not exists
         ( SELECT 'Has mapping table join'
             FROM n_view_tables vt
            WHERE vt.view_name           = map.view_name
              AND vt.query_position      = map.query_position
              AND NVL(vt.omit_flag,'N')  = 'N'
              AND 
                (    vt.table_name              = 'N_APPLICATION_ORG_MAPPINGS'                 -- Still Good
                  OR vt.table_name           LIKE 'N\\_SM\\_%\\_MAPPINGS\\_V'    ESCAPE '\\'   -- OLD
                  OR vt.table_name           LIKE 'N\\_QU\\_%\\_MAPPINGS\\_V'    ESCAPE '\\'   -- OLD
                  OR upper(vt.table_name)    LIKE 'XXNAO\\_ACL\\_%\\_MAP\\_BASE' ESCAPE '\\'   -- 585 TEMP
                  OR upper(vt.table_name)    LIKE '%\\_ACL\\_MAP\\_BASE'         ESCAPE '\\' ) -- 585 NEW
              AND rownum = 1                              )
       AND NOT EXISTS
         ( SELECT 'found a clause with the config var'
             FROM n_view_wheres w, 
                  n_views       v
            WHERE w.view_name           = map.view_name
              AND w.query_position      = map.query_position
              AND nvl(w.omit_flag,'N')  = 'N'
              AND v.view_name           = w.view_name
              AND nvl(v.omit_flag,'N')  = 'N'
              AND upper(w.where_clause) 
                  like upper('% '||map.table_alias||'.'||map.map_type||'%=%^'||map.map_type||'%') )
       AND NOT EXISTS
         ( SELECT 'this view was never partitioned so skip it'
             FROM n_unpartitioned_views_temp np
            WHERE np.view_name = map.view_name
              AND np.query_position = map.query_position );
    --
    v_new_where_clause          n_view_wheres.where_clause%TYPE;
    v_where_clause_position     number;
    --
begin

    v_where_clause_position := 1600;

    for r1 in c1 loop
        
        v_new_where_clause := 'AND '||r1.table_alias||'.'||r1.map_type;

        -- commented out because there weren't any views that needed this
        -- special case
        --
        --if r1.base_table_flag = 'N' then
        --  v_new_where_clause := v_new_where_clause||' (+) ';
        --end if;

        v_new_where_clause := v_new_where_clause||' = ^'||r1.map_type;

        v_where_clause_position := v_where_clause_position + 0.00001;

        begin

        insert into n_view_where_updates_temp
        (
            view_name,
            query_position,
            where_clause_position,
            where_clause
        )
        values
        (
            r1.view_name,
            r1.query_position,
            v_where_clause_position,
            v_new_where_clause
        );

        exception
            when others then 
                raise_application_error
                ( -20010, 'insert into n_view_where_updates_temp: ' || 
                          sqlerrm );
        end;

        commit;

    end loop;
end;
/

commit;
--
-- these are new where clause lines, so insert them (not update)
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
select v.view_name,
       v.view_label,
       tmp.query_position,
       tmp.where_clause_position,
       tmp.where_clause,
       v.application_instance,
       'N',
       'Y'
  from n_views v,
       n_view_where_updates_temp tmp
 where tmp.view_name = v.view_name
;

commit;

--
truncate table n_view_where_updates_temp;
--
--
-- ###############################################################################
--
-- The following code is here to address a problem we discovered while testing, namely
-- that we cannot blindly substitute multiple values for a configuration variable in WHERE
-- clauses.  Consider an example in OE where we would base the org_id column and the 
-- set_of_books_id column in different tables in a view on a list of values.
--
--        and lines.org_id IN ( 101, 102, 103 )
--        and glsob.set_of_books_id IN ( 1, 2 )
--
-- Maybe operating units 101 and 102 belong to Set of Books 1 and OU 103 to Set of Books 2.  We
-- are not guaranteed that Oracle will put this together correctly, in fact, chances are that
-- it won't.  So, for global views we will be using a different approach by using DECODEable
-- "maps".  The above example becomes:
--
--        and lines.org_id IN ( 101, 102, 103 )
--        and glsob.set_of_books_id = DECODE( lines.org_id, 101, 1, 102, 1, 103, 2 )
--
-- The maps are built in GORG.
--
prompt Process config variables in the where clauses

--
-- update where clauses for GL, FA, FV views
--   these views drive off of the SET_OF_BOOKS_ID variable, and all other variables must
--   decode off of this.
--
declare
    cursor c1 is
    select v.view_name,
           v.view_label,
           w.query_position,
           w.where_clause_position,
           w.where_clause,
           w.generated_flag,
           w.profile_option,
           v.application_instance,
           v.application_label,
           map.table_alias,
           map.sob_column_name
      from n_cross_org_map_alias      map,
           n_view_wheres              w,
           n_view_queries             q,
           n_views                    v
     where v.application_label      in ('FA', 'FV', 'GL')
       and v.application_instance like 'X%'
       and q.view_name               = v.view_name
       and w.view_name               = q.view_name
       and w.query_position          = q.query_position
       and 
         (    w.where_clause      like '%^SET_OF_BOOKS_ID%'
           or w.where_clause      like '%^LEDGER_ID%'
           or w.where_clause      like '%^CURRENCY_CODE%' )
       and NVL(q.omit_flag,'N')      = 'N'
       and NVL(v.omit_flag,'N')      = 'N'
       and NVL(w.omit_flag,'N')      = 'N'
       and map.application_label     = v.application_label
       and map.view_label            = v.view_label
       and map.view_name             = v.view_name
       and map.query_position        = w.query_position
       and map.map_type              = 'SET_OF_BOOKS_ID'
       for update of w.where_clause
    ;
    
    cursor c_global_sobs( p_application_label      varchar2,
                          p_application_instance   varchar2 ) is
    select nvl(nao.global_set_of_books,'0')                             value,
           1                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select naog.value                                                   value,
           naog.sequence+1                                              sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_SET_OF_BOOKS'
     order by 2
    ;

    cursor c_global_currs( p_application_label      varchar2,
                           p_application_instance   varchar2,
                           p_decode                 varchar2 ) is
    select nvl(replace(nao.global_sob2curr,'^DECODE',p_decode),
           '''USD''')                                                   value,
           1                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select replace(naog.value,'^DECODE',p_decode)                       global_currency_codes,
           naog.sequence+1                                              sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_SOB2CURR'
     order by 2
    ;

    vs_decode                 VARCHAR2(200);
    vs_beg_of_line            n_view_wheres.where_clause%TYPE;
    vs_end_of_line            n_view_wheres.where_clause%TYPE;
    vi_xop_count              INTEGER;
    vi_sob_var_location       INTEGER;
    vi_ledger_var_location    INTEGER;
    vi_curr_var_location      INTEGER;
    
    vn_where_clause_position  n_view_wheres.where_clause_position%TYPE;
    vn_null                   n_view_wheres.where_clause_position%TYPE := NULL;

    
BEGIN
    for r1 in c1 loop
        -- Initial the variable for this where_clause line
        vn_where_clause_position := r1.where_clause_position;
        vi_sob_var_location      := instrb( r1.where_clause, '^SET_OF_BOOKS_ID' );
        vi_ledger_var_location   := instrb( r1.where_clause, '^LEDGER_ID' );
        vi_curr_var_location     := instrb( r1.where_clause, '''^CURRENCY_CODE''' );
        
        vn_where_clause_position := r1.where_clause_position;
        
        if ( vi_sob_var_location != 0 ) then
            
            select count(distinct xmap.set_of_books_id) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;
            
            IF ( vi_xop_count <= &SOB_MAPPING_THRESHOLD ) THEN
                vs_beg_of_line   := replace(substrb(r1.where_clause,1,vi_sob_var_location-1),'=',' IN ');
                vs_end_of_line   := replace(substrb(r1.where_clause,vi_sob_var_location+lengthb('^SET_OF_BOOKS_ID')),'=',' IN ');
                FOR r_global_sobs in c_global_sobs( r1.application_label,
                                                    r1.application_instance )   LOOP
                    IF ( r_global_sobs.sequence = 1 ) THEN
                        -- Update the current string
                        update n_view_wheres
                           set where_clause = vs_beg_of_line||r_global_sobs.value
                         where current of c1;
                    ELSE
                        -- Add another where clause line for the decode
                        noetix_xop_pkg.insert_view_where( 
                                    i_view_name               => r1.view_name, 
                                    i_view_label              => r1.view_label, 
                                    i_query_position          => r1.query_position,
                                    i_application_instance    => r1.application_instance,
                                    io_where_clause_position  => vn_where_clause_position, 
                                    i_where_clause            => r_global_sobs.value,
                                    i_profile_option          => r1.profile_option          );
                    END IF;
                END LOOP;
                -- Now add back in the ending paren/string
                update n_view_wheres
                   set where_clause = where_clause||vs_end_of_line
                 where view_name             = r1.view_name
                   and query_position        = r1.query_position
                   and where_clause_position = vn_where_clause_position;
            ELSE
                -- Add join to n_application_org_mappings
                noetix_xop_pkg.add_mapping_table_join( 
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the join in n_view_wheres to new mapping table.
                update n_view_wheres w
                   set where_clause = replace(w.where_clause,'^SET_OF_BOOKS_ID','XOP_MAP.SET_OF_BOOKS_ID' )
                 where current of c1;
            END IF;
        ELSIF ( vi_ledger_var_location != 0 ) then
            
            select count(distinct xmap.set_of_books_id) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;
            
            IF ( vi_xop_count <= &SOB_MAPPING_THRESHOLD ) THEN
                vs_beg_of_line   := replace(substrb(r1.where_clause,1,vi_sob_var_location-1),'=',' IN ');
                vs_end_of_line   := replace(substrb(r1.where_clause,vi_sob_var_location+lengthb('^LEDGER_ID')),'=',' IN ');
                FOR r_global_sobs in c_global_sobs( r1.application_label,
                                                    r1.application_instance )   LOOP
                    IF ( r_global_sobs.sequence = 1 ) THEN
                        -- Update the current string
                        update n_view_wheres
                           set where_clause = vs_beg_of_line||r_global_sobs.value
                         where current of c1;
                    ELSE
                        -- Add another where clause line for the decode
                        noetix_xop_pkg.insert_view_where( 
                                    i_view_name               => r1.view_name, 
                                    i_view_label              => r1.view_label, 
                                    i_query_position          => r1.query_position,
                                    i_application_instance    => r1.application_instance,
                                    io_where_clause_position  => vn_where_clause_position, 
                                    i_where_clause            => r_global_sobs.value,
                                    i_profile_option          => r1.profile_option          );
                    END IF;
                END LOOP;
                -- Now add back in the ending paren/string
                update n_view_wheres
                   set where_clause = where_clause||vs_end_of_line
                 where view_name             = r1.view_name
                   and query_position        = r1.query_position
                   and where_clause_position = vn_where_clause_position;
            ELSE
                -- Add join to n_application_org_mappings
                noetix_xop_pkg.add_mapping_table_join( 
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the join in n_view_wheres to new mapping table.
                update n_view_wheres w
                   set where_clause = replace(w.where_clause,'^LEDGER_ID','XOP_MAP.SET_OF_BOOKS_ID' )
                 where current of c1;
            END IF;
        ELSIF ( vi_curr_var_location != 0 ) THEN
            vs_decode        := 'DECODE('||r1.table_alias||'.'||r1.sob_column_name;
            vs_beg_of_line   := substrb(r1.where_clause,1,vi_curr_var_location-1);
            vs_end_of_line   := substrb(r1.where_clause,vi_curr_var_location+lengthb('''^CURRENCY_CODE'''));
            -- Loop throught the records
            FOR r_global_currs in c_global_currs( r1.application_label,
                                                  r1.application_instance,
                                                  vs_decode                 )   LOOP
                IF ( r_global_currs.sequence = 1 ) THEN
                    -- Update the current string
                    update n_view_wheres
                       set where_clause = vs_beg_of_line||vs_decode||','||r_global_currs.value
                     where current of c1;
                ELSE
                    -- Add another where clause line for the decode
                    noetix_xop_pkg.insert_view_where( 
                                i_view_name               => r1.view_name, 
                                i_view_label              => r1.view_label, 
                                i_query_position          => r1.query_position,
                                i_application_instance    => r1.application_instance,
                                io_where_clause_position  => vn_where_clause_position, 
                                i_where_clause            => r_global_currs.value,
                                i_profile_option          => r1.profile_option          );
                END IF;
            END LOOP;
            -- Now add back in the ending paren/string
            update n_view_wheres
               set where_clause          = where_clause||vs_end_of_line
             where view_name             = r1.view_name
               and query_position        = r1.query_position
               and where_clause_position = vn_where_clause_position;
        END IF;
        
    end loop;
END;
/
commit;

--
-- update where clauses for ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' ) views
--   these views drive off of the ORG_ID column, and all other variables must
--   decode off of this.  NOTE: The org_id restriction WHERE clauses are added in xorgid.
--
prompt Update where clauses for ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' ) views
declare 
--
    cursor c1 is
    select w.view_name,
           w.view_label,
           w.query_position,
           w.where_clause_position,
           w.where_clause,
           w.profile_option,
           w.application_instance,
           w.omit_flag,
           w.generated_flag
      from n_view_wheres w
     where NVL(w.omit_flag,'N') = 'N'
       and ( w.where_clause like '%^ORG_ID%' OR
             w.where_clause like '%^SET_OF_BOOKS_ID%' OR
             w.where_clause like '%^LEDGER_ID%' OR
             w.where_clause like '%^ORGANIZATION_ID%' )
       and exists  
         ( select 'a map exists'
             from  n_cross_org_map_alias map
            where map.view_label         = w.view_label
              and map.view_name          = w.view_name
              and map.query_position     = w.query_position
              and map.application_label in 
                     ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' )
              and map.map_type           = 'ORG_ID' )
    ;
    v_where_clause  n_view_wheres.where_clause%TYPE;
BEGIN
    FOR r1 IN c1 LOOP
        v_where_clause  := 
            n_xorgpop_func3( r1.view_name,
                             r1.view_label,
                             r1.query_position,
                             r1.where_clause_position,
                             r1.where_clause,
                             r1.profile_option,
                             r1.application_instance,
                             r1.omit_flag,
                             r1.generated_flag,
                             'ORG_ID' );
    END LOOP;
END;
/

commit;

--
-- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
-- Leave it out of the list for now.
-- update where clauses for ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'WIP' ) views
-- these views drive off of the ORGANIZATION_ID column, and all other variables must
-- decode off of this.  NOTE: some additional WHERE clauses with ^ORG_ID were added
-- in xorgid.sql.
--
prompt Update where clauses for ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' ) views
declare 
    cursor c1 is
    select w.view_name,
           w.view_label,
           w.query_position,
           w.where_clause_position,
           w.where_clause,
           w.profile_option,
           w.application_instance,
           w.omit_flag,
           w.generated_flag
      from n_view_wheres w
     where NVL(w.omit_flag,'N') = 'N'
       and 
         (    w.where_clause like '%^COST_ORGANIZATION_ID%' 
           or w.where_clause like '%^SET_OF_BOOKS_ID%'
           or w.where_clause like '%^LEDGER_ID%'
           or w.where_clause like '%^ORG_ID%' 
           or w.where_clause like '%^ORGANIZATION_ID%' )
       and exists  
         ( select 'a map exists'
             from  n_cross_org_map_alias map
            where map.view_label         = w.view_label
              and map.view_name          = w.view_name
              and map.query_position     = w.query_position
              and map.application_label in 
                -- Since MSC is not supposed to have ORGANIZATION_ID columns anyway
                -- Leave it out of the list for now.
                ( 'BOM', 'CRP', 'CST', 'EAM', 'ENG', 'INV', 'MRP', 'QA',  'WIP' )
              and map.map_type           = 'ORGANIZATION_ID' )
    ;
    v_where_clause  n_view_wheres.where_clause%TYPE;
BEGIN
    FOR r1 IN c1 LOOP
        v_where_clause  := 
            n_xorgpop_func3( r1.view_name,
                             r1.view_label,
                             r1.query_position,
                             r1.where_clause_position,
                             r1.where_clause,
                             r1.profile_option,
                             r1.application_instance,
                             r1.omit_flag,
                             r1.generated_flag,
                             'ORGANIZATION_ID' );
    END LOOP;
END;
/

commit;
---------------------------------------------------------------------------------------

-- insert outer join problem views into temporary table
-- now update the where clauses
--

prompt Insert outer join problem views into temporary table
insert into n_xorg_prob_views
select distinct  w.view_name, 
       w.query_position       
  from n_view_where_updates_temp w
 where (    upper(w.where_clause) like '%NVL%(%ORG%)%IN%(%ORG%)%'
         or upper(w.where_clause) like '%NVL%(%SET_OF_BOOKS%)%IN%(%)%'
         or upper(w.where_clause) like '%NVL%(%LEDGER%)%IN%(%)%'
         or (    upper(w.where_clause) like '%ORGANIZATION_ID%(+)%'
              OR upper(w.where_clause) like '%ORG_ID%(+)%'
              OR upper(w.where_clause) like '%SET_OF_BOOKS_ID%(+)%'
              OR upper(w.where_clause) like '%LEDGER_ID%(+)%'
              OR upper(w.where_clause) like '%(+)%ORGANIZATION_ID%'
              OR upper(w.where_clause) like '%(+)%ORG_ID%'
              OR upper(w.where_clause) like '%(+)%LEDGER_ID%'
              OR upper(w.where_clause) like '%(+)%SET_OF_BOOKS_ID%'))
   and exists
     ( select 'nvl'
         from n_view_where_updates_temp w1
        where w1.view_name              = w.view_name
          and w1.query_position         = w.query_position
          and upper(w1.where_clause) like '%NVL%(%)%IN%(%)%' )
   and exists 
     ( select 'There are'
         from n_view_where_updates_temp w2
        where w2.view_name = w.view_name
          and w2.query_position = w.query_position
          and (    upper(w2.where_clause) like 'ORGANIZATION_ID%'
                or upper(w2.where_clause) like '%ORG_ID%'
                or upper(w2.where_clause) like '%SET_OF_BOOKS_ID%'
                or upper(w2.where_clause) like '%LEDGER_ID%'
                or upper(w2.where_clause) like '%ORGANIZATION_ID%' ))
;

commit;
------------

update n_view_wheres w
   set w.where_clause = ( select wu.where_clause
                            from n_view_where_updates_temp wu
                           where wu.view_name             = w.view_name
                             and wu.query_position        = w.query_position
                             and wu.where_clause_position = w.where_clause_position
                             and wu.add_flag              = 'N' )
 where w.where_clause       like '%^%'
   and NVL(w.omit_flag,'N')    = 'N' 
   and exists
     ( select 'have a new where clause'
         from n_view_where_updates_temp wu
        where wu.view_name             = w.view_name
          and wu.query_position        = w.query_position
          and wu.where_clause_position = w.where_clause_position )
   and not exists 
     ( select 'outer join prob views'
         from n_xorg_prob_views pv
        where pv.view_name       = w.view_name
          and pv.query_position  = w.query_position )
;

-- Insert overflow where clauses
prompt Insert overflow where clauses
insert into n_view_wheres
     ( view_name,
       view_label,
       query_position,
       where_clause_position,
       where_clause,
       profile_option,
       application_instance,
       omit_flag,
       generated_flag )
select wu.view_name,
       wu.view_label,
       wu.query_position,
       wu.where_clause_position,
       wu.where_clause,
       wu.profile_option,
       wu.application_instance,
       wu.omit_flag,
       wu.generated_flag
  from n_view_where_updates_temp wu
 where wu.add_flag             = 'Y'
   and NVL(wu.omit_flag,'N')   = 'N'
   and not exists 
     ( select 'outer join prob views'
         from n_xorg_prob_views pv
        where pv.view_name       = wu.view_name
          and pv.query_position  = wu.query_position )
;

commit;
--
truncate table n_view_where_updates_temp;

--
-- Get any stragglers that haven't been processed.  There may be views in 
-- an application label that don't have any tables with the "driving" 
-- column, i.e., set_of_books_id in GL or org_id in PO, but they do have 
-- other configuration variables.
--
-- Since we would replace the configuration variable with an "IN" list of
-- values, be sure that there is not an outer join sign on the where clause
-- line.  (It is illegal to combine and outer join with an IN.) If we find
-- this situation, we will have to use the union method to create the view
-- so insert it into n_xorg_prob_views.
--
prompt Add any remaining views to the problem view list.
insert into n_xorg_prob_views 
     ( view_name, 
       query_position )
select distinct 
       w.view_name,
       w.query_position
  from n_view_wheres w
 where w.application_instance like 'X%'
   and w.where_clause         like '%^%'
   and w.where_clause         like '%(+)%'
   and translate(UPPER(substrb(w.where_clause,instrb(w.where_clause,'^')+1,1)),
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                 '##########################') = '#'
   and nvl(w.omit_flag,'N')    = 'N'
;
--
-- Finally, replace the remaining configuration variables with their 
-- appropriate list of values.
--
prompt Replace the remaining configuration variables
declare
    cursor c1 is
    select v.view_name,
           v.view_label,
           w.query_position,
           w.where_clause_position,
           w.where_clause,
           w.generated_flag,
           w.profile_option,
           v.application_instance,
           v.application_label
      from n_view_wheres              w,
           n_view_queries             q,
           n_views                    v
     where v.application_instance like 'X%'
       and q.view_name               = v.view_name
       and w.view_name               = q.view_name
       and w.query_position          = q.query_position
       and 
         (    w.where_clause      like '%^ORGANIZATION_ID%'
           or w.where_clause      like '%^SET_OF_BOOKS_ID%'
           or w.where_clause      like '%^LEDGER_ID%'
           or w.where_clause      like '%^COST_ORGANIZATION_ID%'
           or w.where_clause      like '%^CURRENCY_CODE%'        )
       and NVL(q.omit_flag,'N')      = 'N'
       and NVL(v.omit_flag,'N')      = 'N'
       and NVL(w.omit_flag,'N')      = 'N'
       for update of w.where_clause
    ;
    
    cursor c_global_orgs( p_application_label      varchar2,
                          p_application_instance   varchar2 ) is
    select nvl(nao.global_organizations,'0')                           value,
           1                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select naog.value                                                   value,
           naog.sequence+1                                              sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_ORGANIZATIONS'
     order by 2
    ;

    cursor c_global_cost_orgs( p_application_label      varchar2,
                               p_application_instance   varchar2 ) is
    select nvl(nao.global_cost_organizations,'0')                       value,
           1                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select naog.value                                                   value,
           naog.sequence+1                                              sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_COST_ORGANIZATIONS'
     order by 2
    ;

    cursor c_global_sobs( p_application_label      varchar2,
                          p_application_instance   varchar2 ) is
    select nvl(nao.global_set_of_books,'0')                             value,
           1                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select naog.value                                                   value,
           naog.sequence+1                                              sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_SET_OF_BOOKS'
     order by 2
    ;

    cursor c_global_currs( p_application_label      varchar2,
                           p_application_instance   varchar2 ) is
    select nvl(nao.global_currency_codes,'''USD''')                     value,
           1                                                            sequence
      from n_application_owners nao
     where nao.application_label    = p_application_label
       and nao.application_instance = p_application_instance
     union all
    select naog.value                                                   value,
           naog.sequence+1                                              sequence
      from n_application_owner_globals naog
     where naog.application_label    = p_application_label
       and naog.application_instance = p_application_instance
       and naog.column_name          = 'GLOBAL_CURRENCY_CODES'
     order by 2
    ;

    vs_decode                 VARCHAR2(200);
    vs_beg_of_line            n_view_wheres.where_clause%TYPE;
    vs_end_of_line            n_view_wheres.where_clause%TYPE;
    vi_xop_count              INTEGER;
    vi_org_var_location       INTEGER;
    vi_corg_var_location      INTEGER;
    vi_sob_var_location       INTEGER;
    vi_ledger_var_location    INTEGER;
    vi_curr_var_location      INTEGER;
    
    vn_where_clause_position  n_view_wheres.where_clause_position%TYPE;
    vn_null                   n_view_wheres.where_clause_position%TYPE := NULL;

    
BEGIN
    for r1 in c1 loop
        -- Initial the variable for this where_clause line
        vn_where_clause_position := r1.where_clause_position;

        vi_org_var_location      := instrb( r1.where_clause, '^ORGANIZATION_ID' );
        vi_corg_var_location     := instrb( r1.where_clause, '^COST_ORGANIZATION_ID' );
        vi_sob_var_location      := instrb( r1.where_clause, '^SET_OF_BOOKS_ID' );
        vi_ledger_var_location   := instrb( r1.where_clause, '^LEDGER_ID' );
        vi_curr_var_location     := instrb( r1.where_clause, '''^CURRENCY_CODE''' );

        vn_where_clause_position := r1.where_clause_position;

        if ( vi_org_var_location != 0 ) then
            
            -- Get the count for the Organization
            select count(distinct xmap.organization_id) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;

            IF ( vi_xop_count <= &ORG_MAPPING_THRESHOLD ) THEN
                vs_beg_of_line   := replace(substrb(r1.where_clause,1,vi_org_var_location-1),'=',' IN ');
                vs_end_of_line   := replace(substrb(r1.where_clause,vi_org_var_location+lengthb('^ORGANIZATION_ID')),'=',' IN ');
                FOR r_global_orgs in c_global_orgs( r1.application_label,
                                                    r1.application_instance )   LOOP
                    IF ( r_global_orgs.sequence = 1 ) THEN
                        -- Update the current string
                        update n_view_wheres
                           set where_clause = vs_beg_of_line||r_global_orgs.value
                         where current of c1;
                    ELSE
                        -- Add another where clause line for the decode
                        noetix_xop_pkg.insert_view_where( 
                                    i_view_name               => r1.view_name, 
                                    i_view_label              => r1.view_label, 
                                    i_query_position          => r1.query_position,
                                    i_application_instance    => r1.application_instance,
                                    io_where_clause_position  => vn_where_clause_position, 
                                    i_where_clause            => r_global_orgs.value,
                                    i_profile_option          => r1.profile_option          );
                    END IF;
                END LOOP;
                -- Now add back in the ending paren/string
                update n_view_wheres
                   set where_clause = where_clause||vs_end_of_line
                 where view_name             = r1.view_name
                   and query_position        = r1.query_position
                   and where_clause_position = vn_where_clause_position;
            ELSE
                -- Add join to n_application_org_mappings
                noetix_xop_pkg.add_mapping_table_join( 
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the join in n_view_wheres to new mapping table.
                update n_view_wheres w
                   set where_clause = replace(w.where_clause,
                                              '^ORGANIZATION_ID','XOP_MAP.ORGANIZATION_ID' )
                 where current of c1;
            END IF;
        ELSIF ( vi_corg_var_location != 0 ) THEN
            
            -- Get the count for the Organization
            select count(distinct xmap.cost_organization_id) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;

            IF ( vi_xop_count <= &ORG_MAPPING_THRESHOLD ) THEN
                vs_beg_of_line   := replace(substrb(r1.where_clause,1,vi_corg_var_location-1),'=',' IN ');
                vs_end_of_line   := replace(substrb(r1.where_clause,vi_corg_var_location+lengthb('^COST_ORGANIZATION_ID')),'=',' IN ');
                FOR r_global_cost_orgs in c_global_cost_orgs( r1.application_label,
                                                              r1.application_instance )   LOOP
                    IF ( r_global_cost_orgs.sequence = 1 ) THEN
                        -- Update the current string
                        update n_view_wheres
                           set where_clause = vs_beg_of_line||r_global_cost_orgs.value
                         where current of c1;
                    ELSE
                        -- Add another where clause line for the decode
                        noetix_xop_pkg.insert_view_where( 
                                    i_view_name               => r1.view_name, 
                                    i_view_label              => r1.view_label, 
                                    i_query_position          => r1.query_position,
                                    i_application_instance    => r1.application_instance,
                                    io_where_clause_position  => vn_where_clause_position, 
                                    i_where_clause            => r_global_cost_orgs.value,
                                    i_profile_option          => r1.profile_option          );
                    END IF;
                END LOOP;
                -- Now add back in the ending paren/string
                update n_view_wheres
                   set where_clause = where_clause||vs_end_of_line
                 where view_name             = r1.view_name
                   and query_position        = r1.query_position
                   and where_clause_position = vn_where_clause_position;
            ELSE
                -- Add join to n_application_org_mappings
                noetix_xop_pkg.add_mapping_table_join( 
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the join in n_view_wheres to new mapping table.
                update n_view_wheres w
                   set where_clause = replace(w.where_clause,
                                              '^COST_ORGANIZATION_ID','XOP_MAP.COST_ORGANIZATION_ID' )
                 where current of c1;
            END IF;
        ELSIF ( vi_sob_var_location != 0 ) THEN

            -- Get the count for the SOB
            select count(distinct xmap.set_of_books_id) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;

            IF ( vi_xop_count <= &SOB_MAPPING_THRESHOLD ) THEN
                vs_beg_of_line   := replace(substrb(r1.where_clause,1,vi_sob_var_location-1),'=',' IN ');
                vs_end_of_line   := replace(substrb(r1.where_clause,vi_sob_var_location+lengthb('^SET_OF_BOOKS_ID')),'=',' IN ');
                FOR r_global_sobs in c_global_sobs( r1.application_label,
                                                    r1.application_instance )   LOOP
                    IF ( r_global_sobs.sequence = 1 ) THEN
                        -- Update the current string
                        update n_view_wheres
                           set where_clause = vs_beg_of_line||r_global_sobs.value
                         where current of c1;
                    ELSE
                        -- Add another where clause line for the decode
                        noetix_xop_pkg.insert_view_where( 
                                    i_view_name               => r1.view_name, 
                                    i_view_label              => r1.view_label, 
                                    i_query_position          => r1.query_position,
                                    i_application_instance    => r1.application_instance,
                                    io_where_clause_position  => vn_where_clause_position, 
                                    i_where_clause            => r_global_sobs.value,
                                    i_profile_option          => r1.profile_option          );
                    END IF;
                END LOOP;
                -- Now add back in the ending paren/string
                update n_view_wheres
                   set where_clause = where_clause||vs_end_of_line
                 where view_name             = r1.view_name
                   and query_position        = r1.query_position
                   and where_clause_position = vn_where_clause_position;
            ELSE
                -- Add join to n_application_org_mappings
                noetix_xop_pkg.add_mapping_table_join( 
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the join in n_view_wheres to new mapping table.
                update n_view_wheres w
                   set where_clause = replace(w.where_clause,
                                              '^SET_OF_BOOKS_ID','XOP_MAP.SET_OF_BOOKS_ID' )
                 where current of c1;
            END IF;
        ELSIF ( vi_ledger_var_location != 0 ) THEN

            -- Get the count for the SOB
            select count(distinct xmap.set_of_books_id) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;

            IF ( vi_xop_count <= &SOB_MAPPING_THRESHOLD ) THEN
                vs_beg_of_line   := replace(substrb(r1.where_clause,1,vi_ledger_var_location-1),'=',' IN ');
                vs_end_of_line   := replace(substrb(r1.where_clause,vi_ledger_var_location+lengthb('^LEDGER_ID')),'=',' IN ');
                FOR r_global_sobs in c_global_sobs( r1.application_label,
                                                    r1.application_instance )   LOOP
                    IF ( r_global_sobs.sequence = 1 ) THEN
                        -- Update the current string
                        update n_view_wheres
                           set where_clause = vs_beg_of_line||r_global_sobs.value
                         where current of c1;
                    ELSE
                        -- Add another where clause line for the decode
                        noetix_xop_pkg.insert_view_where( 
                                    i_view_name               => r1.view_name, 
                                    i_view_label              => r1.view_label, 
                                    i_query_position          => r1.query_position,
                                    i_application_instance    => r1.application_instance,
                                    io_where_clause_position  => vn_where_clause_position, 
                                    i_where_clause            => r_global_sobs.value,
                                    i_profile_option          => r1.profile_option          );
                    END IF;
                END LOOP;
                -- Now add back in the ending paren/string
                update n_view_wheres
                   set where_clause = where_clause||vs_end_of_line
                 where view_name             = r1.view_name
                   and query_position        = r1.query_position
                   and where_clause_position = vn_where_clause_position;
            ELSE
                -- Add join to n_application_org_mappings
                noetix_xop_pkg.add_mapping_table_join( 
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the join in n_view_wheres to new mapping table.
                update n_view_wheres w
                   set where_clause = replace(w.where_clause,
                                              '^LEDGER_ID','XOP_MAP.SET_OF_BOOKS_ID' )
                 where current of c1;
            END IF;
        ELSIF ( vi_curr_var_location != 0 ) THEN

            -- Get the count for the currencies
            select count(distinct xmap.currency_code) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;

            IF ( vi_xop_count <= &CURR_MAPPING_THRESHOLD ) THEN
                vs_beg_of_line   := replace(substrb(r1.where_clause,1,vi_curr_var_location-1),'=',' IN ');
                vs_end_of_line   := replace(substrb(r1.where_clause,vi_curr_var_location+lengthb('''^CURRENCY_CODE''')),'=',' IN ');
                FOR r_global_currs in c_global_currs( r1.application_label,
                                                      r1.application_instance )   LOOP
                    IF ( r_global_currs.sequence = 1 ) THEN
                        -- Update the current string
                        update n_view_wheres
                           set where_clause = vs_beg_of_line||r_global_currs.value
                         where current of c1;
                    ELSE
                        -- Add another where clause line for the decode
                        noetix_xop_pkg.insert_view_where( 
                                    i_view_name               => r1.view_name, 
                                    i_view_label              => r1.view_label, 
                                    i_query_position          => r1.query_position,
                                    i_application_instance    => r1.application_instance,
                                    io_where_clause_position  => vn_where_clause_position, 
                                    i_where_clause            => r_global_currs.value,
                                    i_profile_option          => r1.profile_option          );
                    END IF;
                END LOOP;
                -- Now add back in the ending paren/string
                update n_view_wheres
                   set where_clause = where_clause||vs_end_of_line
                 where view_name             = r1.view_name
                   and query_position        = r1.query_position
                   and where_clause_position = vn_where_clause_position;
            ELSE
                -- Add join to n_application_org_mappings
                noetix_xop_pkg.add_mapping_table_join( 
                                i_application_label       => r1.application_label,
                                i_application_instance    => r1.application_instance,
                                i_view_name               => r1.view_name,
                                i_view_label              => r1.view_label,
                                i_query_position          => r1.query_position,
                                io_where_clause_position  => vn_null,
                                i_profile_option          => NULL                                 );
                -- Update the join in n_view_wheres to new mapping table.
                update n_view_wheres w
                   set where_clause = replace(w.where_clause,
                                              '''^CURRENCY_CODE''','XOP_MAP.CURRENCY_CODE' )
                 where current of c1;
            END IF;
        END IF;        
    end loop;
END;
/
commit;

-- ###############################################################################
-- make sure that we aren't creating some global views we are not supposed to create,
-- i.e., they don't have any valid component views.
prompt Remove any global views that do not have any children

/*
update  n_views nv
set     omit_flag = 'Y'
where   nv.application_instance like 'X%'
and   ( nv.application_label, nv.view_name ) in
      ( select  v1.application_label, v1.view_name
        from    n_views v1
        where   v1.application_instance like 'X%'
        and     nvl(v1.omit_flag,'N') = 'N'
        and     not exists
              ( select  c_v.view_name
                from    n_application_owners g_a, 
                        n_application_owners c_a,
                        n_views g_v,
                        n_views c_v
                where   c_v.application_label = c_a.application_label
                and     c_v.application_instance = c_a.application_instance
                and     c_a.application_label = g_a.application_label
                and     c_a.chart_of_accounts_id = g_a.chart_of_accounts_id
                and     nvl(c_a.master_organization_id,-9) = nvl(g_a.master_organization_id,-9)
                and     g_v.application_label = g_a.application_label
                and     g_v.application_instance = g_a.application_instance
                and     g_v.view_name = v1.view_name
                and     g_a.application_instance like 'X%'
                and     c_a.application_instance not like 'G%'
                and     c_a.application_instance not like 'X%'
                and     c_v.view_label = g_v.view_label
                and     nvl(c_v.omit_flag,'N') = 'N' ) )
*/

update n_views nv1
   set omit_flag = 'Y'
 where application_instance like 'X%'
   and exists
     ( select application_label,
              application_instance
         from n_application_owners nao1
        where application_instance  like 'X%'
          and nv1.application_label = nao1.application_label
          and nv1.application_instance = nao1.application_instance
          and exists
            ( select count(application_instance), 
                     application_label,
                     chart_of_accounts_id
                from n_application_owners nao2
               where application_instance not like 'X%'
                 and nao1.chart_of_accounts_id   = nao2.chart_of_accounts_id
                 and nao1.application_label      = nao2.application_label
            group by application_label, 
                     chart_of_accounts_id
              having count(application_instance ) <= 1 ))
;
commit;
------------------------
--make sure don't generate global views with   outer join problems, generate separately by union.
--

insert into n_xorg_to_do_views
     (
         view_name,
         query_position
     )
select distinct
       view_name,
       query_position
  from n_xorg_prob_views pv
 where not exists
     ( select 'already there'
         from n_xorg_to_do_views xd
        where xd.view_name         = pv.view_name
          and  xd.query_position   = pv.query_position)
   and not exists
     ( select 'Do not insert XOPORG views'
         from n_views nv
        where nv.view_name                        = pv.view_name
          and NVL(nv.special_process_code,'NONE') = 'XOPORG')
;

commit;

insert into n_xorg_to_do_views 
     ( view_name,
       query_position
     )
select view_name,query_position
  from n_view_queries q
 where q.view_label in ('AP_Invoice_Hold_Details','AP_Invoices',
                        'PO_AP_Invoices','PO_Invoices')
   and application_instance like 'X%'
   and NVL(q.omit_flag,'N') = 'N'
   and not exists
     ( select 'already there'
         from  n_xorg_to_do_views xd
        where xd.view_name = q.view_name
          and  xd.query_position = q.query_position )
   and not exists
     ( select 'Do not insert XOPORG views'
         from n_views nv
        where nv.view_name                        = q.view_name
          and NVL(nv.special_process_code,'NONE') = 'XOPORG')
;
commit;

--this table contains relation between global and component views
Prompt Populate table that contains relation between global and component views
insert into  n_xorg_global_comp_views 
select distinct
       c_v.application_label,
       g_a.application_instance global_instance,  
       c_a.application_instance comp_instance,
       g_v.view_name            global_view,
       c_v.view_name            component_view
  from n_application_owners g_a,
       n_application_owners c_a,
       n_views              g_v,
       n_views              c_v,
       n_xorg_to_do_views   nxv
 where g_a.application_label            = c_a.application_label
   and g_a.chart_of_accounts_id         = c_a.chart_of_accounts_id
   and nvl(g_a.master_organization_id,-9) = nvl(c_a.master_organization_id,-9)
   and g_a.application_instance      like 'X%'
   and c_a.application_instance  not like 'G%'
   and c_a.application_instance  not like 'X%'
   and g_v.application_label            = g_a.application_label
   and c_v.application_label            = g_v.application_label
   and g_v.application_instance         = g_a.application_instance
   and c_v.application_instance         = c_a.application_instance
   and g_v.view_label                   = c_v.view_label 
   and g_v.view_name                    = nxv.view_name
   and nvl(c_v.omit_flag,'N')           = 'N'
   and c_a.xop_instance                is not null
   and nvl(c_a.use_org_in_xop_flag,'N') = 'Y'
   and exists 
     ( select 'exists'
         from n_view_queries nvq
        where nvq.view_name = nxv.view_name)
;

/*
-- omit Z$Columns of of the other modules in global views

 update n_view_columns nvc
    set omit_flag = 'Y'
  where exists
    (select distinct 'Y'
                       from
                   n_views nv,
                   n_views nv1,
                   n_view_columns nvc1
                where nv.view_name = nvc1.view_name
                and nv1.view_name = nvc1.key_view_name
                and nv1.application_label != nv.application_label
                and nvl(nvc1.omit_flag,'N') = 'N'
                and nvc1.view_name   = nvc.view_name
                and nvc1.column_name = nvc.column_name
                and nv.application_instance = nv1.application_instance
                 and nv.application_instance like 'X%')
    and nvc.column_name like 'Z$%'
/

*/

update n_xorg_to_do_views todo
   set (view_label,application_label,application_instance)  =
            ( select v.view_label,v.application_label,v.application_instance
               from n_views v
              where v.view_name = todo.view_name)
;

commit;

set echo on
--
@utlspoff

set timing off

--@wdrop function &noetix_user n_xorgpop_func3
--@wdrop function &noetix_user n_xorgpop_func1
--@wdrop function &noetix_user n_xorgpop_func2

undefine MAX_BUFFER

-- End xorgpop.sql
