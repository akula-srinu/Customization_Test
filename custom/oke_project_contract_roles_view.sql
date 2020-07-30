-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_roles_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Project_Contract_Roles', 'OKE', 'OKE Basic - Project Contract employee roles', 'OKE_1159_ONWARDS', 'This view returns information on the employees who are assigned to the different roles of the project contract. This information is supplied in the Administration tab of the Contract Authoring Workbench window of the Project Contracts module in Oracle E-Business suite. A record is returned for a combination of contract usage type, employee, role, and start date.Use this view to identify the employees who are associated with a contract.This view provides information on the employee, role, start date, end date and the approval process workflow.For optimal performance, filter the records by the Contract_Number.', 'K{\footnote Project Contracts} K{\footnote Employee Roles}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'Rvattikonda', TO_DATE('06/09/2008 05:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:19:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
@utlspoff
