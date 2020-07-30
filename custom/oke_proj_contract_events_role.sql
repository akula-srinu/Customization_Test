-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_events_role
Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Proj_Contract_Events', '11.5+', 'pvemuru', TO_DATE('07/15/2008 03:44:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/15/2008 03:44:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff