-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_fund_sources_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Prj_Contr_Fund_Sources', 'What are the funding sources for a given contract number', 'Select the Contract_Number,Contract_Version,Party_Name,Party_Number,Funding_Pool_Name,Invoice_Hard_Limit, Revenue_Hard_Limit,Funding_Amount,Effective_Start_Date,Effective_End_Date,Fund_Across_Oper_Unit, Exchange_Rate,Exchange_Rate_Date,Exchange_Rate_Type_Code,Agreement_Organization_Name columns from this view. For optimal performance, filter the records by Contract_Number,Party_Number.', '10.7+', 'Rvattikonda', TO_DATE('07/21/2008 00:09:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/21/2008 00:13:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57463);

COMMIT;

@utlspoff