-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_alloctn_seeother

Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 'OKE_Prj_Contr_Fund_Sources', '[View Essay]', '%', 'hpothuri', TO_DATE('07/17/2008 05:24:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:17:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff