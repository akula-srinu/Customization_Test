-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_deliverables_roleview

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Prj_Contr_Deliverables', '11.5+', 'hpothuri', TO_DATE('07/15/2008 03:44:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/15/2008 03:44:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff