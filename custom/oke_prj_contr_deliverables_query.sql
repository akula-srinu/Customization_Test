-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_deliverables_query

Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, GROUP_BY_FLAG, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 1, 'N', '%', 'Query for the IN bound type.', 'kkondaveeti', TO_DATE('07/11/2008 04:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('07/14/2008 04:07:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, UNION_MINUS_INTERSECTION, GROUP_BY_FLAG, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 2, 'UNION ALL', 'N', '%', 'Query for the OUT bound type.', 'kkondaveeti', TO_DATE('07/11/2008 04:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('07/14/2008 04:07:00', 'MM/DD/YYYY HH24:MI:SS'));

COMMIT;

@utlspoff