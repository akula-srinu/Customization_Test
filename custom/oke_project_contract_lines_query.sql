-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_lines_query
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Project_Contract_Lines', 1, 'N', '%', 'NO ORGID', 'Rvattikonda', TO_DATE('06/18/2008 01:56:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/18/2008 23:14:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff