-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_receivables_view
set escape off;
--

Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Deliverable_Receivables', 'OKE', 'OKE/AR Cross Functional - Deliverable Tracking Information for Receivables', 'OKE_1159_ONWARDS', 'This view returns information on receivables made against deliverables of project contracts. This information is displayed in the Deliverable Tracking Information window of the Oracle Project Contracts module.  A record is returned for each receivable transaction line of project contract deliverable.This view provides invoice details like draft invoice number, draft invoice line, invoice date, invoice currency, invoice amount due, invoice amount remaining. This view also provides contract details like contract number, line number and delivery details like delivery number and item details like item, item description and quantity and also event details like event number.For optimal performance, filter the records by the Contract_Number.', 
    'K{\footnote Deliverable} K{\footnote Receivables}', '11.5+', 'Y', 'NONE', 'NONE', 
    'N', 'kkondaveeti', TO_DATE('07/16/2008 03:10:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/21/2008 03:15:00', 'MM/DD/YYYY HH24:MI:SS'), 
    '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
    @utlspoff