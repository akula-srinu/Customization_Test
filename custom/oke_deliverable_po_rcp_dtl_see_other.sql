-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_po_rcp_dtl_see_other
--
--SQL Statement which produced this data:
--  select * from N_HELP_SEE_OTHER_TEMPLATES where view_label like 'OKE_Deliverable_PO_Rcp_Dtl'
--
Insert into N_HELP_SEE_OTHER_TEMPLATES
   (VIEW_LABEL, SEE_OTHER_VIEW_LABEL, HINT, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('OKE_Deliverable_PO_Rcp_Dtl', 'OKE_Deliverable_PO_Pay_Dtl', '[View Essay]', NULL, NULL, 
    'hpothuri', TO_DATE('07/17/2008 05:20:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/18/2008 04:29:00', 'MM/DD/YYYY HH24:MI:SS'));
@utlspoff
COMMIT;
