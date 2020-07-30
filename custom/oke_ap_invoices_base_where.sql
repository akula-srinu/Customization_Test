-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_ap_invoices_base_where
--
--SQL Statement which produced this data:
--  select * from n_view_where_templates where  view_label like 'OKE_AP_Invoices_Base'
--
Insert into N_VIEW_WHERE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, WHERE_CLAUSE_POSITION, WHERE_CLAUSE, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_AP_Invoices_Base', 2, 1, 'AND ICHRG.ITEM_DIST_ID = IDSTR.INVOICE_DISTRIBUTION_ID', NULL, 
    '%', 'Rvattikonda', TO_DATE('07/16/2008 21:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/16/2008 21:53:00', 'MM/DD/YYYY HH24:MI:SS'));
@utlspoff
COMMIT;
