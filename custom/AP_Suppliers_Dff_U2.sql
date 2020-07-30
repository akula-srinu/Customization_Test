-- Title AP_Suppliers_Dff_U2.sql
-- Hookscript to get Ap_Suppliers DFF
-- To be called in wnoetxu2.sql
-- Salesforce Incident No. 77053
-- Created by Apatel 19th Jan 2016

@utlspon AP_Suppliers_Dff_U2


Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_LOOKUP_COLUMN_NAME, GROUP_BY_FLAG, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PO_Expected_Receipts_Vsat', 1, 'VEND', 'VEND', 
    'VEND', 49, 'ATTR', 'Descriptive flexfield from po_vendors.', 
    'ATTRIBUTE%', 
    'N', 'STRING', 'N', '*', 'Y', 'Noetix', TO_DATE('06/24/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'apatel', TO_DATE('06/24/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
    


Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_LOOKUP_COLUMN_NAME, GROUP_BY_FLAG, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PO_All_Orders_Vsat', 1, 'VEND', 'VEND', 
    'VEND', 49, 'ATTR', 'Descriptive flexfield from po_vendors.', 
    'ATTRIBUTE%', 
    'N', 'STRING', 'N', '*', 'Y', 'Noetix', TO_DATE('06/24/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'apatel', TO_DATE('06/24/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

Insert into N_VIEW_COLUMN_TEMPLATES
   (VIEW_LABEL, QUERY_POSITION, COLUMN_LABEL, TABLE_ALIAS, COLUMN_EXPRESSION, COLUMN_POSITION, COLUMN_TYPE, DESCRIPTION, REF_LOOKUP_COLUMN_NAME, GROUP_BY_FLAG, FORMAT_CLASS, GEN_SEARCH_BY_COL_FLAG, PRODUCT_VERSION, INCLUDE_FLAG, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
 Values
   ('PO_All_Lines_Vsat', 1, 'VEND', 'VEND', 
    'VEND', 49, 'ATTR', 'Descriptive flexfield from po_vendors.', 
    'ATTRIBUTE%', 
    'N', 'STRING', 'N', '*', 'Y', 'Noetix', TO_DATE('06/24/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'apatel', TO_DATE('06/24/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));

   
	
@utlspoff