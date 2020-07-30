-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_alloctn_roleview

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Prj_Contr_Fund_Alloctn', '11.5+', 'Rvattikonda', TO_DATE('06/27/2008 06:27:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:13:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff