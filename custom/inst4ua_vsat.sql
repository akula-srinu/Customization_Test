set echo off
-- Title
--   inst4ua.sql
-- Function
--   Launches an unattended installation.
--
-- Description
--
--   Script called to launch an unattended installation.
--   Saves installation option parameters to the
--   n_view_parameters_instopt table and calls inst4imp.sql
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   08-Aug-02 H Schmed  Created (Issue 7992)
--   09-Sep-02 D Glancy  Updated the parameter orders to match
--                       what we do in install4.sql. (Issue 7992)
--   11-Sep-02 H Schmed  Added a call to inst3ua.sql. Set verify off. 
--                      (Issue 7992)
--   12-Sep-02 H Schmed  Added a display prompt at the beginning of the 
--                       script. (Issue 7992)
--   16-Sep-02 D Glancy  Update error number to make unique. (Issue 7992)
--   16-Sep-02 H Schmed  Updating the parameter display prompts for
--                       consistency. Set termout on/off around the prompt
--                       marking the beginning of stage 4. (Issue 7992)
--   18-Jul-03 D Glancy  1.  Added validation for parameters and the current environment.
--                       2.  Added two new parameters.
--                       3.  Added calls to inst2ua, inst5ua, and inst7ua.
--                       4.  Added multiple undefines to clean up the environment.
--                       5.  More generic now to support CM, CRON, and FILE.
--                       (Issue 4826,8310,8324,9454,10386)
--   22-Jul-03 D Glancy  Had to change the call to autorun\cpw.sql.  Now requires that
--                       you pass the tns connection information.  This information is
--                       blank for CM installs and contains the actuall tns connect string
--                       for other installation types.
--                       (Issue 10189)
--   23-Jul-03 D Glancy  Added extra validation.  Basically if the noetix_sys_db passed
--                       into this program was never used before, we assume that 
--                       someone is trying to install from the wrong database.
--                       (Issue 10827)
--   28-Oct-03 D Glancy  Changed the prompt for the save_config parameter when reviewing what the
--                       user entered.
--                       (Issue #11580)
--   31-Oct-03 D Glancy  When setting the save_config_files variable, were not checking the setting
--                       from the cm_save_config_files passed in from the calling program.  This caused
--                       the user preference to be ignored.  This only matters when it is called
--                       from inst4prm because CRON and CM are always set to Y.
--                       (Issue #11640)
--   23-Feb-04 D Glancy  Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy  Update Copyright Info. (Issue 13498)
--   14-Mar-05 D Glancy  1.  Add support for Projects Multi-Currency defaulting from the parameter file.
--                       2.  Add create_projects_mc_cols_flag column to n_view_parameters_instopt.
--                       (Issue 14065)
--   22-Sep-05 D Glancy  Update copyright info. (Issue 15175)
--   24-Apr-06 D Glancy  Rename AnswerPoint Generator to Noetix Platform Generator.
--                       Rename AnswerPoint Builder to Answer Builder. (Issue 16123)
--   25-May-06 D Glancy  Change Meta-data to Metadata.
--   02-Nov-06 D Glancy  Removed references to AOL Help as it is only required for forms.
--                       Forms is no longer supported.
--                       Parameter 7 for utlenv call stored the aol help install information.  
--                       Keeping parameter position and setting to N so maintain compatibility
--                       with gui.
--                       (Issue 16281)
--   05-Jan-07 D Glancy  Correct installer such that the tupdprfx prompt screen is displayed
--                       for DW.
--                       (Issue 17000)
--   20-Mar-07 D Glancy  Hide an error message that was showing up.
--   17-Nov-07 D Glancy  Renamed n_query_users to n_security_mgr_users.
--                       (Issue 18563 and 15240)
--   05-Apr-10 D Glancy  Add the new suppression options that are part of install4/gui stage 4
--                       initial wizard.
--                       (Issue 23684)
--   12-May-10 D Glancy  Fixed issues with the the prompts and variable used for unattended installs.
--                       (Issue 23684)
--   05-Mar-11 D Glancy  Exclude DW and BI.  No longer supported.
--                       (Issue 26404).
--   03-Oct-11 D Glancy  Fixed problems with running via file method.
--                       (Issue 25193)
--   10-Apr-13 D Glancy  QU_FILE_VALID is now obsolete.
--                       (Issue 31869).
--   16-Aug-15 N Mohan    In s_save_config_files column query missing right parenthesis and wrong usage of table alias out side the inner sub-query 
--                        (Issue NV-1189)
--   08_Oct_15 G Venkat   Added a variable to verify n_checkpoint_activation_temp exists before Determine if we need to run from a checkpoint.
--                        (Issue NV-1189)
--
--
set termout off
set verify  off
set echo    off

-- Receive the concurrent parameter values
define cm_noetix_sys_property="&1"
define cm_automation_method="&2"
define cm_install_directory="&3"
define cm_noetix_sys_user="&4"
define cm_noetix_sys_pw="&5"
define cm_noetix_sys_db="&6"
define cm_default_tablespace="&7"
define cm_apps_user="&8"
define cm_noetix_sys_lang="&9"
define cm_install_global="&10"
define cm_install_xop="&11"
define cm_install_standard="&12"
define cm_individual_inv="&13"
define cm_prj_mc_cols="&14"
define cm_prefix_pause="&15"
define cm_object_pause="&16"
define cm_gen_com_hlp="&17"
define cm_gen_ms_hlp="&18"
define cm_gen_html_hlp="&19"
define cm_gen_ap_builder_flag="&20"
define cm_continue_flag="&21"
define cm_save_config_files="&22"
define cm_installation_option="&23"

define sys_pause           = utlnop
define sys_error           = utlnop
column s_text1  format a80
column s_text2  format a80
column s_text3  format a80
column s_sys_pause        new_value sys_pause            noprint
column s_sys_error        new_value sys_error            noprint

--
-- Default the additional parameter that is unavailable
define cm_generator_flag='N'
@noetixd
@datfiles.ini

-- Must have this defined before running the password check
define v_invalid_pwd_counter=0

-- Can't use the connect string for CM installations.

column s_tmp_connect_string  new_value tmp_connect_string   noprint
select ( CASE '&CM_AUTOMATION_METHOD'
           WHEN 'CM' THEN  TO_CHAR(NULL)
           ELSE '@&CM_NOETIX_SYS_DB'
         END  )          s_tmp_connect_string
from dual
;

start utlif "wvdallpw.sql ''&CM_NOETIX_SYS_USER'' ''&CM_NOETIX_SYS_PW'' ''&TMP_CONNECT_STRING'' ''&CM_APPS_USER'' ''&CM_NOETIX_SYS_PROPERTY''" -
"'&CM_NOETIX_SYS_PROPERTY' != 'EBSO' and '&CM_AUTOMATION_METHOD' in ('CRON','CM') and '&CM_INSTALLATION_OPTION' = 'A' "

set termout  off
set echo     off
set heading  off
set headsep  off
set recsep   off
set pagesize 0
set verify   off
set feedback off
set termout  on

select /*+ RULE */
       'ERROR:  Invalid passwords detected. Please fix the problem'||
                ( CASE &V_INVALID_PWD_COUNTER
                    WHEN 1 THEN TO_CHAR( NULL )
                    ELSE 's'
                  END )                                                       s_text1,
       '        by running igetpw.sql or editing autorun/cpw.sql. '           s_text2,
       '        Once corrections have been made, restart the installation.'   s_text3,
       'utlpause EXIT'                                                        s_sys_pause,
       'utlexit 162'                                                          s_sys_error
  from dual
 where '&CM_NOETIX_SYS_PROPERTY' != 'EBSO' 
   and '&CM_AUTOMATION_METHOD'   in ('CRON','CM','FILE')
   and '&CM_INSTALLATION_OPTION'  = 'A'
   and &V_INVALID_PWD_COUNTER    != 0
;

@&SYS_PAUSE
@&SYS_ERROR

select /*+ RULE */
       'ERROR:  ''NONE'' is not valid automation method.'                       s_text1,
       '        Correct your cparam.sql file using the igetprm.sql script.'     s_text2,
       '        Once corrections have been made, restart the installation.'     s_text3,
       'utlpause EXIT'                                                          s_sys_pause,
       'utlexit 162'                                                            s_sys_error
  from dual
 where '&CM_AUTOMATION_METHOD' = 'NONE'
;

@&SYS_PAUSE
@&SYS_ERROR

select /*+ RULE */
       'ERROR:  You are attempting an automated install using an unexpected database'  s_text1,
       '        connect string (&CM_NOETIX_SYS_DB).'                                   s_text1,
       '        This could be an indication of an invalid Concurrent Manager'          s_text1,
       '        setup or an invalid cparam.sql file.'                                  s_text1,
       '                                                                      '        s_text2,
       '        Correct your cparam.sql file using the igetprm.sql script. '           s_text2,
       '        If this was a Concurrent Manager initiated job, then you should '      s_text2,
       '        run iconcmgr.sql for this environment.'                                s_text2,
       '                                                                      '        s_text3,
       '        Once corrections have been made, restart the installation.'            s_text3,
       'utlpause EXIT'                                                                 s_sys_pause,
       'utlexit 162'                                                                   s_sys_error
  from dual
 where not exists 
     ( select 'Match Found'                             
         from n_view_parameters                                
        where upper(noetix_sys_db) = '&CM_NOETIX_SYS_DB'
          and rownum = 1
        union
       select 'Match Found'                             
         from n_view_parameters                                
        where noetix_sys_db is null
          and not exists
            ( select 'database record exists'
                from n_view_parameters
               where noetix_sys_db is not null
                 and rownum = 1 )
          and rownum = 1
        union
       select 'Match Found'                             
         from dual                                
        where 0 = 
            ( select count(*)
                from n_view_parameters ) )
;

@&SYS_PAUSE
@&SYS_ERROR


set termout off
--
start utlif 'inst2ua ' -
"'&CM_NOETIX_SYS_PROPERTY' != 'EBSO' and '&CM_INSTALLATION_OPTION' = 'A'"

start utlif 'inst3ua ' -
"'&CM_INSTALLATION_OPTION' = 'A'"
--
whenever oserror exit 162

set termout off
set echo    off

column s_text1  format   a80
set linesize 80

-- Get the oracle APPLSYS user name
define cm_aol_user = 'APPLSYS'
column s_cm_aol_user  new_value cm_aol_user     noprint
select max(oracle_username) s_cm_aol_user
  from fnd_oracle_userid
 where read_only_flag = 'E'
;

set termout off
--
set null     ""
set head     off
set headsep  off
set feedback off
set echo     off
set termout  off
--
-- Define all of the installation info variables
--
start nscripts.ini
start datfiles.ini
start detectos.sql

define UI='SQLPLUS'
define N_ADMIN_VERSION='NOT_SET'
define TnsName=''
--
-- Set the noetix defaults for level1-3
@noetixd
--
-- Undefine all of the numbered variables.
-- Just in case we are rerunning the scripts.
--
undefine 1
undefine 2
undefine 3
undefine 4
undefine 5
undefine 6
undefine 7 
undefine 8
undefine 9
undefine 10
undefine 11
undefine 12
undefine 13
undefine 14
undefine 15
undefine 16
undefine 17
undefine 18
undefine 19
undefine 20
undefine 21
undefine 22
undefine 23

set termout  off
set echo     off
set verify   off
set heading  off
set headsep  off
set feedback off
set termout  on 

select
'
Executing Stage 4 of the &DAT_APPLICATION Installation'               s_text1
  from dual
 where '&CM_INSTALLATION_OPTION'   = 'A'
;

--
-- Get the product version information.
--
column  c_full_version    new_value FULL_VERSION     noprint
column  c_product_version new_value PRODUCT_VERSION  noprint
column  c_fnd_version     new_value FND_VERSION      noprint
select  MAX(release_name)             c_full_version,
        to_number(substr(MAX(release_name),
                         1,instr(MAX(release_name),'.',1)+1)) c_product_version,
        SUBSTR(MAX(release_name),
               1,INSTR(MAX(release_name),'.')-1) c_fnd_version
from    fnd_product_groups_s
where   product_group_id = 1
;
--
-- Determine if we need to run from a checkpoint.
--

whenever sqlerror continue
set termout off

--
--
-- Determine if we need to run from a checkpoint.
--


define chkpt_selected = "NOT_SET"
define chkpt_desc     = "Not SET"
define check_table     = "N"

column c_chkpt_selected  new_value chkpt_selected noprint
column c_chkpt_desc      new_value chkpt_desc     noprint
column v_check_table  new_value check_table   noprint

select 'Y'  v_check_table
  from user_tables 
 where table_name ='N_CHECKPOINT_ACTIVATION_TEMP';

SET PAGESIZE 0;
SET VERIFY OFF
set TRIMOUT on
set trimspool on
set head on
SPOOL chk_chkpt.sql;
select '
SELECT cat.checkpoint_label     c_chkpt_selected,
       vl.meaning               c_chkpt_desc
  FROM n_view_lookups               vl,
       n_checkpoint_activation_temp cat
WHERE vl.lookup_type = ''INSTALL4_CHECKPOINT''
   AND vl.lookup_code = cat.checkpoint_label
   AND rownum = 1;'
  from dual;
   spool off;

start utlif "chk_chkpt" -
    "'&check_table'    = 'Y' "  
    
set termout off

-- Determine whether we should save the settings
define save_config_files = 'N'
COLUMN s_save_config_files      new_value save_config_files  noprint
SELECT 'Y'                      s_save_config_files
  FROM dual 
 WHERE '&CM_SAVE_CONFIG_FILES' = 'Y'
   AND EXISTS 
     ( SELECT 'role_prefix is populated' 
         FROM n_application_owners ao
        WHERE ao.role_prefix is not null 
          AND rownum = 1 ) 
   AND 
     (     EXISTS 
         ( SELECT 'Y' 
             FROM n_view_parameters p
            WHERE p.install_stage = 4 
              AND p.creation_date = 
                ( SELECT max(p1.creation_date) 
                    FROM n_view_parameters p1
                   WHERE p1.install_stage = 4 ) 
              AND (    upper(nvl(p.install_status,'COMPLETED'))    = 'COMPLETED' 
                    OR upper(nvl(p.current_checkpoint_label,'Z')) in ( 'INSTALL_COMPLETE', 
                                                                        'POST_VIEW_CREATE' ) 
                    OR upper(nvl(p.prefix_file_valid,'Z'))         = 'Y'  ) ) 
         OR NOT EXISTS 
          ( SELECT 'rows exist' 
              FROM n_view_parameters p2
             WHERE rownum = 1 ) 
      )
;

-- Now build the second set of prompts used later on to display the actual 
-- user choices
set termout  off
set verify   off
spool off
spool inst4ua
set pagesize 500
set headsep  off
set head     off
set recsep   off
set escape   off
set escape   \
set verify   on
------------------------------------------
set termout off
--
column s_noetix_sys_property new_value noetix_sys_property noprint
column s_automation_method   new_value automation_method   noprint
column s_install_directory   new_value install_directory   noprint
column s_noetix_sys_user     new_value noetix_sys_user     noprint
column s_noetix_sys_pw       new_value noetix_sys_pw       noprint
column s_noetix_sys_db       new_value noetix_sys_db       noprint
column s_default_tablespace  new_value default_tablespace  noprint
column s_aol_user            new_value aol_user            noprint
column s_apps_user           new_value apps_user           noprint
column s_noetix_sys_lang     new_value noetix_sys_lang     noprint
column s_install_global      new_value install_global      noprint
column s_install_xop         new_value install_xop         noprint
column s_install_standard    new_value install_standard    noprint
column s_individual_inv      new_value individual_inv      noprint
column s_global_inv          new_value global_inv          noprint
column s_prj_mc_cols         new_value prj_mc_cols         noprint
column s_prefix_pause        new_value prefix_pause        noprint
column s_object_pause        new_value object_pause        noprint
column s_gen_ap_builder_flag new_value gen_ap_builder_flag noprint
column s_ap_generator_flag   new_value ap_generator_flag   noprint
column s_continue_flag       new_value continue_flag       noprint
column s_gen_com_hlp         new_value gen_com_hlp         noprint
column s_gen_ms_hlp          new_value gen_ms_hlp          noprint
column s_gen_html_hlp        new_value gen_html_hlp        noprint

--
select upper(nvl('&CM_NOETIX_SYS_PROPERTY',
                 'STANDARD'))                          s_noetix_sys_property,
       upper(nvl('&CM_AUTOMATION_METHOD','FILE'))      s_automation_method,
       '&CM_INSTALL_DIRECTORY'                         s_install_directory,
       upper('&CM_NOETIX_SYS_USER')                    s_noetix_sys_user,
       '&CM_NOETIX_SYS_PW'                             s_noetix_sys_pw,
       upper( ( CASE substr('&CM_NOETIX_SYS_DB',1,1)
                  WHEN '@' THEN ''
                  ELSE ( CASE 
                           WHEN ( '&CM_NOETIX_SYS_DB' is null   ) THEN NULL
                           WHEN ( '&CM_NOETIX_SYS_DB'  = '""'   ) THEN NULL
                           WHEN ( '&CM_NOETIX_SYS_DB'  = '''''' ) THEN NULL
                           ELSE '@'
                         END )
                END ) || ( CASE 
                             WHEN ( '&CM_NOETIX_SYS_DB' is null   ) THEN NULL
                             WHEN ( '&CM_NOETIX_SYS_DB'  = '""'   ) THEN NULL
                             WHEN ( '&CM_NOETIX_SYS_DB'  = '''''' ) THEN NULL
                             ELSE '&CM_NOETIX_SYS_DB'
                           END ) )                      s_noetix_sys_db,
       upper('&CM_DEFAULT_TABLESPACE')                  s_default_tablespace,
       upper('&CM_AOL_USER')                            s_aol_user,
       upper('&CM_APPS_USER')                           s_apps_user,
       upper('&CM_NOETIX_SYS_LANG')                     s_noetix_sys_lang,
       upper(nvl('&CM_INSTALL_GLOBAL','Y'))             s_install_global,
       upper(nvl('&CM_INSTALL_XOP','Y'))                s_install_xop,
       upper(nvl('&CM_INSTALL_STANDARD','Y'))           s_install_standard,
       upper(nvl('&CM_INDIVIDUAL_INV','Y'))             s_individual_inv,
       'N'                                              s_global_inv,
       upper(nvl('&CM_PRJ_MC_COLS','Y'))                s_prj_mc_cols,
       upper(nvl('&CM_PREFIX_PAUSE','N'))               s_prefix_pause,
       upper(nvl('&CM_OBJECT_PAUSE','N'))               s_object_pause,
       upper('&CM_GEN_MS_HLP')                          s_gen_ms_hlp,
       upper('&CM_GEN_COM_HLP')                         s_gen_com_hlp,
       upper('&CM_GEN_HTML_HLP')                        s_gen_html_hlp,
       upper('&CM_GEN_AP_BUILDER_FLAG')                 s_gen_ap_builder_flag,
       'N'                                              s_ap_generator_flag,
       upper('&CM_CONTINUE_FLAG')                       s_continue_flag
from  dual
;
--
set termout on
set verify off
set recsep off

column s_text1  format a80
set linesize 80

select 
'  '                                                                                s_text1,
'Here is the information you entered for Install Stage 4. '                         s_text1,
'  '                                                                                s_text1,
'Noetix Application       - &DAT_APPLICATION'                                       s_text1,
'       Scripts Version   - &N_SCRIPTS_VERSION'                                     s_text1,
'       Metadata Version  - &DAT_VERSION'                                           s_text1,
'  '                                                                                s_text1,
'Noetix System Administration User             : &NOETIX_SYS_USER'                  s_text1,
'Noetix SysAdmin User Password                 : '||
            lpad('*',length('&NOETIX_SYS_PW'),'*')                                  s_text1,
'Noetix SysAdmin User Database Connection      : &NOETIX_SYS_DB'                    s_text1,
'Default Noetix SysAdmin User Tablespace       : &DEFAULT_TABLESPACE'               s_text1,
'Noetix Installation Directory                 : &INSTALL_DIRECTORY'                s_text1,
'Application Object Library User               : &AOL_USER'                         s_text1,
'Default Oracle Apps Translation Language      : &NOETIX_SYS_LANG'                  s_text1,
( CASE '&CHKPT_SELECTED'
    WHEN  'NOT_SET' THEN
'Generate Global Roles                         : &INSTALL_GLOBAL'
    ELSE
'Begin Execution From CheckPoint               : &CHKPT_DESC
Generate Global Roles                         : &INSTALL_GLOBAL'
  END )                                                                             s_text1,
'Generate XOP Roles                            : &INSTALL_XOP'                      s_text1,
'Generate Standard Roles                       : &INSTALL_STANDARD'                 s_text1,
'Generate Individual Inventory Roles           : &INDIVIDUAL_INV'                   s_text1,
'Create Projects Multi-Currency Columns        : &PRJ_MC_COLS'                      s_text1,
'Pause to edit the Noetix prefix file?         : &PREFIX_PAUSE'                     s_text1,
'Run Answer Builder?                           : &GEN_AP_BUILDER_FLAG'              s_text1,
'Continue to next stage on warnings?           : &CONTINUE_FLAG'                    s_text1,
'Generate Query Tool Help (Database comments)? : &GEN_COM_HLP'                      s_text1,
'Generate Microsoft Help?                      : &GEN_MS_HLP'                       s_text1,
'Generate Web (HTML) Help?                     : &GEN_HTML_HLP'                     s_text1,
'Overwrite Configuration File in Install Dir?  : &SAVE_CONFIG_FILES'                s_text1,
'  '                                                                                s_text1
  from dual
 where '&CM_INSTALLATION_OPTION'   = 'A'
;
--
set termout off
--
-- Insert the installation option values into new table
-- n_view_parameters_instopt.
@wdrop table &NOETIX_SYS_USER n_view_parameters_instopt
--
create table n_view_parameters_instopt 
     ( NOETIX_SYS_USER_PROPERTY       varchar2(30),
       AUTOMATION_METHOD              varchar2(30),
       PAUSE_FOR_PREFIX_EDITING_FLAG  varchar2(1),
       PAUSE_FOR_OBJECT_EDITING_FLAG  varchar2(1),
       CREATE_GLOBAL_VIEWS_FLAG       varchar2(1),
       CREATE_CROSS_OP_VIEWS_FLAG     varchar2(1),
       CREATE_STANDARD_VIEWS_FLAG     varchar2(1),
       CREATE_ALL_INV_ORGS_FLAG       varchar2(1),
       CREATE_PROJECTS_MC_COLS_FLAG   varchar2(1),
       INSTALLATION_DIRECTORY         varchar2(2000)   );
--
insert into n_view_parameters_instopt
     ( NOETIX_SYS_USER_PROPERTY,
       AUTOMATION_METHOD,
       PAUSE_FOR_PREFIX_EDITING_FLAG,
       PAUSE_FOR_OBJECT_EDITING_FLAG,
       CREATE_GLOBAL_VIEWS_FLAG,
       CREATE_CROSS_OP_VIEWS_FLAG,
       CREATE_STANDARD_VIEWS_FLAG,
       CREATE_ALL_INV_ORGS_FLAG,
       CREATE_PROJECTS_MC_COLS_FLAG,
       INSTALLATION_DIRECTORY )
values
     ( '&NOETIX_SYS_PROPERTY',
       '&AUTOMATION_METHOD',
       '&PREFIX_PAUSE',
       '&OBJECT_PAUSE',
       '&INSTALL_GLOBAL',
       '&INSTALL_XOP',
       '&INSTALL_STANDARD',
       '&INDIVIDUAL_INV',
       '&PRJ_MC_COLS',
       '&INSTALL_DIRECTORY'  );
--
commit;
   
set termout off
set echo off

--
-- Warn the user if the datfiles.ini file points to a different application
-- than that in the database.  If it does, then we will warn the user and 
-- let them decide what to do. For automated concurrent manager installs
-- we will write the warning and exit.
start instwarn '&NOETIX_SYS_USER'

set termout off
spool off

set echo on

-- Note:  Parameter 7 was formerly AOL Help flag.  Deprecated and defaulted to 'N'
start utlif "inst4imp ''&NOETIX_SYS_USER'' ''&NOETIX_SYS_PW'' ''&NOETIX_SYS_DB'' ''&DEFAULT_TABLESPACE'' ''&AOL_USER'' ''&NOETIX_SYS_LANG'' ''N'' ''&GEN_COM_HLP'' ''&GEN_MS_HLP'' ''&GEN_HTML_HLP'' ''&GEN_AP_BUILDER_FLAG'' ''&AP_GENERATOR_FLAG'' ''&CONTINUE_FLAG''  ''N'' ''N'' ''SQLPLUS'' ''&CHKPT_SELECTED'' ''&SAVE_CONFIG_FILES'' " -
"'&cm_installation_option' = 'A'"

set termout  off
set echo     off
set verify   off
set heading  off
set headsep  off
set feedback off
set termout  on 

column s_text1  format a80
set linesize 80
select 
'
Executing Answer Builder Stage (NoetixViews Only)'  s_text1
  from dual
 where '&cm_installation_option'   = 'B'
;

-- Note:  Parameter 7 was formerly AOL Help flag.  Deprecated and defaulted to 'N'
start utlif "inst5ua  ''&NOETIX_SYS_USER'' ''&NOETIX_SYS_PW'' ''&NOETIX_SYS_DB'' ''&DEFAULT_TABLESPACE'' ''&AOL_USER'' ''&NOETIX_SYS_LANG'' ''N'' ''&GEN_COM_HLP'' ''&GEN_MS_HLP'' ''&GEN_HTML_HLP'' ''&GEN_AP_BUILDER_FLAG'' ''&AP_GENERATOR_FLAG'' ''&CONTINUE_FLAG''  ''N'' ''N'' ''SQLPLUS'' ''&CHKPT_SELECTED'' ''&SAVE_CONFIG_FILES'' " -
"'&cm_installation_option' = 'B'"

set termout  off
set echo     off
set verify   off
set heading  off
set headsep  off
set feedback off
set termout  on 

column s_text1  format a80
set linesize 80
select 
'
Executing the Selected Help Generation Options for NoetixViews/DW'  s_text1
  from dual
 where '&CM_INSTALLATION_OPTION'   = 'H'
;

-- Note:  Parameter 7 was formerly AOL Help flag.  Deprecated and defaulted to 'N'
start utlif "inst7ua  ''&NOETIX_SYS_USER'' ''&NOETIX_SYS_PW'' ''&NOETIX_SYS_DB'' ''&DEFAULT_TABLESPACE'' ''&AOL_USER'' ''&NOETIX_SYS_LANG'' ''N'' ''&GEN_COM_HLP'' ''&GEN_MS_HLP'' ''&GEN_HTML_HLP'' ''&GEN_AP_BUILDER_FLAG'' ''&AP_GENERATOR_FLAG'' ''&CONTINUE_FLAG''  ''N'' ''N'' ''SQLPLUS'' ''&CHKPT_SELECTED'' ''&SAVE_CONFIG_FILES'' " -
"'&cm_installation_option' = 'H'"

spool off

start utlif "utlexit SUCCESS" -
"'&CM_AUTOMATION_METHOD' in ('CRON','CM')"

whenever sqlerror continue
whenever oserror continue

undefine 1
undefine 2
undefine 3
undefine 4
undefine 5
undefine 6
undefine 7 
undefine 8
undefine 9
undefine 10
undefine 11
undefine 12
undefine 13
undefine 14
undefine 15
undefine 16
undefine 17
undefine 18 
undefine 19
undefine 20
undefine 21
undefine 22

-- Undefine variables used.
undefine N_ADMIN_VERSION
undefine N_SCRIPTS_VERSION
undefine FULL_VERSION
undefine PRODUCT_VERSION
undefine FND_VERSION
undefine DAT_VERSION
undefine DAT_TYPE
undefine DAT_APPLICATION
undefine DEFAULT_SYS_ADMIN
undefine DAT_COMPANY_NAME
undefine TL_PROMPT
undefine CHKPT_SELECTED
undefine SAVE_CONFIG_FILES

undefine V_INVALID_PWD_COUNTER
undefine SYS_PAUSE
undefine SYS_ERROR

undefine CM_NOETIX_SYS_PROPERTY
undefine CM_AUTOMATION_METHOD
undefine CM_INSTALL_DIRECTORY
undefine CM_NOETIX_SYS_USER
undefine CM_NOETIX_SYS_PW
undefine CM_NOETIX_SYS_DB
undefine CM_DEFAULT_TABLESPACE
undefine CM_AOL_USER
undefine CM_APPS_USER
undefine CM_NOETIX_SYS_LANG
undefine CM_INSTALL_XOP
undefine CM_INDIVIDUAL_INV
undefine CM_GLOBAL_INV
undefine CM_PRJ_MC_COLS
undefine CM_PREFIX_PAUSE
undefine CM_OBJECT_PAUSE
undefine CM_GEN_COM_HLP
undefine CM_GEN_MS_HLP
undefine CM_GEN_HTML_HLP
undefine CM_GEN_AP_BUILDER_FLAG
undefine CM_CONTINUE_FLAG
undefine CM_SAVE_CONFIG_FILES
undefine CM_INSTALLATION_OPTION
undefine CM_GENERATOR_FLAG

undefine TNSNAME
undefine AUTOMATION_METHOD
undefine NOETIX_SYS_PROPERTY
undefine NOETIX_SYS_USER
undefine NOETIX_SYS_PW
undefine NOETIX_SYS_DB
undefine DEFAULT_TABLESPACE
undefine INSTALL_DIRECTORY
undefine AOL_USER
undefine APPS_USER
undefine NOETIX_SYS_LANG
undefine INSTALL_XOP
undefine CHKPT_DESC
undefine INDIVIDUAL_INV
undefine GLOBAL_INV
undefine PRJ_MC_COLS
undefine PREFIX_PAUSE
undefine GEN_AP_BUILDER_FLAG
undefine CONTINUE_FLAG
undefine GEN_COM_HLP
undefine GEN_MS_HLP
undefine GEN_HTML_HLP
undefine SAVE_CONFIG_FILES
undefine TMP_CONNECT_STRING

undefine FINAL_VALUE
undefine VALUE_HINT

start utlexit "Done"

-- End inst4ua.sql
