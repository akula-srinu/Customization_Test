-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pcontract_print_forms_see_other
--
--SQL Statement which produced this data:
--  select * from n_help_see_other_templates t2 where t2.VIEW_LABEL = 'OKE_PContract_Print_Forms'
--
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_PContract_Print_Forms', 'OKE_Project_Contract_Lines', '[View Essay]', 'jbhattacharya', TO_DATE('03/09/2009 06:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('03/09/2009 06:53:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_PContract_Print_Forms', 'OKE_Project_Contracts', '[View Essay]', '%', 'jbhattacharya', TO_DATE('03/09/2009 06:52:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('03/09/2009 06:52:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff