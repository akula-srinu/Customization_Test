-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_sources_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 'OKE', 'OKE Basic - Funding source detail information', 'OKE_1159_ONWARDS', 'This view returns information on the funding sources for project contracts. This information is displayed on the Funding Workbench window of the Oracle Project Contracts module. A record is return for each funding source. This view provides funding details like amounts, effective dates, currencies, statuses, invoice hard limits, and agreement organizations. This view provides contract details like numbers, versions, and statuses. This view provides information of party and funding pool name. For optimal performance, filter the records by the Party_Number column.', 'K{\footnote Funding} K{\footnote Fund Sources}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'kkondaveeti', TO_DATE('06/26/2008 22:34:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/17/2008 23:35:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');

COMMIT;
set escape on;
@utlspoff