-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_ar_payment_sched_base_query
--
--SQL Statement which produced this data:
--  select * from n_view_query_templates where  view_label like 'OKE_AR_Payment_Sched_Base'
--
Insert into N_VIEW_QUERY_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, UNION_MINUS_INTERSECTION, GROUP_BY_FLAG, PROFILE_OPTION, PRODUCT_VERSION, VIEW_COMMENT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_AR_Payment_Sched_Base', 1, NULL, 'Y', NULL, 
    '%', NULL, 'kkondaveeti', TO_DATE('07/14/2008 04:30:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', 
    TO_DATE('07/14/2008 04:39:00', 'MM/DD/YYYY HH24:MI:SS'));
    @utlspoff
COMMIT;
