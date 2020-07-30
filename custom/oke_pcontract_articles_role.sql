-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pcontract_articles_role
--
--SQL Statement which produced this data:
--  select * from n_role_view_templates t1 where t1.VIEW_LABEL = 'OKE_PContract_Articles'
--
Insert into N_ROLE_VIEW_TEMPLATES
   (ROLE_LABEL, VIEW_LABEL, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PROJECT_CONTRACTS', 'OKE_PContract_Articles', '11.5+', 'rvattikonda', TO_DATE('03/13/2009 04:29:00', 'MM/DD/YYYY HH24:MI:SS'), 
    'rvattikonda', TO_DATE('03/13/2009 04:29:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;
@utlspoff