-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pa_pcontract_projects_view

set escape off;

Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_PA_PContract_Projects', 
'OKE', 
'OKE Basic - Project contract information', 
'OKE_11510_ONWARDS', 
'This view returns information on the project contracts that are associated with projects. This information is supplied in the Contracts Authoring Workbench window of the Project Contracts module in Oracle
E-Business suite. This view returns a record for a contract number.
Use this view to identify the project contracts associated to a project.
This view returns information on the contract amounts, the start and expiry dates of the contract, administrative and financial information of the contract. The view also returns project information like name, number,
start date, and completion date.
For optimal performance, filter the records by the Contract_Number, Contract_Start_Date or Contract_Expiry_Date columns.', 
'K{\footnote Project Contracts} K{\footnote Contract Expiry Date}', 
'11.5+', 
'Y', 
'NONE', 
'NONE', 
'N', 
'Rvattikonda', 
TO_DATE('06/04/2008 00:37:00', 'MM/DD/YYYY HH24:MI:SS'), 
'jbhattacharya', 
TO_DATE('07/18/2008 00:42:00', 'MM/DD/YYYY HH24:MI:SS'), 
'5.7.1.383', 
'5.7.1.383');
COMMIT;

set escape on;

@utlspoff