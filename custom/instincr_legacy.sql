-- Script Name : --instincr_legacy.sql--
-- Purpose     : Script which Process Incremental refresh for 6.5.0 and 6.5.1 releases on noetix views.
--               This script will be called from Instincr.sql 
-- Version     : 1.0

-- Copyright Noetix Corporation 2002-2016  All Rights Reserved

-- MODIFICATION HISTORY

-- Person       Date       Comments
-- ---------    ------     ------------------------------------------       
--  Arvind      25-Apr-16  Created.(Issue: NV-1425)
--  Arvind      28-Apr-16  Modify query to get the APPS user id from n_view_parameters table. (Issue: NV-1462)
--

define level2=off
define LEVEL3=off
define ECHO_LEVEL3=on
DEFINE pw_ ='&1'

column APPS_USERID new_value APPS_USERID noprint 

select apps_user APPS_USERID
  from n_view_parameters
 where creation_date = (select max(creation_date)
                          from n_view_parameters
                         where install_stage = 4
                           and install_Status = 'Completed'
                           and error_status = 'None')
   and install_stage=4;
   
whenever sqlerror exit 999

-- <<code to check if stage4 is run or not>>
column Check_Stage_4 new_value Check_Stage_4 noprint

 select n_view_parameters_api_pkg.VALIDATE_IR_READINESS Check_Stage_4 
   from dual;
   
start utlif 'utlprmpt  ''''&Check_Stage_4''''' "'&Check_Stage_4' != '0'||':'||'0'"
start utlif "noetix_utility_pkg.add_installation_message(''instincr'',''instincr'',''INFO'',''&Check_Stage_4'',sysdate,NULL);" "'&Check_Stage_4' != '0'||':'||'0'"
--exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','&Check_Stage_4',sysdate,NULL);
start utlif 'userexit' "'&Check_Stage_4' != '0'||':'||'0'"
undefine Check_Stage_4
-- <<end of code to check if stage4 is run or not>>

@tconnect
define NVA_IR_FLAG='IR'
start detectos
define automation_method= NONE


set serveroutput on
COLUMN n_count  new_value n_count print
SELECT COUNT(*) n_count  FROM n_view_parameters;

--column v_temp new_value v_temp_flag print
set serveroutput on  
set serveroutput on  
declare
  v_result varchar2(300);
  db_charset varchar2(20);
  db_Language varchar2(20);
  DB_Territory varchar2(20);
  DB_DATE_LANGUAGE varchar2(20);
  DB_DATE_FORMAT varchar2(20);
  NSM_CM_EXEC_NAME varchar2(200);
  NSM_USER_NAME varchar2(20);
  acl_sm_processing_code varchar2(1);
  save_config_files varchar2(1);
  ui varchar2(20);
begin
  --Insert record into n_view_parameters table for IR
  select  n_view_parameters_api_pkg.VALIDATE_IR_READINESS into v_result from dual;
  if(v_result='0'||':'||'0') then
     select db_charset,
            db_Language,
            DB_Territory,
            DB_DATE_LANGUAGE,
            DB_DATE_FORMAT,
            NSM_CM_EXEC_NAME,
            NSM_USER_NAME,
            acl_sm_processing_code,
            save_config_files,
            user_Interface
     into   db_charset,
            db_Language,
            DB_Territory,
            DB_DATE_LANGUAGE,
            DB_DATE_FORMAT,
            NSM_CM_EXEC_NAME,
            NSM_USER_NAME,
            acl_sm_processing_code,
            save_config_files,
            ui
     from n_view_parameters
     where creation_date>=(select max(creation_date) 
                            from n_view_parameters
                            where install_stage=4
                            and install_Status='Completed'
                            and error_status='None')
     and install_stage=4;
     dbms_output.put_line(v_result);
     insert into N_VIEW_PARAMETERS(
            noetix_sys_user,
            noetix_sys_db,
            noetix_sys_password,
            noetix_sys_tablespace,
            noetix_sys_temp,
            noetix_sys_lang,
            aol_user,
            apps_user,
            select_any_table,
            select_any_dictionary,
            generate_ms_help,
            generate_comments,
            generate_aol_help,
            generate_html_help,
            build_answers,
            generate_answers,
            cross_org_flag,
            create_all_inv_orgs_flag,
            create_standard_views_flag,
            create_cross_op_views_flag,
            create_global_views_flag,
            create_projects_mc_cols_flag,
            user_specified_role_prefix,
            create_developer_columns,
            create_update_scripts,
            install_admin_version,
            install_script_version,
            install_datfiles_version,
            oracle_apps_version,
            oracle_server_release,
            active_lang_count,
            active_sec_grp_count,
            install_type,
            answer_flag,
            continue_flag,
            install_stage,
            user_Interface,
            host_os,
            creation_date,
            last_update_date,
            stage_end_date,
            install_status,
            error_status,
            dat_modules,
            dat_version,
            n_scripts_version,
            gen_run_id,
            message,
            restart_label,
            current_checkpoint_label,
            noetix_sys_user_property,
            automation_method,
            installation_directory,
            pause_for_prefix_editing_flag,
            pause_for_object_editing_flag,
            session_id,
            unique_session_id,
            prefix_file_valid,
            qu_file_valid,
            save_config_files,
            ACL_SM_PROCESSING_CODE,
            db_charset,
            db_Language,
            DB_Territory,
            DB_DATE_LANGUAGE        ,
            DB_DATE_FORMAT,
            NSM_CM_EXEC_NAME,
            NSM_USER_NAME)
     select username,                   -- noetix_sys_user
            decode( UPPER('&CONNECT_STRING'),
                              'NULLARG','',
                              '@NULLARG','',
                              ltrim( UPPER('&CONNECT_STRING'), '@' ) ),
                                                      -- noetix_sys_db
            null,                           -- noetix_sys_password
            '&DFLT_TABLESPACE',             -- noetix_sys_tablespace
            temporary_tablespace,           -- noetix_sys_temp
            '&NOETIX_LANG',                 -- noetix_sys_lang
            '&APPLSYS_USERID',              -- aol_user
            '&APPS_USERID',                 -- APPS_user
            n_has_select_any_table,         -- select_any_table,
            n_has_select_any_dictionary,    -- select_any_dictionary,
            '&GEN_MSH',                     -- generate_ms_help
            '&GEN_COM',                     -- generate_comments
            'N',                            -- generate_aol_help
            '&GEN_HTML',                    -- generate_html_help
            'N',                            -- build_answers,
            '&AP_GENERATOR_FLAG',           -- generate_answers,
            '',                             -- cross_org_flag
            'N',                            -- create_all_inv_orgs_flag,
            'N',                            -- create_standard_views_flag,
            'N',                            -- create_cross_op_views_flag,
            '&CREATE_GLOBAL_VIEWS_FLAG',    -- create_global_views_flag,
            '&CREATE_PROJECTS_MC_COLS_FLAG',-- create_projects_mc_cols_flag
            'N',                            -- user_specified_role_prefix
            'N',                            -- create_developer_columns
            'N',                            -- create_update_scripts
            '&N_ADMIN_VERSION',             -- install_admin_version
            '&N_SCRIPTS_VERSION',           -- install_script_version
            '&DAT_VERSION',                 -- install_datfiles_version
            '&FULL_VERSION',                -- oracle_apps_version
            n_get_server_version,           -- oracle_server_release
            &ACTIVE_LANG_COUNT,             -- active_lang_count
            &ACTIVE_SEC_GRP_COUNT,          -- active_sec_grp_count
            '&DAT_TYPE',                    -- install_type
            '&DAT_ANSWERS',                 -- answer_flag
            'N',                            -- continue_flag,
            4.2,                              -- install_stage
            ui,                          -- user_interface
            '&HOST_OS',                     -- host_os
            sysdate,                        -- creation_date
            null,                        -- last_update_date
            null,                           -- stage_end_date
            'Started',                      -- install_status
            null,                           -- error_status
            '&DAT_MODULES',                 -- dat_modules
            '&DAT_VERSION',                 -- dat_version
            '&N_SCRIPTS_VERSION',           -- n_scripts_version
            null,                           -- gen_run_id
            'IR',                           -- message
            null,                           -- restart_label
            null,                           -- Current_checkpoint_label,
            NVL('&NOETIX_SYS_PROPERTY',
                'STANDARD'),                -- noetix_sys_user_property
            NVL('&AUTOMATION_METHOD',
                'NONE'),                    -- automation_method
            null,                           -- installation_directory
            NVL('&PREFIX_PAUSE', 'N'),      -- pause_for_prefix_editing
            NVL('&OBJECT_PAUSE', 'N'),      -- pause_for_object_editing
            userenv('SESSIONID'),           -- session_id
            DBMS_SESSION.unique_session_id, -- unique_session_id
            'Y',                            -- Initialize the prefix_file_valid flag
            NULL,                           -- Initialize the qu_file_valid flag
            save_config_files,
            acl_sm_processing_code,
            db_charset,
            db_Language,
            DB_Territory,
            DB_DATE_LANGUAGE,
            DB_DATE_FORMAT,
            NSM_CM_EXEC_NAME,
            NSM_USER_NAME
     from  user_users
     where  username = USER;
  else
     dbms_output.put_line(v_result);
     noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',v_result,sysdate,null);
  end if;
