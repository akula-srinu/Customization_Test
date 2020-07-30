set feedback off
set verify off
set heading off
define level2=off
define LEVEL3=off
define ECHO_LEVEL3=on
/*
column Check_Stage_4 new_value Check_Stage_4 noprint
--@utlspon install_incr
select 'No stage 4' Check_Stage_4 from dual
where not exists (
select 'Y' from n_view_parameters nvp1
where nvp1.creation_date >=(select max(creation_date) from n_view_parameters nvp2
                                                 where nvp2.install_stage in (2,3))
and nvp1.install_stage=4);
*/

-- <<code to check if stage4 is run or not>>
column Check_Stage_4 new_value Check_Stage_4 noprint

select n_view_parameters_api_pkg.VALIDATE_IR_READINESS Check_Stage_4 from dual;
start utlif 'utlprmpt  ''''&Check_Stage_4''''' "'&Check_Stage_4' != '0'||':'||'0'"
start utlif 'utlpause' "'&Check_Stage_4' != '0'||':'||'0'"
start utlif 'userexit' "'&Check_Stage_4' != '0'||':'||'0'"
set termout on 
undefine Check_Stage_4
-- <<end of code to check if stage4 is run or not>>
@tconnect.sql

column APPS_USERID new_value APPS_USERID noprint 

select distinct apps_user APPS_USERID from n_view_parameters;

@wgetpw &APPS_USERID Y
set feedback on
set serveroutput on
set termout on


@instincr.sql &pw
