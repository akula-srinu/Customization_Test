-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_alloctn_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 1, 'N', '%', 'Rvattikonda', TO_DATE('06/27/2008 04:33:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/16/2008 23:24:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff