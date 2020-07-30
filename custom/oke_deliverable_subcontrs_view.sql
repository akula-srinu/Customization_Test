-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_subcontrs_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Deliverable_Subcontrs', 'OKE', 'OKE Basic - Deliverable Subcontracts information', 'OKE_1159_ONWARDS', 'This view returns information on subcontracts tracked by deliverables tracking system for deliverables of project contracts. This information was supplied in Subcontract tab of Deliverable Tracking Information window of Oracle Project Contracts module in Oracle E-Business suite. A record is returned for each combination of contract number, contract line, contract deliverable number, subcontract number, subcontract line, and subcontract deliverable number. The view returns subcontract information like subcontract status and actual shipment date of an item and item quantity. This view provides contracts information like contract number and deliverable numbers and contract description. For optimal performance, filter the records by Contract_Number, Subcontract_Number, and Deliverable_Number columns.', 'K{\footnote Deliverable} K{\footnote Subcontracts}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'kkondaveeti', TO_DATE('07/16/2008 22:36:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/20/2008 21:52:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');

COMMIT;
set escape on;
@utlspoff