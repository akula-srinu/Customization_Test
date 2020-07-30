-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_ap_invoices_base_role
--
--SQL Statement which produced this data:
--  select * from n_role_view_templates where  view_label like 'OKE_AP_Invoices_Base'
--
Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_AP_Invoices_Base', '11.5+', 'Rvattikonda', TO_DATE('07/16/2008 22:13:00', 'MM/DD/YYYY HH24:MI:SS'), 
    'pvemuru', TO_DATE('07/17/2008 23:52:00', 'MM/DD/YYYY HH24:MI:SS'));
    @utlspoff
COMMIT;
