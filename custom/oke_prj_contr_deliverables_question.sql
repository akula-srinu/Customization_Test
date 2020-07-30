-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_deliverables_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Prj_Contr_Deliverables', 'What are the billable deliverable lines for a given contract number?', 'Select the Contract_Number, Contract_Status, Contract_Type_Class, Contract_Type_Name, Delivery_Date, Delivery_Line_Quantity, End_Date, Hold_Flag, Hold_Reason, Hold_Status, Project_Name, Task_Name, Item_Number, Item_Description, Delivery_Line_Quantity, Shipped_Quantity columns from this view. For optimal performance filter the reocrds by Contract_Number.', '11.5+', 'hpothuri', TO_DATE('07/21/2008 00:06:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/21/2008 00:27:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57449);

COMMIT;

@utlspoff