-- 07-Apr-2011 HChodavarapu Verified for 602 build.
-- 28-Jan-2019 Srinivas     Added calls to the apps_grants.sql and noetix_vsat_utility_pkg.sql
--			    for applying the pre-requisites as part of automation process for ViaSat (JIRA-1096)
--
@utlspon oke_grants_ui

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

-- Connect to the apps account
@ctcustpw

@apps_grants.sql

@XXNAO_VSAT_WRAPPER_PKG.sql;

@XXNAO_VSAT_OKE_WRAPPER_PKG.sql;

@xxnao_oke_wrapper_pkg.sql;

grant execute on xxnao_oke_wrapper_pkg to &noetix_user with grant option; 

grant execute on XXNAO_VSAT_WRAPPER_PKG to &noetix_user with grant option; 

grant execute on XXNAO_VSAT_OKE_WRAPPER_PKG to &noetix_user with grant option; 

connect &noetix_user/&noetix_pw&connect_string 

@noetix_vsat_utility_pkg.sql;

@NOETIX_VSAT_USER_PKG.sql;

@n_add_ebs_query_user.sql;

@n_add_bi_user.sql;

@VSAT_NOETIX_CONC_REQUESTS.pkg

GRANT ALL ON noetix_views.vsat_noetix_conc_requests TO APPS;

--@noetix_oke_pkg.sql;

undefine APPS_ID
undefine APPS_CT

set termout off

@utlspoff
