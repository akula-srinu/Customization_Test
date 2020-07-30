-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_lines_role
Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Project_Contract_Lines', '11.5+', 'Rvattikonda', TO_DATE('06/18/2008 05:20:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/18/2008 05:20:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff