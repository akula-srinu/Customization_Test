-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_prj_contr_funding_hist_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Prj_Contr_Funding_Hist', 'What is the funding amount history for a given contract number', 'Select the Contract_Number,Contract_Version,Funding_Status,Funding_Version,Total_Funded_Amount,
Revenue_Hard_Limit,Invoice_Hard_Limit,Previous_Amount,Amount,Initial_Amount,Agreement_Number,Party_Name,Party_Number columns from this view. For optimal performance, filter the records by Contract_Number,Party_Number.', '10.7+', 'Rvattikonda', TO_DATE('07/21/2008 00:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('07/21/2008 00:16:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57472);

COMMIT;

@utlspoff