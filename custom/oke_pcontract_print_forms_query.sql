-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pcontract_print_forms_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_PContract_Print_Forms', 1, 'N', '11.5+', 'jbhattacharya', TO_DATE('03/09/2009 05:20:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('03/09/2009 05:20:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff
