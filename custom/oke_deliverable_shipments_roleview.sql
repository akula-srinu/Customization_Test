-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_shipments_roleview

Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Deliverable_Shipments', '11.5+', 'kkondaveeti', TO_DATE('07/15/2008 23:56:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:13:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff