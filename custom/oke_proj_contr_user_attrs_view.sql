-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contr_user_attrs_view
set escape off;
Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_Proj_Contr_User_Attrs', 'OKE', 'OKE Basic - User attributes for a project contract', 'OKE_1159_ONWARDS', 'This view returns information on the user attributes defined for a project contract at header and line level. This information is supplied in the User Attributes tab of the Contract Authoring Workbench of the Project Contracts module in Oracle E-Business Suite. A record is returned for a combination of contract number, user attribute group, user attribute context and the UATR$ columns.This view returns information on the project contract. Information on the contract type, value, start date expiry date, and award date are returned by this view. The User_Attribute_Group_Name column describes the attribute group name to which the attribute belongs. The User_Attribute_Level column indicates whether the user attributes are defined at the contract or line level.For optimal performance, filter the records by the Contract_Number, Contract_Start_Date or Contract_Expiry_Date.', 'K{\footnote Project Contracts} K{\footnote User Attributes}', '11.5+', 'Y', 'NONE', 'NONE', 'N', 'Rvattikonda', TO_DATE('06/06/2008 02:46:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/20/2008 21:52:00', 'MM/DD/YYYY HH24:MI:SS'), '5.7.1.383', '5.7.1.383');
COMMIT;
set escape on;
@utlspoff