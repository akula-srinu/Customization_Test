-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_funding_hist_seeother

Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 'OKE_Prj_Contr_Fund_Alloctn', '[View Essay]', '11.5+', 'pvemuru', TO_DATE('07/18/2008 04:19:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:19:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 'OKE_Prj_Contr_Fund_Sources', '[View Essay]', '11.5+', 'pvemuru', TO_DATE('06/30/2008 03:47:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:31:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff