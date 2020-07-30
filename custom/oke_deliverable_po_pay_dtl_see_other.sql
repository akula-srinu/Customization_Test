-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_po_pay_dtl_see_other
--
--SQL Statement which produced this data:
--  select * from N_HELP_SEE_OTHER_TEMPLATES where view_label like 'OKE_Deliverable_PO_Pay_Dtl'
--
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Deliverable_PO_Pay_Dtl', 'OKE_Deliverable_PO_Rcp_Dtl', '[View Essay]', NULL, '%', 
    'hpothuri', TO_DATE('07/17/2008 05:13:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:28:00', 'MM/DD/YYYY HH24:MI:SS'));
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Deliverable_PO_Pay_Dtl', 'OKE_Prj_Contr_Deliverables', '[View Essay]', NULL, '%', 
    'hpothuri', TO_DATE('07/17/2008 05:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/17/2008 05:15:00', 'MM/DD/YYYY HH24:MI:SS'));
@utlspoff
COMMIT;
