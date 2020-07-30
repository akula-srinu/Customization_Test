-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_po_rcp_dtl_query
--
--SQL Statement which produced this data:
--  select * from n_view_query_templates where  view_label like 'OKE_Deliverable_PO_Rcp_Dtl'
--
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, UNION_MINUS_INTERSECTION, GROUP_BY_FLAG, PROFILE_OPTION, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Deliverable_PO_Rcp_Dtl', 1, NULL, 'N', NULL, 
    '%', NULL, 'Rvattikonda', TO_DATE('07/15/2008 01:06:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', 
    TO_DATE('07/16/2008 23:25:00', 'MM/DD/YYYY HH24:MI:SS'));
    @utlspoff
COMMIT;
