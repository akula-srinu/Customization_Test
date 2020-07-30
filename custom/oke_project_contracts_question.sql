-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contracts_question
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Project_Contracts', 'What are the contracts that expire in the next 30 days?', 'Select the Contract_Number, Contract_Short_Description, Contract_Description, Contract_Value, Contract_Currency_Code, Contract_Start_Date, Contract_Expiry_Date, Contract_Received_Date, and Contract_Status columns from this view. Filter the records where the Contract_Expiry_Date is between sysdate and (sysdate + 30). For optimal performance, filter the records by Contract_Number and Contract_Expiry_Date.', '11.5+', 'hpothuri', TO_DATE('06/10/2008 02:26:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('06/23/2008 06:23:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 56975);
COMMIT;
@utlspoff