-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pcontract_articles_view
--
--SQL Statement which produced this data:
--  select * from n_view_templates t1 where t1.VIEW_LABEL = 'OKE_PContract_Articles'
--
set escape off

Insert into N_VIEW_TEMPLATES
   (VIEW_LABEL, APPLICATION_LABEL, DESCRIPTION, PROFILE_OPTION, ESSAY, KEYWORDS, PRODUCT_VERSION, EXPORT_VIEW, SECURITY_CODE, SPECIAL_PROCESS_CODE, FREEZE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGINAL_VERSION, CURRENT_VERSION)
 Values
   ('OKE_PContract_Articles', 
'OKE', 
'OKE Basic - Articles of Project Contracts and Lines', 
'OKE_1159_ONWARDS', 
'This view returns information on the articles of project contracts and the associated projects (if any). This information is supplied in the Articles tab of Contracts Authoring Workbench window of the
Project Contracts module in Oracle E-Business suite. A record is returned for each combination of contract, line (if available) and article.
Use this view for getting information about articles that are associated with project contracts and corresponding lines.
This view returns details of contract such as number, description, version, award, start and expiration dates, status, type and details of contract line such as number, status, style, start, end and termination dates,
item number and description, quantity, firm unit price, firm total amount and estimated cost. This view also shows project number and name, task name and number. The view shows information about articles
such as name, subject, release number, start and end dates, text, status, creation date and user name who created it.
The Article_Context column indicates whether the article belongs to contract header or contract line.
The Standard_Article_Flag column indicates whether or not the article is a standard article.
For optimal performance, filter the records by the Contract_Number column.', 
'K{\footnote Project Contract} K{\footnote Project Contract Line} K{\footnote Article}', 
'11.5+', 
'Y', 
'NONE', 
'NONE', 
'N', 
'jbhattacharya', 
TO_DATE('03/12/2009 23:07:00', 'MM/DD/YYYY HH24:MI:SS'), 
'jbhattacharya', 
TO_DATE('03/16/2009 22:01:00', 'MM/DD/YYYY HH24:MI:SS'), 
'5.7.1.383', '5.7.1.383');

COMMIT;

set escape on

@utlspoff
