-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_events_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Proj_Contract_Events', 'OKE', 'OKE Basic - Billing Events Of Deliverables', 'OKE_1159_ONWARDS', 'This view returns information on the billing events for project contracts deliverables. This information is displayed on the Billing Information tab, Reference Information tab of the Event Details window of the Oracle Project Contracts module.  A record is return for each billing event.Use this view for getting information of all events raised against project contract deliverables even if the billing process initiated or not.This view provides event details like dates, types, numbers, currencies, billing project details, bill amounts, and revenue amounts. This view provides contract details like numbers, line numbers, and deliverables details. This view provides information of funding references. Billing_Initiated_Flag indicates if the event has been initiated for billing. Event_Processed_Flag indicates if the draft invoice generation is completed for this event in Oracle Projects.For optimal performance, filter the records by the Contract_Number, and Deliverable_Number columns.', 'K{\footnote Billing Events} K{\footnote Events}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'pvemuru', TO_DATE('07/15/2008 03:43:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('07/21/2008 04:33:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
@utlspoff