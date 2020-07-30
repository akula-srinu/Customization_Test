-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contract_parties_question
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Proj_Contract_Parties', 'What are the contract roles for a given party?', 'Select the Contract_Party_Name, Contract_Party_Role_Name, Contract_Number, Contract_Party_Description, and Contract_Party_Known_As columns from this view.Filter the records by Contract_Party_Name. For optimal performance, filter the records by Contract_Number.', '11.5+', 'hpothuri', TO_DATE('06/10/2008 02:53:00', 'MM/DD/YYYY HH24:MI:SS'), 'jbhattacharya', TO_DATE('06/10/2008 07:22:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 56981);
COMMIT;
@utlspoff