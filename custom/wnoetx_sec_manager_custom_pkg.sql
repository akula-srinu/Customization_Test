-- Title
--    wnoetx_sec_manager_custom_pkg.sql
-- Function
--    Defines several procedures that are used in the Security Manager process.  These procedures 
--    are stubbed so that they actuall don't do anything.  Expectation is that the customer will
--    add their own code to modify the group and users created if necessary.
--
-- Description
--    Defines several procedures that are used in the Security Manager process.  These procedures 
--    are stubbed so that they actuall don't do anything.  Expectation is that the customer will
--    add their own code to modify the group and users created if necessary.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   11-Jun-11 D Glancy   Created.
--   17-Feb-12 D Glancy   Use wprivs instead of the direct grant.
--                        (Issue 29004)
--   24-Feb-12 D Glancy   Use n_grant_object_access instead of wprivs.  Removes complexity of setting environment.
--                        (Issue 29004)
--   26-Mar-12 R Vattikonda Addressed ampersand variable issue.
--                        (Issue 29279).
--   04-Sep-12 D Glancy   Add errors and spooling.
--                        (Issue 29931)
--
-- ---------------------- DEFINE STUBBED ROUTINES used by the Security Manager Process.----------------------
--
--  WARNING:  CUSTOMIZED VERSIONS OF THESE STUBBED ROUTINES ARE THE RESPONSIBILITY OF THE CUSTOMER.
--            DO NOT UPDATE UNLESS YOU CLEARLY UNDERSTAND WHAT YOU ARE MODIFYING AS IT WILL IMPACT
--            THE SECURITY OF THE ENVIRONMENT.
--
--

whenever sqlerror exit 598
whenever oserror  exit 598

@utlspon wnoetx_sec_manager_custom_pkg

CREATE OR REPLACE PACKAGE n_sec_manager_custom_pkg AUTHID DEFINER IS

    PROCEDURE hk01_START;
    PROCEDURE hk02_POP_SEED_VALUES;
    PROCEDURE hk03_LOAD_TEMP_TABLES;
    PROCEDURE hk04_POPULATE_GROUPS;
    PROCEDURE hk05_GROUP_AUTHS;
    PROCEDURE hk06_USER_ATTRIBUTES;
    PROCEDURE hk07_USER_GRANT_DEFAULTS;
    PROCEDURE hk08_USER_AUTHS;
    PROCEDURE hk09_UPDATE_SM_USERS;
    PROCEDURE hk10_END;

END n_sec_manager_custom_pkg;
/
show errors

CREATE OR REPLACE PACKAGE BODY n_sec_manager_custom_pkg IS

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- Beginning of the refresh process.  This script is run prior to invoking the reminder of the 
    -- Security Manager Refresh process.
    PROCEDURE hk01_START IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk01_START;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After initializing the seed values, use this script for customizations.
    -- This script is run after the initialize_seed_values procedure.
    PROCEDURE hk02_POP_SEED_VALUES IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk02_POP_SEED_VALUES;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After initializing the temporary tables, use this script for customizations.
    -- This script is run after the population of temporary tables used in the 
    -- security manager refresh process.
    PROCEDURE hk03_LOAD_TEMP_TABLES IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk03_LOAD_TEMP_TABLES;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After populating the Responsiblity Groups and the user groups, use this script for customizations.
    -- This script is run after the population the Responsibility and User Groups used in the 
    -- security manager refresh process.  If you have need to update the n_sm_groups and n_sm_group_list
    -- tables, this would be a good place to start.
    PROCEDURE hk04_POPULATE_GROUPS IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk04_POPULATE_GROUPS;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After populating the Effective Authorizations for each Group, use this script for customizations.
    -- This script is run after the population the effective permissions for each group created in the 
    -- previous step.
    -- If you have need to update the n_sm_eff_group_auths table, this would be a good place to start.
    PROCEDURE hk05_GROUP_AUTHS IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk05_GROUP_AUTHS;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After populating the User Attribute records for each query user, use this script to customize the 
    -- results.
    -- This script is run after the user attribute defaults are set and affect the n_sm_user_attributes 
    -- table populated in the previous step.
    -- If you have need to update the n_sm_user_attributes table, this would be a good place to start.
    PROCEDURE hk06_USER_ATTRIBUTES IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk06_USER_ATTRIBUTES;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After refreshing the granted groups/properties associated with a user, use this script to customize the 
    -- results.
    -- This script is run after the populate_user_grant_defaults procedure and affects the n_sm_granted_user_auths table
    -- populated in the previous step.
    -- If you have need to update the n_sm_granted_user_auths table, this would be a good place to start.
    PROCEDURE hk07_USER_GRANT_DEFAULTS IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk07_USER_GRANT_DEFAULTS;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After refreshing the effective properties associated with a user, use this script to customize the 
    -- results.
    -- This script is run after the populate_user_effective_auths procedure and affects the n_sm_effective_user_auths table
    -- populated in the previous step.
    -- If you have need to update the n_sm_effective_user_auths table, this would be a good place to start.
    PROCEDURE hk08_USER_AUTHS IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk08_USER_AUTHS;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- After updating the query user details, use this script to customize the results.
    -- This script is run after the Update_Sec_Manager_Users procedure and affects the n_security_mgr_users table
    -- updated in the previous step.
    -- If you have need to update the n_security_mgr_users table, this would be a good place to start.
    PROCEDURE hk09_UPDATE_SM_USERS IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk09_UPDATE_SM_USERS;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
    --
    -- Post processing step.  Use this if you have any additional updates you need to do after the initialization
    -- routine is finished.
    -- If you have need to update the n_security_mgr_users table, this would be a good place to start.
    PROCEDURE hk10_END IS
    BEGIN
        -- CUSTOM CODE GOES HERE.
        NULL;
    END hk10_END;
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

END n_sec_manager_custom_pkg;
/
show errors

-- Add this because the NOETIX_USER variable may not exist at this point if run from preupd.sql
COLUMN c_noetix_user NEW_VALUE noetix_user NOPRINT
SELECT user  c_noetix_user
  FROM dual;

define APPS_USERID               = 'APPS'
column S_APPS_USERID    new_value APPS_USERID    noprint
select distinct ou.oracle_username  S_APPS_USERID
  from fnd_oracle_userid_s  ou
 where ou.read_only_flag = 'U'
   and rownum            = 1;

set serveroutput on size 1000000
execute n_grant_object_access( 'EXECUTE', '&NOETIX_USER', 'N_SEC_MANAGER_CUSTOM_PKG', '&APPS_USERID' )

whenever sqlerror continue
whenever oserror  continue
spool off


-- end wnoetx_sec_manager_custom_pkg.sql
