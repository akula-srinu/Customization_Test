-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_std_notes_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Deliverable_Std_Notes', 'What are the standard notes for a project contract deliverable line ?', 'select the Contract_Number, Contract_Line_Number, Delivery_Date, Deliverable_Number, Contract_Start_Date, Contract_Expiration_Date, Standard_Note_Type, Standard_Note_Description, Standard_Note_Text, Project_Name, Operating_Unit_Name columns from this view. For optimal performance filter the records by Contract_Number.', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 22:48:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57857);
@utlspoff
COMMIT;
