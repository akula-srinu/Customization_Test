-- File Name: BOM_Current_Structured_Bills_Xu2.sql
--
-- Creation Date: 26-Aug-2015
--
-- To be called from wnoetxu2.sql 
--
-- Purpose: To supress the new view definition and get theolder one to work with read-only database.
--
--

@utlspon BOM_Current_Structured_Bills_Xu2

UPDATE n_view_query_templates
   SET PRODUCT_VERSION = '10.0+'
 WHERE view_label = 'BOM_Current_Structured_Bills' AND query_position = 7;

UPDATE n_view_query_templates
   SET PRODUCT_VERSION = '9'
 WHERE view_label = 'BOM_Current_Structured_Bills' AND query_position = 8;

COMMIT;

@utlspoff
