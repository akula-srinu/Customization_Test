-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pcontract_print_forms_view

set escape off;

Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_PContract_Print_Forms', 
'OKE', 
'OKE Basic - Print Forms of Project Contracts and Lines', 
'OKE_1159_ONWARDS', 
'This view returns information on the print forms of project contracts and the associated projects (if any). This information is supplied in the Print Forms tab of Contracts Authoring Workbench window of the
Project Contracts module in Oracle E-Business suite.A record is returned for each combination of contract, line (if available) and print form. 
Use this view for getting information about print forms that are associated with project contracts and corresponding lines.
This view returns contract details such as contract number, description, version, award, start and expiration dates, status, type and contract line number.This view also shows project number and name.
The view shows information about print forms such as name, description, type, start and end dates, creation date and user name who created it.
The Print_Form_Required_Flag column indicates whether or not the print form is mandatory. The Customer_Furnished_Flag column indicates whether or not customer is supplying the form.
The Print_Form_Completed_Flag column indicates whether or not the print form has sufficient data to fulfill all the requirements.
For optimal performance, filter the records by the Contract_Number column.', 
'K{\footnote Project Contract} K{\footnote Project Contract Line} K{\footnote Print Form}', 
'11.5+', 
'Y', 
'NONE', 
'NONE', 
'N', 
'jbhattacharya', 
TO_DATE('03/09/2009 05:03:00', 'MM/DD/YYYY HH24:MI:SS'), 
'jbhattacharya', 
TO_DATE('03/12/2009 23:08:00', 'MM/DD/YYYY HH24:MI:SS'), 
'5.7.1.383', '5.7.1.383');
COMMIT;

set escape on;

@utlspoff

