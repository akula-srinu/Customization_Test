-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_receivables_help_que
--
--SQL Statement which produced this data:
--  select * from n_help_questions_templates where  view_label like 'OKE_Deliverable_Receivables'
--
Insert into N_HELP_QUESTIONS_TEMPLATES
   (VIEW_LABEL, QUESTION, HINT, KEYWORDS, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, QUESTION_POSITION, BUSINESS_VALUE, T_QUESTION_ID)
 Values
   ('OKE_Deliverable_Receivables', 'What are the invoice details for a given contract number?', 'Select the Contract_Number, Deliverable_Number, Draft_Invoice_Line, Draft_Invoice_Number, Invoice_Adjusted_Amount, Invoice_Applied_Amount, Invoice_Credited_Amount, Invoice_Date, Invoice_Line_Amount, Invoice_Number, Invoice_Original_Due_Amount, Invoice_Remaining_Due_Amount columns from this view. For optimal performance filter the records by Contract_Number.', NULL, 
    NULL, '11.5+', 'hpothuri', TO_DATE('07/21/2008 01:22:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', 
    TO_DATE('07/21/2008 01:22:00', 'MM/DD/YYYY HH24:MI:SS'), 1, 1, 57483);
    @utlspoff
COMMIT;
