-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pa_pcontract_projects_role
Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_PA_PContract_Projects', '11.5+', 'rvattikonda', TO_DATE('03/15/2009 20:24:00', 'MM/DD/YYYY HH24:MI:SS'), 'rvattikonda', TO_DATE('03/15/2009 20:24:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff
