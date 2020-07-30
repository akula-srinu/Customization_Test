-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pa_pcontract_projects_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, UNION_MINUS_INTERSECTION, GROUP_BY_FLAG, PROFILE_OPTION, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_PA_PContract_Projects', 1, NULL, 'N', NULL, 
    '%', NULL, 'Rvattikonda', TO_DATE('06/04/2008 00:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', 
    TO_DATE('06/23/2008 06:15:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff
