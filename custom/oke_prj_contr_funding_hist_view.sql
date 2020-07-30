-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_funding_hist_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 'OKE', 'OKE Basic - Funding Allocation History Information', 'OKE_1159_ONWARDS', 'This view returns historic information on the funding allocation for project contracts. This information is displayed on the Funding History window of the Oracle Project Contracts module.  A record is return for each funding source and version.This view provides funding details like amounts, effective dates, currencies, statuses, and invoice hard limits. This view provides contract details like numbers, versions, and statuses. This view provides funding history information like initial amount, previous amount, and current amount.For optimal performance, filter the records by the Contract_Number column.', 'K{\footnote Funding} K{\footnote Funding History}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'kkondaveeti', TO_DATE('06/30/2008 02:23:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/21/2008 03:35:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');

COMMIT;
set escape on;
@utlspoff