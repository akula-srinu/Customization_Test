-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_parties_role
Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Proj_Contract_Parties', '11.5+', 'jbhattacharya', TO_DATE('06/10/2008 00:29:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('06/10/2008 00:29:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff