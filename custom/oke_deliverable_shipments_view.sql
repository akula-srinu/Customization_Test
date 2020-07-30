-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_shipments_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Deliverable_Shipments', 
   'OKE', 
   'OKE/OM Cross Functional - Delivery Tracking Information for Shipping', 
   'OKE_1159_ONWARDS', 
   'This view returns information on the shipments for deliverables of project contracts. This information is displayed on the Shipping tab of Deliverable Tracking Information window of the Oracle Project Contracts module.  A record is return for each shipping transaction of deliverable line of project contract line. Use the view for status of shipment, after doing initiate shipping process in Oracle Project Contracts for a delivery line. This view provides shipping details like shipping date, packing slip number, bill of lading number and source and destination locations of shipment. This view provides delivery line details like delivery number, delivery status. The view gives details of how much quantity of item has been requested, shipped, cancelled and delivered.  The view provides contract details like numbers, line numbers, and types. For optimal performance, filter the records by the Contract_Number and Deliverable_Number columns.', 'K{\footnote Contract Line Delivery} K{\footnote Delivery Shipping}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'kkondaveeti', TO_DATE('07/14/2008 23:58:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/21/2008 03:29:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');

COMMIT;
set escape on;
@utlspoff