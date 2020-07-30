CREATE OR REPLACE FORCE VIEW NOETIX_VIEWS.GLG0_SOX_MANUAL_JOURNALS_VSAT
(
   A$DOC_SEQUENCE_VALUE,
   A$JE_BATCH_ID,
   A$JE_HEADER_ID,
   A$NAME,
   A$PARENT_JE_HEADER_ID,
   A$PERIOD_NAME,
   A$ZZ__________________________,
   ACCRUAL_REV_CHANGE_SIGN_FLAG,
   ACCRUAL_REV_EFFECTIVE_DATE,
   ACCRUAL_REV_FLAG,
   ACCRUAL_REV_JE_HEADER_ID,
   ACCRUAL_REV_PERIOD_NAME,
   ACCRUAL_REV_STATUS,
   ACTUAL_FLAG,
   ATTRIBUTE1,
   ATTRIBUTE10,
   ATTRIBUTE2,
   ATTRIBUTE3,
   ATTRIBUTE4,
   ATTRIBUTE5,
   ATTRIBUTE6,
   ATTRIBUTE7,
   ATTRIBUTE8,
   ATTRIBUTE9,
   BALANCED_JE_FLAG,
   BALANCING_SEGMENT_VALUE,
   BUDGET_VERSION_ID,
   CLOSE_ACCT_SEQ_ASSIGN_ID,
   CLOSE_ACCT_SEQ_VALUE,
   CLOSE_ACCT_SEQ_VERSION_ID,
   CONTEXT,
   CONTEXT2,
   CONTROL_TOTAL,
   CONVERSION_FLAG,
   CR_BAL_SEG_VALUE,
   CREATED_BY,
   CREATION_DATE,
   CURRENCY_CODE,
   CURRENCY_CONVERSION_DATE,
   CURRENCY_CONVERSION_RATE,
   CURRENCY_CONVERSION_TYPE,
   DATE_CREATED,
   DEFAULT_EFFECTIVE_DATE,
   DESCRIPTION,
   DISPLAY_ALC_JOURNAL_FLAG,
   DOC_SEQUENCE_ID,
   DOC_SEQUENCE_VALUE,
   DR_BAL_SEG_VALUE,
   EARLIEST_POSTABLE_DATE,
   ENCUMBRANCE_TYPE_ID,
   EXTERNAL_REFERENCE,
   FROM_RECURRING_HEADER_ID,
   GLOBAL_ATTRIBUTE1,
   GLOBAL_ATTRIBUTE10,
   GLOBAL_ATTRIBUTE2,
   GLOBAL_ATTRIBUTE3,
   GLOBAL_ATTRIBUTE4,
   GLOBAL_ATTRIBUTE5,
   GLOBAL_ATTRIBUTE6,
   GLOBAL_ATTRIBUTE7,
   GLOBAL_ATTRIBUTE8,
   GLOBAL_ATTRIBUTE9,
   GLOBAL_ATTRIBUTE_CATEGORY,
   INTERCOMPANY_MODE,
   JE_BATCH_ID,
   JE_CATEGORY,
   JE_FROM_SLA_FLAG,
   JE_HEADER_ID,
   JE_SOURCE,
   JGZZ_RECON_CONTEXT,
   JGZZ_RECON_REF,
   LAST_UPDATE_DATE,
   LAST_UPDATE_LOGIN,
   LAST_UPDATED_BY,
   LEDGER_ID,
   LOCAL_DOC_SEQUENCE_ID,
   LOCAL_DOC_SEQUENCE_VALUE,
   MULTI_BAL_SEG_FLAG,
   NAME,
   ORIGINATING_BAL_SEG_VALUE,
   PARENT_JE_HEADER_ID,
   PERIOD_NAME,
   POSTED_DATE,
   POSTING_ACCT_SEQ_ASSIGN_ID,
   POSTING_ACCT_SEQ_VALUE,
   POSTING_ACCT_SEQ_VERSION_ID,
   REFERENCE_DATE,
   REVERSED_JE_HEADER_ID,
   RUNNING_TOTAL_ACCOUNTED_CR,
   RUNNING_TOTAL_ACCOUNTED_DR,
   RUNNING_TOTAL_CR,
   RUNNING_TOTAL_DR,
   STATUS,
   TAX_STATUS_CODE,
   UNIQUE_DATE,
   USSGL_TRANSACTION_CODE
)
AS
   SELECT GLHDR.doc_sequence_value A$Doc_Sequence_Value,
          GLHDR.je_batch_id A$Je_Batch_Id,
          GLHDR.je_header_id A$Je_Header_Id,
          GLHDR.name A$Name,
          GLHDR.parent_je_header_id A$Parent_Je_Header_Id,
          GLHDR.period_name A$Period_Name,
          'A$ZZ__________________________Copyright Noetix Corporation 1992-2016'
             A$ZZ__________________________,
          GLHDR.accrual_rev_change_sign_flag Accrual_Rev_Change_Sign_Flag,
          GLHDR.accrual_rev_effective_date Accrual_Rev_Effective_Date,
          GLHDR.accrual_rev_flag Accrual_Rev_Flag,
          GLHDR.accrual_rev_je_header_id Accrual_Rev_Je_Header_Id,
          GLHDR.accrual_rev_period_name Accrual_Rev_Period_Name,
          GLHDR.accrual_rev_status Accrual_Rev_Status,
          GLHDR.actual_flag Actual_Flag,
          GLHDR.attribute1 Attribute1,
          GLHDR.attribute10 Attribute10,
          GLHDR.attribute2 Attribute2,
          GLHDR.attribute3 Attribute3,
          GLHDR.attribute4 Attribute4,
          GLHDR.attribute5 Attribute5,
          GLHDR.attribute6 Attribute6,
          GLHDR.attribute7 Attribute7,
          GLHDR.attribute8 Attribute8,
          GLHDR.attribute9 Attribute9,
          GLHDR.balanced_je_flag Balanced_Je_Flag,
          GLHDR.balancing_segment_value Balancing_Segment_Value,
          GLHDR.budget_version_id Budget_Version_Id,
          GLHDR.close_acct_seq_assign_id Close_Acct_Seq_Assign_Id,
          GLHDR.close_acct_seq_value Close_Acct_Seq_Value,
          GLHDR.close_acct_seq_version_id Close_Acct_Seq_Version_Id,
          GLHDR.context Context,
          GLHDR.context2 Context2,
          GLHDR.control_total Control_Total,
          GLHDR.conversion_flag Conversion_Flag,
          GLHDR.cr_bal_seg_value Cr_Bal_Seg_Value,
          GLHDR.created_by Created_By,
          GLHDR.creation_date Creation_Date,
          GLHDR.currency_code Currency_Code,
          GLHDR.currency_conversion_date Currency_Conversion_Date,
          GLHDR.currency_conversion_rate Currency_Conversion_Rate,
          GLHDR.currency_conversion_type Currency_Conversion_Type,
          GLHDR.date_created Date_Created,
          GLHDR.default_effective_date Default_Effective_Date,
          GLHDR.description Description,
          GLHDR.display_alc_journal_flag Display_Alc_Journal_Flag,
          GLHDR.doc_sequence_id Doc_Sequence_Id,
          GLHDR.doc_sequence_value Doc_Sequence_Value,
          GLHDR.dr_bal_seg_value Dr_Bal_Seg_Value,
          GLHDR.earliest_postable_date Earliest_Postable_Date,
          GLHDR.encumbrance_type_id Encumbrance_Type_Id,
          GLHDR.external_reference External_Reference,
          GLHDR.from_recurring_header_id From_Recurring_Header_Id,
          GLHDR.global_attribute1 Global_Attribute1,
          GLHDR.global_attribute10 Global_Attribute10,
          GLHDR.global_attribute2 Global_Attribute2,
          GLHDR.global_attribute3 Global_Attribute3,
          GLHDR.global_attribute4 Global_Attribute4,
          GLHDR.global_attribute5 Global_Attribute5,
          GLHDR.global_attribute6 Global_Attribute6,
          GLHDR.global_attribute7 Global_Attribute7,
          GLHDR.global_attribute8 Global_Attribute8,
          GLHDR.global_attribute9 Global_Attribute9,
          GLHDR.global_attribute_category Global_Attribute_Category,
          GLHDR.intercompany_mode Intercompany_Mode,
          GLHDR.je_batch_id Je_Batch_Id,
          GLHDR.je_category Je_Category,
          GLHDR.je_from_sla_flag Je_From_Sla_Flag,
          GLHDR.je_header_id Je_Header_Id,
          GLHDR.je_source Je_Source,
          GLHDR.jgzz_recon_context Jgzz_Recon_Context,
          GLHDR.jgzz_recon_ref Jgzz_Recon_Ref,
          GLHDR.last_update_date Last_Update_Date,
          GLHDR.last_update_login Last_Update_Login,
          GLHDR.last_updated_by Last_Updated_By,
          GLHDR.ledger_id Ledger_Id,
          GLHDR.local_doc_sequence_id Local_Doc_Sequence_Id,
          GLHDR.local_doc_sequence_value Local_Doc_Sequence_Value,
          GLHDR.multi_bal_seg_flag Multi_Bal_Seg_Flag,
          GLHDR.name Name,
          GLHDR.originating_bal_seg_value Originating_Bal_Seg_Value,
          GLHDR.parent_je_header_id Parent_Je_Header_Id,
          GLHDR.period_name Period_Name,
          GLHDR.posted_date Posted_Date,
          GLHDR.posting_acct_seq_assign_id Posting_Acct_Seq_Assign_Id,
          GLHDR.posting_acct_seq_value Posting_Acct_Seq_Value,
          GLHDR.posting_acct_seq_version_id Posting_Acct_Seq_Version_Id,
          GLHDR.reference_date Reference_Date,
          GLHDR.reversed_je_header_id Reversed_Je_Header_Id,
          GLHDR.running_total_accounted_cr Running_Total_Accounted_Cr,
          GLHDR.running_total_accounted_dr Running_Total_Accounted_Dr,
          GLHDR.running_total_cr Running_Total_Cr,
          GLHDR.running_total_dr Running_Total_Dr,
          GLHDR.status Status,
          GLHDR.tax_status_code Tax_Status_Code,
          GLHDR.unique_date Unique_Date,
          GLHDR.ussgl_transaction_code Ussgl_Transaction_Code
     FROM GL.GL_JE_HEADERS GLHDR
    WHERE     'Copyright Noetix Corporation 1992-2016' IS NOT NULL
          AND 1 = 1
          AND glhdr.je_source = 'Manual';
