-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_1159_onwards_profile

SET SCAN OFF;
Insert into N_PROFILE_OPTION_TEMPLATES
   (PROFILE_OPTION, PROFILE_DESCRIPTION, APPLICATION_LABEL, TABLE_APPLICATION_LABEL, TABLE_NAME, PROFILE_SELECT, ESSAY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_1159_ONWARDS', 'Determine if installation is 11.5.9 or more', 'OKE', 'OKE', 'OKE_K_FUND_ALLOCATIONS', 'SELECT /*+ RULE */ ''Y''  FROM DUAL WHERE 1=1    AND NOT EXISTS      ( SELECT ''EXISTS''         FROM SYS.ALL_TAB_COLUMNS        WHERE 1=1          AND OWNER = REPLACE(''&OKE.'',''.'')          AND TABLE_NAME = ''OKE_K_FUND_ALLOCATIONS''          AND COLUMN_NAME = ''FUNDING_CATEGORY''     )', 'This profile options is used for columns that are available from 1159.', 'hpothuri', TO_DATE('08/06/2008 04:43:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('08/06/2008 04:43:00', 'MM/DD/YYYY HH24:MI:SS'));
SET SCAN ON;

COMMIT;

@utlspoff