end;
/

COLUMN pw_apps new_value pw_apps noprint 
select '&APPS_USERID'||'/'||'&pw_'||'&CONNECT_STRING' pw_apps from dual where '&pw_' is not null;

COLUMN n_count1  new_value n_count1 print
SELECT COUNT(*) n_count1  FROM n_view_parameters;
set serveroutput on
clear scr
prompt Online Patching Started...
prompt &n_count;
prompt &n_count1;



--In case no entry in N_VIEW_PARAMETERS, exiting directly
start utlif 'utlprmpt  ''''Previous IR Run Has Errors; Kindly Run Stage4''''' "&n_count=&n_count1"
start utlif 'userexit' "&n_count=&n_count1"
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','Customization Change Detection Running...',sysdate,NULL);
@utlprmpt "Customization Change Detection Running..."
@check_refresh

@utlprmpt "Customization Change Detection Completed "
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','Detecting the list of customizations that are to be completed',sysdate,NULL);
@utlprmpt " "

set echo off
set termout on
set feedback off

set serveroutput on
declare
cnt number;
begin
  DBMS_OUTPUT.PUT_LINE('-------------------------------------');
  DBMS_OUTPUT.PUT_LINE(' NoetixViews To Be Processed         ');
  noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',' NoetixViews To Be Processed ',sysdate,NULL);
  DBMS_OUTPUT.PUT_LINE('-------------------------------------');
for i in (select view_name from n_views 
where view_label in(select view_label from n_to_do_views_incr) 
and application_instance='G0')
 LOOP
 cnt:=cnt+1;
 BEGIN
  DBMS_OUTPUT.PUT_LINE(cnt||'-'||i.view_name);
  noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',cnt||'-'||i.view_name,sysdate,NULL);
  end;
end loop;
for i in (select view_label from n_to_do_views_incr 
where view_label not in(select view_label from n_views 
                               where application_instance='G0'))
loop
  cnt:=cnt+1;
    dbms_output.put_line(cnt||'-'||i.view_label);
    noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',cnt||'-'||i.view_label,sysdate,NULL);
    end loop;
    end;
/

set termout off

-- Enable all relevant constraints
begin
    for i in (select constraint_name, table_name from user_constraints where status='DISABLED')
    LOOP
        BEGIN
            execute immediate 'alter table '||i.table_name||' enable constraint '||i.constraint_name||' ';
    exception
        when others then
        null;
        end;
   end loop;
end;
/


   
   
start utlif 'utlprmpt ''''***  No View Found To Process Refresh  *** '''' ' - 
  "not exists ( select 'View Exists' from n_to_do_views_incr where rownum = 1 )"
declare
v_exists varchar2(1):=null;
  begin
    select 'N' into v_exists from dual where not exists ( select 'View Exists' from n_to_do_views_incr where rownum = 1 );
    if (nvl(v_exists,'Y')='N') then
    noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','***  No View Found To Process Refresh  ***',sysdate,null);
    end if;
end;
/

