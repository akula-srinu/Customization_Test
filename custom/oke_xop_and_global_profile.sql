-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_xop_and_global_profile

Insert into N_PROFILE_OPTION_TEMPLATES
   (PROFILE_OPTION, PROFILE_DESCRIPTION, APPLICATION_LABEL, TABLE_APPLICATION_LABEL, TABLE_NAME, PROFILE_SELECT, ESSAY, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_XOP_AND_GLOBAL', 'XOP and Global Instances only', 'OKE', 'FND', 'FND_DUAL', 'SELECT DECODE(SUBSTR(AO.APPLICATION_INSTANCE, 1, 1),                ''X'',''N'',               ''G'',''N'',               ''Y'' ) FROM N_APPLICATION_OWNERS AO WHERE AO.APPLICATION_LABEL       = N_PROFILE_OPTIONS.APPLICATION_LABEL  AND   AO.APPLICATION_INSTANCE    = N_PROFILE_OPTIONS.APPLICATION_INSTANCE', 'Omit the column if it is not an XOP or Global instance.', '11.5+', 'hpothuri', TO_DATE('12/18/2008 02:28:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 02:41:00', 'MM/DD/YYYY HH24:MI:SS'));


COMMIT;

@utlspoff
