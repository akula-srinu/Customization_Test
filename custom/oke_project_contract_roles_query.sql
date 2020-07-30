-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_roles_query
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Roles', 1, 'N', '%', 'Rvattikonda', TO_DATE('06/09/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/09/2008 05:53:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff