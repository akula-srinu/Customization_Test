-- Title
--    Check_Refresh.sql
--    @(#)Check_Refresh.sql
-- Function
--  @(#)  
--  @(#)  
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--    31-Mar-15 Kumar    Initial version
--    31-Mar-15 Srini    CDC updates Added
--   29-Apr-15 G venkat  Used noetix utility package instead of ir_installation_message.(NV-1027)
--   26-Jun-15 Arvind    Added one deletion for duplicate records in n_customizations.(Issue: NV-1092)
--   21-Jul-15 Arvind    Modified the code to update the t_column_id of n_view_column_templates(Issue: NV-1120)
--   12-Aug-15 Arvind    Added one deletion statement to remove duplicate records in n_customizations.(Issue: NEM-1886)
--   01-Sep-15 Arvind    Added update for n_view_property_templates.(Issue: NEM-1907 / NV-1211)
--   08-Oct-15 Arvind    Added code for n_help% and n_application_owner_templates tables as non supported tables. (Issue: NV-1240)
--   13-Oct-15 Arvind    Added code to detect the physical deletes and restore upon need. (Issue: NV-1217)
--   08-Dec-15 Nagesh	 Updated gc_pkg_version variable definition. removed space between datatype and its size. (Issue: NV-1165)
--   18-Dec-15 Arvind    Updated code to handle Unique key constraint violation in IR processing 
--                       while creating a new custom view from an existing view (Issue: NV-1317)
--   04-Feb-16 Arvind    Change the position to enable constraints. (Issue: NV-1330)
--   05-Feb-16 Arvind    Deleting duplicates from n_join_key_temp_del_incr that is getting populated in Join trigers. (Issue NV-1330)
--	 17-Mar-16 Arvind    Reverted the constraints enable position to old state. (Issue: NV-1330)
--   22-Apr-16 Nasir     Modified delete statement of n_to_do_views_incr to delete the non global views.(NV-1331)
--   13-Apr-16 Arvind    Add call to Create IR utility package if required and move the Hier and Dim procedures to the same package. (Issue: NV-1461)
--   30-May-16 Arvind    Add the code to update the t_folder_id of n_pl_folder_templates. (Issue: NV-1543)
--
whenever sqlerror exit 37

set termout off
set serveroutput on size 1000000;

@utlspon Check_Refresh

---- Create Global temporary template tables

start wdrop table    &NOETIX_USER n_to_do_views_incr
start wdrop table    &NOETIX_USER n_view_templates_gtemp
start wdrop table    &NOETIX_USER n_view_query_templates_gtemp
start wdrop table    &NOETIX_USER n_view_table_templates_gtemp
start wdrop table    &NOETIX_USER n_view_where_templates_gtemp
start wdrop table    &NOETIX_USER n_view_column_templates_gtemp
start wdrop table    &NOETIX_USER n_role_view_templates_gtemp
start wdrop table    &NOETIX_USER n_join_key_templates_gtemp
start wdrop table    &NOETIX_USER n_join_key_col_templates_gtemp
start wdrop table    &NOETIX_USER n_view_prop_templates_gtemp
start wdrop table    &NOETIX_USER n_views_gtemp
start wdrop table    &NOETIX_USER n_view_queries_gtemp
start wdrop table    &NOETIX_USER n_view_tables_gtemp
start wdrop table    &NOETIX_USER n_view_wheres_gtemp
start wdrop table    &NOETIX_USER n_view_columns_gtemp
start wdrop table    &NOETIX_USER n_role_views_gtemp
start wdrop table    &NOETIX_USER n_join_keys_gtemp
start wdrop table    &NOETIX_USER n_join_keys_col_gtemp
start wdrop table    &NOETIX_USER n_view_properties_gtemp
-- Adding non-supported metadata tables
start wdrop table    &NOETIX_USER n_role_templates_gtemp
start wdrop table    &NOETIX_USER N_ANS_WHERE_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ANS_TABLE_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ANS_QUERY_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ANS_PARAM_VALUE_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ANS_PARAM_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ANS_COLUMN_TOTAL_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ANS_COLUMN_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ANSWER_TEMP_gtemp
start wdrop table    &NOETIX_USER N_GRANT_TABLE_TEMP_gtemp
start wdrop table    &NOETIX_USER N_VIEW_TABLE_CHANGE_TEMP_gtemp
start wdrop table    &NOETIX_USER N_SEG_KEY_FLEXFIELD_TEMP_gtemp
start wdrop table    &NOETIX_USER N_ROLE_APPL_XREF_TEMP_gtemp
start wdrop table    &NOETIX_USER N_PROPERTY_TYPE_TEMP_gtemp
start wdrop table    &NOETIX_USER N_PROFILE_OPTION_TEMP_gtemp
start wdrop table    &NOETIX_USER N_PL_FOLDER_TEMP_gtemp
start wdrop table    &NOETIX_USER N_KFF_STRUCT_IDEN_TEMP_gtemp
start wdrop table    &NOETIX_USER N_KFF_PROCESSING_TEMP_gtemp
start wdrop table    &NOETIX_USER N_KFF_FLEX_SOURCE_TEMP_gtemp
--n_help% gtemp tables
start wdrop table    &NOETIX_USER N_HELP_QUESTIONS_TEMP_GTEMP
start wdrop table    &NOETIX_USER N_HELP_SEE_OTHER_TEMP_GTEMP
start wdrop table    &NOETIX_USER N_HELP_PROGRAM_XREF_TEMP_GTEMP
start wdrop table    &NOETIX_USER N_APPLICATION_OWNER_TEMP_GTEMP



Create Table n_to_do_views_incr 
 (view_label varchar2(200),
 session_id number,
 creation_date date,
 last_update_date date);

 
---- Create Global temporary template tables
@create_temp_gtt.sql

---- Create Global temporary non template tables
@create_ntemp_gtt.sql

 -- NV-1461
-- Creating IR Utilty package if required

COLUMN c_IR_utility_package_valid NEW_VALUE IR_utility_package_valid  NOPRINT
SELECT ( CASE COUNT(*)
           WHEN 0 THEN 'Y'
           ELSE 'N'
         END )    c_IR_utility_package_valid
  FROM DUAL
 WHERE n_compare_function_version( 'n_ir_utility_pkg.get_version',  '&N_SCRIPTS_VERSION' ) < 0;
COLUMN c_IR_utility_package_valid CLEAR

start utlif "utlprmpt ''Create the IR utility package during generation''" -
  "'&IR_utility_package_valid' = 'N' "
start utlif "utlstart ycr_ir_utility_pkg continue" -
  "'&IR_utility_package_valid' = 'N' "
start utlif "utlprmpt ''IR utility package exists and is valid (No Action)''" -
  "'&IR_utility_package_valid' = 'Y' "

begin
 if ('&IR_utility_package_valid' = 'N') then
 noetix_utility_pkg.add_installation_message('instincr','check_refresh','INFO','Create the IR utility package during generation',sysdate,NULL);
 elsif ('&IR_utility_package_valid' = 'Y') then
 noetix_utility_pkg.add_installation_message('instincr','check_refresh','INFO','IR utility package exists and is valid (No Action)',sysdate,NULL);
 end if;
end;
/

-- Deleting the duplicate rows from n_customizations Issue: NEM-1886
delete from n_customizations
where rowid not in(select max(rowid) from n_customizations
group by cust_rowid, view_label,cust_location);

Commit;

---- Creating a global temporary table for n_customizations

start wdrop table    &NOETIX_USER n_customizations_gtemp

Create global temporary table n_customizations_gtemp ON COMMIT PRESERVE ROWS 
as 
select ab.* from n_customizations ab;

-- Disable all relavant constraints
-- n_help_% tables added under NV-1240
BEGIN
  for i in (select constraint_name, table_name from user_constraints 
            where table_name in ('N_VIEW_WHERES','N_JOIN_KEYS','N_VIEW_PROPERTIES', 'N_VIEW_PROPERTY_TEMPLATES','N_VIEW_COLUMNS','N_VIEW_TABLES',
                    'N_VIEW_QUERIES','N_ROLE_VIEWS','N_VIEWS','N_VIEW_WHERE_TEMPLATES', 'N_JOIN_KEY_TEMPLATES','N_VIEW_COLUMN_TEMPLATES','N_VIEW_TABLE_TEMPLATES','N_VIEW_QUERY_TEMPLATES','N_ROLE_VIEW_TEMPLATES','N_VIEW_TEMPLATES','N_ROLE_TEMPLATES','N_ANS_WHERE_TEMPLATES','N_ANS_TABLE_TEMPLATES','N_ANS_QUERY_TEMPLATES','N_ANS_PARAM_VALUE_TEMPLATES','N_ANS_PARAM_TEMPLATES','N_ANS_COLUMN_TOTAL_TEMPLATES','N_ANS_COLUMN_TEMPLATES','N_ANSWER_TEMPLATES','N_GRANT_TABLE_TEMPLATES','N_VIEW_TABLE_CHANGES_TEMPLATES','N_SEG_KEY_FLEXFIELD_TEMPLATES','N_ROLE_APPL_XREF_TEMPLATES','N_PROPERTY_TYPE_TEMPLATES','N_PROFILE_OPTION_TEMPLATES','N_PL_FOLDER_TEMPLATES','N_KFF_STRUCT_IDEN_TEMPLATES','N_KFF_PROCESSING_TEMPLATES','N_KFF_FLEX_SOURCE_TEMPLATES','N_HELP_QUESTIONS_TEMPLATES','N_HELP_SEE_OTHER_TEMPLATES','N_HELP_PROGRAM_XREF_TEMPLATES', 'N_APPLICATION_OWNER_TEMPLATES')
      ) LOOP
      BEGIN
        execute immediate 'alter table '||i.table_name||' disable constraint '||i.constraint_name||' cascade';
      exception
        when others then 
             noetix_utility_pkg.Add_Installation_Message( 
                p_script_name               => 'Check Refresh',
                p_location                  => 'Disable Constraints',
                p_message_type              => 'ERROR',
                p_message                   => SQLERRM );
      END;
  END LOOP;
END;
/

----- Delete the custom insert statments from non templates -----
@del_cust_data

commit;

--Bring update data how it is used to be before u2 or u5
@inst_cust_data.sql
commit;	   
-------- Reloading the template and non template ----

@n_temp_customizations
@n_customizations

spool off;

-- Added for NV-1217
@del_cust_tab.sql

-- NV-1330 
-- begin
-- for i in (select constraint_name, table_name from user_constraints where status='DISABLED' order by decode (constraint_type,'P',1,'R',2,3))
 -- LOOP
 -- BEGIN
  -- execute immediate 'alter table '||i.table_name||' enable constraint '||i.constraint_name||'';
 -- exception
  -- when others then 
    -- null;
 -- end;
-- end loop;
-- end;
-- /

@wnoetxu2
@wnoetxu5

-- delete duplicates 
delete from n_join_key_temp_del_incr 
where rowid not in (select max(rowid) from n_join_key_temp_del_incr group by (key_name,view_label));

delete from n_customizations
where rowid not in(select max(rowid) from n_customizations
group by cust_rowid, view_label,cust_location)
;
@utlprmpt "Customized Data Captured."
exec noetix_utility_pkg.add_installation_message('instincr','checkrefresh','INFO',' Customized Data Captured. ',sysdate,NULL);
commit;

start wdrop trigger   &NOETIX_USER n_view_temp_incr_trg
start wdrop trigger   &NOETIX_USER n_view_query_temp_incr_trg
start wdrop trigger   &NOETIX_USER n_view_tabtemp_incr_trg
start wdrop trigger   &NOETIX_USER n_view_coltemp_incr_trg
start wdrop trigger   &NOETIX_USER N_VIEW_WHERE_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER n_join_key_temp_incr_trg
start wdrop trigger   &NOETIX_USER n_join_key_col_temp_incr_trg
start wdrop trigger   &NOETIX_USER n_role_view_temp_incr_trg
start wdrop trigger   &NOETIX_USER n_view_proptemp_incr_trg
start wdrop trigger   &NOETIX_USER n_view_incr_trg
start wdrop trigger   &NOETIX_USER n_view_query_incr_trg
start wdrop trigger   &NOETIX_USER n_view_tab_incr_trg
start wdrop trigger   &NOETIX_USER n_view_col_incr_trg
start wdrop trigger   &NOETIX_USER N_VIEW_WHERE_incr_trg
start wdrop trigger   &NOETIX_USER n_join_key_incr_trg
start wdrop trigger   &NOETIX_USER n_join_key_col_incr_trg
start wdrop trigger   &NOETIX_USER n_role_view_incr_trg
start wdrop trigger   &NOETIX_USER n_view_prop_incr_trg
start wdrop trigger   &NOETIX_USER n_view_temp_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_query_temp_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_tabtemp_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_coltemp_incr_trg1
start wdrop trigger   &NOETIX_USER N_VIEW_WHERE_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER n_join_key_temp_incr_trg1
start wdrop trigger   &NOETIX_USER n_join_key_col_temp_incr_trg1
start wdrop trigger   &NOETIX_USER n_role_view_temp_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_proptemp_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_query_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_tab_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_col_incr_trg1
start wdrop trigger   &NOETIX_USER N_VIEW_WHERE_incr_trg1
start wdrop trigger   &NOETIX_USER n_join_key_incr_trg1
start wdrop trigger   &NOETIX_USER n_join_key_col_incr_trg1
start wdrop trigger   &NOETIX_USER n_role_view_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_prop_incr_trg1
start wdrop trigger   &NOETIX_USER n_role_temp_incr_trg
start wdrop trigger   &NOETIX_USER n_role_temp_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANS_WHERE_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_ANS_WHERE_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANS_TABLE_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_ANS_TABLE_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANS_QUERY_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_ANS_QUERY_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANS_PARAM_VALUE_incr_trg
start wdrop trigger   &NOETIX_USER N_ANS_PARAM_VALUE_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANS_PARAM_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_ANS_PARAM_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANS_COLUMN_TOTAL_incr_trg
start wdrop trigger   &NOETIX_USER N_ANS_COLUMN_TOTAL_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANS_COLUMN_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_ANS_COLUMN_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_ANSWER_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_ANSWER_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_GRANT_TABLE_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_GRANT_TABLE_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_VIEW_TABLE_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_VIEW_TABLE_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_SEG_KEY_FLEX_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_SEG_KEY_FLEX_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_ROLE_APPL_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_ROLE_APPL_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_PROPERTY_TYPE_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_PROPERTY_TYPE_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_PROFILE_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_PROFILE_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_PL_FOLDER_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_PL_FOLDER_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_KFF_STRUCT_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_KFF_STRUCT_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_KFF_PROC_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_KFF_PROC_TEMP_incr_trg1
start wdrop trigger   &NOETIX_USER N_KFF_FLEX_TEMP_incr_trg
start wdrop trigger   &NOETIX_USER N_KFF_FLEX_TEMP_incr_trg1
--n_help triggers
start wdrop trigger   &NOETIX_USER N_HELP_QUES_TEMP_INCR_TRG
start wdrop trigger   &NOETIX_USER N_HELP_QUES_TEMP_INCR_TRG1
start wdrop trigger   &NOETIX_USER N_HELP_SEE_TEMP_INCR_TRG
start wdrop trigger   &NOETIX_USER N_HELP_SEE_TEMP_INCR_TRG1
start wdrop trigger   &NOETIX_USER N_HELP_PRG_XREF_TEMP_INCR_TRG
start wdrop trigger   &NOETIX_USER N_HELP_PRG_XREF_TEMP_INCR_TRG1
start wdrop trigger   &NOETIX_USER N_APPL_OWNER_TEMP_INCR_TRG
start wdrop trigger   &NOETIX_USER N_APPL_OWNER_TEMP_INCR_TRG1


@prdvercl.sql
@verflag.sql
@wtblupd N

@utlspon Check_Refresh1

------ Identifying the latest template customizations ----

---- Identifying the view level changes --

insert into n_to_do_views_incr (view_label) 
 WITH upd_views as
     ( SELECT distinct view_label 
         FROM n_customizations_gtemp 
         UNION
         SELECT distinct view_label 
         FROM n_customizations
       ) 
(select distinct view_label from
((select nv.view_label,application_label,description,profile_option,essay,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,security_code,special_process_code
from n_view_templates nv ,upd_views
where nv.view_label = upd_views.view_label
minus
select nv.view_label,application_label,description,profile_option,essay,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,security_code,special_process_code
from n_view_templates_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
) 
UNION
(select nv.view_label,application_label,description,profile_option,essay,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,security_code,special_process_code
from n_view_templates_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
minus
select nv.view_label,application_label,description,profile_option,essay,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,security_code,special_process_code
from n_view_templates nv,upd_views
where nv.view_label = upd_views.view_label)
)
---- Identifying the query level changes --
UNION
select distinct view_label from
((select nv.view_label, query_position,union_minus_intersection,group_by_flag,profile_option,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_query_templates nv ,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,union_minus_intersection,group_by_flag,profile_option,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_query_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, query_position,union_minus_intersection,group_by_flag,profile_option,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_query_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,union_minus_intersection,group_by_flag,profile_option,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_query_templates nv,upd_views
where nv.view_label = upd_views.view_label
)
)
---- Identifying the table level changes ---
UNION
select distinct view_label from
((select  nv.view_label, query_position,table_alias,from_clause_position, application_label, table_name,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,base_table_flag,subquery_flag,gen_search_by_col_flag
from n_view_table_templates nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,table_alias,from_clause_position, application_label, table_name,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,base_table_flag,subquery_flag,gen_search_by_col_flag
from n_view_table_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, query_position,table_alias,from_clause_position, application_label, table_name,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,base_table_flag,subquery_flag,gen_search_by_col_flag
from n_view_table_templates_gtemp nv ,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,table_alias,from_clause_position, application_label, table_name,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag,base_table_flag,subquery_flag,gen_search_by_col_flag
from n_view_table_templates nv ,upd_views
where nv.view_label = upd_views.view_label
)
)
---- Identifying the where level changes ---
UNION
select distinct view_label from
((select  nv.view_label, query_position,where_clause_position,where_clause,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_where_templates nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,where_clause_position,where_clause,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_where_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, query_position,where_clause_position,where_clause,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_where_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,where_clause_position,where_clause,profile_option,
REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_where_templates nv,upd_views
where nv.view_label = upd_views.view_label
)
)
---- Identifying the column level changes ---
UNION
select distinct view_label from
((select  nv.view_label, query_position,column_label,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_column_templates nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,column_label,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_column_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, query_position,column_label,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_column_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position,column_label,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_view_column_templates nv,upd_views
where nv.view_label = upd_views.view_label
)
)
---- Identifying the role view level changes ---
UNION
select distinct view_label from
((select  nv.view_label, role_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_role_view_templates nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, role_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_role_view_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, role_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_role_view_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, role_label,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') ,user_include_flag
from n_role_view_templates nv,upd_views
where nv.view_label = upd_views.view_label
)
)
---- Identifying the join key level changes ---
UNION
select distinct view_label from
((select  nv.view_label, key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') , profile_option, user_include_flag
from n_join_key_templates nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') , profile_option, user_include_flag
from n_join_key_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') , profile_option, user_include_flag
from n_join_key_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') , profile_option, user_include_flag
from n_join_key_templates nv,upd_views
where nv.view_label = upd_views.view_label
)
)
---- Identifying the join key column level changes ---
UNION
select distinct view_label from
((select nv1.view_label,NV.T_COLUMN_POSITION,NV.COLUMN_LABEL,NV.KFF_TABLE_PK_COLUMN_NAME 
from n_join_key_col_templates NV,n_join_key_templates nv1,upd_views
where nv1.view_label = upd_views.view_label
and nv.T_JOIN_KEY_ID = NV1.T_JOIN_KEY_ID
minus
select nv1.view_label,NV.T_COLUMN_POSITION,NV.COLUMN_LABEL,NV.KFF_TABLE_PK_COLUMN_NAME 
from n_join_key_col_templates_gtemp nv,n_join_key_templates_gtemp nv1,upd_views
where nv1.view_label = upd_views.view_label
and nv.T_JOIN_KEY_ID = NV1.T_JOIN_KEY_ID
)
UNION
(select nv1.view_label,NV.T_COLUMN_POSITION,NV.COLUMN_LABEL,NV.KFF_TABLE_PK_COLUMN_NAME 
from n_join_key_col_templates_gtemp nv,n_join_key_templates_gtemp nv1,upd_views
where nv1.view_label = upd_views.view_label
and nv.T_JOIN_KEY_ID = NV1.T_JOIN_KEY_ID
minus
select nv1.view_label,NV.T_COLUMN_POSITION,NV.COLUMN_LABEL,NV.KFF_TABLE_PK_COLUMN_NAME 
from n_join_key_col_templates NV,n_join_key_templates nv1,upd_views
where nv1.view_label = upd_views.view_label
and nv.T_JOIN_KEY_ID = NV1.T_JOIN_KEY_ID
)
)
---- Identifying the view property level changes ---
UNION
select distinct view_label from
((select  nv.view_label, query_position, property_type_id,  value1, value2, value3, value4, value5, REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') profile_option, user_include_flag,nvl(version_id,1)
from n_view_property_templates nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position, property_type_id,  value1, value2, value3, value4, value5, REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') profile_option, user_include_flag,nvl(version_id,1)
from n_view_prop_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, query_position, property_type_id,  value1, value2, value3, value4, value5, REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') profile_option, user_include_flag,nvl(version_id,1)
from n_view_prop_templates_gtemp nv,upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, query_position, property_type_id,  value1, value2, value3, value4, value5, REPLACE(NVL(PRODUCT_VERSION,'*'),'*','%') profile_option, user_include_flag,nvl(version_id,1)
from n_view_property_templates nv,upd_views
where nv.view_label = upd_views.view_label
)
)
)
;
------ Identifying the latest non template customizations ----

insert into n_to_do_views_incr (view_label) 
WITH upd_views as
     ( SELECT distinct view_label 
         FROM n_customizations_gtemp 
         UNION
         SELECT distinct view_label 
         FROM n_customizations
       ) 
(select distinct view_label from
((select  nv.view_label,view_name,application_label,application_instance,description,profile_option,
essay,omit_flag,user_omit_flag,security_code,special_process_code,sort_layer
from n_views nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name,application_label,application_instance,description,profile_option,
essay,omit_flag,user_omit_flag,security_code,special_process_code,sort_layer
from n_views_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
UNION
(select  nv.view_label,view_name,application_label,application_instance,description,profile_option,
essay,omit_flag,user_omit_flag,security_code,special_process_code,sort_layer
from n_views_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name,application_label,application_instance,description,profile_option,
essay,omit_flag,user_omit_flag,security_code,special_process_code,sort_layer
from n_views nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
)
----Identifying the query level changes ---
UNION
select distinct view_label from
((select  nv.view_label,view_name, query_position,union_minus_intersection,group_by_flag,profile_option,application_instance,omit_flag,user_omit_flag
from n_view_queries nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name, query_position,union_minus_intersection,group_by_flag,profile_option,application_instance,omit_flag,user_omit_flag
from n_view_queries_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
UNION
(select  nv.view_label,view_name, query_position,union_minus_intersection,group_by_flag,profile_option,application_instance,omit_flag,user_omit_flag
from n_view_queries_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name, query_position,union_minus_intersection,group_by_flag,profile_option,application_instance,omit_flag,user_omit_flag
from n_view_queries nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
)
----Identifying the table level changes ---
UNION
select distinct view_label from
((select  nv.view_label, view_name,query_position,table_alias,from_clause_position, application_label,owner_name,table_name,application_instance,
profile_option,omit_flag,user_omit_flag,base_table_flag,subquery_flag,gen_search_by_col_flag,generated_flag
from n_view_tables nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label, view_name,query_position,table_alias,from_clause_position, application_label,owner_name,table_name,application_instance,
profile_option,omit_flag,user_omit_flag,base_table_flag,subquery_flag,gen_search_by_col_flag,generated_flag
from n_view_tables_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
UNION
(select  nv.view_label, view_name,query_position,table_alias,from_clause_position, application_label,owner_name,table_name,application_instance,
profile_option,omit_flag,user_omit_flag,base_table_flag,subquery_flag,gen_search_by_col_flag,generated_flag
from n_view_tables_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label, view_name,query_position,table_alias,from_clause_position, application_label,owner_name,table_name,application_instance,
profile_option,omit_flag,user_omit_flag,base_table_flag,subquery_flag,gen_search_by_col_flag,generated_flag
from n_view_tables nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
)
--- Identifying the where level changes ---
UNION
select distinct view_label from
((select  nv.view_label,view_name, query_position,where_clause_position,where_clause,profile_option,
application_instance,omit_flag,user_omit_flag,generated_flag
from n_view_wheres nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name, query_position,where_clause_position,where_clause,profile_option,
application_instance,omit_flag,user_omit_flag,generated_flag
from n_view_wheres_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
UNION
(select  nv.view_label,view_name, query_position,where_clause_position,where_clause,profile_option,
application_instance,omit_flag,user_omit_flag,generated_flag
from n_view_wheres_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name, query_position,where_clause_position,where_clause,profile_option,
application_instance,omit_flag,user_omit_flag,generated_flag
from n_view_wheres nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
)
--- Identifying the column level changes ---
UNION
select distinct view_label from
((select  nv.view_label,view_name, query_position,column_label,column_name,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,application_instance,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,generated_flag,omit_flag,user_omit_flag
from n_view_columns nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name, query_position,column_label,column_name,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,application_instance,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,generated_flag,omit_flag,user_omit_flag
from n_view_columns_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0')
UNION
(select  nv.view_label,view_name, query_position,column_label,column_name,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,application_instance,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,generated_flag,omit_flag,user_omit_flag
from n_view_columns_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
minus
select  nv.view_label,view_name, query_position,column_label,column_name,table_alias,column_expression,column_position,column_type,description,
profile_option,ref_application_label,ref_lookup_column_name,ref_lookup_type,
id_flex_application_id,id_flex_code,group_by_flag,application_instance,format_mask,format_class,gen_search_by_col_flag,lov_view_label,
lov_column_label,generated_flag,omit_flag,user_omit_flag
from n_view_columns nv, upd_views
where nv.view_label = upd_views.view_label
and nv.application_instance='G0'
)
)
--- Identifying the role view level changes ---
UNION
select distinct view_label from
((select  nv.view_label, role_label,role_name,view_name
from n_role_views nv, upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, role_label,role_name,view_name
from n_role_views_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, role_label,role_name,view_name
from n_role_views_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, role_label,role_name,view_name
from n_role_views nv, upd_views
where nv.view_label = upd_views.view_label
)
)
--- Identifying the join key level changes ---
UNION
select distinct view_label from
((select  nv.view_label, view_name,key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,profile_option, omit_flag, user_omit_flag, generated_flag
from n_join_keys nv, upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, view_name,key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,profile_option, omit_flag, user_omit_flag, generated_flag
from n_join_keys_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_label, view_name,key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,profile_option, omit_flag, user_omit_flag, generated_flag
from n_join_keys_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_label, view_name,key_name, description, join_key_context_code, key_type_code, column_type_code, outerjoin_flag, outerjoin_direction_code,
key_rank,key_cardinality_code,profile_option, omit_flag, user_omit_flag, generated_flag
from n_join_keys nv, upd_views
where nv.view_label = upd_views.view_label
)
)
--- Identifying the join key column level changes ---
UNION
select distinct view_label from
((select nv1.view_label,nv.column_position,nv.column_name,nv.column_label
from n_join_key_columns nv,n_join_keys nv1, upd_views
where nv1.view_label = upd_views.view_label
and nv1.JOIN_KEY_ID = nv.JOIN_KEY_ID
minus
select nv1.view_label,nv.column_position,nv.column_name,nv.column_label
from n_join_keys_col_gtemp nv,n_join_keys_gtemp nv1, upd_views
where nv1.view_label = upd_views.view_label
and nv1.JOIN_KEY_ID = nv.JOIN_KEY_ID
)
UNION
(select nv1.view_label,nv.column_position,nv.column_name,nv.column_label
from n_join_keys_col_gtemp nv,n_join_keys_gtemp nv1, upd_views
where nv1.view_label = upd_views.view_label
and nv1.JOIN_KEY_ID = nv.JOIN_KEY_ID
minus
select nv1.view_label,nv.column_position,nv.column_name,nv.column_label
from n_join_key_columns nv,n_join_keys nv1, upd_views
where nv1.view_label = upd_views.view_label
and nv1.JOIN_KEY_ID = nv.JOIN_KEY_ID
)
)
--- Identifying the view property level changes ---
UNION
select distinct view_label from
((select  nv.view_property_id,nv.t_view_property_id, nv.view_label, view_name,query_position,property_type_id,t_source_pk_id,source_pk_id,value1,value2,value3,value4,value5,profile_option, omit_flag, user_omit_flag,nvl(version_id,1)
from n_view_properties nv, upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_property_id,nv.t_view_property_id, nv.view_label, view_name,query_position,property_type_id,t_source_pk_id,source_pk_id,value1,value2,value3,value4,value5,profile_option, omit_flag, user_omit_flag,nvl(version_id,1)
from n_view_properties_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
)
UNION
(select  nv.view_property_id,nv.t_view_property_id, nv.view_label, view_name,query_position,property_type_id,t_source_pk_id,source_pk_id,value1,value2,value3,value4,value5,profile_option, omit_flag, user_omit_flag,nvl(version_id,1)
from n_view_properties_gtemp nv, upd_views
where nv.view_label = upd_views.view_label
minus
select  nv.view_property_id,nv.t_view_property_id, nv.view_label, view_name,query_position,property_type_id,t_source_pk_id,source_pk_id,value1,value2,value3,value4,value5,profile_option, omit_flag, user_omit_flag,nvl(version_id,1)
from n_view_properties nv, upd_views
where nv.view_label = upd_views.view_label
)
)
)
;

---- Identifying the view level changes ---

Insert into n_to_do_views_incr (view_label) 
select distinct view_label from
(
select view_label from
(
select count(cust_rowID),view_label from n_customizations where cust_action in ('UPDATE','DELETE')  group by view_label
MINUS
select count(cust_rowID),view_label from n_customizations_gtemp where cust_action in ('UPDATE','DELETE')  group by view_label
)
UNION
select view_label from
(
select count(cust_rowID),view_label from n_customizations_gtemp where cust_action in ('UPDATE','DELETE')  group by view_label
MINUS
select count(cust_rowID),view_label from n_customizations where cust_action in ('UPDATE','DELETE')  group by view_label
));

commit;
delete from n_to_do_views_incr 
       where rowid not in 
              ( select min(rowid) 
                            from n_to_do_views_incr group by view_label);

--NV-1331
	delete from  n_to_do_views_incr where nvl(view_label, ' ') not in (select distinct view_label 
    from n_user_role_config rc,	n_role_view_templates nrv
    where rc.application_instance like '%G%'
    and rc.role_label = nrv.role_label
    and rc.User_Enabled_Flag='Y' 
	and exists
		 (select 1
		 from n_view_templates  k,
		      n_application_owners c
		 where k.application_label=c.application_label 
		 and c.application_instance like '%G%'
		 and nrv.view_label=k.view_label) 		
   UNION
    select distinct view_label 
    from n_user_role_config rc, n_Role_View_Templates_Gtemp nrv
    where rc.application_instance like '%G%'
    and rc.role_label = nrv.role_label
    and rc.User_Enabled_Flag='Y' 
	and exists
		 (select 1
		  from n_View_Templates_Gtemp  
		  k, n_application_owners c
	      where k.application_label=c.application_label 
		  and c.application_instance like '%G%'
		  and nrv.view_label=k.view_label));

commit;
update n_to_do_views_incr set session_id=userenv('sessionid'), creation_date=sysdate ,last_update_date=sysdate;

commit;
---------------------- NV-1543 ------------------------
declare
  v_folder_id number;
begin
  for i in (select t_folder_id,
                   folder_name,
                   kff_id_flex_code,
                   hierarchy_name,
                   role_label,
                   parent_t_folder_id,
                   instance_type_code
              from n_pl_folders unps
             where exists
             (select 'Exists'
                      from n_pl_folders nps
                     where not exists
                     (select 'Not Exists'
                              from n_pl_folder_templates npt
                             where npt.t_folder_id = nps.parent_t_folder_id)
                       and nps.parent_t_folder_id is not null
                       and unps.t_folder_id = nps.parent_t_folder_id)) loop
    Begin
      --selecting t_folder_id to replace t_parent_folder_id in n_pl_folder_templates
      select t_folder_id
        into v_folder_id
        from n_pl_folder_templates npt
       where nvl(npt.folder_name, 'N')        = nvl(i.folder_name, 'N')
         and nvl(npt.kff_id_flex_code, 'N')   = nvl(i.kff_id_flex_code, 'N')
         and nvl(npt.hierarchy_name, 'N')     = nvl(i.hierarchy_name, 'N')
         and nvl(npt.role_label, 'N')         = nvl(i.role_label, 'N')
         and nvl(npt.parent_t_folder_id, -1)  = nvl(i.parent_t_folder_id, -1)
         and nvl(npt.instance_type_code, 'N') = nvl(i.instance_type_code, 'N');
    
      -- Updating correct t_folder_id
      update n_pl_folder_templates npt
         set t_folder_id = i.t_folder_id
       where nvl(npt.folder_name, 'N')        = nvl(i.folder_name, 'N')
         and nvl(npt.kff_id_flex_code, 'N')   = nvl(i.kff_id_flex_code, 'N')
         and nvl(npt.hierarchy_name, 'N')     = nvl(i.hierarchy_name, 'N')
         and nvl(npt.role_label, 'N')         = nvl(i.role_label, 'N')
         and nvl(npt.parent_t_folder_id, -1)  = nvl(i.parent_t_folder_id, -1)
         and nvl(npt.instance_type_code, 'N') = nvl(i.instance_type_code, 'N');
    
      -- Updating correct parent_t_folder_id
      update n_pl_folder_templates npt
         set npt.parent_t_folder_id = i.t_folder_id
       where npt.parent_t_folder_id = v_folder_id;
    Exception
      WHEN NO_DATA_FOUND THEN
        null;
      when others then
        dbms_output.put_line(sqlerrm);
    END;
  End loop;
End;
/

commit;
---------------------- NV-1543 ------------------------
-- Enabling Constraints
-- removing the truncate on the table n_installation_messages for NEM purpose
--truncate table n_installation_messages;

-- NV-1330
begin
for i in (select constraint_name, table_name from user_constraints where status='DISABLED' order by decode (constraint_type,'P',1,'R',2,3))
 LOOP
 BEGIN
  execute immediate 'alter table '||i.table_name||' enable constraint '||i.constraint_name||'';
 exception
  when others then 
    null;
 end;
end loop;
end;
/

-- NV-1317 changes are in the below plsql block
Declare
  v_column_id number;
Begin 
--Updating t_column_id as we have in n_view_columns 
  for i in (select t_column_id ,column_label,view_label,query_position, profile_option
           from n_view_columns nvc
           where 1=1
           and nvl(nvc.t_column_id,-1) not in 
               (select t_column_id from n_view_column_templates
                where view_label in 
                      (select distinct view_label
                      from n_customizations nc
                      where nc.cust_action='INSERT'
                       and nc.cust_location='N_VIEW_COLUMN_TEMPLATES'))
           --and nvc.application_instance='G0'
           and nvc.t_column_id is not null
           and nvc.view_label in 
               (select distinct view_label
                from n_customizations nc 
                where nc.cust_action='INSERT'
                and nc.cust_location='N_VIEW_COLUMN_TEMPLATES')) loop
    Begin
      select t_column_id into v_column_id 
      from n_view_column_templates vct
      where vct.view_label=i.view_label
      and vct.column_label=i.column_label
      and vct.query_position=i.query_position
      and (((select decode(pot.include_flag, -- to make the condition true for obsoleted profile_options --95711 , NV-2082
                                  'N',
                                  'N',
                                  pot.profile_option)
                      from n_profile_option_templates pot
                     where pot.profile_option = vct.profile_option) =
                 nvl(i.profile_option, 'N')) OR
                 (nvl(vct.profile_option, 'Y') =
                 nvl(i.profile_option, 'Y')))
      and nvl(vct.include_flag,'Y')= 'Y';
      -- execute immediate 'update n_view_column_templates set t_column_id= '||i.t_column_id||
                        -- ' where view_label=' ||''''||i.view_label||''''||
                        -- ' and column_label='||''''||i.column_label||''''||
                        -- ' and query_position='||''''||i.query_position||''''||
                        -- ' and nvl(profile_option,''Y'')='||''''||nvl(i.profile_option,'Y')||''''||
                        -- ' and nvl(include_flag,''Y'')= ''Y'' ';
                        
        update n_view_column_templates vct
             set t_column_id = i.t_column_id
           where vct.view_label = i.view_label
             and vct.column_label = i.column_label
             and vct.query_position = i.query_position
             and (((select decode(pot.include_flag, -- to make the condition true for obsoleted profile_options --95711 , NV-2082
                                  'N',
                                  'N',
                                  pot.profile_option)
                      from n_profile_option_templates pot
                     where pot.profile_option = vct.profile_option) =
                 nvl(i.profile_option, 'N')) OR
                 (nvl(vct.profile_option, 'Y') =
                 nvl(i.profile_option, 'Y')))
             and nvl(include_flag, 'Y') = 'Y';
                                
      update n_view_property_templates pt
      set pt.t_source_pk_id = i.t_column_id
      where pt.t_source_pk_id = v_column_id;
    Exception
      WHEN NO_DATA_FOUND THEN 
           null;
      when others then
        dbms_output.put_line(sqlerrm);
    END;
  End loop;
  For i in (select  nvp.view_property_id, nvp.t_view_property_id, nvp.view_label, nvp.query_position, 
             nvp.property_type_id, nvp.t_source_pk_id, nvp.source_pk_id, nvp.value1, nvp.value2, nvp.value3,
             nvp.value4,nvp.value5,nvp.profile_option
          from n_view_properties nvp
          where 1=1
          and nvp.t_view_property_id not in 
              (select nvt.t_view_property_id 
               from n_view_property_templates nvt
               where view_label in 
                  (select view_label from n_customizations nc
                   where nc.cust_action='INSERT'
                   and nc.cust_location='N_VIEW_PROPERTY_TEMPLATES'))
          and nvp.t_view_property_id is not null
          and nvp.view_label in 
              (select view_label from n_customizations nc
               where nc.cust_action='INSERT' and nc.cust_location='N_VIEW_PROPERTY_TEMPLATES')
          ) loop
    Begin
      execute immediate 'update n_view_property_templates set t_view_property_id= '||i.t_view_property_id||
                        --', t_source_pk_id = '||i.t_source_pk_id ||
                        ' where view_label=' ||''''||i.view_label||''''||
                        ' and property_type_id='||''''||i.property_type_id||''''||
                        ' and query_position='||''''||i.query_position||''''||
                        ' and nvl(value1,''Y'')='||''''||nvl(i.value1,'Y')||''''||
                        ' and nvl(value2,''Y'')='||''''||nvl(i.value2,'Y')||''''||
                        ' and nvl(value3,''Y'')='||''''||nvl(i.value3,'Y')||''''||
                        ' and nvl(value4,''Y'')='||''''||nvl(i.value4,'Y')||''''||
                        ' and nvl(value5,''Y'')='||''''||nvl(i.value5,'Y')||''''||
                        ' and t_source_pk_id = '||i.t_source_pk_id ||
                        ' and t_view_property_id not in (select t_view_property_id from n_view_proptemp_incr_bkp ) and nvl(profile_option,''Y'')='||
						''''||nvl(i.profile_option,'Y')||'''';
    Exception
      when others then
         dbms_output.put_line(sqlerrm);
    End;
  End loop;
End;
/


commit;

set termout off
set timing       off
set serveroutput off

spool off;
