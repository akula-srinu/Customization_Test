-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_roles_question
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Project_Contract_Roles', 'Who are the employees assigned to a contract role ?', 'Select the Employee_Role_Name, Employee_Name, Contract_Number, Employee_Role_Start_Date, Employee_Role_End_Date, Workflow_Usage_Type_Name, and Approval_Workflow_Name from this view. For optimal performance, filter the records by Contract_Number or Employee_Name.', '11.5+', 'hpothuri', TO_DATE('06/10/2008 02:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('06/23/2008 06:58:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 56978);
COMMIT;
@utlspoff