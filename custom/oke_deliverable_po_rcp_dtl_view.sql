-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_po_rcp_dtl_view
set escape off;
--

Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Deliverable_PO_Rcp_Dtl', 'OKE', 'OKE/PO Cross Functional - Deliverable Tracking Info from Requisition to Receipt', 'OKE_1159_ONWARDS', 'This view returns information on requisitions, purchase orders, and receipts tracked by deliverables tracking system of deliverables of Project Contracts.This information was supplied in Requisition, Purchasing, and Receiving tabs of Deliverable Tracking Information window of Oracle Project Contracts module.A record is returned for each combination of receipt line.Use this view for tracking information on procure to receipt for a deliverable line.This view provides requisitions information like numbers, quantities, and buyers.The view provides purchase orders information like order numbers, ordered quantities, and shipped quantities.The view returns receiving information like receipt numbers, transaction types, and planned receipt dates.The view also returns contracts information like contract numbers, contract line numbers and deliverable numbers.For optimal performance, filter the records by Contract_Number, Deliverable_Number columns.', 
    'K{\footnote  Deliverable Tracking}K{\footnote Requisition}K{\footnote Purchase Orders} K{\footnote Receiving}', '11.5+', 'Y', 'NONE', 'NONE', 
    'N', 'Rvattikonda', TO_DATE('07/15/2008 01:06:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/21/2008 03:11:00', 'MM/DD/YYYY HH24:MI:SS'), 
    '5.7.1.383', '5.7.1.383');
    @utlspoff
COMMIT;
set escape on;