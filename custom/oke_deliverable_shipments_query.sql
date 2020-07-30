-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_shipments_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Deliverable_Shipments', 1, 'N', '%', 'kkondaveeti', TO_DATE('07/14/2008 23:58:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/16/2008 23:25:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff