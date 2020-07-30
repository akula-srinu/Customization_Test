-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_po_rcp_dtl_help_que
--
--SQL Statement which produced this data:
--  select * from n_help_questions_templates where  view_label like 'OKE_Deliverable_PO_Rcp_Dtl'
--
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, KEYWORDS, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Deliverable_PO_Rcp_Dtl', 'What is the receivables information for a given deliverable number?', 'Select the Contract_Number, Contract_Line_Number, Deliverable_Number, Item_Number, Receipt_Number, Receipt_Line_Number,Transaction_Quantity, Receipt_Item_UOM_Code, Planned_Receipt_Date, Actual_Receipt_Date, Transaction_Type
columns from this view.For optimal performance, filter the records by Contract_Number, Contract_Line_Number, and Deliverable_Number column.', NULL, 
    NULL, '10.7+', 'Rvattikonda', TO_DATE('07/21/2008 00:04:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', 
    TO_DATE('07/21/2008 01:52:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57452);
    @utlspoff
COMMIT;
