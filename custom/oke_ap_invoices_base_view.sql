-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_ap_invoices_base_view
set escape off;
--
--SQL Statement which produced this data:
--  select * from n_view_templates where  view_label like 'OKE_AP_Invoices_Base'
--
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_AP_Invoices_Base', 'OKE', 'OKE Base View - AP Invoices Details', 'OKE_1159_ONWARDS', 'This base view returns invoice distribution and charge allocation records associated with project contracts.', 
    'K{\footnote invoice distribution id}K{\footnote allocated amount}K{footnote po distribution id}', '11.5+', 'Y', 'NONE', 'BASEVIEW', 
    'N', 'Rvattikonda', TO_DATE('07/16/2008 21:40:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/17/2008 03:12:00', 'MM/DD/YYYY HH24:MI:SS'), 
    '5.7.1.383', '5.7.1.383');
    @utlspoff
COMMIT;
set escape on;