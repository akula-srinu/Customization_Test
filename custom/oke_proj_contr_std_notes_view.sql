-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contr_std_notes_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Proj_Contr_Std_Notes', 'OKE', 'OKE Basic - Information about Standard Notes of Project Contracts', 'OKE_1159_ONWARDS', 'This view returns information on the project contracts standard notes and the associated projects (if any). This information is supplied in the Standard Notes tab of Contracts Authoring Workbench window of the Project Contracts module in Oracle E-Business suite. A record is returned for each combination of a contract and standard note. Use this view for getting information about standard notes of project contracts that are associated with a project contract. This view returns contract details such as contract number, start and expiration dates, status, type and contract line number. This view also shows project number and name. The view shows information about standard note such as name, description, type, text, creation date and user name who created the note. For optimal performance, filter the records by the Contract_Number.', 'K{\footnote Project Contract} K{\footnote Standard Note}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'hpothuri', TO_DATE('12/10/2008 23:02:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 22:39:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
@utlspoff 