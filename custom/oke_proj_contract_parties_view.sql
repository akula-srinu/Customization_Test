-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_parties_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Proj_Contract_Parties', 'OKE', 'OKE Basic - Project contract party information', 'OKE_1159_ONWARDS', 'This view returns information on the parties and their roles related to project contracts. This information is supplied in the Parties and Contacts tab of the Contract Authoring Workbench window of Project Contracts module in Oracle E-Business suite. A record is returned for a combination of contract number, party name and role.
Use this view to identify the different roles that parties perform for a contract.
This view returns information on the contract, contract party and the role. The Small_Business_Flag indicates whether or not the party is a small business establishment. The Women_Owned_Flag indicates whether the party is owned by women or not.
For optimal performance, filter the records by the Contract_Number or Contract_Party_Name columns.', 'K{\footnote Project Contracts} K{\footnote Parties} K{\footnote Roles}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'kkondaveeti', TO_DATE('06/06/2008 03:02:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/27/2008 06:19:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
@utlspoff