start utlif 'uexit'  "not exists ( select 'View Exists' from n_to_do_views_incr where rownum = 1 )"

  
start utlif 'userexit' - 
  "not exists ( select 'View Exists' from n_to_do_views_incr where rownum = 1 )"
----
--Code to record the views got customized in each IR 
----


----- Delete the custom insert statments from non templates -----

delete from n_view_wheres nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_VIEW_WHERES'
and cust.cust_action in ('INSERT'))
and nv.application_instance='G0';

delete from n_customizations cust WHERE cust.cust_location = 'N_VIEW_WHERES'
and cust.cust_action in ('UPDATE');

delete from n_join_key_columns nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_JOIN_KEY_COLUMNS'
and cust.cust_action in ('INSERT'));

delete from n_customizations cust WHERE cust.cust_location = 'N_JOIN_KEY_COLUMNS'
and cust.cust_action in ('UPDATE');

delete from n_join_keys nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_JOIN_KEYS'
and cust.cust_action in ('INSERT'));

delete from n_customizations cust WHERE cust.cust_location = 'N_JOIN_KEYS'
and cust.cust_action in ('UPDATE');


delete from n_view_columns nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_VIEW_COLUMNS'
and cust.cust_action in ('INSERT'))
and application_instance='G0';

delete from n_customizations cust WHERE cust.cust_location = 'N_VIEW_COLUMNS'
and cust.cust_action in ('UPDATE');


delete from n_view_tables nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_VIEW_TABLES'
and cust.cust_action in ('INSERT'))
and application_instance='G0';

delete from n_customizations cust WHERE cust.cust_location = 'N_VIEW_TABLES'
and cust.cust_action in ('UPDATE');

delete from n_view_queries nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_VIEW_QUERIES'
and cust.cust_action in ('INSERT'))
and application_instance='G0';

delete from n_customizations cust WHERE cust.cust_location = 'N_VIEW_QUERIES'
and cust.cust_action in ('UPDATE');


delete from n_role_views nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_ROLE_VIEWS'
and cust.cust_action in ('INSERT'));

delete from n_customizations cust WHERE cust.cust_location = 'N_ROLE_VIEWS'
and cust.cust_action in ('UPDATE');

delete from n_views nv
where nv.rowid in (select cust.cust_rowid from n_customizations cust
where cust.cust_rowid = nv.rowid
and cust.cust_location = 'N_VIEWS'
and cust.cust_action in ('INSERT'))
and application_instance='G0';

delete from n_customizations cust  WHERE cust.cust_location = 'N_VIEWS'
and cust.cust_action in ('UPDATE');

commit;
@prdvercl.sql
@verflag.sql

@utlprmpt "Candidate View(s) Processing..."
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',' Candidate View(s) Processing... ',sysdate,NULL);
@ycrhint
start w_process_user_flag 'INCLUDE_FLAG' '%' 'N'
@popviewincr
@wtblupd N
@wtblupd Y
@popcat
@omits
@wpsicols
@attrp
@attr
@lookp
@look
@autojoip
@autojoin
@searchbp
@ycr_gseg_pkg
@ycr_gseg_integration_pkg
@w_gseg_upd_mtl_func_areas

--start of NV-1327 KFF cache table is not refreshed with custom view name during IR. The below work around is to fix this issue 
delete from n_f_kff_strgrp_view_xref nft
   where NOT exists (select 'exists'
            from n_views nv
           where nv.view_name = nft.view_name)
and nft.view_name is not null;

INSERT INTO n_f_kff_strgrp_view_xref
  select nf.*
    from n_f_kff_strgrp_helper_view nf, n_to_do_views_incr todo, n_views nv
   where nv.view_label = todo.view_label
     and nv.view_name = nf.view_name
     and NOT exists (select 'exists'
            from n_f_kff_strgrp_view_xref nft
           where nft.view_name = nf.view_name);
