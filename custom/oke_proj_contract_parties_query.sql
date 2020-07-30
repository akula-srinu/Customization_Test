-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_parties_query
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Proj_Contract_Parties', 1, 'N', '%', 'Parties at contract header level', 'kkondaveeti', TO_DATE('06/06/2008 03:04:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/18/2008 03:14:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, UNION_MINUS_INTERSECTION, GROUP_BY_FLAG, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Proj_Contract_Parties', 2, 'UNION ALL', 'N', '%', 'Parties at contract line level', 'kkondaveeti', TO_DATE('06/06/2008 03:04:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('06/18/2008 03:14:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff