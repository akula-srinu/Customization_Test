-- Script Name : --instincr.sql--
-- Purpose     : Master Script which Process Incremental refresh.
--  
-- Version     : 1.0

-- Copyright Noetix Corporation 2002-2016  All Rights Reserved

-- MODIFICATION HISTORY
-- Person       Date       Comments
-- ---------    ------     ------------------------------------------       
--  Srinivasa   31-Mar-15 Created Install version
--  R Lowe      11-May-15  change reference to '0:0' to be '0'||':'||'0' so that it doesn't think colon is identifying a bind variable
--  Arvind      26-Jun-15  Replace 'ganswers' to 'instincr' while inserting messages into n_installation_message.(Issue: NV-1093)
--  Arvind      07-Jul-15  Added messages before and after running ianswers.sql file. (Issue NV-1103)
--  Arvind      18-Dec-15  Added code to refresh the kff cache table so that new custom views are processed without any issue. (Issue: NV-1327)
--  Arvind      29-Dec-15  Modified code to avoid enabling of constraints for non-templates answer metadata tables before calling ianswers. 
--                        (Issue: NV-1309)
--  Arvind      07-Jan-16  Moved the code to insert records into n_ir_view_gen_history table from before popviewincr.sql to after popviewincr.sql. (Issue NV-1327)
--  Arvind      25-Apr-16  Move the different code blocks to 7 new scripts. (Issue: NV-1425)
--  Arvind      28-Apr-16  Modify query to get the APPS user id from n_view_parameters table. (Issue: NV-1462)
--

@tconnect

column c_proceed_to_n_instincr new_value proceed_to_n_instincr noprint
column c_Install_version new_value Install_version noprint

SELECT SUBSTR( install_script_version, 1, INSTR ( install_script_version, '.', 1, 3 ) -1 ) c_Install_version
  FROM n_view_parameters nvp
 WHERE nvp.install_stage BETWEEN 2 AND 5
   AND nvp.creation_date = (SELECT MAX(nvp2.creation_date)
                           FROM n_view_parameters nvp2
                          WHERE nvp2.install_stage BETWEEN 2 AND 5);

select n_compare_version('&Install_version', '6.5.2',3) c_proceed_to_n_instincr 
  from dual;
  
DEFINE pw_ ='&1'

-- Call instincr_legacy script to run IR for NoetixViews 6.5.0 and NoetixViews 6.5.1
start utlif 'instincr_legacy &pw_' "&proceed_to_n_instincr = -1"

-- Following code is to run IR NoetixViews 6.5.2
-- NV-1425

define level2=off
define LEVEL3=off
define ECHO_LEVEL3=on

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

select n_view_parameters_api_pkg.VALIDATE_IR_READINESS Check_Stage_4 from dual;
start utlif 'utlprmpt  ''''&Check_Stage_4''''' "'&Check_Stage_4' != '0'||':'||'0'"
start utlif "noetix_utility_pkg.add_installation_message(''instincr'',''instincr'',''INFO'',''&Check_Stage_4'',sysdate,NULL);" "'&Check_Stage_4' != '0'||':'||'0'"
--exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','&Check_Stage_4',sysdate,NULL);
start utlif 'userexit' "'&Check_Stage_4' != '0'||':'||'0'"
undefine Check_Stage_4
-- <<end of code to check if stage4 is run or not>>


define NVA_IR_FLAG='IR'
start detectos


-- Removing count var 
-- COLUMN n_count  new_value n_count noprint
-- SELECT COUNT(*) n_count  FROM n_view_parameters;

-- NV-1425
-- n_view_parameters entry
@ir_n_view_param_upd.sql

clear scr

exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','Customization Change Detection Running...',sysdate,NULL);
@utlprmpt "Customization Change Detection Running..."

-- CDC for IR
@check_refresh

@utlprmpt "Customization Change Detection Completed "
exec noetix_utility_pkg.add_installation_message('instincr','instincr','INFO','Detecting the list of customizations that are to be completed',sysdate,NULL);
@utlprmpt " "
-- NV-1425
--Displaying the views to process 
@ir_todo_views_list.sql


start utlif 'uexit'  "not exists ( select 'View Exists' from n_to_do_views_incr where rownum = 1 )"
  
start utlif 'userexit' - 
  "not exists ( select 'View Exists' from n_to_do_views_incr where rownum = 1 )"
----
--Code to record the views got customized in each IR 
----

-- NV-1425
----- Delete the custom insert statments from non templates -----
@ir_del_non_temp_cust.sql


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

--start of NV-1425
-- KFF cache table is not refreshing with custom view.
@ir_strgrp_cust_view.sql


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
-- NV- 1425
--Calling The Block for creating joins Hierarichal and Dimension views.
@ir_create_pch_joins.sql



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
-- NV-1425
-- updating n_IR_view_gen_history table 
@ir_views_gen_hist.sql


@genview
@genviewgincr

-- NV-1425
-- Updating n_IR_view_gen_history, n_installation_message, n_view_parameters tables.
@ir_status_upd.sql


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
