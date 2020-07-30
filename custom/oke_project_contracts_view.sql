-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contracts_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Project_Contracts', 'OKE', 'OKE Basic - Project contract information', 'OKE_1159_ONWARDS', 'This view returns information on the project contracts and the associated projects (if any). This information is supplied in the Contracts Authoring Workbench window of the Project Contracts module in Oracle E-Business suite. This view returns one record for a combination of contract number and contract type.
Use this view to track the current status of contracts. This view can also be used to find upcoming expiry of contracts.
This view returns information on project contracts such as number, description, type, current status, the start and expiry dates, total amount, firm and non-firm total amounts. The view provides information about the life cycle of the contracts like authorize date, approval date, signed date, award date. The view also displays financial information of the contract.  The Definitized_Flag column indicates whether the contract is definitized. The Contract_Template_Flag column indicates whether the contract is a template. The Financial_Cntrl_Verified_Flg column indicates whether  the financial control has been verified or not. The Not_Exceed_Warning_Reqd_Flag indicated whether or not a warning is displayed when the bill amount exceeds the contract total amount. The Cust_Quality_Accept_Reqd_Flg indicates whether or not the customer quality acceptance is required. Contract_Termination_Flag column indicates whether the project contract is terminated or not.
For optimal performance, filter the records by the Contract_Number, Contract_Start_Date or Contract_Expiry_Date columns.', 'K{\footnote Project Contracts} K{\footnote Contract Expiry Date}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'Rvattikonda', TO_DATE('06/04/2008 00:37:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/21/2008 03:38:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
@utlspoff