commit;  
-- end of NV-1327
@segp
@seg
exec n_gseg_integration_incr_pkg.dc_main_view;
exec n_gseg_integration_incr_pkg.segstruct_view;
exec n_gseg_integration_incr_pkg.flexsource_direct;
exec n_gseg_integration_incr_pkg.anomaly_view;
exec n_gseg_incr_pkg.view_join_key_pop;
@basecol
exec n_searchby_incr_proc1;
@ycr_jointo_pkg
@jointo
@groupbyp
@groupby
@ysecure
-- Omit views containing SEGP, SEGEXPR or SEGSTRUCT columns.
update n_views
set omit_flag = 'Y'
where application_instance = 'G0'
and view_label in
    (select distinct view_label
     from n_view_column_templates
     where column_type in ('SEGP'));
commit;
--
------ Calling y_add_sr_security_incr script 
--utlprmpt "Process security for service modules"

DEFINE TELE_ADV_SEC=N
COLUMN C_TELE_ADV_SEC new_value TELE_ADV_SEC noprint
SELECT 'Y' c_tele_adv_sec
  FROM dual
 WHERE EXISTS 
     ( SELECT 'Adv sec exists for telesec'
         FROM n_application_owner_templates a
        WHERE a.application_label         in ( 'CSF', 'CSD', 'CS' )
          AND a.base_application = 'Y'
          AND a.advanced_security_allowed  = 'Y'
          AND a.advanced_security_enabled  = 'Y');

start utlif y_add_sr_security.sql "'&TELE_ADV_SEC' = 'Y'" ;
--prompt done y_add_sr_security_incr
------------
------------
------ Calling y_add_csi_security_incr script 
--utlprmpt "Process security for CSI modules"

DEFINE CSI_ADV_SEC=N
COLUMN C_CSI_ADV_SEC new_value CSI_ADV_SEC noprint
SELECT 'Y' c_csi_adv_sec
  FROM dual
 WHERE EXISTS 
     ( SELECT 'Adv sec exists for csi'
         FROM n_application_owner_templates a
        WHERE a.application_label         in ( 'CSI' )
          AND base_application =             'Y'
          AND a.advanced_security_allowed  = 'Y'
          AND a.advanced_security_enabled  = 'Y');

start utlif y_add_csi_security.sql "'&CSI_ADV_SEC' = 'Y'" ;
--prompt done y_add_csi_security_incr
------------
-- Sub query factoring options for xmap table.  Valid options are ( 'ALL', 'MULTIQUERY', 'NONE' )
DEFINE ENABLE_XMAP_ACL_VIEW_SQF_OPT = 'NONE'
--
-- Enable SQF for standard/xop/global ( Valid options are Y/N )
DEFINE ENABLE_GLOBAL_SQF_OPT   = 'Y'
DEFINE ENABLE_XOP_SQF_OPT      = 'Y'
DEFINE ENABLE_STANDARD_SQF_OPT = 'Y'
--
-- Enable the option to include the MATERIALIZE HINT.  ( Valid options are Y/N )
DEFINE ENABLE_MATERIALIZE_SQF_OPT = 'N'
--
-- Enable the option to include an additional where clause.  Seems to help performance with XMAP views.  Adds an extra statement
-- 'WHERE org_id >= -9999' which helps performance.  ALternate is to update the metadata.
DEFINE ENABLE_XMAP_FILTER_SQF_OPT = 'Y'

@wnoetxu4
@w_config_sqf_in_views
@wnoetx_config_sqf_in_views
--Calling The Block
Declare
Cursor C1 is   
SELECT distinct ahier.dimension_view_name  dm_view FROM n_md_hierarchies ahier;
Cursor C2 is   
SELECT distinct ahier.HIERARCHY_VIEW_NAME hi_view FROM n_md_hierarchies ahier;
Begin
For i in c1 loop
Create_IR_Dim_Join_Keys( 'XXHIE_Acct_Dim' ,null, i.dm_view);
End loop;
For j in c2 loop
Create_IR_Hier_Join_Keys( 'XXHIE_Acct' ,null, j.hi_view);
End loop;
DBMS_OUTPUT.PUT_LINE('Execeution Completed');
End;
/


