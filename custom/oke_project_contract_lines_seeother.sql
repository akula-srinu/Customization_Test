-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_lines_seeother
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 'OKE_Proj_Contract_Parties', '[View Essay]', '11.5+', 'hpothuri', TO_DATE('06/30/2008 23:17:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/30/2008 23:17:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 'OKE_Prj_Contr_Line_Std_Notes', '[View Essay]', '11.5+', 'hpothuri', TO_DATE('12/19/2008 06:29:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/19/2008 06:29:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff