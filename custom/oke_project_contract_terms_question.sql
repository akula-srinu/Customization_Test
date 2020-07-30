-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_terms_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Project_Contract_Terms', 'What are the terms and conditions for a specific project contract ?', 'select the Contract_Number, Contract_Start_Date, Contract_Expiration_Date, Term_Name, Term_Value, Term_Value_Description, Term_Value_Start_Date, Term_Value_End_Date, Operating_Unit_Name columns from this view. For optimal performance filter the records by Contract_Number.', '11.5+', 'hpothuri', TO_DATE('12/18/2008 22:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 22:53:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57889);
@utlspoff
COMMIT;
