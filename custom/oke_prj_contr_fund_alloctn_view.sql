-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_alloctn_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 'OKE', 'OKE Basic - Funding allocation information', 'OKE_1159_ONWARDS', 'This view returns allocation level information on the funding source for project contract lines. This information is displayed on the Fund Allocations window of the Oracle Project Contracts module in Oracle E-Business suite. A record is returned for each funding allocation line for the funding party. Use this view for getting information about allocation of funding amounts to the contract lines. These are contract lines are associated with the project or task. Use this view to tract the funded amount for the contract line or project or task for a funding party. This view returns funding party name and funding source currency code. This view provides information of contract line number and description, start date, end date, funding status, funding type and funding amount. This view also provides details about the projects and tasks. The amount columns are shown in invoice hard limit amount and revenue hard limit amounts. This view also displays agreement conversion type, agreement rate and agreement date columns. For optimal performance, filter the records by the Contract_Line_Number column.', 'K{\footnote Funding Allocations} K{\footnote Funding}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'Rvattikonda', TO_DATE('06/27/2008 04:33:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/29/2008 23:34:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');

set escape on;

COMMIT;

@utlspoff