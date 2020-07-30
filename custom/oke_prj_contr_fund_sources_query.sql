-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_sources_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 1, 'N', '%', 'kkondaveeti', TO_DATE('06/26/2008 22:34:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/26/2008 22:34:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff