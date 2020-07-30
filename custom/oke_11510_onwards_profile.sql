-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_11510_onwards_profile
--
--
set scan off;
Insert into N_PROFILE_OPTION_TEMPLATES
   (PROFILE_OPTION, PROFILE_DESCRIPTION, APPLICATION_LABEL, TABLE_APPLICATION_LABEL, TABLE_NAME, PROFILE_SELECT, ESSAY, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_11510_ONWARDS', 'Determine if installation is 11.5.10 or more', 'OKE', 'OKE', 'OKE_K_DELIVERABLES_B', 
    'SELECT /*+ RULE */ ''Y''  FROM DUAL WHERE 1=1    AND NOT EXISTS    ( SELECT ''EXISTS''       FROM SYS.ALL_TAB_COLUMNS
        WHERE 1=1         AND OWNER = REPLACE(''&OKE.'',''.'')         AND TABLE_NAME = ''OKE_K_DELIVERABLES_B''       AND COLUMN_NAME = ''PO_CATEGORY_ID''   )', 'This profile options is used for columns that are available from 11510.', NULL, 'pvemuru', TO_DATE('06/27/2008 06:19:00', 'MM/DD/YYYY HH24:MI:SS'), 
    'pvemuru', TO_DATE('06/27/2008 06:19:00', 'MM/DD/YYYY HH24:MI:SS'));
set scan on;
@utlspoff
COMMIT;
