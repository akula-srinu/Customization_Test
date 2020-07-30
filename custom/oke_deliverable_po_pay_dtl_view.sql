-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_po_pay_dtl_view
set escape off;
--
--
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Deliverable_PO_Pay_Dtl', 'OKE', 'OKE/AP Cross Functional - Deliverable Tracking Information for Payables', 'OKE_1159_ONWARDS', 'This view returns information on payables and corresponding requisition and purchase orders, tracked by deliverables tracking system for inbound deliverables of Project Contracts. This information was supplied in Requisition, Purchasing and Payables tabs of Deliverable Tracking Information window of Oracle Project Contracts module. A record is returned for each combination of invoice distribution and corresponding charge allocation.The view returns invoice information like invoice number, invoice amount, paid and unpaid amounts, invoice date, payment and invoice currency codes. The view also provides purchase order information like purchase order number, purchase order line number, purchase order shipment number and requisition information like requisition number, line number. Project contract information like contract number, contract line number, deliverable number, project name and number, task name and number, and item number are also shown. The Record_Type column indicates whether it is a invoice distribution or charge allocation record.For optimal performance, filter the records by Contract_Number, and Deliverable_Number columns.', 
    'K{\footnote  Deliverable Tracking}K{\footnote Purchase Orders} K{\footnote Payables}K{\footnote Invoice}', '11.5+', 'Y', 'NONE', 'NONE', 
    'N', 'Rvattikonda', TO_DATE('07/15/2008 04:23:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/21/2008 03:19:00', 'MM/DD/YYYY HH24:MI:SS'), 
    '5.7.1.383', '5.7.1.383');
    @utlspoff
COMMIT;
set escape on;
