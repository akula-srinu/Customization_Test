-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_receivables_role
--
--SQL Statement which produced this data:
--  select * from n_role_view_templates where  view_label like 'OKE_Deliverable_Receivables'
--
Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_Deliverable_Receivables', '11.5+', 'kkondaveeti', TO_DATE('07/16/2008 23:55:00', 'MM/DD/YYYY HH24:MI:SS'), 
    'pvemuru', TO_DATE('07/18/2008 04:13:00', 'MM/DD/YYYY HH24:MI:SS'));
    @utlspoff
COMMIT;
