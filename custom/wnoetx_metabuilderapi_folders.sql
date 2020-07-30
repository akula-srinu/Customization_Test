-- Title
--    wnoetx_metabuilderapi_folders.sql
-- Function
--    Perform customer update sql processes
--    will be custom for each update release
--
-- Description
--    Do nothing for this release
--
-- Instructions for populating n_metabuilderapi_folders
-- COLUMN_NAME                EXPECTED_CONTENTS
-- APPLICATION_LABEL          Corresponds to application_label in n_roles.
-- APPLICATION_INSTANCE       Corresponds to application_instance in n_roles.  If this record 
--                            is just to establish a parent folder (not one associated with roles), 
--                            this value should be null.
-- ROLE_NAME                  Corresponds to role_name in n_roles.  If this record is just to 
--                            establish a parent folder, this value should be 'ALL'.
-- FOLDER_NAME                The name of the folder that should contain the views associated with 
--                            the role.  Note that for non-global views, this is the role name.  
--                            For global views, it is usually similar to the role description 
--                            followed by " Views".  e.g. "Payables Views".
-- SEARCH_FOLDER_NAME         The name of the folder as it is to be displayed in Noetix Search.
--                            For non-global views, this is the role name.  For global views, it is 
--                            usually the role description (or the folder name minus " Views").
-- FOLDER_GROUP_NAME          The next level folder name that the folder should be placed in.  For 
--                            Global views, these folders are normally named something like 
--                            "NoetixViews for Oracle Financials"; for Standard views they describe 
--                            the operational unit, such as 
--                            "Operating Unit: Vision Operations (Item validation: Vision Operations)".
--                            For Standard ledger views, the folder group name may contain the string 
--                            "V_LEDGER_PREFIX:" which will be replaced with "Ledger:" or 
--                            "Set of Books:" depending on the version of EBS.
-- PARENT_FOLDER_GROUP_NAME   If there are more than 2 levels of folders, this identifies the folder 
--                            in which the folder group should be placed.
-- ROOT_FOLDER_GROUP_NAME     This should be left null.  (Used by Analytics)
-- FOLDER_DESCRIPTION         Usually is the same as the role description.  Is displayed with the 
--                            folder name.
-- FOLDER_GROUP_DESCRIPTION   Usually is the same as the folder group name, but this is not a requirement.  
-- FOLDER_LEVEL               Indicates the hierarchy of the folders.  The top-most folder should be 
--                            level 1.  Its children should be level 2, etc.
-- SORT_ORDER                 Indicates the order that folders should be displayed within a level.  
--                            If the folders should be sorted by name, set sort_order to 1 for every folder.
-- RELATIONSHIP_SET_ID        This should be left null.  (Used by Analytics)
-- QUALIFYING_FLAG            This should be set to Y.  This column is used along with 
--                            deprecation_version when folders have been deprecated.  If the 
--                            deprecation_version is not null, set qualifying_flag to N.
-- LEAF_NODE_FLAG             This should be set to N.  (Used by Analytics)
-- DEPRECATION_VERSION        This should be left null.  If we choose to rename folders in the 
--                            future, the old versions of the folders will still be created here but 
--                            will have a non-null deprecation version.  This will allow customers to 
--                            continue to use the old folder names if desired.
-- SOURCE_SCHEMA              Set to the noetix_sys user name.
-- SOURCE_QUERY               This is used internally to tell which query in a multiple query insert 
--                            statement populated the data.  If data is added manually, set this to 
--                            'CUSTOM'.
-- FOLDER_USAGE               This has 3 possible values: ALL, VIEWS, and ANSWERS.  If the same folder 
--                            name is used for views and for answers, set this to ALL.  If the folder 
--                            name is just used for views, set to VIEWS.  If the folder is just used for 
--                            answers, set to ANSWERS.
-- FOLDER_TYPE                This has 2 possible values: ORG and ROLE.  When the role name is ALL, the 
--                            folder type should be ORG.  When the role name is an actual role, set the 
--                            folder type to ROLE.
-- OMIT_FLAG                  Standard usage.  Null or N means use the record. Y means do not use the record.
--
-- Copyright Noetix Corporation 1992-2016  All Rights Reserved
--
-- History
--   17-Jun-11 R Lowe     Created
--

--
-- Set a variable to identify the output file, because this may be run from 
-- multiple places with different log file folders.
column s_spool_file NEW_VALUE spool_file noprint
select case when &INSTALL_STAGE between 6.1 and 6.9 or
                 &INSTALL_STAGE = 7.5
            then '&GEN_API_DIR/wnoetx_metabuilderapi_folders.lst'
            else 'wnoetx_metabuilderapi_folders.lst' 
            end s_spool_file
  from dual
;

spool &SPOOL_FILE

-- Suppression script goes here...

--commit;

spool off