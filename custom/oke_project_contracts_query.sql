-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contracts_query
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contracts', 1, 'N', '%', 'Rvattikonda', TO_DATE('06/04/2008 00:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/23/2008 06:39:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff