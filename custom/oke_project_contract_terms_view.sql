-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_terms_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Project_Contract_Terms', 'OKE', 'OKE Basic - Information about Terms and Conditions of Project Contracts', 'OKE_1159_ONWARDS', 'This view returns information on the terms and conditions of project contracts. This information is supplied in the Terms and Conditions tab of the Contract Authoring Workbench window of Project Contracts module in Oracle E-Business suite. A record is returned for each combination of contract and terms. Use this view for getting information about the different terms and conditions that are associated with a project contract. This view returns contract details such as contract number, start and expiration dates, status, type and contract line number. This view also shows project number and name. The view shows information about term name and type and term value and description and start and end dates of term value. The User_Defined_Flag indicates whether or not the term is defined by the user or not. For optimal performance, filter the records by the Contract_Number.', 'K{\footnote Project Contract} K{\footnote Project Contract Line} K{\footnote Terms and Conditions}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'jbhattacharya', TO_DATE('12/16/2008 22:09:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 22:45:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
@utlspoff