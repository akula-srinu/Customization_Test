-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pcontract_print_forms_question
--
--SQL Statement which produced this data:
--  select * from  n_help_questions_templates t3 where t3.VIEW_LABEL = 'OKE_PContract_Print_Forms'
--
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_PContract_Print_Forms', 'What are the customer furnished print forms associated to a project contract?', 'Select Contract_Number, Contract_Start_Date, Contract_Expiration_Date, Contract_Version, Contract_Type_Name, Contract_Status, Contract_Line_Number, Billable_Flag, Line_Billing_Method, Line_Firm_Total_Amount, Line_Firm_Unit_Price, Line_Quantity, Item_Number, Item_Description, Shippable_Flag, Project_Name, Project_Number, Print_Form_Code, Print_Form_Name, Print_Form_Description, Print_Form_Type_Name, Print_Form_Context, Print_Form_Creation_Date, Print_Form_Start_Date, Print_Form_End_Date, Print_Form_Completed_Flag, Print_Form_Required_Flag, Customer_Furnished_Flag from this view.

Filter the records by the Customer_Furnished_Flag,Contract_Number columns, where Customer_Furnished_Flag is "Y"  
For optimal performance, filter the records by Contract_Number column.
', '10.7+', 'jbhattacharya', TO_DATE('03/17/2009 02:51:00', 'MM/DD/YYYY HH24:MI:SS'), 'rvattikonda', TO_DATE('03/17/2009 04:02:00', 'MM/DD/YYYY HH24:MI:SS'), 2, 1, 57953);
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_PContract_Print_Forms', 'What are the print forms associated to a project contract?', 'Select Contract_Number, Contract_Start_Date, Contract_Expiration_Date, Contract_Version, Contract_Type_Name, Contract_Status, Contract_Line_Number, Billable_Flag, Item_Number, Item_Description, Shippable_Flag, Project_Name, Project_Number, Print_Form_Code, Print_Form_Name, Print_Form_Description, Print_Form_Type_Name, Print_Form_Context, Print_Form_Creation_Date, Print_Form_Start_Date, Print_Form_End_Date, Print_Form_Completed_Flag, Print_Form_Required_Flag, Customer_Furnished_Flag from this view.

For optimal performance, filter the records by Contract_Number column.
', '10.7+', 'jbhattacharya', TO_DATE('03/09/2009 06:51:00', 'MM/DD/YYYY HH24:MI:SS'), 'rvattikonda', TO_DATE('03/17/2009 03:48:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57938);
COMMIT;
@utlspoff