@n_customizations
start wnoetxu5
start wdrop trigger   &NOETIX_USER n_view_incr_trg
start wdrop trigger   &NOETIX_USER n_view_query_incr_trg
start wdrop trigger   &NOETIX_USER n_view_tab_incr_trg
start wdrop trigger   &NOETIX_USER n_view_col_incr_trg
start wdrop trigger   &NOETIX_USER N_VIEW_WHERE_incr_trg
start wdrop trigger   &NOETIX_USER n_join_key_incr_trg
start wdrop trigger   &NOETIX_USER n_role_view_incr_trg
start wdrop trigger   &NOETIX_USER n_view_prop_incr_trg
start wdrop trigger   &NOETIX_USER n_view_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_query_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_tab_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_col_incr_trg1
start wdrop trigger   &NOETIX_USER N_VIEW_WHERE_incr_trg1
start wdrop trigger   &NOETIX_USER n_join_key_incr_trg1
start wdrop trigger   &NOETIX_USER n_role_view_incr_trg1
start wdrop trigger   &NOETIX_USER n_view_prop_incr_trg1
start genviewp column_name

commit;

--Issue: 1327 changes
BEGIN
    for i in (select view_label from n_to_do_views_incr)
    loop 
        begin
            for j in (select distinct view_name from n_views where view_label =i.view_label and application_instance='G0'
                     UNION
                     select distinct view_name from n_views_gtemp where view_label =i.view_label and application_instance='G0')
            loop
                begin
                  insert into n_IR_view_gen_history values(i.view_label,j.view_name,nvl2(j.view_name,'CREATE','DELETE'),user,sysdate,null,null);
                exception
                  when others then 
                       dbms_output.put_line(sqlerrm);
                end;
            end loop;
            exception
                when others then 
                     dbms_output.put_line(sqlerrm);
        end;
    end loop;
END;
/

Commit;

begin
    for i in (select view_label from n_to_do_views_incr )
    loop
    begin
        update n_IR_view_gen_history
        set view_name = (select view_name from n_views where view_label=i.view_label and application_instance='G0' union select view_name from n_views_gtemp where view_label=i.view_label and application_instance='G0'),
        cust_action=nvl2((select view_name from n_views_gtemp where view_label=i.view_label and application_instance='G0'),'DELETE','CREATE')
        where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR')
         and view_label=i.view_label;
        update n_IR_view_gen_history
        set view_name = (select view_name from n_views where view_label=i.view_label and application_instance='G0' union select view_name from n_views_gtemp where view_label=i.view_label and application_instance='G0'),
        cust_action=nvl2((select view_name from n_views where view_label=i.view_label and application_instance='G0'),'CREATE','DELETE')
        where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR')
        and view_label=i.view_label;
        update n_IR_view_gen_history
        set cust_action=case  (select omit_flag from n_views where view_label=i.view_label and application_instance='G0') when 'Y' then 'DELETE' else cust_action end
        where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR')
        and view_label=i.view_label;
exception 
  when others
    then
      dbms_output.put_line(sqlerrm);
      update n_IR_view_gen_history j
        set view_name = (select view_name from n_views where view_label=i.view_label and application_instance='G0' and view_name=j.view_name union select view_name from n_views_gtemp where view_label=i.view_label and application_instance='G0' and view_name=j.view_name),
        cust_action=nvl2((select view_name from n_views_gtemp where view_label=i.view_label and application_instance='G0' and view_name=j.view_name),'DELETE','CREATE')
        where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR')
         and view_label=i.view_label;
        update n_IR_view_gen_history j
        set view_name = (select view_name from n_views where view_label=i.view_label and application_instance='G0' and view_name=j.view_name union select view_name from n_views_gtemp where view_label=i.view_label and application_instance='G0' and view_name=j.view_name),
        cust_action=nvl2((select view_name from n_views where view_label=i.view_label and application_instance='G0' and view_name=j.view_name),'CREATE','DELETE')
        where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR')
        and view_label=i.view_label;
        update n_IR_view_gen_history j
        set cust_action=case  (select omit_flag from n_views where view_label=i.view_label and application_instance='G0' and view_name=j.view_name) when 'Y' then 'DELETE' else cust_action end
        where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR')
        and view_label=i.view_label;
      end;
end loop;
end;
/


