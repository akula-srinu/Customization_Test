-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_alloctn_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Prj_Contr_Fund_Alloctn', 'What are the funding allocations for a given project', 'Select the Contract_Number,Contract_Line_Number,Contract_Line_Start_Date,Contract_Line_End_Date,Project_Number,Project_Name,Task_Name,Task_Number,Fund_Allocation_Reference1,Fund_Allocation_Reference2,Fund_Allocation_Reference3, Funding_Agreement_Version, Allocation_Created_Version, Allocation_Updated_Version columns from this view. For optimal performance, filter the records by Contract_Number,Project_Number', '10.7+', 'Rvattikonda', TO_DATE('07/21/2008 00:07:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/21/2008 00:12:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57459);

COMMIT;

@utlspoff