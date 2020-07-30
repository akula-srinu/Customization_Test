-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_po_pay_dtl_help_que
--
--SQL Statement which produced this data:
--  select * from n_help_questions_templates where  view_label like 'OKE_Deliverable_PO_Pay_Dtl'
--
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, KEYWORDS, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Deliverable_PO_Pay_Dtl', 'What are the invoice information for a given deliverable number?', 'Select the Contract_Number, Contract_Line_Number, Deliverable_Number, Item_Number, Invoice_Number, Invoice_Date,
 Invoice_Amount, Invoice_Currency_Code, Invoice_Paid_Amount, Invoice_Unpaid_Amount, Supplier_Name, Supplier_Site_Code columns from this view. For optimal performance, filter the records by Contract_Number, Contract_Line_Number and Deliverable_Number columns.', NULL, 
    NULL, '10.7+', 'Rvattikonda', TO_DATE('07/21/2008 00:05:00', 'MM/DD/YYYY HH24:MI:SS'), 'pvemuru', 
    TO_DATE('07/21/2008 01:54:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57456);
    @utlspoff
COMMIT;
