-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pa_pcontract_projects_question
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, KEYWORDS, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_PA_PContract_Projects', 'What are the contracts associated to a project?',  'Select the Contract_Number, Contract_Short_Description, Contract_Description, Contract_Value, Contract_Currency_Code, Contract_Start_Date, Contract_Expiry_Date, Contract_Received_Date, and Contract_Status columns from this view.For optimal performance, filter the records by Project_Number or Project_Name column.', NULL, 
    NULL, '11.5+', 'hpothuri', TO_DATE('06/10/2008 02:26:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', 
    TO_DATE('06/10/2008 06:57:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 58222);
COMMIT;
@utlspoff