delete from n_to_do_views
where view_name in (select view_name from n_IR_view_gen_history
                    where cust_action='DELETE'
                    and creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR'));

commit;
@genview
@genviewgincr


begin
    for i in (select view_label from n_to_do_views_incr )
    loop
    begin
        update n_IR_view_gen_history
        set cust_action=case  (select omit_flag from n_views where view_label=i.view_label  and application_instance='G0') when 'Y' then 'DELETE' else cust_action end
        where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR')
       and view_label=i.view_label;
exception 
  when others
    then
      dbms_output.put_line(sqlerrm);
      end;
end loop;
end;
/

declare
counter number;
begin
counter:=0;
  DBMS_OUTPUT.PUT_LINE('-------------------------------------');
  DBMS_OUTPUT.PUT_LINE(' NoetixViews To Be Processed         ');
noetix_utility_pkg.add_installation_message('instincr','genviewgincr','INFO',' Views that are processed successfully... ',sysdate,NULL);
  DBMS_OUTPUT.PUT_LINE('-------------------------------------');
for i in (select view_name from n_views where view_label in(select view_label from n_to_do_views_incr) and application_instance='G0')
 LOOP
 counter:=counter+1;
 BEGIN
  DBMS_OUTPUT.PUT_LINE(counter||'-'||i.view_name);
noetix_utility_pkg.add_installation_message('instincr','genviewgincr','INFO',counter||'-'||i.view_name,sysdate,NULL);
 end;
end loop;
end;
/

----
--Updating n_view_parameters on the basis of n_installation_messages
--Set Install_Status and error_status
----
-- Modify code to suppress non-templates answers metadata tables. issue: NV-1309
begin
   for i in (select constraint_name, table_name from user_constraints 
             where (SUBSTR(table_name, 1,5) != 'N_ANS'
                    OR (SUBSTR(table_name, 1,5)= 'N_ANS' AND SUBSTR(table_name, -9,9) = 'TEMPLATES'))
             AND status = 'DISABLED')
    LOOP
    BEGIN
     execute immediate 'alter table '||i.table_name||' enable constraint '||i.constraint_name||' ';
    exception
     when others then
       noetix_utility_pkg.Add_Installation_Message(
                   p_script_name               => 'instincr',
                   p_location                  => 'Enable Constraints',
                   p_message_type              => 'ERROR',
                   p_message                   => SQLERRM );
    end;
   end loop;
   end;
/

update n_IR_view_gen_history
set last_updated_by=user,
last_update_date=sysdate
where creation_date >=(select max(creation_date) 
                       from n_view_parameters
                       where install_stage=4.2
                       and message ='IR'); 
   
column error_stat new_value error_stat noprint
select 'None' error_stat
from dual;

select Message_type error_stat from n_installation_messages
where message_type ='ERROR'
and script_name in('Check Refresh','uexit','instincr')
and creation_date>=(select max(creation_date) from n_view_parameters
                                   where install_stage=4.2
                                   and message='IR')
group by Message_type
having count(*) > 0;
   
update n_view_parameters
set error_status        =(case '&error_stat' when 'None' then 'None'
                                   when 'ERROR' then 'Errors' end),
install_Status          =(case '&error_stat' when 'None' then 'Completed'
                                   when 'ERROR' then 'Aborted' end),
Current_Checkpoint_label='INSTALL_COMPLETE',
last_update_date       =sysdate,  
stage_end_date         =sysdate
where install_stage    =4.2
and   message          ='IR'
and   creation_date    =(select max(creation_date)
                       from n_view_parameters
                       where install_stage=4.2
                       );


commit;
@utlprmpt " Patch Process Summary      " 
@utlprmpt "===================================           "    
@utlprmpt "  Refresh Completed Sucessfully...  " 
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',' Refresh Completed Sucessfully... ',sysdate,NULL);
@utlprmpt "  Please Check mkviewgincr.lst file for Generated Views...        " 
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','  Please Check mkviewgincr.lst file for Generated Views... ',sysdate,NULL);
--promt 'begigning of the gans'
--@tconnect
--@ganswers_check
--promt 'end of the gans'
@utlprmpt "              " 
@utlprmpt "              " 

set termout off
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',' Running Answer Builder ',sysdate,NULL);
@ianswers.sql
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO',' Answer Builder process completed successfully.',sysdate,NULL);
exit

