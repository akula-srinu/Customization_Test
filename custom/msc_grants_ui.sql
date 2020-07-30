-- 28-Jul-2015 Srinivas Akula Created.
@utlspon msc_grants_ui

set termout on

column C_APPS_ID    new_value APPS_ID   noprint
column C_APPS_CT    new_value APPS_CT   noprint
select distinct 
       ou.oracle_username           C_APPS_ID,
       '\&pw_'||ou.oracle_username  C_APPS_CT
  from fnd_oracle_userid  ou
 where read_only_flag = 'U';
-- 
@utlspsql 100 ctcustpw
prompt connect  &APPS_CT
spool off

set termout on
set echo on

@xxnao_msc_wrapper_pkg.sql;

grant execute on xxnao_msc_wrapper_pkg to &noetix_user with grant option; 

--connect &noetix_user/&noetix_pw&connect_string 

set termout off

undefine APPS_ID
undefine APPS_CT


@utlspoff
