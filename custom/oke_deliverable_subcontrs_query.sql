-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_subcontrs_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Deliverable_Subcontrs', 1, 'N', '%', 'kkondaveeti', TO_DATE('07/16/2008 22:36:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('07/16/2008 22:36:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff