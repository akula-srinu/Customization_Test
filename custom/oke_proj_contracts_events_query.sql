-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_events_query
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Proj_Contract_Events', 1, 'N', '%', 'Events associated with Project Contract Deliverables', 'pvemuru', TO_DATE('07/15/2008 03:44:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/15/2008 03:44:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff