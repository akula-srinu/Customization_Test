-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_proj_contr_user_attrs_question
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Proj_Contr_User_Attrs', 'What are the user attributes for a given contract number?', 'Select the Contract_Number, Contract_Expiry_Date, Contract_Start_Date, Contract_Award_Date, Contract_Type_Name, Contract_Value, ContrUAtr$A,  User_Attribute_Description, User_Attribute_Group_Name columns from this view. For optimal performance, filter the records by Contract_Number.
', '11.5+', 'hpothuri', TO_DATE('06/10/2008 03:05:00', 'MM/DD/YYYY HH24:MI:SS'), 'Rvattikonda', TO_DATE('06/23/2008 06:21:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 56985);
COMMIT;
@utlspoff