-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_pcontract_articles_question
--
--
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_PContract_Articles', 'What are the standard articles associated to the lines of a project contract?', 'Select Contract_Number, Contract_Start_Date,Contract_Termination_Date, Contract_Expiry_Date, Contract_Line_Number, Item_Number, Item_Description,Line_Quantity, Line_Status, Line_Start_Date,Line_Termination_Date, Line_Style_Name, Project_Name,Project_Number, Task_Name, Task_Number,Total_Estimated_Cost, Article_Name, Article_Subject,Article_Status, Article_Text, Article_Release_Number, Article_Comment, Article_Start_Date, Article_End_Date, Article_Creation_Date columns from the view.Filter the records by the Standard_Article_Flag and Article_Context columns, where Standard_Article_Flag is "Y" and Article_Context is "Line".For optimal performance, filter the records by Contract_Number column.', '10.7+', 'jbhattacharya', TO_DATE('03/16/2009 21:52:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('03/17/2009 02:49:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57943);
COMMIT;
@utlspoff