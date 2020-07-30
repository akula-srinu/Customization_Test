-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_project_contract_lines_question
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Project_Contract_Lines', 'What are the Item manufacturing completed contract lines for a given contract?', 'Select the Contract_Number, Contract_Award_Date, Contract_Description, Contract_Expiry_Date, Contract_Intent, Contract_Priority_Code,Contract_Status, Contract_Type, Contract_Value, Contract_Version, Contract_Value, Item_Number, Customer_Item_Number, Export_Flag, Hold_Flag, Hold_Schedule_Remove_Date, Hold_Status, Hold_Type, Line_Number, Line_Billing_Method, Line_Termination_Date, Parent_Line_Number columns from this view. For optimal performance filter the records by Contract_Number.', '11.5+', 'hpothuri', TO_DATE('07/21/2008 01:01:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/21/2008 01:10:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57478);
COMMIT;
@utlspoff