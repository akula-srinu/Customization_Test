-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_subcontrs_question

Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Deliverable_Subcontrs', 'What are the subcontracts for a given contract number?', 'Select the Contract_Number, Contract_Type_Name, Contract_Line_Number, Actual_Ship_Date, Deliverable_Number, Item_Quantity, Subcontract_Line_Number, Subcontract_Number, Subcontract_Status, Subcontract_Status columns from this view. For optimal performance filter the records by Contract_Number.', '11.5+', 'hpothuri', TO_DATE('07/20/2008 23:17:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('07/20/2008 23:17:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57438);

COMMIT;

@utlspoff