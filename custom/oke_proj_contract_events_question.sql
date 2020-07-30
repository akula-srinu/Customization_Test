-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_events_question
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Proj_Contract_Events', 'What are the details of billing events of a project contract?', 'Select the Contract_Number, Contract_Line_Number, Event_Number, Event_Date, Event_Processed_Flag, Revenue_Amount, Event_Type, and Billing_Line_Number columns from this view. Filter the records by the Contract_Number column.', '10.7+', 'pvemuru', TO_DATE('07/20/2008 23:33:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', TO_DATE('07/20/2008 23:33:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 3, 57446);
COMMIT;
@utlspoff