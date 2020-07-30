-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_deliverables_seeother
--
--SQL Statement which produced this data:
--  select * from N_HELP_SEE_OTHER_TEMPLATES where view_label like 'OKE_Prj_Contr_Deliverables'
--
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 'OKE_Deliverable_PO_Pay_Dtl', '[View Essay]', NULL, '11.5+', 
    'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 'OKE_Deliverable_PO_Rcp_Dtl', '[View Essay]', NULL, '11.5+', 
    'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 'OKE_Deliverable_Receivables', '[View Essay]', NULL, '11.5+', 
    'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 'OKE_Deliverable_Shipments', '[View Essay]', NULL, '11.5+', 
    'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 'OKE_Deliverable_Subcontrs', '[View Essay]', NULL, '11.5+', 
    'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/22/2008 07:29:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Prj_Contr_Deliverables', 'OKE_Deliverable_Std_Notes', '[View Essay]', '11.5+', 'hpothuri', TO_DATE('12/19/2008 06:33:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/19/2008 06:33:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;

@utlspoff
