set echo off
-- Title
--   igetpw.sql
-- Function
--   Creates the cpw.sql file used in unattended installations.
--
-- Description
--   Prompts the user for password values and populates the cpw.sql 
--   file with the given values. This file is used for all unattended
--   installations.
--
--   We first set default values using cpwdf.sql and the current 
--   user/database. Then, we overwrite any defaults with values
--   found in /autojoin/cparam.sql. Finally, we overwrite any defaults
--   with values found in the most recent n_view_parameters records.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   12-Feb-03 H Schmed  Created (Issue 8310)
--   26-Feb-03 H Schmed  Added a "set define '&'" command. Removed
--                       the spooling to igetpw.lst. (Bug 10019)
--   15-Jul-03 D Glancy  Added step to backup the cpw.sql file.
--                       (Issue 4826,8310,8324,9454)
--   15-Jul-03 D Glancy  1.  Changed AOL_USER prompt to be APPS_USER.  Make this field
--                       non-displayable but active.
--                       2.  Added step to backup the file.
--                       (Issue 4826,8310,8324,9454)
--   18-Jul-03 D Glancy  Resolved missing variable issue.
--   20-Jul-03 D Glancy  Made the exit number unique.
--                       (Issue 8324)
--   22-Jul-03 D Glancy  The cpw.sql file now requires a parameter.  This supports using
--                       automation for CM - STANDARD installations.
--                       (Issue 4826,8310,8324,9454)
--   31-Jul-03 D Glancy  User_sys_privs may have multiple rows returned (USER or PUBLIC).
--                       Only allow one match to return.
--                       (Issue 10924)
--   17-Sep-03 D Glancy  Added NF_NQS_RESET_PACKAGE to support nqs customer issue.
--   17-Sep-03 D Glancy  Added seconds to the backup file name.
--                       (Issue #11120)
--   21-Sep-03 D Glancy  Modify the call to wgetpw.sql.  Added extra parameter 
--                       to indicate if the connect_string info should be appended to 
--                       the created PW_??? variable.
--                       (Issue 10189)
--   23-Feb-04 D Glancy  Update Copyright Info. (Issue 11982)
--   03-Nov-04 D Glancy  Update Copyright Info. (Issue 13498)
--   13-Jun-05 D Glancy  Allow for creation of the new HR Security Objects.
--                       (Issue 12120 and 13739)
--   29-Aug-05 D Glancy  Added check to determine if the objects previously added to the 
--                       APPS account are valid when we determine if we want to regenerate them.
--                       (Issue 15167)
--   22-Sep-05 D Glancy  Update copyright info. (Issue 15175)
--   12-Oct-06 M Kaku    Added check grants for 'Noetix_Pay_Pkg' and 'EIS_AU_BALANCE_PKG'
--   06-Nov-06 D Glancy  Prepended the "PATH=$PATH:.;" command for all host calls in the unix environment.
--                       In LINUX, if you don't have "." in the path, then the batch script will fail to 
--                       execute.  Should be the same for all flavors of UNIX, but SUN does not appear
--                       to be working this way.
--   08-Jan-07 M Kaku    Added check grants for 'EIS_GBBAL' and 'EIS_GB_BALANCE_PKG'
--                       (Issue 17005)
--   10-May-07 S Lakshminarayanan Initialised DAT_APPLICATION variable by including a call to datfiles.ini. Without this the 
--                       script hangs waiting for input. Also added a call to nscripts.ini
--                       (Issue 17520)
--   31-Aug-07 D Glancy   Removed grants for fnd_global, fnd_profile, and hr_security.  These should not be
--                        necessary with the implentation of the fnd wrapper package.  
--                        (Issue 17945)
--   17-Sep-07 D Glancy   Use the new n_compare_version function to support new wrapper 
--                        packages.  If the version of the existing wrapper is > the 
--                        version we're going to install, then don't re-install the wrapper.
--                        (Issue 14839)
--   11-Dec-07 D Glancy   Added version checking to prevent an older script from overlaying a newer script.
--   19-Apr-08 D Glancy   Fixed multiple issues with the parameter gathering system.
--                        (Issue 19587 and 19588)
--   21-Nov-13 D Glancy   EBS 12.2 support.
--   14-Feb-14 D Glancy   Ensure there is only one @ in the connect strings.
--
-- Define the variables to *Undefined*
define apps_userid = '*Undefined*'
define applsys_userid = '*Undefined*'
define connect_string = '*Undefined*'
define dat_answers = '*Undefined*'
define dat_modules = '*Undefined*'
define dat_type = '*Undefined*'
define dat_version = '*Undefined*'
define has_select_any_table = '*Undefined*'
define n_scripts_version = '*Undefined*'
define noetix_connect = '*Undefined*'
define p_apps_user = '*Undefined*'
define p_noetix_sys_db = '*Undefined*'
define p_noetix_sys_property = '*Undefined*'
define p_noetix_sys_pw = '*Undefined*'
define p_noetix_sys_user = '*Undefined*'
define product_version = '*Undefined*'
define regenerate_nqs_objects = '*Undefined*'
define xxeis_userid = '*Undefined*'
define xxeis_app_detected = '*Undefined*'

@noetixd
--
-- ??? WHAT DO WE DO IF THE INI FILES DO NOT EXIST???
-- Define dat_type, dat_version and dat_modules
set termout &LEVEL2
@datfiles.ini
--
-- Define n_scripts_version
set verify   off
set feedback off
set echo     off
set termout  &LEVEL2
@nscripts.ini
--
prompt
prompt Gathering the passwords required for an unattended installation.
prompt
prompt First, we must validate cparam.sql because some parameters are
prompt required for password validation.
prompt
--
@ivalprm

prompt
prompt Now, passwords will be gathered.
set termout &LEVEL2
--
start autorun/cparam.sql
--
set define '&'
--
-- ??? ADD CODE TO CHECK FOR ANY UNDEFINED COLUMNS THAT WE 
--     EXPECT ARE DEFINED. IF WE FIND THEM, EXIT.
--
--
-- Define the XXEIS_USERID and XXEIS_APP_DETECTED values
define XXEIS_USERID = 'XXEIS'
define XXEIS_APP_DETECTED=N
column c_xxeis_app_detected new_value XXEIS_APP_DETECTED noprint
select 'Y' c_xxeis_app_detected
  from dual
 where '&DAT_MODULES' like '%PAY%'
   and '&DAT_TYPE'       = 'Views';

define has_select_any_table = 'N'
COLUMN s_has_select_any_table new_value HAS_SELECT_ANY_TABLE noprint
SELECT /*+ RULE */
       'Y'          s_has_select_any_table
  FROM user_sys_privs
 WHERE privilege = 'SELECT ANY TABLE'
   AND rownum    = 1
;

COLUMN S_APPS_USERID    new_value APPS_USERID    noprint
SELECT distinct ou.oracle_username  S_APPS_USERID
  FROM fnd_oracle_userid_s  ou
 WHERE ou.read_only_flag = 'U'
   AND rownum = 1;
--
COLUMN S_APPLSYS_USERID    new_value APPLSYS_USERID    noprint
SELECT distinct ou.oracle_username  S_APPLSYS_USERID
  FROM fnd_oracle_userid_s  ou
 WHERE ou.read_only_flag        = 'E'
   AND rownum                   = 1;
--
COLUMN s_product_version new_value PRODUCT_VERSION  noprint
SELECT to_number( substr(MAX(pg.release_name),
                  1, instr(MAX(pg.release_name),'.',1)+1)) s_product_version
  FROM fnd_product_groups_s pg
 WHERE pg.product_group_id = 1;

set termout off
set echo    off
--
whenever sqlerror continue

--
column s_connect_string new_value CONNECT_STRING noprint
column s_noetix_connect new_value NOETIX_CONNECT noprint
column s_date_and_time  new_value date_and_time  noprint
select to_char(sysdate, 'DD-MON-YYYY HH12:MI:SS PM') s_date_and_time,
      '&P_NOETIX_SYS_USER'||'/'||'&P_NOETIX_SYS_PW'
           ||'@'||ltrim('&P_NOETIX_SYS_DB','@')      s_noetix_connect,
        '@'||ltrim('&P_NOETIX_SYS_DB','@')           s_connect_string 
from dual;
--
--
-- Look up the parameter list
column us format A50 
define t_connect_string=''

set verify off
set echo   off
set escape off
set escape \

whenever sqlerror exit 313
@utlspsql 80 tmppw
prompt whenever sqlerror continue

-- Always get the APPS Account because that is where we
-- are going to put various wrappers.
select /*+ RULE */
       distinct '@wgetpw &APPS_USERID N'   us
  from dual
 where nvl( '&P_NOETIX_SYS_PROPERTY', 
            'STANDARD' )         != 'EBSO'
 UNION
-- Get the XXEIS User if the XXEIS App is detected.
select '@wgetpw '||au.username||' N'
  from sys.all_users au
 where '&DAT_TYPE'           = 'Views'  
   and &PRODUCT_VERSION     >= 11.5
   and au.username           = '&XXEIS_USERID'
   and '&XXEIS_APP_DETECTED' = 'Y'
   and nvl( '&P_NOETIX_SYS_PROPERTY', 
            'STANDARD' )         != 'EBSO'
 UNION
select '@wgetpw '||fou.oracle_username||' N'
  from fnd_oracle_userid_s       fou
 where '&DAT_TYPE'       = 'Views'  
   and &PRODUCT_VERSION >= 10.7
   and nvl( '&P_NOETIX_SYS_PROPERTY', 
            'STANDARD' )         != 'EBSO'
   and (       fou.read_only_flag = 'U'
         OR
         (     fou.read_only_flag in ( 'O', 'K', 'M' )
           and &PRODUCT_VERSION < 11.5               
         )
       )
order by 1;
--
-- Now, spool the results to the output file
--

prompt spool autorun/cpw.sql
prompt set escape on
prompt prompt -- Receive the current password values
prompt prompt -- ; ;
prompt prompt -- Created using igetpw.sql on &date_and_time
prompt prompt -- ; ;
prompt prompt define t_connect_string = '\\\&1'
prompt prompt 
--
select /*+ RULE */
       distinct 
       'prompt define PW_'||'&APPS_USERID'||
           '= \&PW_'||'&APPS_USERID'||'\\\&T_CONNECT_STRING'
  from dual
 where nvl( '&P_NOETIX_SYS_PROPERTY', 
            'STANDARD' )         != 'EBSO'
 UNION
select 'prompt define PW_'||au.username ||
           '= \&PW_'||au.username||'\\\&T_CONNECT_STRING'
  from sys.all_users au
 where '&DAT_TYPE'          != 'DW'  
   and &PRODUCT_VERSION     >= 11.5
   and au.username           = '&XXEIS_USERID'
   and '&XXEIS_APP_DETECTED' = 'Y'
   and nvl( '&P_NOETIX_SYS_PROPERTY', 
            'STANDARD' )         != 'EBSO'
 UNION
select 'prompt define PW_'||fou.oracle_username||
            '= \&PW_'||fou.oracle_username||'\\\&T_CONNECT_STRING'
  from fnd_oracle_userid_s       fou
 where '&DAT_TYPE'           = 'Views'  
   and nvl( '&P_NOETIX_SYS_PROPERTY', 
            'STANDARD' )         != 'EBSO'
   and &PRODUCT_VERSION          >= 11.5
   and (       fou.read_only_flag = 'U'
         OR
         (     fou.read_only_flag in ( 'O', 'K', 'M' )
           and &PRODUCT_VERSION < 11.5               
         )
       )
order by 1;
prompt prompt 
prompt prompt undefine T_CONNECT_STRING
prompt spool off
prompt whenever sqlerror exit 313
-- Undefine the variables after creation of the file
select /*+ RULE */
       distinct 'undefine PW_'||'&APPS_USERID'
  from dual
 UNION
select 'undefine PW_'||'&XXEIS_USERID'
  from sys.all_users au
 where '&DAT_TYPE'          != 'DW'  
   and &PRODUCT_VERSION     >= 11.5
   and au.username           = '&XXEIS_USERID'
   and '&XXEIS_APP_DETECTED' = 'Y'
 UNION
select 'undefine PW_'||fou.oracle_username
  from fnd_oracle_userid_s       fou
 where (       fou.read_only_flag = 'U'
         OR
         (     fou.read_only_flag in ( 'O', 'K', 'M' )
           and &PRODUCT_VERSION < 11.5               
         )
       )
order by 1;
spool off

--debug
set termout &level2
set echo &level2
----------------------

whenever oserror continue

-- Set the permissions on the file to read only
whenever oserror continue
set termout off

-- Just in case, create the autorun directory.
host PATH=.:$PATH;wmkdir.bat ./autorun

define host_call_param='cpw.sql'
column c_host_call_param new_value host_call_param noprint
select 'cpw.sql '||to_char( sysdate, '_YYYYMMDD_HH24MISS' )||' autorun' c_host_call_param
  from dual
;
-- Create a backup copy 
host PATH=.:$PATH;dobackup.bat &host_call_param
-- 

-- Allow for read/write permissions.
host PATH=.:$PATH;chperm.bat 700 autorun/cpw.sql

-- start the UI/install type appropriate script
start tmppw
--
set termout on
prompt 
prompt All passwords have been gathered and saved in 
prompt autorun/cpw.sql.
prompt 

set termout off
whenever oserror continue

-- Set the permissions on the file to read only
host chperm.bat 400 autorun/cpw.sql

-- Backup the current cpw.sql file
define host_call_param='cpw.sql'
column c_host_call_param new_value host_call_param noprint
select 'cpw.sql '||to_char( sysdate, '_YYYYMMDD_HH24MISS' )||' autorun' c_host_call_param
  from dual
;
-- Create a backup copy 
host  PATH=.:$PATH;dobackup.bat &host_call_param

undefine APPS_USERID
undefine APPLSYS_USERID
undefine CONNECT_STRING
undefine DAT_ANSWERS
undefine DAT_MODULES
undefine DAT_TYPE
undefine DAT_VERSION
undefine HAS_SELECT_ANY_TABLE
undefine N_SCRIPTS_VERSION
undefine NOETIX_CONNECT
undefine PRODUCT_VERSION
undefine REGENERATE_NQS_OBJECTS
undefine XXEIS_USERID
undefine XXEIS_APP_DETECTED
undefine ACTION_TYPE
undefine DATE_AND_TIME
undefine HOST_CALL_PARAM

set termout on

-- end igetpw.sql
