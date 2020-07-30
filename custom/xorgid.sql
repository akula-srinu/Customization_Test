-- Title
--   xorgid.sql
-- Function
--   Add extra where clauses to the global views for the org_id column
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   21-Sep-98 C Lee      created
--   25-May-99 M potluri  modified to handle outer join problem when making where clauses to add views
--   04-Jun-99 M potluri  modified to do union all for those views which have outer join problems
--   09-Jun-99 D Glancy   Added performance enchancements to the queries below.
--                        Add +0 to the last session_id joins.
--   10-Jun-99 D Glancy   In c1 query, "label_exists" to 'label_exists'.
--   14-Jun-99 D Glancy   Change XOP instance indicator from GX to X.
--   21-Jun-99 D Glancy   Exclude views from xorgid processing that have the 
--                        XOPORG special_Process_code set.  These will are 
--                        handled through meta-data.
--   02-Jul-99 M Potluri  changed dummy value in NVL i.e '999' to '9999' for consistency.
--   11-Aug-99 D Glancy   Change spacing for the where clause that begins with 
--                        ' AND.*' to 'AND.*'.  Effects output of genview.
--   20-Sep-99 R Lowe     Update copyright info.
--   16-Feb-00 H Sumanam  Update copyright info.
--   20-Jul-00 R Kompella multiorg_flag variable is used in the script but not
--                        defined with in the script. Now added the variable 
--                        definition and initialization.
--   11-Dec-00 D Glancy   Update Copyright info.
--   12-Nov-01 D Glancy   Update copyright info. (Issue #5285)
--   17-Jul-03 D Glancy   Added undefine statements to clean up environment. (Issue #8561)
--   23-Feb-04 D Glancy   Update Copyright Info. (Issue 11982)
--   25-Mar-04 D Glancy   Related fix to large installation support.
--                        Add support to use the new n_xop_mappings and n_application_owner_globals tables.
--                        If < 1000 orgs (by default), then use the n_application_owners/globals tables to 
--                        generate the in-list.  If 1000 or greater, add a join to the n_xop_mappings table 
--                        instead of using the in-list.
--                        (Issue 10328,10843,11698)
--   03-Nov-04 D Glancy   Update Copyright Info. (Issue 13498)
--   22-Sep-05 D Glancy   Update copyright info. (Issue 15175)
--   15-Nov-05 D Glancy   Add XOP support for GMS and IGW.
--                        (Issue 15417)
--   20-Nov-05 D Glancy   Rename n_xop_mappings to new n_application_org_mappings.
--                        (Issue 15240)
--   14-Mar-07 D Glancy   Add support for 'CS' module.
--                        (Issue 16803)
--   07-May-07 D Glancy   Add support for 'CSD', 'CSF', and 'CSI' modules.
--                        (Issue 17582)
--   23-Oct-07 D Glancy   Add support for 'PJM' and 'MSC'.
--                        (Issue 18001)
--   20-Oct-08 D Glancy   Add 'N_SM_FV_SOB_MAPPINGS_V' to the xmap view check.
--   09-Feb-09 D Glancy   Change in design for global security.  We are now going to reference metadata
--                        generated views out of xxnao (XXNAO_ACL_<APPL>_<ORG>_MAP_BASE.
--                        (Issue 21378)
--  09-Mar-09 D Glancy    Change in design for global security.  We are now going to reference metadata
--                        generated views out of xxnao (<APPL>_<ORG_TYPE>_ACL_MAP_BASE).
--                        (Issue 21378)
--  02-Apr-09 D Glancy    insert into the n_xorg_to_do_views was not correct.  Needed to eliminate 
--                        queries that are not going to be generated anyway.
--                        (Issue 21838)
--  08-Apr-09 D Glancy    Use upper(table_name) for the XXNAO and <APPL>_<ORG_TYPE> map views in the check for 
--                        for XOPORG functionality.
--                        (Issue 21378)
--  03-Jun-09 D Glancy    "insert into n_xorg_to_do_views" statement should use view_name in the n_view_wheres sub-query
--                        so we hit the index.
--                        (Issue 22172)
--  13-Nov-13 kkondaveeti Added support for OKE
@utlspon xorgid

column multi_org_flag new_value MULTIORG_FLAG noprint
select multi_org_flag multi_org_flag
  from fnd_product_groups_v  fpg
 where fpg.release_name = 
     ( select max(release_name)
         from fnd_product_groups_v fpg2
        where fpg2.product_group_id = 1 )
   and fpg.product_group_id = 1;
--
declare
    -- this cursor returns all view-queries with at least one table with
    -- a column called ORG_ID
    cursor c1 is
    select v1.application_label, 
           v1.application_instance, 
           v1.view_label, 
           v1.view_name, 
           q1.query_position
      from n_view_queries q1,
           n_views v1,
           n_to_do_views todo1
     where v1.application_instance like 'X%'
    -- dglancy 21-Jun-99
    -- Exclude views that have the XOPORG special_Process_code set.
       and NVL(v1.special_process_code,'NONE') 
                                   != 'XOPORG'
       and q1.view_name             = v1.view_name
       and v1.view_name             = todo1.view_name
       and todo1.session_id         = userenv('SESSIONID')
       and nvl(v1.omit_flag,'N')    = 'N'
       and nvl(q1.omit_flag,'N')    = 'N'
    -- dglancy 09-Jun-99
    -- Instead of using select in use exists clause for performance reasons.
    --  and     ( v1.view_label, q1.query_position ) in
    --      ( select distinct v.view_label, q.query_position
       and exists
         ( select 'label_exists'
             from n_org_columns_temp orgtbl,
                  n_application_owners a,
                  n_application_xref x,
                  n_view_tables t,
                  n_view_queries q,
                  n_views v,
                  n_to_do_views todo
            where v.view_label            = v1.view_label
              and v.view_name             = todo.view_name
              and todo.session_id+0       = userenv('SESSIONID')
              and q.view_name             = v.view_name
              and q.query_position        = q1.query_position
              and nvl(v.omit_flag,'N')    = 'N'
              and nvl(q.omit_flag,'N')    = 'N'
              and t.view_name             = q.view_name
              and t.query_position        = q.query_position
              and nvl(t.omit_flag,'N')    = 'N'
              and nvl(t.subquery_flag,'N') = 'N'
              and t.application_label     = x.ref_application_label
              and v.application_label     = x.application_label
              and v.application_instance  = x.application_instance
              and a.application_label     = x.ref_application_label
              and a.application_instance  = x.ref_application_instance
              and a.application_instance  not like 'X%'
              and a.org_id             is not null
              and orgtbl.table_name       = t.table_name
              and orgtbl.owner            = t.owner_name )
       -- Do the old way if we don't detect the mapping tables
       and not exists
         ( select 'using new mappings table or view'
             from n_view_tables vt
            where vt.view_name           = q1.view_name
              and vt.query_position      = q1.query_position
              and NVL(vt.omit_flag,'N')  = 'N'
              and 
                (    vt.table_name              = 'N_APPLICATION_ORG_MAPPINGS'                 -- Still Good
                  OR vt.table_name           LIKE 'N\\_SM\\_%\\_MAPPINGS\\_V'    ESCAPE '\\'   -- OLD
                  OR vt.table_name           LIKE 'N\\_QU\\_%\\_MAPPINGS\\_V'    ESCAPE '\\'   -- OLD
                  OR upper(vt.table_name)    LIKE 'XXNAO\\_ACL\\_%\\_MAP\\_BASE' ESCAPE '\\'   -- 585 TEMP
                  OR upper(vt.table_name)    LIKE '%\\_ACL\\_MAP\\_BASE'         ESCAPE '\\' ) -- 585 NEW
              and rownum = 1                        );
    --
    -- this cursor returns all of the table aliases in the view-query that
    -- have an ORG_ID column except the one passed in as parameter 3
    cursor c2 ( p_view_name varchar2, p_query_position number, p_table_alias varchar2 ) is
    select t1.table_alias, t1.base_table_flag
      from n_view_tables t1
     where t1.view_name              = p_view_name
       and t1.query_position         = p_query_position
       and t1.table_alias           != p_table_alias
       and nvl(t1.omit_flag,'N')     = 'N'
       and nvl(t1.subquery_flag,'N') = 'N'
       and t1.table_alias in
         ( select t.table_alias
             from n_org_columns_temp orgtbl,
                  n_application_owners a,
                  n_application_xref x,
                  n_view_tables t,
                  n_view_queries q,
                  n_views v,
                  n_to_do_views todo
            where v.view_label              = t1.view_label
              and v.view_name               = todo.view_name
              and todo.session_id+0         = userenv('SESSIONID')
              and q.view_name               = v.view_name
              and q.query_position          = t1.query_position
              and nvl(v.omit_flag,'N')      = 'N'
              and nvl(q.omit_flag,'N')      = 'N'
              and t.view_name               = q.view_name
              and t.query_position          = q.query_position
              and nvl(t.omit_flag,'N')      = 'N'
              and nvl(t.subquery_flag,'N')  = 'N'
              and t.application_label       = x.ref_application_label
              and v.application_label       = x.application_label
              and v.application_instance    = x.application_instance
              and a.application_label       = x.ref_application_label
              and a.application_instance    = x.ref_application_instance
              and a.application_instance  not like 'X%'
              and a.org_id                 is not null
              and orgtbl.table_name         = t.table_name
              and orgtbl.owner              = t.owner_name );
    --
    cursor c_global_orgs( p_application_label    VARCHAR2,
                          p_application_instance VARCHAR2 ) IS
    -- get the list of org_ids that this instance is aggregating
    select rtrim(global_orgs,')') value,
           1                      sequence
      from n_application_owners
     where application_label    = p_application_label
       and application_instance = p_application_instance
     UNION
    select rtrim(value,')')       value,
           sequence+1             sequence
      from n_application_owner_globals
     where application_label    = p_application_label
       and application_instance = p_application_instance
       and column_name          = 'GLOBAL_ORGS'
     order by 2;
    --
    TYPE GlobalValueTab IS TABLE OF N_VIEW_WHERES.WHERE_CLAUSE%TYPE
         INDEX BY BINARY_INTEGER;
    --
    v_where_clause_table  GlobalValueTab;
    v_where_clause_count  BINARY_INTEGER;
    --
    v_map_table_alias           n_cross_org_map_alias.table_alias%TYPE;
    v_where_clause_position     n_view_wheres.where_clause_position%TYPE;
    v_where_clause              n_view_wheres.where_clause%TYPE;
    v_global_orgs               n_application_owners.global_orgs%TYPE;
    v_outerjoin_table           varchar2(1);
    vi_xop_count                INTEGER;
    --
begin

    for r1 in c1 loop

        -- get the starting where clause position, start after the
        -- last non-generated where clause since group by has already
        -- added it information.  if none are found, start at 1800 which
        -- is before the point that group by starts
        begin
            select nvl( max( w.where_clause_position ), 1800 )
              into v_where_clause_position
              from n_view_wheres w
             where w.view_label     = r1.view_label
               and w.view_name      = r1.view_name
               and w.query_position = r1.query_position
               and w.where_clause_position < 1900;
--               and w.generated_flag = 'N';
        exception
            when NO_DATA_FOUND then
                v_where_clause_position := 1800;                
        end;
        

        if ( r1.application_label in 
                ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA', 'OKE' ) ) then

            select count(distinct xmap.ORG_ID) 
              into vi_xop_count
              from n_application_org_mappings xmap
             where xmap.application_label      = r1.application_label
               and xmap.application_instance   = r1.application_instance;
               
            -- get the table alias for this view from our custom table
            -- (this is loaded in xorgcfg.sql)
            begin
                select map.table_alias
                  into v_map_table_alias
                  from n_cross_org_map_alias map
                 where map.application_label    = r1.application_label
                   and map.view_label           = r1.view_label
                   and map.view_name            = r1.view_name
                   and map.query_position       = r1.query_position
                   and map.map_type             = 'ORG_ID'
                   and map.base_table_flag      = 'Y';
            exception
                when NO_DATA_FOUND then
                    v_map_table_alias := NULL;
            end;
            --
            
            if ( v_map_table_alias is not null ) then

                -- this view-query has a base table with an ORG_ID column

                -- If the number of applications in the instance is less than the max
                -- number of items in an in-list, then use the n_application_mappings table instead.
                if vi_xop_count <= &OU_MAPPING_THRESHOLD then
                    -- insert the where clause dealing with the base table
                    --v_where_clause := 'AND '||v_map_table_alias
                    --                  ||'.ORG_ID IN '||v_global_orgs||',-9999');
                    v_where_clause_count := 0;
                    v_where_clause_table.DELETE;
                    for r_global_orgs in c_global_orgs( r1.application_label,
                                                        r1.application_instance ) loop
                        v_where_clause_count                       := r_global_orgs.sequence;
                        v_where_clause_table(v_where_clause_count) := r_global_orgs.value;
                    end loop; -- c_global_orgs
                    --
                    v_where_clause_table(1) := 
                            'AND NVL ('||v_map_table_alias||
                            '.ORG_ID ,-9999 ) IN '||
                                v_where_clause_table(1);
                    v_where_clause_table(v_where_clause_count) := 
                            v_where_clause_table(v_where_clause_count)||
                              ', -9999) ' ;
                    --
                    for i in 1..v_where_clause_count loop
                        noetix_xop_pkg.insert_view_where( 
                                i_view_name               => r1.view_name, 
                                i_view_label              => r1.view_label, 
                                i_query_position          => r1.query_position,
                                i_application_instance    => r1.application_instance,
                                io_where_clause_position  => v_where_clause_position, 
                                i_where_clause            => v_where_clause_table(i),
                                i_profile_option          => NULL                     );
                    end loop; -- 1 to v_where_clause_count
                -- If the number of applications in the instance greater than the max
                -- number of items in an in-list, then use the n_application_mappings table instead.
                else
                    -- Add join to n_application_org_mappings
                    noetix_xop_pkg.add_mapping_table_join( 
                                 i_application_label       => r1.application_label,
                                 i_application_instance    => r1.application_instance,
                                 i_view_name               => r1.view_name,
                                 i_view_label              => r1.view_label,
                                 i_query_position          => r1.query_position,
                                 io_where_clause_position  => v_where_clause_position, 
                                 i_profile_option          => NULL                                 );
                    -- Insert the join in n_view_wheres to new mapping table.
                    noetix_xop_pkg.insert_view_where( 
                                 i_view_name               => r1.view_name, 
                                 i_view_label              => r1.view_label, 
                                 i_query_position          => r1.query_position,
                                 i_application_instance    => r1.application_instance,
                                 io_where_clause_position  => v_where_clause_position, 
                                 i_where_clause            => 'AND NVL ('||v_map_table_alias||'.ORG_ID ,-9999 ) = XOP_MAP.ORG_ID ',
                                 i_profile_option          => NULL                     );
                end if;
                --
                -- now, loop through all the rest of the tables with ORG_ID
                for r2 in c2 ( r1.view_name, r1.query_position, v_map_table_alias ) loop

                    /*
                      v_where_clause := 'AND NVL( '||r2.table_alias||'.ORG_ID, '||
                                             v_map_table_alias||'.ORG_ID ) = '||
                                             v_map_table_alias||'.ORG_ID';
                    */

                    if r2.base_table_flag  = 'Y' then

                        v_where_clause := 
                            'AND NVL( '||r2.table_alias||'.ORG_ID, '||
                            'NVL ( '||v_map_table_alias||'.ORG_ID, -9999)) = '||
                                   'NVL( '||v_map_table_alias||'.ORG_ID, -9999)';
                    else
    
                        v_where_clause := 
                            'AND NVL( '||r2.table_alias||'.ORG_ID, '||
                            'NVL ( '||v_map_table_alias||'.ORG_ID, -9999)) = '||
                                   'NVL( '||v_map_table_alias||'.ORG_ID, NVL('||
                                   r2.table_alias||'.ORG_ID, -9999))';
                    end if;
          
                    noetix_xop_pkg.insert_view_where( 
                                i_view_name               => r1.view_name, 
                                i_view_label              => r1.view_label, 
                                i_query_position          => r1.query_position,
                                i_application_instance    => r1.application_instance,
                                io_where_clause_position  => v_where_clause_position, 
                                i_where_clause            => v_where_clause,
                                i_profile_option          => NULL                     );

                end loop;  -- c2

                if ( c2%isopen ) then
                    close c2;
                end if;

            else

                -- this view-query does not have any base tables with an ORG_ID column,
                -- but there are tables with ORG_ID (save the data and we'll do it later
                -- in genview)

                insert into n_xorg_to_do_views
                     ( application_label, 
                       application_instance, 
                       view_name, 
                       view_label, 
                       query_position )
                values
                     ( r1.application_label, 
                       r1.application_instance, 
                       r1.view_name, 
                       r1.view_label, 
                       r1.query_position );
                    
            end if;

            commit;
        end if;
    end loop;  -- c1
end;
/
commit
/

-- populate problem views into table, later we use this table to do union all
insert into n_xorg_to_do_views
     ( application_label,
       application_instance,
       view_label,
       view_name,
       query_position )
select distinct
       nv.application_label,
       nv.application_instance,
       nq.view_label,
       nq.view_name,
       nq.query_position
  from n_view_queries nq,
       n_views nv
 where nv.application_instance  like 'X%'
   and nv.application_label     in ( 'AP', 'AR', 'CS', 'CSD', 'CSF', 'CSI', 'GMS', 'IGW', 
                                     'OE', 'PA', 'PB', 'PC',  'PJM', 'PO',  'RA', 'OKE')
   -- dglancy 21-Jun-99
   -- Exclude views that have the XOPORG special_Process_code set.
   and NVL(nv.special_process_code,'NONE')
                               != 'XOPORG'
   and nq.application_instance  = nv.application_instance
   and nq.view_label            = nv.view_label
   and nq.view_name             = nv.view_name
   and nvl(nv.omit_flag,'N')    = 'N'
   and nvl(nq.omit_flag,'N')    = 'N'
   and nvl(nv.omit_flag,'N')    = nvl(nq.omit_flag,'N')
   and exists 
     ( select q.view_label
         from n_org_columns_temp orgtbl,
              n_application_owners a,
              n_application_xref x,
              n_view_tables t,
              n_view_queries q,
              n_views v,
              n_to_do_views todo
        where v.view_label                      = nv.view_label  -- xorg
          -- dglancy 09-Jun-99  Join based on application_label used above
          -- and  v.application_label in ( 'AP', 'AR', 'OE', 'PA', 'PB', 'PC', 'PJM', 'PO', 'RA')
          and v.application_label                = nv.application_label
          and q.view_name                        = v.view_name
          and v.view_name                        = todo.view_name
          -- dglancy 09-Jun-99  Disable the non-unique index.
          and todo.session_id+0                  = userenv('SESSIONID')
          --
          and nvl(v.omit_flag,       'N')        = 'N'
          and nvl(q.omit_flag,       'N')        = 'N'
          and t.view_name                        = q.view_name
          and t.query_position                   = q.query_position
          and nvl(t.omit_flag,       'N')        = 'N'
          and nvl(t.subquery_flag,   'N')        = 'N'
          and t.application_label                = x.ref_application_label
          and v.application_label                = x.application_label
          and v.application_instance             = x.application_instance
          and v.application_instance      not like 'X%'   --xorg
          and a.application_label                = x.ref_application_label
          and a.application_instance             = x.ref_application_instance
          and a.application_instance      not like 'X%'   --xorg
          and a.org_id                          is not null
          and '&MULTIORG_FLAG'                                  = 'Y'
          and orgtbl.table_name                  = t.table_name
          and orgtbl.owner                       = t.owner_name
          and exists
            ( select 'table exist'
                from n_view_wheres w
               where w.view_name            = t.view_name
                 and w.query_position       = t.query_position
                 and (    w.where_clause like '%'||t.table_alias||'.%(+)%=%'
                       or w.where_clause like '%=%'||t.table_alias||'.%(+)%' )
                 and w.where_clause  not like '%'||t.table_alias||'.ORG_ID'||'%(+)%'
              )
       )
   and not exists
     ( select 'view is already exists'
         from n_xorg_to_do_views todo1
        where todo1.view_name = nq.view_name )
   -- Do the old way if we don't detect the mapping tables
   and not exists
     ( select 'using new mappings table or view'
         from n_view_tables vt
        where vt.view_name           = nv.view_name
          and vt.query_position      = nq.query_position
          and NVL(vt.omit_flag,'N')  = 'N'
          and 
            (    vt.table_name              = 'N_APPLICATION_ORG_MAPPINGS'            -- Still Good
              OR vt.table_name           LIKE 'N\\_SM\\_%\\_MAPPINGS\\_V'    ESCAPE '\\'   -- OLD
              OR vt.table_name           LIKE 'N\\_QU\\_%\\_MAPPINGS\\_V'    ESCAPE '\\'   -- OLD
              OR upper(vt.table_name)    LIKE 'XXNAO\\_ACL\\_%\\_MAP\\_BASE' ESCAPE '\\'   -- 585 TEMP
              OR upper(vt.table_name)    LIKE '%\\_ACL\\_MAP\\_BASE'         ESCAPE '\\' ) -- 585 NEW
          and rownum = 1                        )
/
commit
/
--
@utlspoff

undefine MULTIORG_FLAG
-- End xorgid.sql
