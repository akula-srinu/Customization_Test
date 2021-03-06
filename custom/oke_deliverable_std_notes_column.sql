-- 07-Apr-2011 HChodavarapu Verified for 602 build.
@utlspon oke_deliverable_std_notes_column

Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Number', 'CHDR', 'CONTRACT_NUMBER', 1, 'COL', 'Project contract number.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Start_Date', 'CHDR', 'START_DATE', 2, 'COL', 'Contract start date.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Expiration_Date', 'CHDR', 'END_DATE', 18, 'COL', 'Contract expiration date.', 'N', '%', 'hpothuri', TO_DATE('12/18/2008 04:15:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 21:46:00', 'MM/DD/YYYY HH24:MI:SS'), 'DATE', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_APPLICATION_LABEL, REF_TABLE_NAME, REF_LOOKUP_COLUMN_NAME, REF_DESCRIPTION_COLUMN_NAME, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Status', 'CHDR', 'STS_CODE', 23, 'LOOK', 'Current status of the contract.', 'OKC', 'OKC_STATUSES_TL', 'CODE', 'MEANING', 'N', '%', 'hpothuri', TO_DATE('12/18/2008 21:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 21:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Description', 'CHDRL', 'DESCRIPTION', 3, 'COL', 'Contract description.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Line_Number', 'CLNE', 'LINE_NUMBER', 14, 'COL', 'Project contract line number.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Deliverable_Number', 'KDLVB', 'DELIVERABLE_NUM', 16, 'COL', 'Deliverable line number.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 22:21:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 22:21:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Delivery_Date', 'KDLVB', 'DELIVERY_DATE', 20, 'COL', 'Deliverable line delivery date.', 'N', '%', 'hpothuri', TO_DATE('12/18/2008 20:45:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 21:55:00', 'MM/DD/YYYY HH24:MI:SS'), 'DATE', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_APPLICATION_LABEL, REF_TABLE_NAME, REF_DESCRIPTION_COLUMN_NAME, REF_LOOKUP_TYPE, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Standard_Note_Type', 'NOTE', 'TYPE_CODE', 4, 'LOOK', 'Standard note type of contract.', 'NOETIX', 'N_OKE_LOOKUPS_VL', 'MEANING', 'STD_NOTE_TYPE', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_LOOKUP_COLUMN_NAME, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Std_Note', 'NOTE', 'STD_NOTE', 17, 'ATTR', 'Deliverable standard note descriptive flexfield (OKE_K_Standard_Notes_B).', 'ATTRIBUTE%', 'N', '%', 'hpothuri', TO_DATE('12/18/2008 04:11:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 20:52:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Standard_Note_Creation_Date', 'NOTE', 'CREATION_DATE', 19, 'COL', 'Creation date of the standard note.', 'N', '%', 'hpothuri', TO_DATE('12/18/2008 04:25:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 04:25:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_APPLICATION_LABEL, REF_TABLE_NAME, REF_LOOKUP_COLUMN_NAME, REF_DESCRIPTION_COLUMN_NAME, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Standard_Note_Created_By', 'NOTE', 'CREATED_BY', 22, 'LOOK', 'The name of the user who created the standard note.', 'FND', 'FND_USER', 'USER_ID', 'USER_NAME', 'N', '%', 'hpothuri', TO_DATE('12/18/2008 21:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 23:10:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Standard_Note_Description', 'NOTL', 'DESCRIPTION', 5, 'COL', 'Standard note description.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Standard_Note_Name', 'NOTL', 'NAME', 6, 'COL', 'Standard note name.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Standard_Note_Text', 'NOTL', 'TEXT', 7, 'COL', 'Standard note text.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Owning_Organization_Name', 'OORG', 'NAME', 10, 'COL', 'The name of the organization owning the contract.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PROFILE_OPTION, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Operating_Unit_Name', 'ORG', 'NAME', 11, 'COL', 'Operating unit name.', 'N', 'OKE_XOP_AND_GLOBAL', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 04:07:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Award_Date', 'PHDR', 'AWARD_DATE', 13, 'COL', 'The date on which the contract was awarded.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Project_Name', 'PROJ', 'NAME', 8, 'COL', 'Project name associated with the project contract.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Project_Number', 'PROJ', 'SEGMENT1', 9, 'COL', 'Project number associated with the project contract.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Type_Name', 'PTYPL', 'K_TYPE_NAME', 24, 'COL', 'Contract type. Possible value are "Award'', "Bid", "Proposal", "RFP", "IFB" etc.', 'N', '%', 'hpothuri', TO_DATE('12/18/2008 21:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 21:16:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, GROUP_BY_FLAG, PRODUCT_VERSION, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG)
 Values
   ('OKE_Deliverable_Std_Notes', 1, 'Contract_Version', 'VERN', 'MAJOR_VERSION + 1', 12, 'EXPR', 'Project contract version.', 'N', '11.5+', 'hpothuri', TO_DATE('12/11/2008 21:43:52', 'MM/DD/YYYY HH24:MI:SS'), 'hpothuri', TO_DATE('12/18/2008 04:06:00', 'MM/DD/YYYY HH24:MI:SS'), 'STRING', 'N');
@utlspoff

COMMIT;
