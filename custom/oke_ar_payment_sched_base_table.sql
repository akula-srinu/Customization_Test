-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_ar_payment_sched_base_table
--
--SQL Statement which produced this data:
--  select * from n_view_table_templates where  view_label like 'OKE_AR_Payment_Sched_Base'
--
Insert into N_VIEW_TABLE_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, TABLE_ALIAS, FROM_CLAUSE_POSITION, APPLICATION_LABEL, TABLE_NAME, PROFILE_OPTION, PRODUCT_VERSION, BASE_TABLE_FLAG, KEY_VIEW_LABEL, SUBQUERY_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_AR_Payment_Sched_Base', 1, 'PSHD', 1, 'AR', 
    'AR_PAYMENT_SCHEDULES_ALL', NULL, '%', 'Y', NULL, 
    'N', 'kkondaveeti', TO_DATE('07/14/2008 04:31:00', 'MM/DD/YYYY HH24:MI:SS'), 'kkondaveeti', TO_DATE('07/14/2008 04:31:00', 'MM/DD/YYYY HH24:MI:SS'), 
    'N');
    @utlspoff
COMMIT;
