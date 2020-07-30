-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contracts_seeother
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contracts', 'OKE_Proj_Contr_User_Attrs', '[View Essay]', 'jbhattacharya', TO_DATE('06/10/2008 03:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('06/27/2008 05:38:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contracts', 'OKE_Proj_Contract_Parties', '[View Essay]', '%', 'jbhattacharya', TO_DATE('06/10/2008 03:35:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('06/10/2008 03:35:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contracts', 'OKE_Project_Contract_Lines', '[View Essay]', 'jbhattacharya', TO_DATE('06/27/2008 05:39:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('06/27/2008 05:39:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contracts', 'OKE_Project_Contract_Roles', '[View Essay]', '%', 'jbhattacharya', TO_DATE('06/10/2008 03:36:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('06/10/2008 03:36:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contracts', 'OKE_Proj_Contr_Std_Notes', '[View Essay]', '11.5+', 'hpothuri', TO_DATE('12/19/2008 06:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/19/2008 06:30:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contracts', 'OKE_Project_Contract_Terms', '[View Essay]', '11.5+', 'hpothuri', TO_DATE('12/19/2008 06:31:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/19/2008 06:31:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff