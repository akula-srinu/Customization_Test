-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_terms_roleview

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Project_Contract_Terms', '11.5+', 'jbhattacharya', TO_DATE('12/17/2008 04:58:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('12/17/2008 04:58:00', 'MM/DD/YYYY HH24:MI:SS'));
@utlspoff
COMMIT;
