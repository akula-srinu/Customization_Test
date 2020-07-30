-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_ar_payment_sched_base_view
set escape off;
--
--SQL Statement which produced this data:
--  select * from n_view_templates where  view_label like 'OKE_AR_Payment_Sched_Base'
--
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_AR_Payment_Sched_Base', 'OKE', 'OKE Base View - Summarized Invoice Payment Schedules', 'OKE_1159_ONWARDS', 'This base view returns summarized amount values of receivables invoices from payment schedules table.', 
    NULL, '11.5+', 'Y', 'NONE', 'BASEVIEW', 
    'Y', 'kkondaveeti', TO_DATE('07/14/2008 04:27:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/18/2008 05:49:00', 'MM/DD/YYYY HH24:MI:SS'), 
    '5.7.1.383', '5.7.1.383');
    @utlspoff
COMMIT;
set escape on;